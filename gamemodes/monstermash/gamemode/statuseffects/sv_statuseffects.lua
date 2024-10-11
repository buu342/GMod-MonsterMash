/**************************************************************
                         GoreJar Trail
**************************************************************/

hook.Add("PlayerTick", "MM_GoreJarTrailThink", function(ply, mv)
    if ply.lastBloodTrail == nil then
        ply.lastBloodTrail = 0
    end
    if ply:HasStatusEffect(STATUS_GOREJARED) && ply:Alive() then
        local time = 0.1
        
        if (ply.lastBloodTrail == 0) then
            ply.lastBloodTrail = CurTime()
        end
        
        if (ply.lastBloodTrail < CurTime()) then
            ply.lastBloodTrail = CurTime()+time
            local start = ply:GetPos()
            local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
            util.Decal("Blood", btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal, ply)
        end
    elseif ply.lastBloodTrail != 0 then
        ply.lastBloodTrail = 0
    end
end)


/**************************************************************
                            Bleed
**************************************************************/

hook.Add("PlayerTick", "MM_BleedThink", function(ply, mv)
    if ply.lastBleed == nil then
        ply.lastBleed = 0
    end
    if ply.lastBleedTime == nil then
        ply.lastBleedTime = 0
    end
    if ply.BleedStarted == nil then
        ply.BleedStarted = 0
    end

    if ply:HasStatusEffect(STATUS_BLEED) && ply:Alive() then
        local time = 1
    
        // First time/Bleed reset
        if ply.lastBleedTime == 0 || (ply:GetStatusEffectTime(STATUS_BLEED)+CurTime() > ply.BleedStarted+ply:GetStatusEffectMaxTime(STATUS_BLEED)) then
            ply.lastBleed = ply:GetStatusEffectMaxTime(STATUS_BLEED)
            ply.lastBleedTime = CurTime() + 0.9
            ply.BleedStarted = CurTime()
        end
        
        // After some time has passed
        if ply.lastBleedTime < CurTime() then
            // If this will kill the player, set the kill flag
            if ply:Health() - ply.lastBleed <= 0 then
                ply:SetKillFlag(KILL_BLEED)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(ply.lastBleed)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_BLEED)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_BLEED))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_BLEED)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_BLEED))
            end
            dmginfo:SetDamageType(DMG_SLOWBURN)
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()

            // If the player is alive, create blood
            if ply:Alive() then
                local pos, ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine2"))
                GAMEMODE:EmitBlood(ply:GetCharacter(), BLOODEFFECT_IMPACT, pos)
                GAMEMODE:EmitBlood(ply:GetCharacter(), BLOODEFFECT_DECAL, ply:GetPos(), ply:GetPos() + Vector(0, 0, -256), ply)
            end

            // Decrease the damage amount and call this again in a second
            ply.lastBleedTime = CurTime() + time
            ply.lastBleed = ply.lastBleed - 1
        end
    elseif ply.BleedStarted != 0 then
        ply.lastBleed = 0
        ply.BleedStarted = 0
        ply.lastBleedTime = 0
    end
end)


/**************************************************************
                             Acid
**************************************************************/

hook.Add("PlayerTick", "MM_AcidThink", function(ply, mv)
    if ply.lastAcidTime == nil then
        ply.lastAcidTime = 0
    end

    if (ply:HasStatusEffect(STATUS_ACID) || ply:HasStatusEffect(STATUS_SUPERACID)) && ply:Alive() then
        local damage = 5
        local time = 0.375
        if (ply:HasStatusEffect(STATUS_SUPERACID)) then
            damage = 9
        end
        
        if (ply.lastAcidTime == 0) then
            ply.lastAcidTime = CurTime()
        end
        
        if (ply.lastAcidTime < CurTime()) then
            ply.lastAcidTime = CurTime()+time
            
            // If this will kill the player, set the kill flag
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_ACID)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_ACID)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_ACID))
            elseif IsValid(ply:GetStatusEffectAttacker(STATUS_SUPERACID)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_SUPERACID))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_ACID)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_ACID))
            elseif IsValid(ply:GetStatusEffectInflictor(STATUS_SUPERACID)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_SUPERACID))
            end
            dmginfo:SetDamageType(DMG_AIRBOAT)
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastAcidTime != 0 then
        ply.lastAcidTime = 0
    end
