local RedBloodEffect = {
	"blood_advisor_pierce_spray",
	"blood_advisor_pierce_spray_b",
	"blood_advisor_pierce_spray_c",
	"blood_advisor_puncture_withdraw",
	"blood_zombie_split_spray"
}

local deathanims = {
    ["general"] = {
        "death_02",
        "death_03",
        "death_kneel_faceplant",
        "death_kneel_fallback",
        "death_l4d_clutch_faceplant",
        "death_l4d_clutch_kneel",
        "death_l4d_crumple_forward",
        "death_l4d_twirl1",
        "death_l4d_twirl2",
        "death_l4d_twirl3",
        "death_slump_backwards",
        "death_slump_forward1",
        "death_slump_forward2",
        "death_slump_forward3",
        "death_twirl_back",
        "death_l4d_kneel_fallforward",
        "death_l4d_fallback1",
        "death_l4d_fallback2",
        "death_l4d_fallback3",
    },
    ["headshot"] = {
        "death_04",
        "death_kneel_faceplant",
        "death_slump_forward1",
        "death_slump_forward3",
        "death_step_faceplant",
        "death_l4d_headshot_backward",
        "death_l4d_headshot_forward",
        "death_l4d_fallback1",
        "death_l4d_kneel_fallforward",
    },
    ["cleaver"] = {
        "death_01",
        "death_kneel_faceplant",
        "death_slump_forward2",
        "death_slump_forward3",
        "death_twirl_back"
    },
    ["stake"] = {
        {"death_04", 1},
        {"death_abdomen_front", 1},
        {"death_kneel_struggle", 1},
        {"death_slump_forward2", 1},
        {"death_l4d_stepback_fall", 1.8},
        {"death_l4d_stepback_kneel", 1.8}
    },
    ["shotgun"] = {
        "death_blast_back",
        "death_blast_front",
        "death_blast_left",
        "death_blast_right"
    },
    ["acid"] = {
        "death_kneel_fallback",
        "death_kneel_struggle",
        "death_step_faceplant"
    },
    ["locomotion"] = {
        ["Left"] = {"death_strafing_left"},
        ["Right"] = {"death_strafing_right"},
        ["Back"] = {"death_thud_back", "death_l4d_stepback_fall"},
        ["Forward"] = {"death_twirl_back", "death_l4d_running1", "death_l4d_running2"}
    }
}

util.AddNetworkString("MMPlayerKilled")
util.AddNetworkString("MMNPCKilled")

function GM:PlayerDeathSound()
    return true
end

local function WeaponHasKillFlag(wep, flag)
    if (wep == nil || !IsValid(wep)) then return nil end
    
    return (wep:IsWeapon() && bit.band(wep.KillFlags, flag) != 0)
end

