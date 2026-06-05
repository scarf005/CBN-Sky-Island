-- Sky Islands BN Port - Proof of Concept
-- preload.lua - Hook and iuse registration

local mod = game.mod_runtime[game.current_mod]
local util = require("util")

local function register_iuse(id, fn_name)
  game.iuse_functions[id] = {
    use = function(params)
      return mod[fn_name](params.user, params.item, params.pos)
    end
  }
end

-- Register item use functions
register_iuse("SKYISLAND_WARP_OBELISK", "use_warp_obelisk")
register_iuse("SKYISLAND_RETURN_OBELISK", "use_return_obelisk")
register_iuse("SKYISLAND_HEART_MENU", "use_heart_menu")

-- Upgrade item activations
register_iuse("SKYISLAND_UPGRADE_STABILITY1", "use_upgrade_stability1")
register_iuse("SKYISLAND_UPGRADE_STABILITY2", "use_upgrade_stability2")
register_iuse("SKYISLAND_UPGRADE_STABILITY3", "use_upgrade_stability3")
register_iuse("SKYISLAND_UPGRADE_SCOUTING1", "use_upgrade_scouting1")
register_iuse("SKYISLAND_UPGRADE_SCOUTING2", "use_upgrade_scouting2")
register_iuse("SKYISLAND_UPGRADE_EXITS1", "use_upgrade_exits1")
register_iuse("SKYISLAND_UPGRADE_RAIDLENGTH1", "use_upgrade_raidlength1")
register_iuse("SKYISLAND_UPGRADE_RAIDLENGTH2", "use_upgrade_raidlength2")
register_iuse("SKYISLAND_UPGRADE_BASEMENTS", "use_upgrade_basements")
register_iuse("SKYISLAND_UPGRADE_ROOFS", "use_upgrade_roofs")
register_iuse("SKYISLAND_UPGRADE_LABS", "use_upgrade_labs")
register_iuse("SKYISLAND_UPGRADE_SCOUTING_CLAIRVOYANCE1", "use_upgrade_scouting_clairvoyance1")
register_iuse("SKYISLAND_UPGRADE_SCOUTING_CLAIRVOYANCE2", "use_upgrade_scouting_clairvoyance2")
register_iuse("SKYISLAND_UPGRADE_BONUSMISSIONS1", "use_upgrade_bonusmissions1")
register_iuse("SKYISLAND_UPGRADE_BONUSMISSIONS2", "use_upgrade_bonusmissions2")
register_iuse("SKYISLAND_UPGRADE_BONUSMISSIONS3", "use_upgrade_bonusmissions3")
register_iuse("SKYISLAND_UPGRADE_BONUSMISSIONS4", "use_upgrade_bonusmissions4")
register_iuse("SKYISLAND_UPGRADE_BONUSMISSIONS5", "use_upgrade_bonusmissions5")
register_iuse("SKYISLAND_UPGRADE_HARDMISSIONS1", "use_upgrade_hardmissions1")
register_iuse("SKYISLAND_UPGRADE_HARDMISSIONS2", "use_upgrade_hardmissions2")
register_iuse("SKYISLAND_UPGRADE_SLAUGHTER", "use_upgrade_slaughter")
register_iuse("SKYISLAND_UPGRADE_LANDING_FLIGHT", "use_upgrade_landing_flight")
register_iuse("SKYISLAND_PROOF_DETERMINATION", "use_proof_determination")
register_iuse("SKYISLAND_PROOF_MASTERY", "use_proof_mastery")

-- Utility item activations
register_iuse("SKYISLAND_QUICKHEAL", "use_quickheal")
register_iuse("SKYISLAND_EARTHBOUND_PILL", "use_earthbound_pill")
register_iuse("SKYISLAND_SKYWARD_BEACON", "use_skyward_beacon")
register_iuse("SKYISLAND_WARP_CRYSTAL", "use_warp_crystal")
register_iuse("SKYISLAND_ANIMAL_TELEPORTER", "use_animal_teleporter")
register_iuse("SKYISLAND_WARP_FOCUS", "use_warp_focus")
register_iuse("SKYISLAND_IMPRINT_AUTODOC", "use_imprint_autodoc")
register_iuse("SKYISLAND_IMPRINT_AUTODOC_COUCH", "use_imprint_autodoc_couch")
register_iuse("SKYISLAND_IMPRINT_NANOFAB_BODY", "use_imprint_nanofab_body")
register_iuse("SKYISLAND_IMPRINT_NANOFAB_PANEL", "use_imprint_nanofab_panel")
register_iuse("SKYISLAND_IMPRINT_CVD_BODY", "use_imprint_cvd_body")
register_iuse("SKYISLAND_IMPRINT_CVD_PANEL", "use_imprint_cvd_panel")

-- Register hooks
table.insert(game.hooks.on_game_started, function(...)
  return mod.on_game_started(...)
end)

table.insert(game.hooks.on_game_load, function(...)
  return mod.on_game_load(...)
end)

table.insert(game.hooks.on_game_save, function(...)
  return mod.on_game_save(...)
end)

-- table.insert(game.hooks.on_char_death, function(...)
--   return mod.on_char_death(...)
-- end)

table.insert(game.hooks.on_character_death, function(...)
  return mod.on_character_death(...)
end)

util.debug_log("Sky Islands PoC preload complete")
