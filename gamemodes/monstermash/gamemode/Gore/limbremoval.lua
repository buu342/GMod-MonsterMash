function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
    local dismember = ply:GetNWInt("Dismember")
    ply:SetNWInt("Dismember", 0)
    if GetGlobalVariable("RoundsToWacky") == 0 && dmginfo:GetAttacker():IsPlayer() && ply:IsPlayer() && dmginfo:GetAttacker():Team() == ply:Team() && ply:Team() == 3 && dmginfo:GetAttacker():IsPlayer() != ply then 
        dmginfo:ScaleDamage( 0 ) 
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
        return 
    end
    if !IsValid(ply) then return end
    if !ply:IsPlayer() then return end
    if !ply:Alive() then return end
    if ply:HasGodMode() then return end

    local ht = ply:GetNWInt("LastHitgroupMelee")
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 1 )
	end

	if ( hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		hitgroup == HITGROUP_LEFTLEG or
		hitgroup == HITGROUP_RIGHTLEG or
		hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 1 )
	end
    
    if (hitgroup == HITGROUP_RIGHTLEG || hitgroup == HITGROUP_RIGHTLEG) && ply:GetNWInt("LegMissing") == 3 then
        dmginfo:ScaleDamage( 0 )
    end
    
    if (ply:Health() - dmginfo:GetDamage()) <= 0 then return end
    if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_COOPOther") == victim then return end
	if dismember == 0 && dmginfo:GetInflictor():GetClass() != "mm_coachgun" then return end
    
    if dmginfo:GetInflictor():GetClass() == "mm_coachgun" then
        if ply:GetNWFloat("DamageTaken")+10 <= 40 then
            return
        end
        if ply:GetNWFloat("CoachGun") < CurTime() then
            ply:SetNWFloat("CoachGun", CurTime())
        else
            return 
        end
    end

    local total = 0
    if ply:GetNWInt("LegMissing") == 1 then
        total = total + 1
    elseif ply:GetNWInt("LegMissing") == 2 then
        total = total + 1
    elseif ply:GetNWInt("LegMissing") == 3 then
        total = 2
    end
    
    if ply:GetNWInt("ArmMissing") == 1 then
        total = total + 1
    elseif ply:GetNWInt("ArmMissing") == 2 then
        total = total + 1
    elseif ply:GetNWInt("ArmMissing") == 3 then
        total = 2
    end
    if total >= 2 then return end
    //if ht == -1 && dmginfo:GetInflictor():GetClass() != "mm_coachgun" then return end
    if ply:GetNWString("Buff") == "armor" then return end
    local part = math.random(1,4)
    if dmginfo:GetAttacker() != ply  then
        dmginfo:GetAttacker():SetNWFloat("LastScoreTime", CurTime()+1)
        AddMedal(dmginfo:GetAttacker(), "dismember")
    end
    
    while part != 0 do
        if part == 1 then
            if ply:GetNWInt("LegMissing") == 0 then
                ply:SetBodygroup(3,2)
                ply:SetNWInt("LegMissing", 2)
                LoseLimb(ply, "leftleg", ply:GetModel())
                part = 0
            elseif ply:GetNWInt("LegMissing") == 1 then
                ply:SetBodygroup(3,3)
                ply:SetNWInt("LegMissing", 3)
                LoseLimb(ply, "leftleg", ply:GetModel())
                part = 0
            else
                part = math.random(1,4)
            end
        elseif part == 2 then
            if ply:GetNWInt("LegMissing") == 0 then
                ply:SetBodygroup(3,1)
                ply:SetNWInt("LegMissing", 1)
                LoseLimb(ply, "rightleg", ply:GetModel())
                part = 0
            elseif ply:GetNWInt("LegMissing") == 2 then
                ply:SetBodygroup(3,3)
                LoseLimb(ply, "rightleg", ply:GetModel())
                ply:SetNWInt("LegMissing", 3)
                part = 0
            else
                part = math.random(1,4)
            end
        elseif part == 3 then
            if ply:GetNWInt("ArmMissing") == 0 then
                ply:SetBodygroup(2,1)
                ply:SetNWInt("ArmMissing", 1)
                LoseLimb(ply, "leftarm", ply:GetModel())
                part = 0
            elseif ply:GetNWInt("ArmMissing") == 2 then
                ply:SetBodygroup(2,3)
                LoseLimb(ply, "leftarm", ply:GetModel())
                ply:SetNWInt("ArmMissing", 3)
                part = 0
                if SERVER then
                    ply:StripWeapons()
                    ply:Give("mm_headbutt")
                    ply:SelectWeapon("mm_headbutt")
                end
            else
                part = math.random(1,4)
            end
        elseif part == 4 then
            if ply:GetNWInt("ArmMissing") == 0 then
                ply:SetBodygroup(2,2)
                ply:SetNWInt("ArmMissing", 2)
                LoseLimb(ply, "rightarm", ply:GetModel())
                part = 0
            elseif ply:GetNWInt("ArmMissing") == 1 then
                ply:SetBodygroup(2,3)
                ply:SetNWInt("ArmMissing", 3)
                LoseLimb(ply, "rightarm", ply:GetModel())
                part = 0
                if SERVER then
                    ply:StripWeapons()
                    ply:Give("mm_headbutt")
                    ply:SelectWeapon("mm_headbutt")
                end
            else
                part = math.random(1,4)
            end
        end
        /*
            2, 0 - Both torso
            2, 1 - No left
            2, 2 - No right
            2, 3 - None

            3, 0 - Both Legs
            3, 1 - No left
            3, 2 - No right
            3, 3 - None
        */
    end
