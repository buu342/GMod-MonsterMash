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

function hiteffect( Entity, dmginfo)

	if (Entity:GetClass() == "prop_ragdoll" ) then
	

		local startp = dmginfo:GetDamagePosition()
       	local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = Entity, mask = MASK_SOLID_BRUSHONLY}
       	local trace = util.TraceLine(traceinfo)
       	local todecal1 = trace.HitPos + trace.HitNormal
       	local todecal2 = trace.HitPos - trace.HitNormal
		
		if Entity:GetMaterialType() == 70 || Entity:GetMaterialType() == 66 then
        	util.Decal("Blood", todecal1, todecal2)
			local effect = EffectData()  
			local origin = dmginfo:GetDamagePosition()
			effect:SetOrigin( origin )
			util.Effect( "bloodimpact", effect ) 
		elseif Entity:GetMaterialType() == 65 || Entity:GetMaterialType() == 72 then
			util.Decal("YellowBlood", todecal1, todecal2)
			local RandomBlood = table.Random(YellowBloodEffect)
			local BloodTrail = ents.Create( "info_particle_system" )
			BloodTrail:SetKeyValue( "effect_name", RandomBlood )
			BloodTrail:SetKeyValue( "start_active", tostring( 1 ) )
			BloodTrail:SetPos( dmginfo:GetDamagePosition() )
			local AngleMark = Entity:GetPos() - dmginfo:GetAttacker():GetPos()
			AngleMark = AngleMark:Angle()
			AngleMark.p = -100
			BloodTrail:SetAngles( AngleMark )
			BloodTrail:SetParent(Entity)
			BloodTrail:Spawn()
			BloodTrail:Activate()
			BloodTrail:Fire( "Kill", nil, 0.4 )
		end
	end
	
end
	

hook.Add("EntityTakeDamage", "hiteffect", hiteffect)

function RainbowPhysgunForAdmins()
	for id, ply in pairs( player.GetAll() ) do
		if ( ply:IsAdmin() ) then
			local col = HSVToColor( CurTime() % 6 * 60, 1, 1 )
			ply:SetWeaponColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) )
		end
	end
end
hook.Add("Think", "RainbowPhysgunForAdmins", RainbowPhysgunForAdmins)