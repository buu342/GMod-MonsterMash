AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "Menu/weapon_descriptions.lua" )
AddCSLuaFile( "Menu/cl_menu.lua" )
AddCSLuaFile( "Menu/cl_menu_old.lua" )  
AddCSLuaFile( "Music/cl_music.lua" )
AddCSLuaFile( "Flinch/cl_flinch.lua")
AddCSLuaFile( "HUD/cl_hud.lua" )
AddCSLuaFile( "HUD/cl_deathnotices.lua" )
AddCSLuaFile( "HUD/cl_scoreboard.lua" )
AddCSLuaFile( "Admin/adminlist.lua" )
AddCSLuaFile( "Admin/playerkick.lua" )
AddCSLuaFile( "Spawning/spookyspawn.lua" )
AddCSLuaFile( "globals.lua" )

include( 'shared.lua' )
include( 'Admin/adminlist.lua' )
include( 'Admin/playerkick.lua' )
include( 'Spawning/sv_spawn.lua' )
include( 'Menu/sv_menu.lua' )
include( 'Gore/sv_gore.lua' )
include( 'Flinch/sv_flinch.lua' )
include( 'Gore/ragdollblood.lua' )
include( 'Health/sv_health.lua' )
include( 'Gore/limbremoval.lua' )
include( 'Rounds/sv_kill_limit.lua' )

util.AddNetworkString( "ServerDoingTauntCamera" )

net.Receive("ServerDoingTauntCamera", function(len, ply)
	ply:SetNWBool("DoingTauntCamera", true)
	ply:SetCycle(0)
	timer.Simple(3, function() ply:SetNWBool("DoingTauntCamera", false) end)
end)

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

util.AddNetworkString( "ResetLimbs" )

local meta = FindMetaTable("Entity");

function meta:SetNWTable(name, tbl)
	self._nwtables = self._nwtables or {}
	self._nwtables[name] = tbl
end

function meta:GetNWTable(name, default)
    return self._nwtable and self._nwtable[name] or default
end

function GM:PlayerLoadout( pl )
end

util.AddNetworkString("MMPlyModel")
function setpmodel(len,client)
	local st = net.ReadString()
	if IsValid(client) then
		client:SetNWString("plymdl",st)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			if st == "models/monstermash/random_character.mdl" then
				client:SetModel(table.Random(models))
				client:SetupHands()
			else
				client:SetModel(st)
				client:SetupHands()
			end
		end
	end
end
net.Receive("MMPlyModel", setpmodel)

util.AddNetworkString("MMTeam")
function setteam(len,client)
	if IsValid(client) then
		if client:Team() == 2 then
			client:SetTeam(1)
			client:Spawn()
		else
			if GetGlobalVariable("RoundStartTimer") < CurTime() then
			client:ChatPrint("Changes will take effect after respawning")
			end
		end
	end
end
net.Receive("MMTeam", setteam)

util.AddNetworkString("MMSkin")
function setskin(len,client)
	if IsValid(client) then
        client:SetNWInt("plyskn",net.ReadInt(5))
	end
end
net.Receive("MMSkin", setskin)

util.AddNetworkString("MM_Wep_Melee")
function MM_Wep_Melee(len,client)
    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == client then return end
	if IsValid(client) then
		local wep = net.ReadString()
		local cost = net.ReadFloat()
        client:SetNWString("Melee",wep)
		client:SetNWInt("gold",client:GetNWInt("gold")-cost+client:GetNWInt("lastcost_Melee"))
		client:SetNWInt("lastcost_Melee",cost)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			local weptbl = client:GetWeapons()
			for k, v in pairs( weptbl ) do 
				if v:GetSlot() == 0 then
					v:Remove()
				end
				if wep != "" then
					client:Give(wep,false)
					client:SelectWeapon(wep)
				end
			end
		end
	end
end
net.Receive("MM_Wep_Melee", MM_Wep_Melee)