end

function LoseLimb(ply, which, model)
    if !ply:Alive() then return end
    ply:EmitSound("ambient/machines/slicer1.wav")
    if which == "leftarm" then
        CreateGibBody("models/monstermash/bloody_mary_final.mdl", "models/monstermash/gibs/bm_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/deer_haunter_final.mdl", "models/monstermash/gibs/dh_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/headless_horseman_final.mdl", "models/monstermash/gibs/hhm_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/guest_final.mdl", "models/monstermash/gibs/guest_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/nosferatu_final.mdl", "models/monstermash/gibs/nosferatu_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/mummy_final.mdl", "models/monstermash/gibs/mummy_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/scarecrow_final.mdl", "models/monstermash/gibs/scarecrow_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/skeleton_final.mdl", "models/monstermash/gibs/sk_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/vampire_final.mdl", "models/monstermash/gibs/vampire_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/stein_final.mdl", "models/monstermash/gibs/stein_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/witch_final.mdl", "models/monstermash/gibs/witch_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/banshee_final.mdl", "models/monstermash/gibs/banshee_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/mad_scientist_final.mdl", "models/monstermash/gibs/scientist_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/zombie_final.mdl", "models/monstermash/gibs/zombie_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/rex_final.mdl", "models/monstermash/gibs/rex_arm_left.mdl", ply, true)
        CreateGibBody("models/monstermash/invisible_man_final.mdl", "models/monstermash/gibs/invisibleman_arm_left.mdl", ply, true)
    elseif which == "rightarm" then
        CreateGibBody("models/monstermash/bloody_mary_final.mdl", "models/monstermash/gibs/bm_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/deer_haunter_final.mdl", "models/monstermash/gibs/dh_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/headless_horseman_final.mdl", "models/monstermash/gibs/hhm_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/guest_final.mdl", "models/monstermash/gibs/guest_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/nosferatu_final.mdl", "models/monstermash/gibs/nosferatu_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/mummy_final.mdl", "models/monstermash/gibs/mummy_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/scarecrow_final.mdl", "models/monstermash/gibs/scarecrow_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/skeleton_final.mdl", "models/monstermash/gibs/sk_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/vampire_final.mdl", "models/monstermash/gibs/vampire_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/stein_final.mdl", "models/monstermash/gibs/stein_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/witch_final.mdl", "models/monstermash/gibs/witch_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/banshee_final.mdl", "models/monstermash/gibs/banshee_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/mad_scientist_final.mdl", "models/monstermash/gibs/scientist_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/zombie_final.mdl", "models/monstermash/gibs/zombie_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/rex_final.mdl", "models/monstermash/gibs/rex_arm_right.mdl", ply, true)
        CreateGibBody("models/monstermash/invisible_man_final.mdl", "models/monstermash/gibs/invisibleman_arm_right.mdl", ply, true)
    elseif which == "leftleg" then
        CreateGibBody("models/monstermash/bloody_mary_final.mdl", "models/monstermash/gibs/bm_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/deer_haunter_final.mdl", "models/monstermash/gibs/dh_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/headless_horseman_final.mdl", "models/monstermash/gibs/hhm_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/guest_final.mdl", "models/monstermash/gibs/guest_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/nosferatu_final.mdl", "models/monstermash/gibs/nosferatu_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/mummy_final.mdl", "models/monstermash/gibs/mummy_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/scarecrow_final.mdl", "models/monstermash/gibs/scarecrow_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/skeleton_final.mdl", "models/monstermash/gibs/sk_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/vampire_final.mdl", "models/monstermash/gibs/vampire_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/stein_final.mdl", "models/monstermash/gibs/stein_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/witch_final.mdl", "models/monstermash/gibs/witch_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/banshee_final.mdl", "models/monstermash/gibs/banshee_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/mad_scientist_final.mdl", "models/monstermash/gibs/scientist_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/zombie_final.mdl", "models/monstermash/gibs/zombie_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/rex_final.mdl", "models/monstermash/gibs/rex_leg_left.mdl", ply, true)
        CreateGibBody("models/monstermash/invisible_man_final.mdl", "models/monstermash/gibs/invisibleman_leg_left.mdl", ply, true)
    elseif which == "rightleg" then
        CreateGibBody("models/monstermash/bloody_mary_final.mdl", "models/monstermash/gibs/bm_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/deer_haunter_final.mdl", "models/monstermash/gibs/dh_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/headless_horseman_final.mdl", "models/monstermash/gibs/hhm_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/guest_final.mdl", "models/monstermash/gibs/guest_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/nosferatu_final.mdl", "models/monstermash/gibs/nosferatu_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/mummy_final.mdl", "models/monstermash/gibs/mummy_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/scarecrow_final.mdl", "models/monstermash/gibs/scarecrow_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/skeleton_final.mdl", "models/monstermash/gibs/sk_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/vampire_final.mdl", "models/monstermash/gibs/vampire_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/stein_final.mdl", "models/monstermash/gibs/stein_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/witch_final.mdl", "models/monstermash/gibs/witch_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/banshee_final.mdl", "models/monstermash/gibs/banshee_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/mad_scientist_final.mdl", "models/monstermash/gibs/scientist_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/zombie_final.mdl", "models/monstermash/gibs/zombie_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/rex_final.mdl", "models/monstermash/gibs/rex_leg_right.mdl", ply, true)
        CreateGibBody("models/monstermash/invisible_man_final.mdl", "models/monstermash/gibs/invisibleman_leg_right.mdl", ply, true)
    end