function GM:DoPlayerDeath(victim, attacker, dmginfo)

    if (victim:Team() == TEAM_SPECT || victim:Team() == TEAM_COOPDEAD) then return end
    
    local inflictor = dmginfo:GetInflictor()
    
    if (victim == attacker || attacker:IsWorld()) then
        local vicstring = tostring(victim)
        local dmgtable = victim:GetLastDamage().dmgtable
        local smallest = vicstring
        local smallesttime = CurTime()-4
        
        if (dmgtable != nil) then
            for k, v in pairs(dmgtable) do
                if k != vicstring && v.time > smallesttime then
                    smallest = k
                    smallesttime = v.time
                end
            end
            
            if smallest != vicstring then
                attacker = dmgtable[smallest].attacker
                inflictor = dmgtable[smallest].inflictor
                if (attacker:IsPlayer()) then
                    attacker:GiveTreat("assisted_suicide")
                end
            end
            
            local thisplayerhit = {}
            for k, v in pairs(player.GetAll()) do
                if (v:Alive() && v:GetLastDamage().dmgtable != nil) then
                    for a, b in pairs(v:GetLastDamage().dmgtable) do
                        if (b.attacker == victim && b.time == CurTime()) then
                            table.insert(thisplayerhit, v)
                            break
                        end
                    end
                end
            end
            if (#thisplayerhit > 0) then
                victim:GiveTreat("youtried")
            end
        end
    end

    // Get what direction the player was moving when he died
    local pang = (math.Round(math.AngleDifference(victim:GetVelocity():GetNormalized():Angle().y, victim:GetAngles().y))+360)%360  
    if (victim:GetVelocity():Length() < 5) then
        victim.deathang = ""
    elseif (pang > 315 || pang < 45) then
        victim.deathang = "Forward"
    elseif (pang > 45 && pang < 135) then
        victim.deathang = "Left"
    elseif (pang > 135 && pang < 225) then
        victim.deathang = "Back"
    elseif (pang > 225 && pang < 315) then
        victim.deathang = "Right"
    else
        victim.deathang = ""
    end
    
    // Create the ragdoll entity and add deaths to the victim
    victim:CreateRagdoll()
	victim:AddDeaths(1)
	victim:Freeze(false)
    victim:SetDieTime()
    self:IncrementPlayerStat(victim, "Deaths")
    
    // Ludicrous gibs
    if (GetConVar("mm_ludicrousgibs"):GetBool()) then
        victim:ClearKillFlags()
        victim:SetKillFlag(KILL_GIB)
    end
    
    // Funny death sounds
    if GetConVar("mm_tasermanmode"):GetBool() then
        victim:EmitSound("death/death8.wav")
    elseif GetConVar("mm_orgasmicdeathsounds"):GetBool() then
        victim:EmitSound("death/death"..math.random(1,7)..".wav")
    end
    
    // Add frags to the killer
	if (attacker != nil && attacker:IsPlayer()) then
		if (attacker == victim) then
			attacker:AddFrags(-1)
            self:IncrementPlayerStat(attacker, "Suicides")
		else
			attacker:AddFrags(1)
            self:IncrementPlayerStat(attacker, "Kills")
		end
	end
    
    // Treats
    if (victim != attacker && attacker:IsPlayer()) then
        local attacker_hitnonmelee = false
        local attacker_hitmeleelast = false
        local stacksize = #victim:GetDamageStack()
        attacker:StoreWeaponKill(inflictor)
		
        for k, v in pairs (victim:GetDamageStack()) do
            if k != stacksize && v.attacker == attacker && v.inflictor != nil && v.inflictor:IsWeapon() && v.inflictor.Base != "weapon_mm_basemelee" then
                attacker_hitnonmelee = true
            end
            if (k == stacksize) then
                if (v.inflictor != nil && v.inflictor.Base == "weapon_mm_basemelee") then
                    attacker_hitmeleelast = true
                end
            end
        end
    
        if (!inflictor.IsMMNPC) then
            attacker:AddLifeKill()
        end
        attacker:AddScore(dmginfo:GetInflictor().Points)
        
        if (inflictor != nil && inflictor:IsWeapon()) then
            if (inflictor.slot == 0) then
                attacker:IncrementPlayerStat("Melee_Kills")
            elseif (inflictor.slot == 1) then
                attacker:IncrementPlayerStat("Handgun_Kills")
            elseif (inflictor.slot == 2) then
                attacker:IncrementPlayerStat("Primary_Kills")
            elseif (inflictor.slot == 3) then
                attacker:IncrementPlayerStat("Throwable_Kills")
            end
        end
        
        if (#attacker:GetDamageStack() > 2) then
            local lastdamage1 = nil
            local lastdamage2 = nil
            for i = #attacker:GetDamageStack(), 1, -1 do
                if (lastdamage1 == nil) then
                    if (attacker:GetDamageStack()[i].time+10 < CurTime()) then
                        break
                    end
                    lastdamage1 = attacker:GetDamageStack()[i].attacker
                elseif (attacker:GetDamageStack()[i].attacker != lastdamage1) then
                    lastdamage2 = attacker:GetDamageStack()[i].attacker
                    if (attacker:GetDamageStack()[i].time+10 < CurTime()) then
                        lastdamage2 = nil
                    end
                    break
                end
            end
            if ((lastdamage1 == victim && lastdamage2 == attacker.lastkill) || (lastdamage2 == victim && lastdamage1 == attacker.lastkill)) then
                attacker:GiveTreat("two_attackers")
            end
        end
        
        if (attacker_hitnonmelee && attacker_hitmeleelast) then
            attacker:GiveTreat("finish_with_melee")
        end
        if (!GAMEMODE:GetFirstBlood()) then
            attacker:GiveTreat("firstblood")
            GAMEMODE:SetFirstBlood()
        end
        if (attacker:GetLifeKills() == 3) then
            attacker:GiveTreat("killstreak")
        end
        if victim:HasKillFlag(KILL_BLEED) then
            attacker:GiveTreat("bleed")
        end
        if victim:HasKillFlag(KILL_FIRE) then
            attacker:GiveTreat("fire")
        end
        if attacker:GetLastKiller() == victim:SteamID64() then
            attacker:GiveTreat("revenge")
            attacker:SetLastKiller(nil)
        end
        if (inflictor.Base == "weapon_mm_basemelee" && inflictor.Base == "weapon_mm_basemelee") then
            attacker:GiveTreat("melee_duel")
        end
        if (inflictor.Base == "weapon_mm_basemelee" && inflictor.Base == "weapon_mm_basegun") then
            attacker:GiveTreat("melee_guns")
        end
        for k, v in pairs (attacker.WeaponTemp) do
            if (v == "Random" && k != "Trick_NextLife" && GAMEMODE.Weapons[k][dmginfo:GetInflictor():GetClass()] != nil) then
                attacker:GiveTreat("random")
            end
        end
        if (!inflictor.IsMMNPC) then
            if (attacker:Alive() && attacker:Health() <= 20) then
                attacker:GiveTreat("neardeath")
            end
            if (!attacker:Alive()) then
                attacker:GiveTreat("post_mortem")
            end
            if (attacker:HasStatusEffect(STATUS_BLEED)) then
                attacker:GiveTreat("killwhilebleeding")
            end
            if (attacker:HasStatusEffect(STATUS_CONCUSS)) then
                attacker:GiveTreat("killwhileconcussed")
            end
            if (attacker:HasStatusEffect(STATUS_GOREJARED)) then
                attacker:GiveTreat("killwhilegorejar")
            end
            if (victim:HasStatusEffect(STATUS_GOREJARED)&& victim:GetActiveWeapon().Base == "weapon_mm_basegun") then
                attacker:GiveTreat("killed_jammed")
            end
            if (attacker:MissingAnArm() || attacker:MissingALeg()) then
                attacker:GiveTreat("killwhilelimbless")
            end
            if (attacker:HasStatusEffect(STATUS_HALLUCINATING)) then
                attacker:GiveTreat("while_tripping")
            end
            if (WeaponHasKillFlag(inflictor, KILL_BACKSTAB)) then
                attacker:GiveTreat("backstab")
            end
            if (attacker:HasStatusEffect(STATUS_SPOOKED) || attacker:HasStatusEffect(STATUS_SPIDERWEBBED) || 
                attacker:HasStatusEffect(STATUS_BATS) || attacker:HasStatusEffect(STATUS_SELFELECTROCUTED)) then
                attacker:GiveTreat("while_immobilized")
            end
            if (victim:HasStatusEffect(STATUS_SPOOKED) || victim:HasStatusEffect(STATUS_SPIDERWEBBED) || 
                victim:HasStatusEffect(STATUS_BATS) || victim:HasStatusEffect(STATUS_SELFELECTROCUTED)) then
                attacker:GiveTreat("immobilized")
            end
            if (attacker:GetPos():Distance(victim:GetPos()) >= 1024) then
                attacker:GiveTreat("longrange")
            end
            if (IsValid(victim:GetActiveWeapon()) && victim:GetActiveWeapon().Base == "weapon_mm_basegun" && victim:GetActiveWeapon():GetMMBase_ReloadTimer() > CurTime()) then
                attacker:GiveTreat("killed_reloading")
            end
            if (victim:HasStatusEffect(STATUS_MELEECHARGE)) then
                attacker:GiveTreat("dash_kill")
            end
            if (attacker:HasStatusEffect(STATUS_MELEECHARGE) || attacker:HasStatusEffect(STATUS_MELEECHARGEEXTRA)) then
                attacker:GiveTreat("dash")
            end
            if (!victim:IsOnGround()) then
                attacker:GiveTreat("airborne")
            end
            if (IsValid(victim:GetActiveWeapon()) && victim:GetActiveWeapon():GetClass() == "weapon_mm_candycorn") then
                attacker:GiveTreat("kill_healing")
            end
        end
        if (victim:GetLifeKills() >= 3) then
            attacker:GiveTreat("spree_ender")
        end
        victim:SetLastKiller(attacker)
        attacker.lastkill = victim
    end

    // Spawn a little ghost
    local effectdata = EffectData()
	effectdata:SetStart(victim:GetPos()+Vector(0,0,50)) 
	effectdata:SetOrigin(victim:GetPos()+Vector(0,0,50))
	util.Effect("mm_Spoopyghost", effectdata)
    
    // Select the player's death
    if (dmginfo:GetDamageType() != DMG_DISSOLVE) then
        if (victim:HasKillFlag(KILL_BLEED)) then
            self:GoreNormalDeath(victim)
            victim:GetRagdollEntity():Remove()
        elseif (victim:HasKillFlag(KILL_ACID)) then
            self:GoreMelter(victim)
            victim:GetRagdollEntity():Remove()
        elseif (WeaponHasKillFlag(inflictor, KILL_MELTER) || victim:HasKillFlag(KILL_MELTER)) then
            self:GoreMelter(victim)
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && WeaponHasKillFlag(inflictor, KILL_SKELETIZE)) then
            self:GoreSkeletize(victim)
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && victim:GetCharacter().decapitates && WeaponHasKillFlag(inflictor, KILL_DECAPITATE)) then
            self:GoreDecapitate(victim)
            if (victim != attacker && attacker:IsPlayer()) then
                attacker:GiveTreat("behead")
            end
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && victim:GetCharacter().decapitates && WeaponHasKillFlag(inflictor, KILL_HEADEXPLODE) && victim:GetLastHitgroup() == HITGROUP_HEAD) then
            self:GoreHeadExplode(victim)
            if (victim != attacker && attacker:IsPlayer()) then
                attacker:GiveTreat("behead")
            end
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && victim:GetCharacter().bifurcates && WeaponHasKillFlag(inflictor, KILL_BIFURCATE)) then
            self:GoreBifurcate(victim)
            victim:GetRagdollEntity():Remove()
        elseif (victim:GetCharacter().gibs && (WeaponHasKillFlag(inflictor, KILL_GIB)) || victim:HasKillFlag(KILL_GIB)) then
            self:GoreExplode(victim)
            if (victim != attacker && attacker:IsPlayer() && !inflictor.IsMMNPC) then
                attacker:GiveTreat("gib")
            end
            victim:GetRagdollEntity():Remove()
        elseif (victim:GetCharacter().gibs && WeaponHasKillFlag(inflictor, KILL_GIBTHRESHOLD) && victim:GetLastDamage().totalamount >= 100) then
            self:GoreExplode(victim)
            if (victim != attacker && attacker:IsPlayer() && !inflictor.IsMMNPC) then
                attacker:GiveTreat("gib")
            end
            victim:GetRagdollEntity():Remove()
        elseif (WeaponHasKillFlag(inflictor, KILL_ELECTRIC)) then
            self:GoreElectric(victim)
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && WeaponHasKillFlag(inflictor, KILL_SCRIPTED)) then
            self:GoreScripted(victim, inflictor)
            victim:GetRagdollEntity():Remove()
        elseif (WeaponHasKillFlag(inflictor, KILL_GRAVE)) then
            self:GoreGrave(victim)
            victim:GetRagdollEntity():Remove()
        elseif (victim:HasStatusEffect(STATUS_ONFIRE)) then
            self:GoreFire(victim)
            victim:GetRagdollEntity():Remove()
        elseif (!victim:MissingBothLegs() && victim:GetLastDamage().totalamount >= 50 && bit.band(dmginfo:GetDamageType(), DMG_BULLET) == DMG_BULLET) then
            MakeExtraBodyGibs(victim, dmginfo)
            self:BlowTorsoOff(victim)
            victim:GetRagdollEntity():Remove()
        else
            if victim:IsOnGround() && math.random(1, 2) == 1 && !victim:MissingBothLegs() then
                self:GoreScripted(victim, inflictor)
            else
                self:GoreNormalDeath(victim, inflictor)
            end
            MakeExtraBodyGibs(victim, dmginfo)
            victim:GetRagdollEntity():Remove()
        end
    end
    
    local killtable = {
        attacker = attacker,
        victim = victim,
        inflictor = inflictor,
        killflags = victim:GetKillFlags()
    }
    net.Start("MMPlayerKilled")
        net.WriteTable(killtable)
    net.Broadcast()
    
    victim:ResetLifeStats()
    victim:ClearStatusEffects()
    self:SavePlayerStats(victim)
    
    if (GAMEMODE:InWackyRound()) then
        if (GAMEMODE:WackyRoundData().mode == MODE_CONVERT) then
            victim:SetTeam(TEAM_COOPOTHER)
        elseif (GAMEMODE:WackyRoundData().allow_respawn == false) then
            victim:SetTeam(TEAM_COOPDEAD)
        end
    end