util.AddNetworkString("MM_Wep_Handgun")
function MM_Wep_Handgun(len,client)
    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == client then return end
	if IsValid(client) then
		local wep = net.ReadString()
		local cost = net.ReadFloat()
        client:SetNWString("Handgun",wep)
		client:SetNWInt("gold",client:GetNWInt("gold")-cost+client:GetNWInt("lastcost_Handgun"))
		client:SetNWInt("lastcost_Handgun",cost)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			local weptbl = client:GetWeapons()
			for k, v in pairs( weptbl ) do 
				if v:GetSlot() == 1 then
					v:Remove()
				end
				if wep != "" then
					client:Give(wep,false)
					client:SelectWeapon(wep)
				end
			end
		end
	end
end
net.Receive("MM_Wep_Handgun", MM_Wep_Handgun)

util.AddNetworkString("MM_Wep_Primary")
function MM_Wep_Primary(len,client)
    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == client then return end
	if IsValid(client) then
		local wep = net.ReadString()
		local cost = net.ReadFloat()
        client:SetNWString("Primary",wep)
		client:SetNWInt("gold",client:GetNWInt("gold")-cost+client:GetNWInt("lastcost_Primary"))
		client:SetNWInt("lastcost_Primary",cost)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			local weptbl = client:GetWeapons()
			for k, v in pairs( weptbl ) do 
				if v:GetSlot() == 2 then
					v:Remove()
				end
				if wep != "" then
					client:Give(wep,false)
					client:SelectWeapon(wep)
				end
			end
		end
	end
end
net.Receive("MM_Wep_Primary", MM_Wep_Primary)

util.AddNetworkString("MM_Wep_Throwable")
function MM_Wep_Throwable(len,client)
    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == client then return end
	if IsValid(client) then
		local wep = net.ReadString()
		local cost = net.ReadFloat()
        client:SetNWString("Throwable",wep)
		client:SetNWInt("gold",client:GetNWInt("gold")-cost+client:GetNWInt("lastcost_Throwable"))
		client:SetNWInt("lastcost_Throwable",cost)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			local weptbl = client:GetWeapons()
			for k, v in pairs( weptbl ) do 
				if v:GetSlot() == 3 then
					v:Remove()
				end
				if wep != "" then
					client:Give(wep,false)
					client:SelectWeapon(wep)
				end
			end
		end
	end
end
net.Receive("MM_Wep_Throwable", MM_Wep_Throwable)

util.AddNetworkString("MM_Wep_Buff")
function MM_Wep_Buff(len,client)
    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == client then return end
	if IsValid(client) then
		local wep = net.ReadString()
		local cost = net.ReadFloat()
        client:SetNWString("Buff",wep)
		client:SetNWInt("gold",client:GetNWInt("gold")-cost+client:GetNWInt("lastcost_Buff"))
		client:SetNWInt("lastcost_Buff",cost)
		if GetGlobalVariable("RoundStartTimer") > CurTime() then
			local weptbl = client:GetWeapons()
			for k, v in pairs( weptbl ) do 
				if v:GetSlot() == 0 then
					v:Remove()
				end
				if wep != "" then
					client:Give(wep,false)
					client:SelectWeapon(wep)
				end
			end
		end
	end
end
net.Receive("MM_Wep_Buff", MM_Wep_Buff)

util.AddNetworkString("MM_SelectWeapon")
function MM_SelectWeapon(len,client)
	if IsValid(client) then
		client:SetNWFloat("WeaponSelectOpen",CurTime()+1)
		client:SelectWeapon(net.ReadString())
	end
end
net.Receive("MM_SelectWeapon",MM_SelectWeapon)

util.AddNetworkString("MM_SelectWeaponOpen")
function MM_SelectWeaponOpen(len,client)
	if IsValid(client) then
		local wep = net.ReadEntity()
		if IsValid(client) && client:GetActiveWeapon() != nil && client:GetActiveWeapon():GetClass() != nil && wep != nil && wep:GetClass() != nil && client:GetActiveWeapon():GetClass() != wep:GetClass() then
		client:SetNWFloat("WeaponSelectOpen",CurTime()+1.1)
		end
	end
end
net.Receive("MM_SelectWeaponOpen",MM_SelectWeaponOpen)

concommand.Add( "mm_healplayer", function( ply )
    if SERVER then
		if GetGlobalVariable("RoundStartTimer") > CurTime() then return end
        if IsValid(ply:GetActiveWeapon()) && ply:Health() < ply:GetMaxHealth() && ply:GetNWFloat("HealTime") < CurTime() then
			ply:Give("mm_heal")
			ply:SelectWeapon("mm_heal")
			ply:SetNWFloat("HealTime", CurTime()+ 20)
        end
    end
end )

