local models = {
    "models/monstermash/deer_haunter_final.mdl",
    "models/monstermash/vampire_final.mdl",
    "models/monstermash/nosferatu_final.mdl",
    "models/monstermash/guest_final.mdl",
    "models/monstermash/scarecrow_final.mdl",
    "models/monstermash/skeleton_final.mdl",
    "models/monstermash/witch_final.mdl",
    "models/monstermash/headless_horseman_final.mdl",
    "models/monstermash/stein_final.mdl",
    "models/monstermash/mummy_final.mdl",
    "models/monstermash/bloody_mary_final.mdl"
}

function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "mm_player" )
    
    if (ply:IsAdmin() || ply:IsSuperAdmin()) && !table.HasValue(admins, ply:SteamID()) then
        table.insert(admins, ply:SteamID())
    end
    
	ply:SetNWBool("UsingRandomPModel",false)
	ply:SetNWInt("gold", GetConVar("mm_budget"):GetInt())
	
	ply:SetNWString("Melee","")
	ply:SetNWInt("lastcost_Melee",0)
	
	ply:SetNWString("Handgun","")
	ply:SetNWInt("lastcost_Handgun",0)
	
	ply:SetNWString("Primary","")
	ply:SetNWInt("lastcost_Primary",0)
	
	ply:SetNWString("Throwable","")
	ply:SetNWInt("lastcost_Throwable",0)
	
    ply:SetNWString("plymdl", table.Random(models))
    ply:SetNWInt("plyskn", math.random(5))
    ply:SetTeam(2)
    ply:Spectate( OBS_MODE_ROAMING );
    ply:ConCommand( "noclip" )
	ply:ConCommand( "mm_menu" )
    ply:SetModel( ply:GetNWString("plymdl") )
    ply:SetSkin(ply:GetNWInt("plyskn"))
end