end

function CreateGibBody(check,path,victim,dobleed)
    if !IsValid(victim) then return end
	if victim:GetModel() == check then
		local ent2 = ents.Create("prop_physics")
		ent2:SetModel(path)        
        ent2:SetPos(victim:GetPos())
		ent2:SetAngles(victim:GetAngles())
		ent2:SetSkin(victim:GetSkin())
		ent2:SetMaterial(victim:GetMaterial())
		ent2:Spawn()
        ent2:Activate()
        
		local phys = ent2:GetPhysicsObject()
		if ( !IsValid( phys ) ) then ent2:Remove() return end
		phys:ApplyForceCenter( Vector( math.random(-200,200), math.random(-200,200), 100 ) )
		
		local num = math.Rand(1,3)
		if dobleed == true then
			for i = 0.1, num, 0.1 do
				timer.Simple(i,function()
					if !IsValid(ent2) then return end
					local effectdata = EffectData()
					effectdata:SetOrigin( ent2:GetPos() )
					util.Effect( "BloodImpact", effectdata )  
				end)
			end
			if victim:IsOnFire() then ent2:Ignite(math.Rand(6, 8), 0) end
			local color = Color( 105, 0, 0, 255 )
			local trail = util.SpriteTrail(ent2, 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "effects/bloodstream.vmt")
		end
	   
		ent2:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
	   
		timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent2) then return end ent2:Remove() end)
	end
end

function GM:GetFallDamage( ply, speed )
	if ply:GetNWString("Buff") == "broom" then
		return 0
    else
        speed = speed - 526.5;
		return speed * 100/(922.5-526.5);
	end
end