end

function MakeExtraBodyGibs(ply, dmginfo)
    if (ply:GetLastDamage().totalamount >= 30 && bit.band(dmginfo:GetDamageType(), DMG_BULLET) == DMG_BULLET) then
        local ent = ents.Create("prop_ragdoll")
        ent:SetModel(ply:GetCharacter().gib_chunks)
        ent:SetSkin(ply:GetSkin())
        ent:SetPos(dmginfo:GetDamagePosition())
        ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        ent:Spawn()
        ent:Activate()
        if (ply:GetCharacter().bloodtype == BLOODTYPE_NONE) then
            ent:EmitSound("death/damage_bones.wav")
        else
            ent:EmitSound("death/damage_flesh.wav")
        end
        if ent:IsValid() then
            for i = 1, ent:GetPhysicsObjectCount() do
                local bone = ent:GetPhysicsObjectNum(i)
                if bone and bone.IsValid and bone:IsValid() then
                    bone:AddVelocity(VectorRand()*300)
                end
            end
        end
        timer.Simple(GetConVar("mm_cleanup_time"):GetInt(), function() if IsValid(ent) then ent:Remove() end end)
    end
end

function KillTimer(name)
    if timer.Exists(name) then
        timer.Stop(name)
        timer.Remove(name)
    end
end

