"""Run with: python3 -m unittest discover -s tests"""

import json
from pathlib import Path
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]


class HomeDimensionTest(unittest.TestCase):
    def test_home_travel_and_special_footprint(self):
        result = subprocess.run(
            ["luajit", "-"], cwd=ROOT, text=True, capture_output=True, check=True,
            input=r'''
package.loaded.util = { debug_log = function() end }
locale = { gettext = function(text) return text end }
OtMatchType = { EXACT = 1, CONTAINS = 2 }
TripointAbsOmt = { new = function(x, y, z) return { x=x, y=y, z=z } end }
local current = ""
local calls = 0
local entered = true
local last
local position = { x=2, y=2, z=10 }
local absolute = { x=60, y=60, z=10, to_omt=function() return position end }
gapi = {
  get_current_dimension_id = function() return current end,
  get_avatar = function() return { get_pos_ms=function() return {} end } end,
  get_map = function() return { bub_to_abs=function() return absolute end } end,
  add_msg = function() end,
  place_player_dimension_at = function(options)
    calls = calls + 1
    last = options
    if entered then current = options.dimension_id end
    return entered
  end,
}
local teleport = require("teleport")
local storage = {}
assert(teleport.ensure_home_dimension(storage))
assert(calls == 1 and storage.home_dimension_id == "sky_island_home")
assert(storage.home_omt.x == position.x and storage.skyisland_storage_version == 2)
assert(last.world_type == "pocket_dimension")
assert(last.pregen_special_id == "Sky Island Pocket")
assert(last.target_omt.x == last.pregen_special_omt.x)
assert(last.target_omt.y == last.pregen_special_omt.y)
assert(last.target_omt.z == last.pregen_special_omt.z)
print(last.pregen_special_id)
for _, p in ipairs({last.target_omt, last.bounds_min_omt, last.bounds_max_omt}) do
  print(p.x, p.y, p.z)
end
assert(teleport.ensure_home_dimension(storage) and calls == 1)
current = "raid"
storage.home_omt = { x=0, y=0, z=10 }
assert(teleport.ensure_home_dimension(storage) and calls == 2)
assert(last.target_omt.x == 0 and last.target_omt.y == 0)
assert(last.pregen_special_id == nil and last.bounds_min_omt == nil)
current = ""
entered = false
local failed = {}
assert(not teleport.ensure_home_dimension(failed))
assert(next(failed) == nil and current == "")
gapi.place_player_dimension_at = nil
assert(not teleport.ensure_home_dimension({}))
''',
        )
        special_id, *points = result.stdout.strip().splitlines()
        anchor, minimum, maximum = [tuple(map(int, p.split())) for p in points]
        specials = {s["id"]: s for s in json.loads((ROOT / "overmap_special.json").read_text())}
        original = specials["Sky Island"]
        pocket = specials[special_id]
        self.assertEqual(pocket["copy-from"], original["id"])
        self.assertEqual(pocket["occurrences"], [0, 0])
        self.assertEqual(original["occurrences"], [100, 100])
        self.assertEqual(maximum[2], 10)  # No opaque boundary above the surface.
        self.assertEqual(len(pocket["overmaps"]), 18)
        for old, new in zip(original["overmaps"], pocket["overmaps"]):
            self.assertEqual(old["overmap"], new["overmap"])
            self.assertEqual(old["point"], [*new["point"][:2], new["point"][2] + 10])
            placed = tuple(a + b for a, b in zip(anchor, new["point"]))
            for value, low, high in zip(placed, minimum, maximum):
                self.assertLessEqual(low, value)
                self.assertLessEqual(value, high)
            self.assertTrue(0 <= placed[0] < 180 and 0 <= placed[1] < 180)
            self.assertIn(placed[2], (9, 10))


if __name__ == "__main__":
    unittest.main()