end)


/**************************************************************
                            Melter
**************************************************************/

hook.Add("PlayerTick", "MM_MelterThink", function(ply, mv)
    if ply.lastMelterTime == nil then
        ply.lastMelterTime = 0
    end

    if ply:HasStatusEffect(STATUS_MELTER) && ply:Alive() then
        local damage = 3
        local time = 0.5
        
        if (ply.lastMelterTime == 0) then
            ply.lastMelterTime = CurTime()
        end
                
        if (ply.lastMelterTime < CurTime()) then
            ply.lastMelterTime = CurTime()+time
        
            // Viewpunch
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_MELTER)
            else
                local punch = 0.5
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
        
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_MELTER)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_MELTER))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_MELTER)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_MELTER))
            end
            dmginfo:SetDamageType(DMG_AIRBOAT)
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastMelterTime != 0 then
        ply.lastMelterTime = 0
    end
end)


/**************************************************************
                             Bats
**************************************************************/

hook.Add("PlayerTick", "MM_BatsThink", function(ply, mv)
    if ply.lastBatsTime == nil then
        ply.lastBatsTime = 0
    end

    if ply:HasStatusEffect(STATUS_BATS) && ply:Alive() then
        local damage = 5
        local time = 0.375
        
        if (ply.lastBatsTime == 0) then
            ply.lastBatsTime = CurTime()
        end
        
        if (ply.lastBatsTime < CurTime()) then
            ply.lastBatsTime = CurTime()+time
            
            // If this will kill the player, set the kill flag
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_BATS)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_BATS)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_BATS))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_BATS)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_BATS))
            end
            dmginfo:SetDamageType(DMG_SLOWBURN)
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastBatsTime != 0 then
        ply.lastBatsTime = 0
    end
end)


/**************************************************************
                             Spiderweb
**************************************************************/

hook.Add("PlayerTick", "MM_SpidersThink", function(ply, mv)
    if ply.lastSpidersTime == nil then
        ply.lastSpidersTime = 0
    end

    if ply:HasStatusEffect(STATUS_SPIDERWEBBED) && ply:Alive() then
        local damage = 3
        local time = 0.5
        
        if (ply.lastSpidersTime == 0) then
            ply.lastSpidersTime = CurTime()
        end
        
        if (ply.lastSpidersTime < CurTime()) then
            ply.lastSpidersTime = CurTime()+time
            
            // If this will kill the player, set the kill flag
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_SPIDERS)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_SPIDERWEBBED)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_SPIDERWEBBED))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_SPIDERWEBBED)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_SPIDERWEBBED))
            end
            dmginfo:SetDamageType(DMG_PARALYZE)
            
            ply.WebSound = CreateSound(ply, "ambient/creatures/leech_bites_loop1.wav")
            if ply.WebSound then
                ply.WebSound:SetSoundLevel(35) 
                ply.WebSound:Play()
            end
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastSpidersTime != 0 then
        ply.lastSpidersTime = 0
        ply.WebSound:Stop()
    end
end)


/**************************************************************
                              Fire
**************************************************************/

hook.Add("PlayerTick", "MM_IgniteThink", function(ply, mv)
    if ply:HasStatusEffect(STATUS_ONFIRE) && !ply:IsOnFire() then
        ply:Ignite(ply:GetStatusEffectTime(STATUS_ONFIRE))
    end
    
    if ply.lastFiresTime == nil then
        ply.lastFiresTime = 0
    end

    if ply:HasStatusEffect(STATUS_ONFIRE) && ply:Alive() then
        local damage = 3
        local time = 0.5
        
        if (ply.lastFiresTime == 0) then
            ply.lastFiresTime = CurTime()
        end
        
        if (ply:WaterLevel() >= 2) then
            ply.lastFiresTime = 0
            ply:RemoveStatusEffect(STATUS_ONFIRE)
            ply:Extinguish()
            ply.FireSound:Stop()
            return
        end
        
        if (ply.lastFiresTime < CurTime()) then
            ply.lastFiresTime = CurTime()+time
            
            // If this will kill the player, set the kill flag
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_FIRE)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_ONFIRE)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_ONFIRE))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_ONFIRE)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_ONFIRE))
            end
            dmginfo:SetDamageType(DMG_MISSILEDEFENSE)
            
            ply.FireSound = CreateSound(ply, "player/general/flesh_burn.wav")
            if ply.FireSound then
                ply.FireSound:SetSoundLevel(35) 
                ply.FireSound:Play()
            end
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastFiresTime != 0 then
        ply.lastFiresTime = 0
        ply.FireSound:Stop()
    end