function SpectateEntity(ply, ent)
    if !IsValid(ply) || ply == nil then return end
    if !IsValid(ent) || ent == nil then return end
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(ent)
    KillTimer("Cleanup_"..tostring(ent))
    
    timer.Create(tostring(ent).."_spectate", GetConVar("mm_cleanup_time"):GetInt(), 0, function()
        if (ent == nil || !IsValid(ent)) then return end
        
        if (!IsValid(ply) || ply == nil || ply:GetObserverTarget() != ent) then 
            ent:Remove() 
            KillTimer(tostring(ent).."_spectate")
            return
        end
    end)
end

function GM:BlowTorsoOff(ply)
    local ent = ents.Create("prop_ragdoll")
    ent:SetModel(ply:GetCharacter().gib_torso)
    ent:SetSkin(ply:GetSkin())
    ent:SetPos(ply:GetPos())
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ent:Spawn()
    ent:Activate()
    if (ply:GetCharacter().bloodtype == BLOODTYPE_NONE) then
        ent:EmitSound("death/damage_bones.wav")
    else
        ent:EmitSound("death/damage_flesh.wav")
    end
    if ent:IsValid() then
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                bone:AddVelocity(VectorRand()*100)
            end
        end
    end
    timer.Create("Cleanup_"..tostring(ent), GetConVar("mm_cleanup_time"):GetInt(), 1, function() if IsValid(ent) then ent:Remove() end end)
    
    
    local head = self:GoreCreateGib(ply, ply:GetCharacter().gib_head, ply:GetPos()+Vector(0, 0, 65), ply:GetAngles(), true, nil, false)
    self:GoreCreateRagdoll(ply, ply:GetCharacter().gib_bottom, ply:GetPos(), ply:GetAngles()+Angle(0, 0, 0), false, "bot")
    if !ply:MissingLeftArm() then
        self:GoreCreateGib(ply, ply:GetCharacter().gib_armleft, ply:GetPos(), ply:GetAngles(), true)
    end
    if !ply:MissingRightArm() then
        self:GoreCreateGib(ply, ply:GetCharacter().gib_armright, ply:GetPos(), ply:GetAngles(), true)
    end
    SpectateEntity(ply, head)