function GM:PlayerSpawn( ply )

	-- Stop observer mode
	ply:UnSpectate()
	if GetGlobalVariable("RoundsToWacky") != 0 && ply:Team() != 2 then
        ply:SetTeam(1)
    end
    
    ply:SetNWInt("LegMissing", 0)
	ply:SetNWInt("ArmMissing", 0)
	
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )
	
    if (ply:Team() == 2 || ply:Team() == 5) && !ply:IsBot() then
        ply:Spectate( OBS_MODE_ROAMING );
        ply:ConCommand( "noclip" )
    end
    
    ply:SetNWBool("DisplayKilla",false)
    ply.UseWeaponSpawn = CurTime()
    ply:SetCanZoom( false )

	if ply:GetNWString("plymdl") == "models/monstermash/random_character.mdl" then
		local modelchosen = table.Random(models)
		ply:SetModel(modelchosen)
	else
		ply:SetModel( ply:GetNWString("plymdl") )
	end
	if ply:GetNWString("plymdl") == "models/monstermash/random_character.mdl" then
		if modelchosen == "models/monstermash/vampire_final.mdl" then
		ply:SetSkin(math.random(0,2))
		end
		if modelchosen == "models/monstermash/mummy_final.mdl" then
		ply:SetSkin(math.random(0,1))
		end
		if modelchosen == "models/monstermash/guest_final.mdl" then
		ply:SetSkin(math.random(0,5))
		end
		if modelchosen == "models/monstermash/witch_final.mdl" then
		ply:SetSkin(math.random(0,3))
		end
		if modelchosen == "models/monstermash/skeleton_final.mdl" then
		ply:SetSkin(math.random(0,3))
		end
	else
		ply:SetSkin(ply:GetNWInt("plyskn"))
	end
	
	ply:SetNWBool("DoingTauntCamera", false)
		
	ply:SetupHands()
	ply:StripAmmo()
	ply:StripWeapons()
    ply:SetWalkSpeed(250)
    ply:SetRunSpeed(250)
    ply:SetJumpPower( 200 )
    ply:ShouldDropWeapon( true )
	ply:SetNWInt("SpawnTime",CurTime()+0.2)
	ply:SetNWFloat("HealTime",CurTime())
	ply:GodEnable()
	ply:SetMaterial( "", true ) 
	
	if ply:GetNWString("Buff") == "armor" then
		ply:SetBloodColor( BLOOD_COLOR_MECH )
	else
		ply:SetBloodColor( BLOOD_COLOR_RED )
	end
    
    if ply:Team() == 1 then

		if ply:GetNWString("Primary") != "" then
            ply:Give(ply:GetNWString("Primary"))
		end
		if ply:GetNWString("Handgun") != "" then
            ply:Give(ply:GetNWString("Handgun"))
		end
		if ply:GetNWString("Melee") != "" then
            ply:Give(ply:GetNWString("Melee"))
		end
		if ply:GetNWString("Throwable") != "" then
            ply:Give(ply:GetNWString("Throwable"))
		end
        ply.UsingRandomLoadout = false
        if ply:GetNWString("Primary") == "" && ply:GetNWString("Handgun") == "" && ply:GetNWString("Melee") == "" && ply:GetNWString("Throwable") == "" then
            local budget = GetConVar("mm_budget"):GetInt()
            ply.UsingRandomLoadout = true
            while budget == GetConVar("mm_budget"):GetInt() do
                local category = "melee"
                local num = #MonsterMash_Weapons[category]
                local rand = math.random(1, num)
                if MonsterMash_Weapons[category][rand] == nil then
                    ply:ChatPrint("WEAPON LIST NEEDS REBUILDING!")
                    break
                end
                if budget-MonsterMash_Weapons[category][rand].cost >= 0 then
                    ply:Give(MonsterMash_Weapons[category][rand].entity)
                    budget = budget - MonsterMash_Weapons[category][rand].cost
                end
                
                category = "handgun"
                num = #MonsterMash_Weapons[category]
                rand = math.random(1, num)
                if budget-MonsterMash_Weapons[category][rand].cost >= 0  then
                    ply:Give(MonsterMash_Weapons[category][rand].entity)
                    budget = budget - MonsterMash_Weapons[category][rand].cost
                end
                
                category = "primary"
                num = #MonsterMash_Weapons[category]
                rand = math.random(1, num)
                if budget-MonsterMash_Weapons[category][rand].cost >= 0  then
                    ply:Give(MonsterMash_Weapons[category][rand].entity)
                    budget = budget - MonsterMash_Weapons[category][rand].cost
                end
                
                category = "throwable"
                num = #MonsterMash_Weapons[category]
                rand = math.random(1, num)
                if budget-MonsterMash_Weapons[category][rand].cost >= 0  then
                    ply:Give(MonsterMash_Weapons[category][rand].entity)
                    budget = budget - MonsterMash_Weapons[category][rand].cost
                end
            end
        end
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			ply:Freeze( true )
			timer.Simple(GetGlobalVariable("RoundStartTimer") - CurTime(),function() if !IsValid(ply) then return end ply:Freeze( false ) SetGlobalVariable("RoundStartTimer", 0) end)
		end
		ply.LightingFrame = 0
        ply:Give("mm_candlestick")
		ply:GiveAmmo(24,"ammo_revolver",true)
		ply:GiveAmmo(28,"ammo_colt",true)
		ply:GiveAmmo(24,"ammo_battlerifle",true)
		ply:GiveAmmo(20,"ammo_repeater",true)
		ply:GiveAmmo(100,"ammo_thompson",true)
		ply:GiveAmmo(18,"ammo_shotgun",true)
		ply:GiveAmmo(20,"ammo_crossbow",true)
        ply:GiveAmmo(150,"ammo_flame",true)
		ply:GiveAmmo(8,"ammo_cannon",true)
        ply:GiveAmmo(100, "ammo_zap", true)
    end
	
	if ply:GetNWString("Melee") == "mm_battleaxe" then
		ply:SetHealth(125)
		ply:SetMaxHealth(125)
	end
	
	ply:SetBodygroup(1,0)
	ply:SetBodygroup(2,0)
	ply:SetBodygroup(3,0)
	ply:SetBodygroup(4,0)
	ply:SetBodygroup(5,0)

    ply:SetNWBool("DiedFromBleed", false)
    ply:SetNWEntity("MM_BleedOwner", nil)
    ply:SetNWEntity("MM_BleedInflictor", nil)

	ply:SetNWInt("LastHitgroupMelee", 0)
	ply:SetNWFloat("NextHop", 0)
    ply:SetNWFloat("mm_musketpistol_recharge", 0) 
    ply:SetNWFloat("mm_musketpistol", 0)
    ply:SetNWFloat("mm_urn_recharge", 0)
    ply:SetNWFloat("mm_web_recharge", 0)
    ply:SetNWFloat("mm_acid_recharge", 0)
    ply:SetNWFloat("mm_pumpkinnade_recharge", 0)
    ply:SetNWFloat("mm_cleaver_recharge", 0)
    ply:SetNWFloat("mm_gorejar_recharge", 0)
    ply:SetNWFloat("mm_stake_recharge", 0)
    ply:GetHands():SetSkin(ply:GetNWInt("plyskn"))
    ply:SetNWFloat("HealthRegen", CurTime()+GetConVar("mm_healthregentime"):GetInt())
    ply:SetNWFloat("DivingRight", -1)
    ply:SetNWFloat("DivingLeft", -1)
    ply:SetNWFloat("DamageTaken", 0)
    ply:SetNWFloat("SuicideDamageTaken", 0)
    ply:SetNWInt("Dismember", 0)
    ply:SetNWFloat("Acidied", 0)
    ply:SetNWInt("MM_AcidDamage", 0)
    ply:SetNWFloat("MM_AcidTime", 0)
	ply:SetNWFloat("MM_AcidTime", 0)
	ply:SetNWEntity("MM_AcidOwner", NULL)
    ply:SetNWEntity("MM_AcidInflictor", NULL)
    ply:SetNWEntity("MM_Assister", NULL)
    ply:SetNWEntity("MM_AssisterInflictor", NULL)
    ply:SetNWFloat("MM_FireDuration", 0)
    ply:SetNWInt("MM_FireDamage", 0)
    ply:SetNWEntity("MM_FireOwner", NULL)
    ply:SetNWEntity("MM_FireInflictor", NULL)
    ply:SetNWFloat("Sticky", 0)
    ply:SetNWEntity("Sticky_Attacker", NULL)
    ply:SetNWEntity("Sticky_Inflictor", NULL)
    ply:GetNWFloat("Battlerifle_alt", 0)
    ply:SetNWFloat("MM_Concussion",0)
    ply:SetNWInt("LegMissing", 0)
	ply:SetNWInt("ArmMissing", 0)
    ply:SetNWFloat("DiveCooldown", 0)
    if ply:GetNWInt("NumberShowingMedals") != 0 then
        ply:SetNWFloat("ShowMedal1", CurTime()+3)
        ply:SetNWFloat("ShowMedal2", CurTime()+3)
        ply:SetNWFloat("ShowMedal3", CurTime()+3)
    else
        ply:SetNWInt("NumberShowingMedals", 0)
        ply:SetNWFloat("ShowMedal1", 0)
        ply:SetNWFloat("ShowMedal2", 0)
        ply:SetNWFloat("ShowMedal3", 0)
        ply:SetNWString("ShowMedalType1", "")
        ply:SetNWString("ShowMedalType2", "")
        ply:SetNWString("ShowMedalType3", "")
    end
    ply:SetNWBool("KillFromBackstab", false)
    ply:SetNWBool("DamagedSelf", false)
    ply:SetNWBool("DamagedOther", false)
    ply:SetNWEntity("DamagedPlayer", NULL)
    ply:SetNWFloat("DamagedFrame", 0)
    
    // Wacky Round Manipulation
    if GetGlobalVariable("RoundsToWacky") == 0 && ply:Team() != 5 then
        if GetGlobalVariable("WackyRound_Event") == 0 then
            if GetGlobalVariable("WackyRound_COOPOther") == ply then
                ply:SetModel("models/player/kirito.mdl")
                ply:StripAmmo()
                ply:StripWeapons()
                ply:Give("mm_stick")
                ply:SetTeam(4)
                ply:SetBloodColor( BLOOD_COLOR_MECH )
                //ply:SetNWString("buff", "armor")
                ply:SetMaxHealth(2000)
                ply:SetHealth(2000)
            else
                ply:SetTeam(3)
            end
        elseif GetGlobalVariable("WackyRound_Event") == 1 then
            ply:SetTeam(3)
        end
    end
