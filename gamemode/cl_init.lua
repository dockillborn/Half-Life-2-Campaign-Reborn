include("shared.lua")

include("client/hud/cl_hud.lua")
include("client/hud/cl_spectate.lua")
include("client/ui/cl_ui_elements.lua")
include("client/ui/cl_ui_fonts.lua")
include("client/menus/cl_scoreboard_menu.lua")
include("client/menus/cl_end_results.lua")
include("client/menus/cl_help_menu.lua")
include("client/menus/cl_settings_menu.lua")
include("client/menus/cl_voice_menu.lua")
include("client/menus/cl_qmenu.lua")
include("client/menus/cl_achievement_menu.lua")
include("client/menus/cl_pet_menu.lua")
include("client/menus/cl_pet_statmenu.lua")
include("client/hud/cl_hitboxrender.lua")
include("client/hud/cl_ach.lua")
<<<<<<< Updated upstream
=======
include("client/chat/cl_leifchat.lua")
>>>>>>> Stashed changes

include("shared/misc/sh_voting.lua")
include("shared/ach/sh_player_ach.lua")
include("shared/playerclass/sh_player_classes.lua")
include("shared/playerclass/sh_player_skills.lua")
include("shared/playerclass/sh_player_pets.lua")
include("shared/petskills/sh_pets_skills_base.lua")
include("shared/petskills/sh_pets_headcrab_skills.lua")
<<<<<<< Updated upstream
include("shared/shop/sh_shop_items.lua")
include("shared/shop/sh_craftable_items.lua")
include("shared/sh_translate.lua")

net.Receive("HL2CR_Discord", function()
	gui.OpenURL("https://discord.gg/zvvZ2ugHQY")
end)
=======
include("shared/petskills/sh_pets_fastheadcrab_skills.lua")
include("shared/shop/sh_shop_items.lua")
include("shared/shop/sh_craftable_items.lua")
include("shared/sh_translate.lua")
include("shared/quests/sh_quest_system.lua")
>>>>>>> Stashed changes
