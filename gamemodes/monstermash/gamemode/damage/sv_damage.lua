util.AddNetworkString("MM_DoPlayerFlinch")
util.AddNetworkString("MM_DamageDirection")
util.AddNetworkString("MM_PlaySoundClient")

function GM:ScalePlayerDamage(victim, hitgroup, dmginfo)
    
    if (dmginfo:GetAttacker():IsPlayer() && !victim:CanBeDamagedBy(dmginfo:GetAttacker())) then
        dmginfo:ScaleDamage(0)
        return 
    end
    
    // Don't scale damage to different hitgroups
	if (hitgroup == HITGROUP_HEAD or 
        hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		hitgroup == HITGROUP_LEFTLEG or
		hitgroup == HITGROUP_RIGHTLEG or
		hitgroup == HITGROUP_GEAR) then
		dmginfo:ScaleDamage(1)
	end
    
    // If a player is shot in a missing limb, do no damage
    if ((victim:MissingLeftLeg() && hitgroup == HITGROUP_LEFTARM) or
        (victim:MissingRightLeg() && hitgroup == HITGROUP_RIGHTARM) or
        (victim:MissingLeftLeg() && hitgroup == HITGROUP_LEFTLEG) or
        (victim:MissingRightLeg() && hitgroup == HITGROUP_RIGHTLEG)) then
        dmginfo:ScaleDamage(0)
        return
    end
        
    // Flinch animations
    if victim:IsPlayer() then
		local group = nil
		local hitpos = {
            [HITGROUP_HEAD] = ACT_FLINCH_HEAD,
            [HITGROUP_CHEST] = ACT_FLINCH_PHYSICS,
            [HITGROUP_STOMACH] = ACT_FLINCH_STOMACH,
            [HITGROUP_LEFTARM] = ACT_FLINCH_SHOULDER_LEFT,
            [HITGROUP_RIGHTARM] = ACT_FLINCH_SHOULDER_RIGHT,
            [HITGROUP_LEFTLEG] = ACT_FLINCH_BACK,
            [HITGROUP_RIGHTLEG] = ACT_FLINCH_BACK
        }
		
		if hitpos[hitgroup] == nil then
			group = ACT_FLINCH_PHYSICS
		else
			group = hitpos[hitgroup]
		end
		
		victim:Flinch(group)
		if (victim:GetLastHitgroup() == 0) then
			victim:SetLastHitgroup(hitgroup)
		end
        timer.Simple(0, function() if IsValid(victim) then victim:SetLastHitgroup(0) end end)
	end
end