end

function GM:GoreGrave(ply)
    local ent = ents.Create("prop_dynamic")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel("models/misc/gravestone.mdl")
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    SpectateEntity(ply, ent)
end

function GM:GoreNormalDeath(ply, inflictor)
    SpectateEntity(ply, self:GoreCreateRagdoll(ply, nil, nil, nil, nil, nil, false, inflictor))
end

function GM:GoreFire(ply)
    local ent
    if (!ply:MissingALeg()) then
        // Spawn an animated corpse
        ent = ents.Create("sent_mm_body")
        ent:SetPos(ply:GetPos())
        ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
        ent:SetModel(ply:GetModel())
        ent:SetSkin(ply:GetSkin())
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent:SetSequence(ent:LookupSequence("death_burn_"..math.random(1, 4)))
        ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
        ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
        ent.Ply = ply
        ent.Character = ply:GetCharacter()
        ent.Decapitated = false
        ent.Electrocuted = false
        ent.Ignited = true
        ent.BloodType = ply:GetCharacter().bloodtype
        ent.RagdollTime = CurTime() + 3.5
        SpectateEntity(ply, ent)
    else
        ent = self:GoreCreateRagdoll(ply, nil, nil, nil, nil, nil, false)
    end
    ent:SetMaterial("models/player/monstermash/gibs/burn")
    ent:Ignite(math.Rand(4, 6), 0)
    timer.Create("CorpseSmoke"..tostring(ent), 0.1, 120, function()
        if !IsValid(ent) then return end
        local attachment = ent:LookupBone("ValveBiped.Bip01_Spine2")
        local position, angles = ent:GetBonePosition(attachment)
        local effectdata = EffectData()
        effectdata:SetOrigin(position)
        util.Effect("mm_corpse_smoke", effectdata)
    end)
    SpectateEntity(ply, ent)
end

function GM:GoreScripted(ply, wep)
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetModel())
    ent:SetSkin(ply:GetSkin())
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent.RagdollTime = CurTime() + 1
    if wep:GetClass() == "weapon_mm_pumpshotgun" || wep:GetClass() == "weapon_mm_coachgun" then
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["shotgun"])))
        ent.RagdollTime = CurTime() + 0.1
    elseif wep:GetClass() == "weapon_mm_cleaver" then
        ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_CLEAVER)
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["cleaver"])))
    elseif wep:GetClass() == "weapon_mm_stake" then
        local anim = table.Random(deathanims["stake"])
        ent:SetBodygroup(GIBGROUP_STAKE, GIBGROUP_STAKE_ON)
        ent:SetSequence(ent:LookupSequence(anim[1]))
        ent.RagdollTime = CurTime() + anim[2]
    else
        if math.random(1, 2) == 1 && ply.deathang != "" then
            ent:SetSequence(ent:LookupSequence(table.Random(deathanims["locomotion"][ply.deathang])))
            ent.RagdollTime = CurTime() + 0.675
        else
            ent:SetSequence(ent:LookupSequence(table.Random(deathanims["general"])))
        end
    end
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent.Ply = ply
    ent.Character = ply:GetCharacter()
    ent.BloodType = ply:GetCharacter().bloodtype
    SpectateEntity(ply, ent)
end

function GM:GoreElectric(ply)
    // Create the ragdoll
    local ent = ents.Create("prop_ragdoll")
    ent:SetModel(ply:GetCharacter().model)
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial("models/player/monstermash/gibs/shock")
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent.zapcount = 0
    ent.zapmax = 40
       
    // If the player was on fire, set the ragdoll on fire
    if ply:IsOnFire() then
        ent:Ignite(math.Rand(6, 8), 0) 
    end
       
    // Position the ragdoll's bones to match up with the player's
    if ent:IsValid() then
        local plyvel = ply:GetVelocity()
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = ply:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
                bone:AddVelocity(plyvel)
            end
        end
    end
    
    timer.Create("RagdollElectrocute"..tostring(ent), 0.05, ent.zapmax, function()
        if !IsValid(ent) then return end
        local plyvel = ply:GetVelocity()
        local i = math.random(1, ent:GetPhysicsObjectCount())
        local bone = ent:GetPhysicsObjectNum(i)
        if bone and bone.IsValid and bone:IsValid() then
            local dir = VectorRand()
            local bonepos, boneang = ent:GetBonePosition(ent:TranslatePhysBoneToBone(i))
            bone:SetPos(bonepos)
            bone:SetAngles(boneang)
            bone:AddVelocity(VectorRand()*500)
            local effectdata = EffectData()
            effectdata:SetStart(bonepos) 
            effectdata:SetOrigin(bonepos)
            effectdata:SetNormal(dir)
            effectdata:SetAngles(dir:Angle())
            util.Effect("MetalSpark", effectdata)
        end
        ent.zapcount = ent.zapcount + 1
        if (ent.zapcount == ent.zapmax) then
            ent:SetMaterial("")
        end
    end)
        
    SpectateEntity(ply, ent)
