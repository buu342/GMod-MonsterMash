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
    ["legbifurcate"] = {
        "death_04",
        "death_kneel_faceplant",
        "death_l4d_clutch_faceplant",
        "death_l4d_clutch_kneel",
        "death_l4d_headshot_backward",
        "death_l4d_headshot_forward",
        "death_slump_forward1",
        "death_slump_forward2",
        "death_slump_forward3",
        "death_step_faceplant",
    },
    ["cleaver"] = {
        "death_01",
        "death_kneel_faceplant",
        "death_slump_forward2",
        "death_slump_forward3",
        "death_twirl_back"
    },
    ["burn"] = {
        "death_burn_1",
        "death_burn_2",
        "death_burn_3",
        "death_burn_4",
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
        ["Back"] = "death_blast_back",
        ["Right"] = "death_blast_right",
        ["Forward"] = "death_blast_front",
        ["Left"] = "death_blast_left"
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

    // Handle medals
    self:GiveMedalsOnDeath(victim, attacker, dmginfo)

    // Increment player stats
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

    // Handle treats
    self:GiveTreatsOnKill(victim, attacker, dmginfo)

    // Spawn a little ghost
    local effectdata = EffectData()
    effectdata:SetStart(victim:GetPos()+Vector(0,0,50)) 
    effectdata:SetOrigin(victim:GetPos()+Vector(0,0,50))
    util.Effect("mm_Spoopyghost", effectdata)

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

    // Get killer angle
    local kang = (math.Round(math.AngleDifference(victim:GetAngles().y, attacker:GetAngles().y))+360)%360
    if (kang > 315 || kang < 45) then
        victim.killang = "Back"
    elseif (kang > 45 && kang < 135) then
        victim.killang = "Left"
    elseif (kang > 135 && kang < 225) then
        victim.killang = "Forward"
    elseif (kang > 225 && kang < 315) then
        victim.killang = "Right"
    end

    // Do the actual networking of the corpse animation
    self:DoDeathGore(victim, attacker, dmginfo)

    // Notify everyone of player death
    net.Start("MMPlayerKilled")
        net.WriteTable({ attacker = attacker, victim = victim, inflictor = dmginfo:GetInflictor(), killflags = victim:GetKillFlags() })
    net.Broadcast()
    
    // Last set of stats
    victim:ResetLifeStats()
    victim:ClearStatusEffects()
    self:SavePlayerStats(victim)
    
    // Change teams
    if (self:InWackyRound()) then
        if (self:WackyRoundData().mode == MODE_CONVERT) then
            victim:SetTeam(TEAM_COOPOTHER)
        elseif (self:WackyRoundData().allow_respawn == false) then
            victim:SetTeam(TEAM_COOPDEAD)
        end
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

function GM:DoDeathGore(victim, attacker, dmginfo)

    if (dmginfo:IsDamageType(DMG_DISSOLVE)) then victim:CreateRagdoll() return end

    local inflictor = dmginfo:GetInflictor()

    // Do the death animation/ragdoll
    if (victim:HasKillFlag(KILL_ACID) || WeaponHasKillFlag(inflictor, KILL_MELTER) || victim:HasKillFlag(KILL_MELTER)) then
        self:GoreMelter(victim, dmginfo)
    elseif (victim:HasKillFlag(KILL_BLEED)) then
        self:GoreNormalDeath(victim, dmginfo)
    elseif (!victim:MissingBothLegs() && WeaponHasKillFlag(inflictor, KILL_SKELETIZE)) then
        self:GoreScriptedDeath(victim, dmginfo, "skeletize")
    elseif victim:GetCharacter().decapitates && WeaponHasKillFlag(inflictor, KILL_DECAPITATE) then
        self:GoreScriptedDeath(victim, dmginfo, "decapitate")
        if (victim != attacker && attacker:IsPlayer()) then
            attacker:GiveTreat("behead")
        end
    elseif (!victim:MissingBothLegs() && victim:GetCharacter().decapitates && WeaponHasKillFlag(inflictor, KILL_HEADEXPLODE) && victim:GetLastHitgroup() == HITGROUP_HEAD) then
        self:GoreScriptedDeath(victim, dmginfo, "headexplode")
        if (victim != attacker && attacker:IsPlayer()) then
            attacker:GiveTreat("behead")
        end
    elseif (!victim:MissingBothLegs() && victim:GetCharacter().bifurcates && WeaponHasKillFlag(inflictor, KILL_BIFURCATE)) then
        self:GoreBifurcate(victim, dmginfo)
    elseif (victim:GetCharacter().gibs && (WeaponHasKillFlag(inflictor, KILL_GIB)) || victim:HasKillFlag(KILL_GIB)) then
        self:GoreExplode(victim, dmginfo)
        if (victim != attacker && attacker:IsPlayer() && !inflictor.IsMMNPC) then
            attacker:GiveTreat("gib")
        end
    elseif (victim:GetCharacter().gibs && WeaponHasKillFlag(inflictor, KILL_GIBTHRESHOLD) && victim:GetLastDamage().totalamount >= 100) then
        self:GoreExplode(victim, dmginfo)
        if (victim != attacker && attacker:IsPlayer() && !inflictor.IsMMNPC) then
            attacker:GiveTreat("gib")
        end
    elseif (WeaponHasKillFlag(inflictor, KILL_ELECTRIC)) then
        self:GoreElectric(victim, dmginfo)
    elseif (!victim:MissingBothLegs() && WeaponHasKillFlag(inflictor, KILL_SCRIPTED)) then
        self:GoreScriptedDeath(victim, dmginfo)
        if (victim:GetLastDamage().totalamount >= 30 && dmginfo:IsDamageType(DMG_BULLET)) then
            self:GoreGibChunks(victim, dmginfo)
        end
    elseif (WeaponHasKillFlag(inflictor, KILL_GRAVE)) then
        self:GoreGrave(victim, dmginfo)
    elseif (victim:HasStatusEffect(STATUS_ONFIRE)) then
        if (!victim:MissingALeg()) then
            self:GoreScriptedDeath(victim, dmginfo, "fire")
        else
            self:GoreNormalDeath(victim, dmginfo)
        end
    elseif (!victim:MissingBothLegs() && victim:GetLastDamage().totalamount >= 50 && dmginfo:IsDamageType(DMG_BULLET)) then
        self:GoreBlownTorso(victim, dmginfo)
    else
        if (victim:IsOnGround() && math.random(1, 2) == 1 && !victim:MissingBothLegs()) then
            self:GoreScriptedDeath(victim, dmginfo)
        else
            self:GoreNormalDeath(victim, dmginfo)
        end
        if (victim:GetLastDamage().totalamount >= 30 && dmginfo:IsDamageType(DMG_BULLET)) then
            self:GoreGibChunks(victim, dmginfo)
        end
    end
end

function GM:GoreNormalDeath(ply, dmginfo)
    local ent = self:GoreCreateRagdoll(ply, nil, nil, nil, nil, nil, false, dmginfo:GetInflictor())
    SpectateEntity(ply, ent)
    if IsValid(ply:GetRagdollEntity()) then
        ply:GetRagdollEntity():Remove()
    end
    return ent
end

function GM:GoreScriptedDeath(ply, dmginfo, extra)
    local inflictor = dmginfo:GetInflictor()
    local character = ply:GetCharacter()
    local spectateafter = true
    local ent = ents.Create("base_gmodentity")
    local originalpos = ply:GetPos()
    local originalang = ply:GetAngles()
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetModel())
    ent:SetSkin(ply:GetSkin())
    ent:Spawn()
    ent:Activate()
    SpectateEntity(ply, ent)
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ent:SetSolid(SOLID_VPHYSICS)
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetMoveType(MOVETYPE_NONE)
    local physobj = ent:GetPhysicsObject()
    if IsValid(physobj) then
        physobj:Wake()
    end
    ent.RagdollTime = 1
    if (extra == "acid") then
        ent:SetModel(ply:GetCharacter().gib_skeleton)
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["acid"])))
        ent.RagdollTime = 1.5
    elseif (extra == "decapitate") then
        ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["headshot"])))
        ent.RagdollTime = 1
        self:EmitBlood(ply:GetCharacter(), BLOODEFFECT_SPRAY, nil, nil, ent, "head_splurt", ent.RagdollTime)
        spectateafter = false
        local head = self:GoreCreateGib(ply, character.gib_head, ply:GetPos(), ply:GetAngles(), nil, nil, false)
        SpectateEntity(ply, head)
    elseif (extra == "headexplode") then
        ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["headshot"])))
        ent.RagdollTime = 1
        self:EmitBlood(ply:GetCharacter(), BLOODEFFECT_SPRAY, nil, nil, ent, "head_splurt", ent.RagdollTime)
        ply:EmitSound(ply:GetCharacter().gib_headsnd)
        // local bonemat = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Head1"))
        local head = self:GoreCreateGib(ply, character.gib_headbits, originalpos/*bonemat:GetTranslation()*/, originalang+Angle(0,90,0), 100, true, true)
    elseif (extra == "skeletize") then
        ent:SetSequence(ent:LookupSequence("electrocution"))
        ent:SetMaterial("models/player/monstermash/gibs/shock")
        ent.RagdollTime = 1
    elseif (extra == "fire") then
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["burn"])))
        ent:SetMaterial("models/player/monstermash/gibs/burn")
        ent.RagdollTime = 3
    elseif inflictor:GetClass() == "weapon_mm_pumpshotgun" || inflictor:GetClass() == "weapon_mm_coachgun" || inflictor:GetClass() == "weapon_mm_sawedoff" then
        local attackervec = dmginfo:GetAttacker():GetAngles():Forward()
        ent:SetSequence(ent:LookupSequence(deathanims["shotgun"][ply.killang]))
        ent:SetMoveType(MOVETYPE_VPHYSICS)
        physobj:ApplyForceCenter(Vector(attackervec.x, attackervec.y, 0)*4500)
        ent.RagdollTime = 0.5
    elseif inflictor:GetClass() == "weapon_mm_cleaver" then
        ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_CLEAVER)
        ent:SetSequence(ent:LookupSequence(table.Random(deathanims["cleaver"])))
    elseif inflictor:GetClass() == "weapon_mm_stake" then
        local anim = table.Random(deathanims["stake"])
        ent:SetBodygroup(GIBGROUP_STAKE, GIBGROUP_STAKE_ON)
        ent:SetSequence(ent:LookupSequence(anim[1]))
        ent.RagdollTime = anim[2]
    else
        if math.random(1, 2) == 1 && ply.deathang != "" then
            ent:SetSequence(ent:LookupSequence(table.Random(deathanims["locomotion"][ply.deathang])))
            ent.RagdollTime = 0.675
        else
            ent:SetSequence(ent:LookupSequence(table.Random(deathanims["general"])))
        end
    end
    ent:SetBodygroup(GIBGROUP_ARMS, ply:GetBodygroup(GIBGROUP_ARMS))
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent:SetPlaybackRate(1)
    ent.AutomaticFrameAdvance = true
    function ent:Think()
        self:NextThink(CurTime())
        return true
    end
    timer.Simple(ent.RagdollTime, function()
        if (!IsValid(ent)) then return end
        local mdlreplace = nil
        if (extra == "skeletize") then
            mdlreplace = character.gib_skeleton
        end
        local rag = self:GoreCreateRagdoll(ent, mdlreplace, nil, nil, true, extra, true, inflictor)
        rag:SetBodygroup(GIBGROUP_ARMS, ent:GetBodygroup(GIBGROUP_ARMS))
        rag:SetBodygroup(GIBGROUP_LEGS, ent:GetBodygroup(GIBGROUP_LEGS))
        for i = 0, rag:GetPhysicsObjectCount()-1 do
            local bone = rag:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = ent:GetBonePosition(rag:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
            end
        end
        if (spectateafter) then
            SpectateEntity(ply, rag)
        end
        ent:Remove()
    end)
    if IsValid(ply:GetRagdollEntity()) then
        ply:GetRagdollEntity():Remove()
    end
    return ent
end

function GM:GoreGrave(ply, dmginfo)
    local ent = ents.Create("prop_dynamic")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel("models/misc/gravestone.mdl")
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    SpectateEntity(ply, ent)

    // Remove the ragdoll entity
    if IsValid(ply:GetRagdollEntity()) then
        ply:GetRagdollEntity():Remove()
    end
end

function GM:GoreBifurcate(ply, dmginfo, notop)
    if (notop == nil) then
        notop = false
    end

    // Create the gibs
    if (!notop) then
        local top = self:GoreCreateRagdoll(ply, ply:GetCharacter().gib_top, ply:GetPos()+Vector(0, 0, 46), ply:GetAngles()+Angle(0, 0, 90), true, "top", true)
        top:GetPhysicsObject():SetVelocity(Vector(0,0,1)*500)
    end
    local ent = ents.Create("base_gmodentity")
    ent:SetPos(ply:GetPos())
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetModel(ply:GetCharacter().gib_bottom)
    ent:SetSkin(ply:GetSkin())
    ent:Spawn()
    ent:SetBodygroup(GIBGROUP_LEGS, ply:GetBodygroup(GIBGROUP_LEGS))
    ent:Activate()
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    ent:SetSolid(SOLID_VPHYSICS)
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetMoveType(MOVETYPE_NONE)
    local physobj = ent:GetPhysicsObject()
    if IsValid(physobj) then
        physobj:Wake()
    end
    local anim = table.Random(deathanims["legbifurcate"])
    ent:SetSequence(ent:LookupSequence(anim))
    ent.RagdollTime = ent:SequenceDuration(ent:LookupSequence(anim))
    ent:SetPlaybackRate(1)
    ent.AutomaticFrameAdvance = true
    local bloodemitragdolltime = 3-ent.RagdollTime
    function ent:Think()
        self:NextThink(CurTime())
        return true
    end
    timer.Simple(ent.RagdollTime, function()
        local rag = self:GoreCreateRagdoll(ent, nil, nil, nil, nil, nil, true, nil)
        rag:SetBodygroup(GIBGROUP_LEGS, ent:GetBodygroup(GIBGROUP_LEGS))
        for i = 0, rag:GetPhysicsObjectCount()-1 do
            local bone = rag:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = ent:GetBonePosition(rag:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
            end
        end
        self:EmitBlood(ply:GetCharacter(), BLOODEFFECT_SPRAY, nil, Vector(0, 0, 1), rag, "blood_splurt", bloodemitragdolltime)
        ent:Remove()
    end)
    ply:EmitSound("physics/flesh/flesh_bloody_break.wav")
    
    // Emit a blood effect
    self:EmitBlood(ply:GetCharacter(), BLOODEFFECT_SPRAY, nil, Vector(0, 0, 1), ent, "blood_splurt", ent.RagdollTime)
    
    // Spectate the top half
    if (!notop) then
        SpectateEntity(ply, top)
    end

    // Remove the ragdoll entity
    if IsValid(ply:GetRagdollEntity()) then
        ply:GetRagdollEntity():Remove()
    end
end

function GM:GoreExplode(ply, dmginfo)
    local head = self:GoreCreateGib(ply, ply:GetCharacter().gib_head, ply:GetPos()+Vector(0, 0, 65), ply:GetAngles(), nil, nil, false)

    // Spawn generic gibs
    if (ply:GetCharacter().gib_stack != nil) then
        local ent = self:GoreCreateGib(ply, ply:GetCharacter().gib_stack, ply:GetPos(), ply:GetAngles(), 500, true, true)
        ent:SetBodygroup(GIBGROUP_HEAD, GIBGROUP_HEAD_OFF)
    end
    
    // Spawn a gory particle effect and spectate the head
    self:EmitBlood(ply:GetCharacter(), BLOODEFFECT_GIBPLOSION, ply:GetPos() + Vector(0, 0, 50))
    SpectateEntity(ply, head)
end

function GM:GoreBlownTorso(ply, dmginfo)
    // Spawn some animated legs
    self:GoreBifurcate(ply, dmginfo, true)

    // Spawn the arms that aren't missing
    if !ply:MissingLeftArm() then
        self:GoreCreateGib(ply, ply:GetCharacter().gib_armleft, ply:GetPos(), ply:GetAngles(), nil)
    end
    if !ply:MissingRightArm() then
        self:GoreCreateGib(ply, ply:GetCharacter().gib_armright, ply:GetPos(), ply:GetAngles(), nil)
    end

    // Spawn the torso chunks
    self:GoreGibChunks(ply, dmginfo, true)

    // Spawn the head and spectate it
    local bonemat = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Head1"))
    local head = self:GoreCreateGib(ply, ply:GetCharacter().gib_head, bonemat:GetTranslation(), ply:GetAngles()+Angle(0,90,0), nil, nil, false)
    SpectateEntity(ply, head)
end

function GM:GoreGibChunks(ply, dmginfo, blowntorso)
    local gib = ply:GetCharacter().gib_chunks
    local pos = dmginfo:GetDamagePosition()
    if (blowntorso) then
        gib = ply:GetCharacter().gib_torso
        pos = ply:GetPos()
    end
    local ent = self:GoreCreateRagdoll(ply, gib, pos, ply:GetAngles(), false, nil, true)
    if (ply:GetCharacter().bloodtype == BLOODTYPE_NONE) then
        ply:EmitSound("death/damage_bones.wav")
    else
        ply:EmitSound("death/damage_flesh.wav")
    end
    if ent:IsValid() then
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                bone:AddVelocity(VectorRand()*300)
            end
        end
    end
end

function GM:GoreMelter(ply, dmginfo)
    // Spawn an animated corpse
    local ent
    local ppos = ply:GetPos()
    local pang = ply:GetAngles()
    if (ply:IsOnGround() && !ply:MissingBothLegs()) then
        ent = self:GoreScriptedDeath(ply, dmginfo, "acid")
    else
        ent = self:GoreNormalDeath(ply, dmginfo)
        ent:SetModel(ply:GetCharacter().gib_skeleton)
    end
    ent:SetMaterial("models/flesh")

    local effectdata = EffectData()
    effectdata:SetStart(ppos+Vector(0, 0, -50)) 
    effectdata:SetOrigin(ppos+Vector(0, 0, -50))
    util.Effect("mm_melterkill", effectdata)
    ply:EmitSound("weapons/melter/melted.wav", 90)
    local phys = ent:GetPhysicsObject()
    if (!IsValid(phys)) then 
        ent:Remove() return 
    end

    timer.Create("RagdollMelter"..tostring(ent), 0.05, 40, function()
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

function GM:GoreElectric(ply, dmginfo)
    // Create the ragdoll
    local ent = self:GoreNormalDeath(ply, dmginfo)
    ent:SetMaterial("models/player/monstermash/gibs/shock")
    ent.zapcount = 0
    ent.zapmax = 40
    
    timer.Create("RagdollElectrocute"..tostring(ent), 0.05, 40, function()
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
end