concommand.Add( "mm_givelight", function( ply )
    if SERVER then
        if IsValid(ply) then
            ply:SelectWeapon("mm_candlestick")
        end
    end
end )

util.AddNetworkString( "RebuildWeapons" )

local NextSkelly = 0
local SkellySpawnCount = 0
hook.Add("Think", "Spooked", function()
	for k, v in pairs( ents.FindByClass("player") ) do
		if v:GetNWFloat("MM_FireDuration") < CurTime() && v:GetNWBool("FireSoundOn") == true then
			v:SetNWBool("FireSoundOn", false)
			v.sound:Stop()
		end
        if IsValid(v) && v:GetNWFloat("Spooked") > CurTime() && v:Team() != 3  then
			v:Freeze(true)
			timer.Simple(2.5,function() if !IsValid(v) then return end v:Freeze(false) end)
		end
        if IsValid(v) && v:GetNWFloat("Sticky") > CurTime() then
            v.WebSound = CreateSound(v, "ambient/creatures/leech_bites_loop1.wav")
            if v.WebSound then
                v.WebSound:SetSoundLevel( 35 ) 
                v.WebSound:Play()
            end
            if v:GetNWFloat("Sticky_Bite") < CurTime() then
                v:SetNWFloat("Sticky_Bite",CurTime()+0.5)
                v:TakeDamage(3, v:GetNWFloat("Sticky_Attacker"), v:GetNWFloat("Sticky_Inflictor"))
            end
        elseif v.WebSound then
            v.WebSound:Stop()
		end
		if !IsValid(v:GetActiveWeapon()) then
			v:SelectWeapon("mm_candlestick")
			v:SelectWeapon(v:GetNWString("Throwable"))
			v:SelectWeapon(v:GetNWString("Melee"))
			v:SelectWeapon(v:GetNWString("Handgun"))
			v:SelectWeapon(v:GetNWString("Primary"))
		end
		if IsValid(v) && v:HasGodMode() then
			if (v:GetVelocity():Length() > 50 || v:KeyDown(IN_ATTACK) || (v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() && (v:GetNWFloat("DivingRight") != -1 || v:GetNWFloat("DivingLeft") != -1))) && v:GetNWInt("SpawnTime") < CurTime() then
				if !(GetConVar("mm_tasermanmode"):GetInt() == 1 && (v:GetModel() == "models/monstermash/deer_haunter_final.mdl")) then
                    v:GodDisable() 
				end
				v:SetMaterial( "", true )
			end
		end
		if IsValid(v) && (v:IsPlayingTaunt() || v:GetNWFloat("MM_Deanimatorstun") > CurTime() || v:GetNWFloat("DivingLeft") > CurTime() || v:GetNWFloat("DivingRight") > CurTime()) then
			v:Freeze( true )
		elseif IsValid(v) && v:GetNWFloat("Spooked") < CurTime() && GetGlobalVariable("RoundStartTimer") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() && v:GetNWFloat("DivingRight") < CurTime() then
			v:Freeze( false )
		end
        if v:GetNWFloat("HealthRegen") < CurTime() then
            v:SetHealth(math.Clamp(v:Health() + 1, 0, v:GetMaxHealth()))
            v:SetNWFloat("HealthRegen", CurTime()+GetConVar("mm_healthregentime"):GetInt())
        end
		if IsValid(v) && v:HasGodMode() && v:GetNWFloat("DivingLeft") < CurTime() && v:GetNWFloat("DivingRight") < CurTime() then
			v:SetNWFloat("MM_BleedTime", 0)
			v:SetNWInt("MM_BleedDamage", 0)
			v:SetNWFloat("MM_Concussion",0)
			if v:Team() == 1 then
				v:SetMaterial( "models/props_combine/tprings_globe", true )
			end
		elseif IsValid(v) && v:GetNWFloat("Bloodied") > CurTime() && v:Team() != 3  then
			v:SetMaterial( "Models/flesh", true )
			v:SetRunSpeed(120)
			v:SetWalkSpeed(120)
		elseif IsValid(v) && v:GetNWFloat("Acidied") > CurTime() && v:Team() != 3  then
			v:SetMaterial( "Models/flesh", true )
		else
			v:SetMaterial( "", true )
		end
		if v:GetNWFloat("mm_musketpistol_recharge") < CurTime() && v:HasWeapon("mm_musketpistol") && v:GetWeapon("mm_musketpistol"):Clip1() == 0 then
			v:GetWeapon("mm_musketpistol"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_urn_recharge") < CurTime() && v:HasWeapon("mm_urn") && v:GetWeapon("mm_urn"):Clip1() == 0 then
			v:GetWeapon("mm_urn"):SetClip1( 1 )
		end
        if v:GetNWFloat("mm_web_recharge") < CurTime() && v:HasWeapon("mm_spidernade") && v:GetWeapon("mm_spidernade"):Clip1() == 0 then
			v:GetWeapon("mm_spidernade"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_acid_recharge") < CurTime() && v:HasWeapon("mm_acidflask") && v:GetWeapon("mm_acidflask"):Clip1() == 0 then
			v:GetWeapon("mm_acidflask"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_pumpkinnade_recharge") < CurTime() && v:HasWeapon("mm_pumpkinnade") && v:GetWeapon("mm_pumpkinnade"):Clip1() == 0 then
			v:GetWeapon("mm_pumpkinnade"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_cleaver_recharge") < CurTime() && v:HasWeapon("mm_cleaver") && v:GetWeapon("mm_cleaver"):Clip1() == 0 then
			v:GetWeapon("mm_cleaver"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_gorejar_recharge") < CurTime() && v:HasWeapon("mm_gorejar") && v:GetWeapon("mm_gorejar"):Clip1() == 0 then
			v:GetWeapon("mm_gorejar"):SetClip1( 1 )
		end
		if v:GetNWFloat("mm_stake_recharge") < CurTime() && v:HasWeapon("mm_stake") && v:GetWeapon("mm_stake"):Clip1() == 0 then
			v:GetWeapon("mm_stake"):SetClip1( 1 )
		end
        if v:GetNWFloat("mm_skull_recharge") < CurTime() && v:HasWeapon("mm_skull") && v:GetWeapon("mm_skull"):Clip1() == 0 then
			v:GetWeapon("mm_skull"):SetClip1( 1 )
		end
		if v:GetNWFloat("MM_BleedTime") < CurTime() && v:GetNWInt("MM_BleedDamage") >= 1 && v:Team() != 3 then
			if v:Health()-v:GetNWInt("MM_BleedDamage") <= 0 then
                v:SetNWBool("DiedFromBleed", true)
				v:TakeDamage(v:GetNWInt("MM_BleedDamage"),v:GetNWEntity("MM_BleedOwner"),v:GetNWEntity("MM_BleedInflictor"))
				v:SetNWInt("MM_BleedDamage", 0)
				v:SetNWFloat("MM_BleedTime", 0)
			else
				v:TakeDamage(v:GetNWInt("MM_BleedDamage"),v:GetNWEntity("MM_BleedOwner"),v:GetNWEntity("MM_BleedInflictor"))
				v:SetNWInt("MM_BleedDamage", v:GetNWInt("MM_BleedDamage")-1)
				v:SetNWFloat("MM_BleedTime", CurTime()+1)
                if v:Health()-v:GetNWInt("MM_BleedDamage") <= 0 then
                    v:SetNWBool("DiedFromBleed", true)
                end
			end
			if v:Alive() then
				v:GetNWEntity("MM_BleedOwner"):ConCommand("play gameplay/hit_sound.wav")
			end
			if v:Alive() then
				local start = v:GetPos()
				local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
				util.Decal("Blood", btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal,v)
				local effectdata = EffectData()
				effectdata:SetOrigin( v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Spine2")))
				util.Effect( "BloodImpact", effectdata )
			end
		end
		
		if v:GetNWFloat("MM_FireDuration") > CurTime() && v:Team() != 3  then
			if v:GetNWFloat("MM_FireTime") < CurTime() then
				if v:Health()-v:GetNWInt("MM_FireDamage") <= 0 then
					v:TakeDamage(v:GetNWInt("MM_FireDamage"),v:GetNWEntity("MM_FireOwner"),v:GetNWEntity("MM_FireInflictor"))
					v:SetNWInt("MM_FireDamage", 0)
					v:SetNWFloat("MM_FireTime", 0)
				else
					v:TakeDamage(v:GetNWInt("MM_FireDamage"),v:GetNWEntity("MM_FireOwner"),v:GetNWEntity("MM_FireInflictor"))
					v:SetNWFloat("MM_FireTime", CurTime()+0.5)
				end
				if v:Alive() && v:IsPlayer() then
					v:GetNWEntity("MM_FireOwner"):ConCommand("play gameplay/hit_sound.wav")
				end
			end
		end
		
		if v:GetNWFloat("Acidied") > CurTime() && v:Team() != 3  then
			if v:GetNWFloat("MM_AcidTime") < CurTime() then
				if v:Health()-v:GetNWInt("MM_AcidDamage") <= 0 then
					v:TakeDamage(v:GetNWInt("MM_AcidDamage"),v:GetNWEntity("MM_AcidOwner"),v:GetNWEntity("MM_AcidInflictor"))
					v:SetNWInt("MM_AcidDamage", 0)
					v:SetNWFloat("MM_AcidTime", 0)
				else
					v:TakeDamage(v:GetNWInt("MM_AcidDamage"),v:GetNWEntity("MM_AcidOwner"),v:GetNWEntity("MM_AcidInflictor"))
					v:SetNWFloat("MM_AcidTime", CurTime()+0.5)
				end
				if IsValid(v) && v:Alive() && IsValid(v:GetNWEntity("MM_AcidOwner")) && v:GetNWEntity("MM_AcidOwner") != nil then
					v:GetNWEntity("MM_AcidOwner"):ConCommand("play gameplay/hit_sound.wav")
				end
			end
		end
        if v:GetNWFloat("DivingLeft") > CurTime() then
            local vec = Vector(v:GetAimVector().x, v:GetAimVector().y, 0)
            vec:Rotate( Angle(0,-90,0) )
            v:SetVelocity( -Vector(v:GetVelocity().x,v:GetVelocity().y,0) -vec*300 )
            if v:GetNWFloat("NextDiveSound") <= CurTime() then
                v:SetNWFloat("NextDiveSound", CurTime() + 0.2)
                if SERVER then
                    v:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav", math.Rand(80, 100), math.Rand(90, 120))
                end		
            end
            v:GodEnable()
        elseif v:GetNWFloat("DivingRight") > CurTime() then
            local vec = Vector(v:GetAimVector().x, v:GetAimVector().y, 0)
            vec:Rotate( Angle(0,90,0) )
            v:SetVelocity( -Vector(v:GetVelocity().x,v:GetVelocity().y,0) -vec*300 )
            if v:GetNWFloat("NextDiveSound") <= CurTime() then
                v:SetNWFloat("NextDiveSound", CurTime() + 0.2)
                if SERVER then
                    v:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav", math.Rand(80, 100), math.Rand(90, 120))
                end		
            end
            v:GodEnable()
        end
        
        if v:GetNWFloat("ShowMedal1") < CurTime() && v:GetNWInt("NumberShowingMedals") > 0 && v:Alive() then
            v:SetNWFloat("ShowMedal1", v:GetNWFloat("ShowMedal2"))
            v:SetNWFloat("ShowMedal2", v:GetNWFloat("ShowMedal3"))
            v:SetNWString("ShowMedalType1", v:GetNWString("ShowMedalType2"))
            v:SetNWString("ShowMedalType2", v:GetNWString("ShowMedalType3"))
            v:SetNWInt("NumberShowingMedals", v:GetNWInt("NumberShowingMedals")-1)
        end
        
        // Extinguish dead/spectators
        if v:IsOnFire() && (v:Team() == 2 || v:Team() == 5) then
           v:Extinguish()
        end
    end
    
	for k, ent in pairs( ents.FindByClass("prop_ragdoll") ) do
		if ent:GetMaterial() == "Models/player/monstermash/gibs/burn" then
			ent:SetNWInt("particlenum",ent:GetNWInt("particlenum")+1)
			if ent:GetNWInt("particlenum") % 5 == 0 then
                local attachment = ent:LookupBone("ValveBiped.Bip01_Spine2")
                local position, angles = ent:GetBonePosition( attachment )
                local effectdata = EffectData()
                effectdata:SetOrigin( position )
                util.Effect( "corpse_smoke", effectdata )
			end
		end
	end
    
    // Rebuild Weapon cache when editing the gamemode
    if MonsterMash_Weapons["melee"][3] == nil then
        ImplementWeapons()
        net.Start( "RebuildWeapons" )
        net.Broadcast()
    end
    
    // Wacky Round Stuff
    if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 1 && GetGlobalVariable("RoundStartTimer") < CurTime() && GetGlobalVariable("Game_Over") == false then
        if NextSkelly == 0 then
            NextSkelly = CurTime() + 5
        elseif NextSkelly < CurTime() then
            SkellySpawnCount = SkellySpawnCount + 1
            NextSkelly = CurTime() + 3
            local spawns = ents.FindByClass( "info_player_start" )
            local random_entry = table.Random(spawns)
            
            local skull = NULL
            if (SkellySpawnCount % 8) == 0 then
                skull = ents.Create("sent_jitterskull")
            else
                skull = ents.Create("sent_skellington")
            end
            skull:SetPos(random_entry:GetPos()+Vector(0,0,60))
            skull:Spawn()
            skull:Activate()
        end
    elseif GetGlobalVariable("RoundsToWacky") != 0 && NextSkelly != 0 then
        NextSkelly = 0
        SkellySpawnCount = 0
        local ent = ents.FindByClass( "sent_jitterskull" )
        for i=1, #ent do
            ent[i]:TakeDamage(1337, NULL, NULL)
        end
        ent = ents.FindByClass( "sent_skellington" )
        for i=1, #ent do
            ent[i]:TakeDamage(1337, NULL, NULL)
        end
    end
end)

function CalculateMedalStuff(ply, type)
    if ply:GetNWInt("NumberShowingMedals") == 3 then
        ply:SetNWInt("NumberShowingMedals", 2)
        ply:SetNWFloat("ShowMedal1", ply:GetNWFloat("ShowMedal2"))
        ply:SetNWFloat("ShowMedal2", ply:GetNWFloat("ShowMedal3"))
        ply:SetNWString("ShowMedalType1",  ply:GetNWString("ShowMedalType2"))
        ply:SetNWString("ShowMedalType2",  ply:GetNWString("ShowMedalType3"))
    end
    ply:SetNWInt("NumberShowingMedals", ply:GetNWInt("NumberShowingMedals")+1)
    
    ply:SetNWFloat("ShowMedal"..tostring(ply:GetNWInt("NumberShowingMedals")), CurTime()+3)
    ply:SetNWString("ShowMedalType"..tostring(ply:GetNWInt("NumberShowingMedals")), type)
end

function GM:CanPlayerSuicide( ply )
    if ply:Team() == 2 || ply:Team() == 5 then
        return false
    else
        return true
    end
end

function AddMedal(ply, type)
    if GetConVar("mm_medals"):GetInt() == 0 then return end
    if !ply:IsPlayer() then return end
    CalculateMedalStuff(ply, type)
    
    ply:ConCommand("play ui/bell1.wav")
    
    if     type == "gib"                then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "behead"             then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 25)
    elseif type == "1hitkill"           then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "killwhileconcussed" then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 20)
    elseif type == "killwhilelimbless"  then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 20)
    elseif type == "killwhilebleeding"  then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "neardeath"          then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "longrange"          then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "backstab"           then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 25)
    elseif type == "post_mortem"        then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    elseif type == "concuss"            then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10) ply:SetNWInt("LastScore", 10)
    elseif type == "dismember"          then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 15) ply:SetNWInt("LastScore", 15)
    elseif type == "random"             then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 5)
    elseif type == "immobilized"        then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 5)
    elseif type == "honorabledeath"     then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 5)
    elseif type == "youtried"           then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 5)
    elseif type == "bleed"              then ply:SetNWInt("killcounter", ply:GetNWInt("killcounter") + 10)
    end
end

util.AddNetworkString( "DoLeftDive" )
util.AddNetworkString( "DoRightDive" )