GM.Name = "Monster Mash"
GM.Author = "Buu342"
GM.Email = "buu342@hotmail.com"
GM.Website = "N/A"

include("sh_constants.lua")
include("Admin/sh_playerkick.lua")
include("Characters/sh_characters.lua")
include("Menu/sh_weapondescriptions.lua")
include("Player/sh_mmplayer.lua")
include("Rounds/sh_rounds.lua")
include("Rounds/sh_wackyrounds.lua")
include("Stats/sh_playerstats.lua")
include("Stats/sh_treats.lua")
include("Tricks/sh_tricks.lua")

CreateConVar("mm_orgasmicdeathsounds", "0",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_tasermanmode",        "0",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_ludicrousgibs",       "1",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_deathcam",            "1",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_budget",              "100", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_point_limit",         "500", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_wackyfrequency",      "3",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_healthregen_time",    "5",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_healthregen_amount",  "3",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_wackytaunts",         "0",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_buytime",             "15",  FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_roundtime",           "360", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_endtime",             "15",  FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_spawnprotect",        "1",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_cleanup_time",        "20",  FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_maxrounds",           "10",  FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_endofmonstermash",    "0",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_endroundboard_time",  "4",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("mm_slomo_duration",      "3",   FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

team.SetUp(TEAM_SPECT,     "Spectators",    Color(0, 0, 0, 255))
team.SetUp(TEAM_MONST,     "Monsters",      Color(255, 140, 0, 255))
team.SetUp(TEAM_COOPMONST, "COOP-Monsters", Color(0, 255, 0, 255))
team.SetUp(TEAM_COOPOTHER, "COOP-Other",    Color(194, 120, 194, 255))
team.SetUp(TEAM_COOPDEAD,  "COOP-Dead",     Color(0, 0, 0, 255))

local count = 0
local function cacheit(str)
    util.PrecacheModel(str)
    //print("Precached "..str)
    count = count+1
end

function GM:PrecacheEverything()
    print("Precaching stuff, hold on...")
    
        local mode = ""
        if file.Exists("models/monstermash/deer_haunter_final.mdl", "WORKSHOP") then
            mode = "WORKSHOP"
            print("Precaching from Workshop...")
        elseif file.Exists("models/monstermash/deer_haunter_final.mdl", "GAME") then
            mode = "GAME"
            print("Precaching from game folder...")
        else
            print("Unable to find models. Something isn't right...")
            return
        end
    
        // Precache characters
        local files, directories = file.Find("models/monstermash/*.mdl", mode)
        for k, v in pairs(files) do
            cacheit("models/monstermash/"..v)
        end
        
        // Precache gibs
        local files, directories = file.Find("models/monstermash/gibs/*.mdl", mode)
        for k, v in pairs(files) do
            cacheit("models/monstermash/"..v)
        end
    
        // Precache weapons
        local files, directories = file.Find("models/weapons/monstermash/*.mdl", mode)
        for k, v in pairs(files) do
            cacheit("models/weapons/monstermash/"..v)
        end
        
        // Precache c_arms
        cacheit("models/c_models/c_arms_banshee.mdl")
        cacheit("models/c_models/c_arms_bm.mdl")
        cacheit("models/c_models/c_arms_deer.mdl")
        cacheit("models/c_models/c_arms_guest.mdl")
        cacheit("models/c_models/c_arms_hhm.mdl")
        cacheit("models/c_models/c_arms_invisibleman.mdl")
        cacheit("models/c_models/c_arms_mummy.mdl")
        cacheit("models/c_models/c_arms_nosferatu.mdl")
        cacheit("models/c_models/c_arms_scarecrow.mdl")
        cacheit("models/c_models/c_arms_scientist.mdl")
        cacheit("models/c_models/c_arms_skeleton.mdl")
        cacheit("models/c_models/c_arms_vampire.mdl")
        cacheit("models/c_models/c_arms_witch.mdl")
        cacheit("models/c_models/c_arms_zombie.mdl")
        
        // Precache extra
        cacheit("models/misc/gravestone.mdl")
        cacheit("models/player/cancer.mdl")
        cacheit("models/player/kirito.mdl")
        cacheit("models/player/sdk_player_shared.mdl")

    print("Done! Precached "..count.." models")
end

function GM:Initialize()
    // Initialize the gamemode
    self:PrecacheEverything()
    self:InitializeRounds()
    
    // Initialize player stats
    self.PlayerStats = {}
    if !file.Exists("monstermash", "DATA") then
        file.CreateDir("monstermash")
    end
end

function GM:Think()
    self:UpdateRound()
end