end


local function DisableNoclip( ply )
    if ply:Team() == 2 then
	return true
    end
end
hook.Add( "PlayerNoClip", "DisableNoclip", DisableNoclip )

function GM:PlayerAuthed( ply, steamID, uniqueID )
end

function GM:PlayerDisconnected( ply )
end

if ( CLIENT ) then return end

local function PlayerCanPickupWeapon( ply, weap )
	if GetGlobalVariable("RoundStartTimer") > CurTime() then return end
    
    if ( weap:GetClass() == "mm_headbutt" ) then
		return ( weap:GetClass() == "mm_headbutt" )
	end
    
    if ply:GetNWInt("ArmMissing") == 3 then return false end
    
    if ( weap:GetClass() == "mm_heal") then
		return ( weap:GetClass() == "mm_heal" )
	end
    
    if ( weap:GetClass() == "mm_revolver") then
		return ( weap:GetClass() == "mm_revolver" )
	end
	if ( weap:GetClass() == "mm_skull") then
		return ( weap:GetClass() == "mm_skull" )
    else
		if ( CurTime() <= ( ply.UseWeaponSpawn or 0 ) ) then return end
		if ( !ply:KeyDown( IN_USE ) ) then return false end
		if ply:HasWeapon(weap:GetClass()) then return false end
		local trace = util.TraceHull( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ( ply:GetAimVector() * 100 ),
			filter = ply,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		local weptbl = ply:GetWeapons()
		for k, v in pairs( weptbl ) do
			if ( !trace.Entity || !trace.Entity:IsValid() || trace.Entity != weap ) then
				return false
			end
			if (trace.Entity && trace.Entity:IsValid() && v:GetSlot() == trace.Entity:GetSlot()) then
				ply:DropWeapon(v)
			end
		end
	end
end
hook.Add( "PlayerCanPickupWeapon", "UseWeapon", PlayerCanPickupWeapon )

function GM:PlayerDeathThink( pl )

	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime()-2 ) then return end

	if ( pl:IsBot() || pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
	
		pl:Spawn()
	
	end
	
end

function GM:PlayerConnect( name, ip )
	if CLIENT then
		chat.AddText( Color( 255,105,0 ), name .. " has joined the mash.")
	end
end

function GM:PlayerDisconnected( ply )
end

local function up( ply, ent )
	return false
end
hook.Add( "AllowPlayerPickup", "some_unique_name", up )