function GM:EntityTakeDamage(victim, dmginfo)
    if !victim:IsPlayer() then return end
    if victim:HasGodMode() then dmginfo:SetDamage(0) return end
    if (dmginfo:GetAttacker():IsPlayer() && victim != dmginfo:GetAttacker() && !victim:CanBeDamagedBy(dmginfo:GetAttacker())) then dmginfo:SetDamage(0) dmginfo:SetDamageForce(Vector(0, 0, 0)) return end
    if (GetConVar("mm_tasermanmode"):GetBool() && victim:GetCharacterName() == "Deer Haunter") then dmginfo:SetDamage(0) return end
    
    // Don't take physics damage from throwables
    if (dmginfo:GetAttacker().MMSent) then
        dmginfo:SetDamage(0)
        return
    end
    
    // If taking fire damage or dodge rolling, ignore
    if dmginfo:IsDamageType(DMG_BURN) || victim:IsDodgeRolling() then
        dmginfo:SetDamage(0)
        return
    end
    
    // Scale stake on super player
    if ((GAMEMODE:GetSuperPlayer() == victim || victim:IsSuper()) && (dmginfo:GetInflictor() == "weapon_mm_stake" || dmginfo:GetDamage() == 9001)) then
        dmginfo:ScaleDamage(0.01)
    end
    
    // Scale bullet damage if armor'd
    if (victim:GetBloodColor() == BLOOD_COLOR_MECH && dmginfo:IsDamageType(DMG_BULLET)) then
        dmginfo:ScaleDamage(0.5)
    end
        
    // Viewpunch if hit by a melee weapon
    if IsValid(victim) && victim:IsPlayer() && (dmginfo:IsDamageType(DMG_SLASH) || dmginfo:IsDamageType(DMG_DIRECT)) then
        local force = 50
        if dmginfo:IsDamageType(DMG_DIRECT) then
            force = 3
        end
        local punch = math.Clamp(force*((math.random(1,2)*2)-3),force*((math.random(1,2)*2)-3),force*((math.random(1,2)*2)-3))
        local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
        victim:ViewPunch(randpunch)
    end
    
    // Concuss the player
    if bit.band(dmginfo:GetDamageCustom(), STATUS_CONCUSS) == STATUS_CONCUSS then
        victim:SetStatusEffect(STATUS_CONCUSS, dmginfo, 8)
		victim:SetDSP(35, false)
        if dmginfo:GetAttacker():IsPlayer() && dmginfo:GetAttacker() != victim then
            dmginfo:GetAttacker():GiveTreat("concuss")
        end
    end
    
    // Bleed the player
    if bit.band(dmginfo:GetDamageCustom(), STATUS_BLEED) == STATUS_BLEED then
        victim:SetStatusEffect(STATUS_BLEED, dmginfo, 7)
    end    
    
    // Apply acid on the player
    if bit.band(dmginfo:GetDamageCustom(), STATUS_MELTER) == STATUS_MELTER then
        victim:SetStatusEffect(STATUS_MELTER, dmginfo, 0.5*5)
    end
    
    // Send the damageinfo to the player
    victim:SetLastDamage(dmginfo)
    
    // If got shot by the coachgun, lose a limb if more than 40 damage
    if IsValid(victim) && victim:IsPlayer() && IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "weapon_mm_coachgun" then
        if victim.coachgunDelimbTime == nil then
            victim.coachgunDelimbTime = 0
        end
        if victim:GetLastDamage().totalamount >= 40 && victim.coachgunDelimbTime != CurTime() then 
            victim.coachgunDelimbTime = CurTime()
            dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_MISSINGLIMB))
        end
    end
    
    // Lose limbs if not armor'd
    if (victim:GetBloodColor() != BLOOD_COLOR_MECH && !victim:IsSuper()) then
        self:LoseLimb(victim, dmginfo)
    end
    
    // Flinch if no bullet damage was taken
    if (!dmginfo:IsBulletDamage()) then
        victim:Flinch(ACT_FLINCH_PHYSICS)
    end
    
    // Nofify the attacker and victim
    if dmginfo:GetDamage() > 0 then
        net.Start("MM_PlaySoundClient")
            if (victim:GetBloodColor() != BLOOD_COLOR_MECH) then
                net.WriteString("gameplay/Flesh_Arm-0"..math.random(1,4)..".wav")
            else
                net.WriteString("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
            end
        net.Send(victim)
        if dmginfo:GetAttacker():IsPlayer() then
            net.Start("MM_PlaySoundClient")
                if bit.band(dmginfo:GetDamageCustom(), STATUS_CONCUSS) == STATUS_CONCUSS then
                    net.WriteString("gameplay/crit_hit.wav")
                elseif (victim:GetBloodColor() == BLOOD_COLOR_MECH) then
                    net.WriteString("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
                else
                    net.WriteString("gameplay/hit_sound.wav")
                end
            net.Send(dmginfo:GetAttacker())
        end
        victim.NextRegenTime = CurTime()+GetConVar("mm_healthregen_time"):GetInt()
    end
	
	if (IsValid(dmginfo:GetAttacker())) then
		net.Start("MM_DamageDirection")
			net.WriteVector(dmginfo:GetAttacker():GetPos())
		net.Send(victim)
	end
end

// lua_run local dmginfo = DamageInfo() dmginfo:SetDamage(1) dmginfo:SetDamageCustom(STATUS_MISSINGLIMB) Entity(1):TakeDamageInfo(dmginfo)
function GM:LoseLimb(victim, dmginfo, force)
    if force == nil && victim:Health()-dmginfo:GetDamage() <= 0 then return end
    
    // If the damagetype contained the dismember flag
    if force != nil || bit.band(dmginfo:GetDamageCustom(), STATUS_MISSINGLIMB) == STATUS_MISSINGLIMB then
        if victim:CountMissingLimbs() == 2 then return end
        
        // Award the player who dismembered with a treat
        if force == nil && dmginfo:GetAttacker():IsPlayer() then
            dmginfo:GetAttacker():GiveTreat("dismember")
        end
        
        // Pick a limb at random if no value was provided beforehand
        local limb = force
        if force == nil then
            limb = math.random(1, 4)
        end
        
        // Keep trying to lose limbs
        while (limb != 0) do
        
            // Lose left arm
            if limb == 1 then
                if !victim:MissingLeftArm() then
                    victim:SetStatusEffect(STATUS_MISSINGLARM, dmginfo)
                    victim:EmitSound("ambient/machines/slicer1.wav")
                    self:GoreCreateGibClient(victim, victim:GetCharacter().gib_armleft, victim:GetPos(), victim:GetAngles(), nil, false, true)
                    if victim:MissingRightArm() then
                        victim:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_NONE)
                    else
                        victim:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_NOLEFT)
                    end
                    limb = 0
                    if (IsValid(victim:GetActiveWeapon())) then
                        victim:GetActiveWeapon():Deploy()
                    end
                else
                    limb = math.random(1, 4)
                end
            end
            
            // Lose right arm
            if limb == 2 then
                if !victim:MissingRightArm() then
                    victim:SetStatusEffect(STATUS_MISSINGRARM, dmginfo)
                    victim:EmitSound("ambient/machines/slicer1.wav")
                    self:GoreCreateGibClient(victim, victim:GetCharacter().gib_armright, victim:GetPos(), victim:GetAngles(), nil, false, true)
                    if victim:MissingLeftArm() then
                        victim:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_NONE)
                    else
                        victim:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_NORIGHT)
                    end
                    limb = 0
                    if (IsValid(victim:GetActiveWeapon())) then
                        victim:GetActiveWeapon():Deploy()
                    end
                else
                    limb = math.random(1, 4)
                end
            end
            
            // Lose left leg
            if limb == 3 then
                if !victim:MissingLeftLeg() then
                    victim:SetStatusEffect(STATUS_MISSINGLLEG, dmginfo)
                    victim:EmitSound("ambient/machines/slicer1.wav")
                    self:GoreCreateGibClient(victim, victim:GetCharacter().gib_legleft, victim:GetPos(), victim:GetAngles(), nil, false, true)
                    if victim:MissingRightLeg() then
                        victim:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_NONE)
                    else
                        victim:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_NOLEFT)
                    end
                    limb = 0
                else
                    limb = math.random(1, 4)
                end
            end
            
            // Lose right leg
            if limb == 4 then
                if !victim:MissingRightLeg() then
                    victim:SetStatusEffect(STATUS_MISSINGRLEG, dmginfo)
                    victim:EmitSound("ambient/machines/slicer1.wav")
                    self:GoreCreateGibClient(victim, victim:GetCharacter().gib_legright, victim:GetPos(), victim:GetAngles(), nil, false, true)
                    if victim:MissingLeftLeg() then
                        victim:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_NONE)
                    else
                        victim:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_NORIGHT)
                    end
                    limb = 0
                else
                    limb = math.random(1, 3)
                end
            end
            
        end
    end
