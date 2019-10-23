local RedBloodEffect = {
"blood_advisor_pierce_spray",
"blood_advisor_pierce_spray_b",
"blood_advisor_pierce_spray_c",
"blood_advisor_puncture_withdraw",
"blood_zombie_split_spray"}

local YellowBloodEffect = {
//"blood_advisor_shrapnel_spray_2",
//"blood_advisor_shrapnel_spray_1",
//"blood_advisor_shrapnel_spurt_1",
//"blood_advisor_shrapnel_spurt_2",
"blood_advisor_shrapnel_impact",
}

function GM:PlayerHurt(victim, attacker, health, damage)

end

util.AddNetworkString( "EmitConcussEffect" )

function GM:EntityTakeDamage(victim, dmginfo)

    if (victim:GetClass() == "prop_ragdoll" ) then
	
		local startp = dmginfo:GetDamagePosition()
       	local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = victim, mask = MASK_SOLID_BRUSHONLY}
       	local trace = util.TraceLine(traceinfo)
       	local todecal1 = trace.HitPos + trace.HitNormal
       	local todecal2 = trace.HitPos - trace.HitNormal
		
		if victim:GetMaterialType() == 70 || victim:GetMaterialType() == 66 then
        	util.Decal("Blood", todecal1, todecal2)
			local effect = EffectData()  
			local origin = dmginfo:GetDamagePosition()
			effect:SetOrigin( origin )
			util.Effect( "bloodimpact", effect ) 
		elseif victim:GetMaterialType() == 65 || victim:GetMaterialType() == 72 then
			util.Decal("YellowBlood", todecal1, todecal2)
			local RandomBlood = table.Random(YellowBloodEffect)
			local BloodTrail = ents.Create( "info_particle_system" )
			BloodTrail:SetKeyValue( "effect_name", RandomBlood )
			BloodTrail:SetKeyValue( "start_active", tostring( 1 ) )
			BloodTrail:SetPos( dmginfo:GetDamagePosition() )
			local AngleMark = victim:GetPos() - dmginfo:GetAttacker():GetPos()
			AngleMark = AngleMark:Angle()
			AngleMark.p = -100
			BloodTrail:SetAngles( AngleMark )
			BloodTrail:SetParent(victim)
			BloodTrail:Spawn()
			BloodTrail:Activate()
			BloodTrail:Fire( "Kill", nil, 0.4 )
		end
        return
	end

    if dmginfo:GetAttacker() != victim && dmginfo:GetAttacker():IsPlayer() then
        victim:SetNWEntity("MM_Assister", dmginfo:GetAttacker())
        victim:SetNWEntity("MM_AssisterInflictor", dmginfo:GetInflictor())
        timer.Simple(5, function() if !IsValid(victim) then return end victim:SetNWEntity("MM_Assister", NULL) victim:SetNWString("MM_AssisterInflictor", "suicide") end)
    end
        
    if dmginfo:GetInflictor():GetClass() == "ent_cleaver" then
        dmginfo:SetDamage(0) 
    end
    if dmginfo:GetInflictor():GetClass() == "ent_fireball" then
        dmginfo:SetDamage(0) 
    end
    if dmginfo:GetInflictor():GetClass() == "ent_fireballsmol" then
        dmginfo:SetDamage(0) 
    end
    if dmginfo:GetInflictor():GetClass() == "ent_deanimatorball" then
        dmginfo:SetDamage(0) 
    end    
    if dmginfo:GetInflictor():GetClass() == "ent_magicball" then
        dmginfo:SetDamage(0) 
    end
    
    if victim:GetNWString("Buff") == "armor" && dmginfo:IsBulletDamage() then
        dmginfo:SetDamage( dmginfo:GetDamage() * 0.5 )
	end
    
	if victim:IsPlayer() && dmginfo:GetDamageType() == DMG_SLASH then 
		victim:SetNWFloat("MM_Concussion", CurTime() + 8)
		victim:SetDSP( 35, false )
        if dmginfo:GetAttacker() != victim then
            dmginfo:GetAttacker():SetNWFloat("LastScoreTime", CurTime()+1)
            AddMedal(dmginfo:GetAttacker(), "concuss")
            dmginfo:GetAttacker():EmitSound("gameplay/crit_hit.wav")
            net.Start("EmitConcussEffect")
            net.WriteEntity(victim)
            net.Broadcast()
        end
	end	
    
	local e = dmginfo:GetInflictor()
	if IsValid(e) and e:GetClass() == "entityflame" && victim:IsPlayer() then
		dmginfo:SetDamageType( DMG_SLASH )
		dmginfo:SetDamage( 0 )
	end
	if IsValid(victim) && victim:IsPlayer() && dmginfo:GetInflictor().Base == "mm_melee_base" && math.floor(victim:GetNWFloat("MM_BleedTime")) != math.floor(CurTime()) then
        local punch = math.Clamp(50*((math.random(1,2)*2)-3),50*((math.random(1,2)*2)-3),50*((math.random(1,2)*2)-3))
        local randpunch = Angle(math.random(-punch,punch),math.random(-punch,punch),math.random(-punch,punch))
        victim:ViewPunch(randpunch)
    end
	
	local health = victim:Health()
	local attacker = dmginfo:GetAttacker()
	local hitgroup
		
	if ( attacker:IsPlayer() && victim:GetNWInt("MM_BleedDamage") < 1 ) then
		GAMEMODE:ScalePlayerDamage( victim, hitgroup, dmginfo )
	end	
end

hook.Add("GM:CalcMainActivity", "animations", function(ply, velocity)
	if ply:GetNWBool("Spooked",false) == true then
		ply:SetAnimation(PLAYER_JUMP)
		ply.CalcIdeal = ACT_IDLE;
		return ply.CalcIdeal, ply:LookupSequence("idle_cower_all");
		//ply:ResetSequence("idle_cower_all")
	end
end)