end

function GM:GoreSkeletize(ply)
    // Spawn an animated corpse
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetModel())
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial("models/player/monstermash/gibs/shock")
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent:SetSequence(ent:LookupSequence("electrocution"))
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent.Ply = ply
    ent.Character = ply:GetCharacter()
    ent.Decapitated = false
    ent.Electrocuted = true
    ent.BloodType = ply:GetCharacter().bloodtype
    ent.RagdollTime = CurTime() + 1
    SpectateEntity(ply, ent)
end

function GM:GoreMelter(ply)
    // Spawn an animated corpse
    local ent
    local ppos = ply:GetPos()
    local pang = ply:GetAngles()
    if (ply:IsOnGround() && !ply:MissingBothLegs()) then
        ent = ents.Create("sent_mm_body")
        ent:SetPos(ppos)
        ent:SetAngles(pang)
        ent:SetModel(ply:GetCharacter().gib_skeleton)
        ent:SetSkin(ply:GetSkin())
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent.RagdollTime = CurTime() + 1.5
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["acid"])))
        ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
        ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
        ent:SetMaterial("models/flesh")
    else
        ent = ents.Create("prop_ragdoll")
        ent:SetPos(ppos)
        ent:SetAngles(pang)
        ent:SetModel(ply:GetCharacter().gib_skeleton)
        ent:SetSkin(ply:GetSkin())
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent:SetMaterial("models/flesh")
        ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
        ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
        
        // Position the ragdoll's bones to match up with the player's
        if not ent:IsValid() then return end
        local plyvel = ply:GetVelocity()
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = ply:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
                bone:AddVelocity(plyvel)
            end
        end
    end
    ent.Ply = ply
    ent.Character = ply:GetCharacter()
    ent.BloodType = ply:GetCharacter().bloodtype
    ent.zapmax = 40
    SpectateEntity(ply, ent)

    local effectdata = EffectData()
    effectdata:SetStart(ppos+Vector(0, 0, -50)) 
    effectdata:SetOrigin(ppos+Vector(0, 0, -50))
    util.Effect("mm_melterkill", effectdata)
    ent:EmitSound("weapons/melter/melted.wav", 90)
    local phys = ent:GetPhysicsObject()
    if (!IsValid(phys)) then 
        ent:Remove() return 
    end
    
    // If the player was on fire, set the ragdoll on fire
    if ply:IsOnFire() then
        ent:Ignite(math.Rand(6, 8), 0) 
    end

    timer.Create("RagdollMelter"..tostring(ent), 0.05, ent.zapmax, function()
        if !IsValid(ent) then return end
        local i = math.random(1, 17)
        local bonepos, boneang = ent:GetBonePosition(ent:TranslatePhysBoneToBone(i))
        local dir = VectorRand()
        local effectdata = EffectData()
        effectdata:SetStart(bonepos) 
        effectdata:SetOrigin(bonepos)
        effectdata:SetNormal(dir)
        effectdata:SetAngles(dir:Angle())
        util.Effect("mm_melterimpact", effectdata)
    end)

    local ent2 = ents.Create("sent_mm_fadingcorpse")
    ent2:SetPos(ppos)
    ent2:SetAngles(pang)
    ent2:SetModel(ply:GetCharacter().model)
    ent2:SetSkin(ply:GetSkin())
    ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ent2:Spawn()
    ent2:SetParent(ent)
    ent2:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent2:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
end

function GM:GoreDecapitate(ply)
    // Spawn an animated corpse
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetModel())
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent:SetSequence(ent:LookupSequence(table.Random(deathanims["headshot"])))
    ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent.Decapitated = true
    ent.BloodType = ply:GetCharacter().bloodtype
    ent.RagdollTime = CurTime() + 1
    
    // Spawn the head gib and spectate it
    local head = self:GoreCreateGib(ply, ply:GetCharacter().gib_head, ply:GetPos()+Vector(0, 0, 65), ply:GetAngles(), false, nil, false)
    SpectateEntity(ply, head)
end

function GM:GoreHeadExplode(ply)
    // Spawn an animated corpse
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetModel())
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent:SetSequence(ent:LookupSequence(table.Random(deathanims["headshot"])))
    ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent.Decapitated = true
    ent.BloodType = ply:GetCharacter().bloodtype
    ent.RagdollTime = CurTime() + 2
    ent.Ply = ply
    ent:EmitSound(ply:GetCharacter().gib_headsnd)
    
    // Spawn character specific head gibs
    self:GoreCreateGib(ply, ply:GetCharacter().gib_headbits, ply:GetPos()+Vector(0,0,2), ply:GetAngles(), false, true)
    SpectateEntity(ply, ent)
