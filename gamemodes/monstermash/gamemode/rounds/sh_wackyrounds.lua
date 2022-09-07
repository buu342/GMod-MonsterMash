AddCSLuaFile()

GM.WackyRounds = {
    ["Dodgeball"] = {
        loadout_override   = {
            ["Melee"]     = "None",
            ["Handgun"]   = "None",
            ["Primary"]   = "None",
            ["Throwable"] = "weapon_mm_dodgeball",
            ["Trick"]      = "None",
        },
        allow_buy = false,
        allow_time = true,
        allow_score = false,
        force_teams = false,
        limit_time = 150,
        stamina_recharge = 2.0,
        mode = MODE_DEATHMATCH, 
        round_message1 = "Time for a deadly game of dodgeball!", 
    },
	
    ["And Then A Skeleton Popped Out!"] = {
        mode = MODE_DEATHMATCH, 
        round_message1 = "Players who are killed release a spooky skeleton!",
    },
	
    ["Cycler"] = {
        loadout_override   = {
            ["Melee"]     = "None",
            ["Handgun"]   = "None",
            ["Primary"]   = "None",
            ["Throwable"] = "None",
            ["Trick"]      = "None",
        },
        allow_buy = false,
        allow_time = false,
        allow_score = false,
        force_teams = false,
        limit_time = 180,
        mode = MODE_DEATHMATCH,
        round_message1 = "Your loadout will be randomzied every 10 seconds!",
    },

    ["Bullet Time"] = {
        allow_time = false,
        limit_time = 180,
		stamina_recharge = 2.0,
        mode = MODE_DEATHMATCH,
        round_message1 = "Get ready for itermmitent bouts of slow motion!",
    },
	
    ["Unstable"] = {
        mode = MODE_DEATHMATCH,
        round_message1 = "Players explode on death!",
    },
    
    ["Spooky Scary Skeletons"] = {
        allow_respawn = false,
        allow_score = false,
        limit_time = 180,
        mode = MODE_PVM,
        round_message1 = "Crappy skeleton sprites are invading! Survive!",
        text_aiwin = "The peaceful skeleton realm has annihilated the monsters",
        text_playerswin = "You survived the attack from the peaceful skeleton realm",
    },
    
    ["Bone To Pick"] = {
        character_override2 = "Skeleton",
        use_teams = true,
        limit_time = 240,
        mode = MODE_CONVERT, 
        round_message1 = "The skeletons are trying to turn you into one of them. Keep them at bay until time runs out!",
        round_message2 = "Smack the flesh-wearers with your boner to convert them to your superior spooky side",
        text_monsterwin = "The skeletons have spooked the whole land",
        text_playerswin = "The monsters were not spooked",
    },
    ["Goblin Slayer"] = {
        character_override2 = "Kirito",
        allow_respawn = false,
        allow_time = false,
        allow_score = false,
        force_teams = true,
        mode = MODE_PVSUPER, 
        superchar = "Kirito",
        round_message1 = "Kirito from the Chinese cartoon Goblin Slayer is on the loose! Work together to put a stop to him!",
        round_message2 = "Show everyone the cool stick you found at the park. Leave no survivors.",
        text_monsterwin = "Cloud Strife won!",
        text_playerswin = "The Afro Samurai was defeated!",
    },
    ["Witching Hour"] = {
        character_override1 = "Witch",
        loadout_override   = {
            ["Melee"]     = "weapon_mm_boner",
            ["Handgun"]   = "None",
            ["Primary"]   = "weapon_mm_wand",
            ["Throwable"] = "weapon_mm_acidflask",
            ["Trick"]      = "broom",
        },
        allow_buy = false,
        allow_score = false,
        use_teams = false,
        limit_time = 180,
        mode = MODE_DEATHMATCH,
        round_message1 = "Go show those wannabe-witches you're the best witch in the village!",
        instanttrick = true,
    },
    ["Hell's Kitchen"] = {
        loadout_override   = {
            ["Melee"]     = "weapon_mm_knife",
            ["Handgun"]   = "None",
            ["Primary"]   = "weapon_mm_flamethrower",
            ["Throwable"] = "weapon_mm_cleaver",
            ["Trick"]      = "None",
        },
        allow_buy = false,
        allow_score = false,
        use_teams = false,
        limit_time = 180,
        mode = MODE_DEATHMATCH,
        round_message1 = "Prove to the Devil that you're Hell's best chef!",
    },
	
    ["Execution!"] = {
        allow_respawn = false,
        mode = MODE_LMS,
        round_message1 = "You have one life, make it count!",
    },
}


/* Slo-mo Sound pitching */

hook.Add("EntityEmitSound", "MM_TimeWarpSounds", function(t)
	local p = t.Pitch
	if (game.GetTimeScale() != 1) then
		p = p*game.GetTimeScale()
	end
	if (GetConVarNumber("host_timescale") != 1 && GetConVarNumber("sv_cheats") == 1) then
		p = p*GetConVarNumber("host_timescale")
	end
	if (p != t.Pitch) then
		t.Pitch = math.Clamp(p, 0, 255)
		return true
	end
	if (CLIENT && engine.GetDemoPlaybackTimeScale() != 1) then
		t.Pitch = math.Clamp(t.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255)
		return true
	end
end)