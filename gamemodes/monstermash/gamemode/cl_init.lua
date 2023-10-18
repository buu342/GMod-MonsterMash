include("shared.lua")
include("Tricks/sh_tricks.lua")
include("Damage/cl_damage.lua")
include("Gore/cl_gore.lua")
include("Gore/cl_screenblood.lua")
include("HUD/cl_hud.lua")
include("HUD/cl_endroundboard.lua")
include("HUD/cl_fonts.lua")
include("HUD/cl_killfeed.lua")
include("HUD/cl_scoreboard.lua")
include("Menu/cl_menu.lua")
include("Music/cl_music.lua")
include("Music/cl_songlist.lua")
include("Player/cl_mmplayer.lua") 
include("Rounds/cl_wackyrounds.lua") 
include("StatusEffects/cl_statuseffects.lua") 
include("Taunts/cl_tauntcamera.lua") 

CreateClientConVar("mm_aimenable", "0", true, false)
CreateClientConVar("mm_meleeaim", "0", true, false)
CreateClientConVar("mm_pussymode", "0", true, true)
CreateClientConVar("mm_blurmenu", "1", true, true) --
CreateClientConVar("mm_rollrotatescreen", "1", true, false)
CreateClientConVar("mm_cleardecals", "60", true, false)
CreateClientConVar("mm_deanimatorshake", "1", true, false)
CreateClientConVar("mm_deathtips", "1", true, false)
CreateClientConVar("mm_autoreload", "1", true, false)
CreateClientConVar("mm_screenblood", "1", true, false)
CreateClientConVar("mm_confetti", "0", true, false)
CreateClientConVar("mm_endroundboard", "1", true, false)
CreateClientConVar("mm_oldtimeymode", "0", true, false)

function GM:PlayerConnect(name, ip)
    chat.AddText(Color(255,105,0), name .. " has joined the mash.")
end

function GM:Think()
    if (MusicThink != nil) then
        MusicThink()
    end
end