end

function GM:PostEntityTakeDamage(ent, dmg, took)
    if (ent:IsPlayer() && !ent:EarnedTreatInLife("damage_sources")) then
        local victim_damagesources = {}
        local stacksize = #ent:GetDamageStack()
        for k, v in pairs (ent:GetDamageStack()) do
            if (victim_damagesources[v.type] == nil) then
                victim_damagesources[v.type] = 0
            end
            victim_damagesources[v.type] = victim_damagesources[v.type] + 1
        end
        if (table.Count(victim_damagesources) >= 3) then
            ent:GiveTreat("damage_sources")
        end
    end
end

function GM:GetFallDamage(ply, speed)
	if ply:HasStatusEffect(STATUS_BROOM) then
		return 0
    else
        speed = speed - 526.5;
		return speed * 100/(922.5-526.5);
	end
end

hook.Add("PlayerTick", "MM_HealthRegen", function(ply, mv)
    if ply.NextRegenTime == nil then
        ply.NextRegenTime = 0
    end
    if (ply.NextRegenTime < CurTime() && ply:Health() < ply:GetMaxHealth()) then
        ply.NextRegenTime = CurTime()+GetConVar("mm_healthregen_time"):GetInt()
        ply:SetHealth(math.min(ply:Health()+GetConVar("mm_healthregen_amount"):GetInt(), ply:GetMaxHealth()))
    end
end)

function GM:PostEntityTakeDamage(ent, dmginfo, took)
    if (ent:IsPlayer() && dmginfo:GetAttacker() != nil && dmginfo:GetAttacker():IsPlayer() && ent != dmginfo:GetAttacker()) then
        ent:IncrementPlayerStat("Damage_Received", dmginfo:GetDamage())
        dmginfo:GetAttacker():IncrementPlayerStat("Damage_Given", dmginfo:GetDamage())
    end
end