end

function GM:GoreExplode(ply)
    // Spawn the head gib
    local head = self:GoreCreateGib(ply, ply:GetCharacter().gib_head, ply:GetPos()+Vector(0, 0, 65), ply:GetAngles(), false, nil, false)

    // Spawn generic gibs
    if (ply:GetCharacter().gib_stack != nil) then
        local ret = self:GoreCreateRagdoll(ply, ply:GetCharacter().gib_stack, ply:GetPos(), ply:GetAngles(), false)
        ret:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
        for i=0, ret:GetPhysicsObjectCount() do
            local bone = ret:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                bone:AddVelocity(VectorRand()*500)
            end
        end
    end
    
    // Spawn a gory particle effect
    if ply:GetCharacter().bloodtype == BLOODTYPE_NORMAL then
        local effectdata = EffectData()
        effectdata:SetStart(ply:GetPos()+Vector(0, 0, 50)) 
        effectdata:SetOrigin(ply:GetPos()+Vector(0, 0, 50))
        util.Effect("gibs", effectdata)
        for i=1, 4 do
            local effectdata = EffectData()
            effectdata:SetStart(ply:GetPos()) 
            effectdata:SetOrigin(ply:GetPos())
            util.Effect("mm_gorejar_explosion", effectdata)
        end
    elseif ply:GetCharacter().bloodtype == BLOODTYPE_HAY then
        local effectdata = EffectData()
        effectdata:SetStart(ply:GetPos()+Vector(0, 0, 50)) 
        effectdata:SetOrigin(ply:GetPos()+Vector(0, 0, 50))
        util.Effect("gibs_scarecrow", effectdata)
    end
    
    SpectateEntity(ply, head)
end

function GM:GoreBifurcate(ply)
    // Create the gibs
    local top = self:GoreCreateRagdoll(ply, ply:GetCharacter().gib_top, ply:GetPos()+Vector(0, 0, 46), ply:GetAngles()+Angle(0, 0, 90), true, "top", false)
    local bot = self:GoreCreateRagdoll(ply, ply:GetCharacter().gib_bottom, ply:GetPos(), ply:GetAngles()+Angle(0, 0, 0), false, "bot")
    ply:EmitSound("physics/flesh/flesh_bloody_break.wav")
    
    // Emit a blood trail effect
    if ply:GetCharacter().bloodtype == BLOODTYPE_NORMAL then
        local effectdata = EffectData()
        effectdata:SetStart(ply:GetPos()+Vector(0, 0, 50)) 
        effectdata:SetOrigin(ply:GetPos()+Vector(0, 0, 50))
        util.Effect("bloodspray", effectdata)
    end
    
    // Spectate the top half
    SpectateEntity(ply, top)
end

function GM:GoreCreateGib(ply, model, pos, ang, overrideforce, ragdoll, remove)
    // Create the gib model
    local ent
    if ragdoll then
        ent = ents.Create("prop_ragdoll")
    else
        ent = ents.Create("prop_physics")
    end
    ent:SetPos(pos)
    ent:SetModel(model)
    ent:SetAngles(ang)
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    
    // Add a collision callback depending on the bloodtype
    if ply:GetCharacter().bloodtype == BLOODTYPE_NORMAL then
        ent:AddCallback("PhysicsCollide", GibModelCallbackBlood)
    elseif ply:GetCharacter().bloodtype == BLOODTYPE_HAY then
        ent:AddCallback("PhysicsCollide", GibModelCallbackHay)
    end
    
    // If the player was on fire, set the gib on fire
    if ply:IsOnFire() then 
        ent:SetMaterial("Models/player/monstermash/gibs/burn")
        ent:Ignite(math.Rand(6, 8), 0)
    end
    
    // Apply some physics to the gib
    if (overrideforce == nil || !overrideforce) then
        if ragdoll then
            for i=0, ent:GetPhysicsObjectCount() do
                local bone = ent:GetPhysicsObjectNum(i)
                if bone and bone.IsValid and bone:IsValid() then
                    bone:AddVelocity(VectorRand()*250)
                end
            end
        else
            local phys = ent:GetPhysicsObject()
            if (!IsValid(phys)) then 
                ent:Remove() return 
            end
            phys:AddVelocity(VectorRand()*375)
        end
    end
    
    // Make the gib bleed a bunch
    local num = math.Rand(1,3)
    if ply:GetCharacter().bloodtype == BLOODTYPE_NORMAL then
        local color = Color(105, 0, 0, 255)
        if ragdoll then
            for i=0, ent:GetPhysicsObjectCount() do
                local bone = ent:GetPhysicsObjectNum(i)
                if bone and bone.IsValid and bone:IsValid() then
                    for i = 0.1, num, 0.1 do
                        timer.Simple(i,function()
                            if !IsValid(bone:GetEntity()) then return end
                            local effectdata = EffectData()
                            effectdata:SetOrigin(bone:GetEntity():GetPos())
                            util.Effect("BloodImpact", effectdata)  
                        end)
                    end
                    util.SpriteTrail(bone:GetEntity(), 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "particle/mm_bloodtrail1.vmt")
                end
            end
        else
            for i = 0.1, num, 0.1 do
                timer.Simple(i,function()
                    if !IsValid(ent) then return end
                    local effectdata = EffectData()
                    effectdata:SetOrigin(ent:GetPos())
                    util.Effect("BloodImpact", effectdata)  
                end)
            end
            util.SpriteTrail(ent, 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "particle/mm_bloodtrail1.vmt")
        end
    else
        for i = 0.1, num, 0.1 do
            timer.Simple(i,function()
                if !IsValid(ent) then return end
                local effectdata = EffectData()
                effectdata:SetOrigin(ent:GetPos())
                util.Effect("WheelDust", effectdata)  
            end)
        end        
    end
   
    // Remove the giblet after some time has passed
    if (remove || remove == nil) then
        timer.Create("Cleanup_"..tostring(ent), GetConVar("mm_cleanup_time"):GetInt(), 1, function() 
            if !IsValid(ent) then return end 
            ent:Remove() 
        end)
    end
    
    // Return the created entity
    return ent