end)


/**************************************************************
                          Hallucinate
**************************************************************/

hook.Add("PlayerTick", "MM_HallucinateThink", function(ply, mv)
    if ply.lastHallucinateTime == nil then
        ply.lastHallucinateTime = 0
    end

    if ply:HasStatusEffect(STATUS_HALLUCINATING) && ply:Alive() then
        local damage = 3
        local time = 0.5
        
        if (ply.lastHallucinateTime == 0) then
            ply.lastHallucinateTime = CurTime()
        end
        
        if (ply.lastHallucinateTime < CurTime()) then
            ply.lastHallucinateTime = CurTime()+time
            
            // If this will kill the player, set the kill flag
            if ply:Health() - damage <= 0 then
                ply:SetKillFlag(KILL_HALLUCINATE)
            else
                local punch = math.random(1,5)
                local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
                ply:ViewPunch(randpunch)
            end
            
            // Damage the player
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(damage)
            if IsValid(ply:GetStatusEffectAttacker(STATUS_HALLUCINATING)) then
                dmginfo:SetAttacker(ply:GetStatusEffectAttacker(STATUS_HALLUCINATING))
            end
            if IsValid(ply:GetStatusEffectInflictor(STATUS_HALLUCINATING)) then
                dmginfo:SetInflictor(ply:GetStatusEffectInflictor(STATUS_HALLUCINATING))
            end
            dmginfo:SetDamageType(DMG_NERVEGAS)
            
            ply.HallucinateSound = CreateSound(ply, "player/general/flesh_burn.wav")
            if ply.HallucinateSound then
                ply.HallucinateSound:SetSoundLevel(35) 
                ply.HallucinateSound:Play()
            end
            ply:TakeDamageInfo(dmginfo)
            ply:Flinch()
        end
    elseif ply.lastHallucinateTime != 0 then
        ply.lastHallucinateTime = 0
        ply.HallucinateSound:Stop()
    end
end)


/**************************************************************
                          Dodgerolling
**************************************************************/

hook.Add("PlayerTick", "MM_DodgeThink", function(ply, mv)
    if ply.LastDodgeSound == nil then
        ply.LastDodgeSound = 0
        ply.JustDidDodge = false
    end
    if ply:IsDodgeRolling() then
        local vec = Vector(ply:GetAimVector().x, ply:GetAimVector().y, 0)
        if ply:HasStatusEffect(STATUS_ROLLLEFT) then
            vec:Rotate(Angle(0, -90, 0))
        else
            vec:Rotate(Angle(0, 90, 0))
        end
        ply:SetVelocity(-Vector(ply:GetVelocity().x,ply:GetVelocity().y,0) -vec*300)
        if ply.LastDodgeSound <= CurTime() then
            ply.LastDodgeSound = CurTime() + 0.2
            if SERVER then
                ply:EmitSound("gameplay/roll"..math.random(1, 5)..".wav", math.Rand(80, 100), math.Rand(90, 120))
            end		
        end
        ply.JustDidDodge = true
        ply:GodEnable()
    elseif ply.JustDidDodge then
        ply.JustDidDodge = false
        ply:GodDisable()
    end
end)


/**************************************************************
                         Spawning
**************************************************************/

hook.Add("PlayerTick", "MM_SpawnThink", function(ply, mv)
    if ply:HasStatusEffect(STATUS_SPAWNPROTECTED) then
        ply:GodEnable()
        ply:SetStatusEffect(STATUS_SPAWNPROTECTED, nil, CurTime()+1)
    end
end)

hook.Add("StartCommand", "MM_TakeOffInvulOnMoveClient", function(ply, cmd)

    if (ply:HasStatusEffect(STATUS_SPAWNPROTECTED) && (cmd:GetForwardMove() != 0 || cmd:GetSideMove() != 0)) then
        ply:RemoveStatusEffect(STATUS_SPAWNPROTECTED)
        ply:GodDisable()
    end
    
end)