end

function GibModelCallbackBlood(ent, data)
    local startp = data.HitPos
    local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = ent, mask = MASK_SOLID_BRUSHONLY}
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    util.Decal("Blood", todecal1, todecal2)
    
    local effect = EffectData()  
    local origin = data.HitPos
    effect:SetOrigin(origin)
    util.Effect("bloodimpact", effect) 
end

util.AddNetworkString("DoHayDecal")
function GibModelCallbackHay(ent, data)
    if ent:GetVelocity():Length() >= 100 then
        net.Start("DoHayDecal")
            net.WriteTable({HitPos = data.HitPos, Ent = data.Entity, HitNormal = data.HitNormal})
        net.Broadcast()
    end
end

function GM:GoreCreateRagdoll(ply, model, pos, ang, matchbones, extra, remove, wep)
    // Fix missing arguments
    if model == nil then
        model = ply:GetModel()
        pos = ply:GetPos()
        ang = ply:GetAngles()
        matchbones = true
        extra = nil
    end

    // Create the ragdoll
    local ent = ents.Create("prop_ragdoll")
    ent:SetModel(model)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    if wep != nil && wep:IsWeapon() && wep:GetClass() == "weapon_mm_stake" then
        ent:SetBodygroup(GIBGROUP_STAKE, GIBGROUP_STAKE_ON)
    end
    if extra == nil then
        ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
        ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    else
        if extra == "top" then
            ent:SetBodygroup(0, ply:GetBodygroup(GIBGROUP_ARMS))
        else
            ent:SetBodygroup(0, ply:GetBodygroup(GIBGROUP_LEGS))
        end
    end
       
    // If the player was on fire, set the ragdoll on fire
    if ply:IsOnFire() then
        ent:Ignite(math.Rand(6, 8), 0) 
    end
    
    local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(phys:GetMass())
	end
       
    // Position the ragdoll's bones to match up with the player's
    if (matchbones) then
        if not ent:IsValid() then return end
        local plyvel = ply:GetVelocity()
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = ply:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                if (bonepos != nil) then
                    bone:SetPos(bonepos)
                end
                if (boneang != nil) then
                    bone:SetAngles(boneang)
                end
                bone:AddVelocity(plyvel)
            end
        end
    end
        
    // Remove the model after some time has passed
    if (remove || remove == nil) then
        timer.Create("Cleanup_"..tostring(ent), GetConVar("mm_cleanup_time"):GetInt(), 1, function() 
            if !IsValid(ent) then return end 
            ent:Remove() 
        end)
    end
    
    return ent
end

function ShowKiller(victim, weapon, killer)

	if killer:GetClass() == "trigger_hurt" then return end
	if killer:GetClass() == "env_fire" then return end
    if (!GetConVar("mm_deathcam"):GetBool()) then return end
	timer.Create("FreezeCamDeath", 1.5, 1, function()
        if !IsValid(killer) then return end
        if (GetConVar("mm_endofmonstermash"):GetBool()) then return end
        if GAMEMODE:GetRoundState() == GMSTATE_BUYTIME then victim:SetNWEntity("MM_Killer", killer) return end
		if IsValid(victim) && victim == killer then
			victim:ConCommand("play misc/freeze_cam2.wav") 
		else
			victim:ConCommand("play misc/freeze_cam1.wav") 
		end
        if (victim != killer) then
            victim:SpectateEntity(killer)
        end
		victim:Spectate(OBS_MODE_FREEZECAM)
		if killer:GetName() == nil then return end --If the Name is nil, end
		victim:SetNWEntity("MM_Killer", killer)
	end)
    timer.Simple(5, function()
        if GAMEMODE:GetRoundState() == GMSTATE_BUYTIME then return end
        if IsValid(victim) &&!victim:Alive() then
            victim:Spectate(OBS_MODE_CHASE)
        end
    end)

end 
hook.Add("PlayerDeath", "MM_ShowKiller", ShowKiller)