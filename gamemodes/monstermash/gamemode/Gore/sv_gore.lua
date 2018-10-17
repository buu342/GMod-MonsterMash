local RedBloodEffect = {
	"blood_advisor_pierce_spray",
	"blood_advisor_pierce_spray_b",
	"blood_advisor_pierce_spray_c",
	"blood_advisor_puncture_withdraw",
	"blood_zombie_split_spray"
} 
 
local Playermodels = {
	"models/monstermash/deer_haunter_final.mdl",
	"models/monstermash/skeleton_final.mdl",
	"models/monstermash/guest_final.mdl",
	"models/monstermash/vampire_final.mdl",
	"models/monstermash/stein_final.mdl",
	"models/monstermash/witch_final.mdl",
	"models/monstermash/headless_horseman_final.mdl",
	"models/monstermash/mummy_final.mdl",
	"models/monstermash/scarecrow_final.mdl",
	"models/monstermash/nosferatu_final.mdl",
	"models/monstermash/bloody_mary_final.mdl"
}

/*---------------------------------------------------*/
 
local Weps_CanBifurcate = {
	"mm_battleaxe",
	"mm_scythe"
}

local Weps_CanHeadOff = {
	"mm_axe",
	"mm_battleaxe",
	"mm_scythe",
	"mm_sword",
	"mm_hacksaw"
}

local Weps_CanGib = {
    "ent_pumpkin_nade",
    "mm_coachgun",
    "ent_cannonball"
}

local Weps_CanHeadExplode = {
	"mm_mace",
	"mm_battlerifle",
    "mm_sawedoff",
    "mm_musketpistol",
    "mm_pumpshotgun",
    "mm_repeater"
}

local Weps_CanScripted = {
	"mm_stake",
    "mm_acidflask",
    "mm_cleaver", 
    "ent_cleaver"
}

/*---------------------------------------------------*/

local Weps_Class_LowTierMelee = {
	"mm_boner",
	"mm_knife", 
	"mm_shovel",
	"mm_hook",
	"mm_candlestick",
}

local Weps_Class_RegularMelee = {
	"mm_axe",
	"mm_fencepost",
	"mm_mace",
	"mm_pitchfork",
	"mm_hacksaw",
	"mm_sword",
}

local Weps_Class_HeavyMelee = {
	"mm_stake",
	"mm_scythe",
	"mm_battleaxe",
}

local Weps_Class_Handgun = {
	"mm_colt",
	"mm_musketpistol",
	"mm_revolver",
	"mm_shield",
	"mm_sawedoff",
	"mm_crossbow",
	"ent_arrow",
}

local Weps_Class_Long = {
    "mm_undertaker",
	"mm_pumpshotgun",
	"mm_repeater",
	"mm_thompson",
	"mm_battlerifle",
	"mm_flamethrower",
	"ent_flamehitbox",
}

local Weps_Class_Heavy = {
    "mm_sawblade",
	"mm_coachgun",
	"mm_cannon",
	"mm_deanimator",
    "mm_pumpkinnade",
    "ent_sawblade",
	"ent_pumpkin_nade",
	"ent_cannonball"
}

local Weps_Class_Throwable = {
	"mm_skull",
	"mm_cleaver",
	"mm_spidernade",
	"mm_acidflask",
	"ent_skull",
	"ent_acidflask",
	"ent_acid"
}

local meta = FindMetaTable("Player")
function meta:CreateRagdoll()
end
 
function GM:PlayerDeathSound()
    return true
end
 
function stuff(victim,inflictor,attacker)

	local effectdata4 = EffectData()
	effectdata4:SetStart( victim:GetPos()+Vector(0,0,50) ) 
	effectdata4:SetOrigin( victim:GetPos()+Vector(0,0,50) )
	util.Effect( "Spoopyghost", effectdata4 )

    if victim != attacker && inflictor:GetClass() != nil && inflictor:GetClass() != "mm_coachgun" && (victim:GetNWFloat("ArmMissing") != 0 || victim:GetNWFloat("LegMissing") != 0) then
        AddMedal(victim, "honorabledeath")
    end
    
    if victim == attacker && attacker:GetNWBool("DamagedSelf") == true && attacker:GetNWBool("DamagedOther") == true && attacker:GetNWFloat("DamagedFrame") >= CurTime() && attacker:GetNWEntity("DamagedPlayer") != NULL then
        AddMedal(attacker, "youtried")
    end
    
    if victim == attacker && victim:GetNWEntity("MM_Assister") != NULL then
        attacker = victim:GetNWEntity("MM_Assister")
        inflictor = victim:GetNWEntity("MM_AssisterInflictor")
    end
    local oldkillc = attacker:GetNWInt("killcounter")
    if !(victim == attacker) && inflictor:IsValid() && attacker:IsPlayer() then
        if inflictor:GetClass() == "mm_urn" then
            attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 10)
        elseif inflictor:GetClass() == "mm_headbutt" then
            attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 150)
		elseif table.HasValue( Weps_Class_LowTierMelee, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 75)
		elseif table.HasValue( Weps_Class_RegularMelee, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 40)
		elseif table.HasValue( Weps_Class_HeavyMelee, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 20)
		elseif table.HasValue( Weps_Class_Handgun, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 40)
		elseif table.HasValue( Weps_Class_Long, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 25)
		elseif table.HasValue( Weps_Class_Heavy, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 10)
		elseif table.HasValue( Weps_Class_Throwable, inflictor:GetClass() ) then
			attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 40)
		end
        if attacker:GetNWFloat("MM_Concussion") > CurTime() then
            AddMedal(attacker, "killwhileconcussed")
        end
        if attacker:GetNWFloat("MM_BleedTime") > CurTime() then
            AddMedal(attacker, "killwhilebleeding")
        end
        if attacker:GetNWFloat("ArmMissing") != 0 || attacker:GetNWFloat("LegMissing") != 0 then
            AddMedal(attacker, "killwhilelimbless")
        end
        if attacker:Health() <= 20 && attacker:Alive() then
            AddMedal(attacker, "neardeath")
        end
        if math.ceil(victim:Health()+victim:GetNWFloat("DamageTaken")) >= victim:GetMaxHealth() && victim:Health() <= 0 then
            AddMedal(attacker, "1hitkill")
        end
        if attacker:GetPos():Distance(victim:GetPos()) >= 1024 then
            AddMedal(attacker, "longrange")
        end
        if attacker:GetNWBool("KillFromBackstab") then
            AddMedal(attacker, "backstab")
            attacker:SetNWBool("KillFromBackstab", false)
        end
        if !attacker:Alive() then
            AddMedal(attacker, "post_mortem")
        end
        if attacker.UsingRandomLoadout then
            AddMedal(attacker, "random")
        end
        if victim:GetNWFloat("Sticky") > CurTime() && victim:GetNWEntity("Sticky_Attacker" ) == attacker then
            AddMedal(attacker, "immobilized")
        end
        if victim:GetNWFloat("Spooked") > CurTime() && victim:GetNWEntity("MM_Assister" ) == attacker then
            AddMedal(attacker, "immobilized")
        end
        if victim:GetNWBool("DiedFromBleed") then
            AddMedal(attacker, "bleed")
        end
    else
        
    end
    if victim:IsPlayer() then
		victim:SetNWFloat("MM_BleedTime", 0)
		victim:SetNWInt("MM_BleedDamage", 0)
		victim:SetNWFloat("MM_Concussion",0)
		if GetConVarNumber("mm_tasermanmode") == 1 then
			victim:EmitSound("death/death8.wav")
		elseif GetConVarNumber("mm_OrgasmicDeathSounds") == 1 then
			victim:EmitSound("death/death"..math.random(1,7)..".wav")
		else
			victim:ConCommand("play gameplay/death.wav")
		end
		if IsValid(attacker) && attacker:IsPlayer() && victim != attacker then
			attacker:ConCommand("play gameplay/kill_confirm.wav")
		end
    end
 
    local ply_pos = victim:GetPos()
    local ply_ang = victim:GetAngles()
    local ply_mdl = victim:GetModel()
    local ply_skn = victim:GetSkin()
    local ply_col = victim:GetColor()
    local ply_mat = victim:GetMaterial()
	local chance = math.random(0,2)
    if victim:GetNWFloat("DamageTaken") == nil then
		victim:SetNWFloat("DamageTaken", 0)
    end
	local effectdata4 = EffectData()
	effectdata4:SetStart( ply_pos+Vector(0,0,50) ) 
	effectdata4:SetOrigin( ply_pos+Vector(0,0,50) )
	util.Effect( "Spoopyghost", effectdata4 )
    if GetConVarNumber("mm_ludicrousgibs") != 1 && IsValid(attacker) && attacker:IsPlayer() then
        if victim == attacker && victim:GetNWFloat("SuicideDamageTaken") > 119 then
            PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif victim == attacker && victim:GetNWFloat("SuicideDamageTaken") <= 119 then
            PlayerCorpse_Normal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif IsValid(attacker:GetActiveWeapon()) && inflictor:GetClass() == "mm_acidflask" then
            PlayerCorpse_ScriptedAcid(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif victim != attacker && IsValid(attacker:GetActiveWeapon()) && attacker:GetActiveWeapon():GetClass() == "mm_shovel" then
            PlayerCorpse_Grave(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif table.HasValue( Weps_CanBifurcate, inflictor:GetClass() ) || (inflictor:GetClass() == "mm_sword" && victim:GetNWFloat("DamageTaken") == 100) then
            PlayerCorpse_Bifurcate(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif table.HasValue( Weps_CanGib, inflictor:GetClass() ) || (victim:GetNWFloat("DamageTaken") > 119 && inflictor:GetClass() != "mm_stake") then
            PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
            AddMedal(attacker, "gib")
        elseif (!victim:GetNWBool("DiedFromBleed") && table.HasValue( Weps_CanHeadOff, inflictor:GetClass() ) && victim:GetNWInt("LastHitgroupMelee") == HITGROUP_HEAD) || inflictor:GetClass() == "ent_sawblade" then
            PlayerCorpse_DecapNormal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
            if inflictor:GetClass() != "ent_sawblade" then
                AddMedal(attacker, "behead")
            end
        elseif !victim:GetNWBool("DiedFromBleed") && table.HasValue( Weps_CanHeadExplode, inflictor:GetClass() ) && victim:GetNWInt("LastHitgroupBullet") == HITGROUP_HEAD then
            PlayerCorpse_DecapExplode(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
            AddMedal(attacker, "behead")
        elseif victim:IsOnGround() && (table.HasValue( Weps_CanScripted, inflictor:GetClass() ) || (chance == 0)) then
            PlayerCorpse_Scripted(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        else
            PlayerCorpse_Normal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        end
    else
        PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        if attacker != victim then
            AddMedal(attacker, "gib")
        end
    end
	
    if (IsValid(attacker) && !(victim == attacker) && attacker:IsPlayer() && (inflictor:GetClass() == "mm_boner")) then
        local ent = ents.Create("item_healthkit")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:Spawn()
    end
    
    attacker:SetNWInt("LastScore", attacker:GetNWInt("killcounter")-oldkillc)
    attacker:SetNWFloat("LastScoreTime", CurTime()+1)
    
    if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("Game_Over") == false then
        victim:SetTeam(5)
    end
    
    victim:SetNWInt("LegMissing", 0)
	victim:SetNWInt("ArmMissing", 0)
    net.Start("ResetLimbs")
    net.Send(victim)
end
hook.Add("PlayerDeath", "stuff", stuff)

function PlayerCorpse_Grave(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
	local ent = ents.Create("prop_dynamic")
    ent:SetPos(ply_pos)
    ent:SetAngles(ply_ang)
    ent:SetModel("models/misc/gravestone.mdl")
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent) then return end ent:Remove() end)
end

function PlayerCorpse_Bifurcate(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    local ent = ents.Create("prop_ragdoll")
    ent:SetPos(ply_pos+Vector(0,0,40))
    ent:SetAngles(ply_ang - Angle(ply_ang.p,0,-90))
    if ply_mdl == "models/monstermash/deer_haunter_final.mdl" then
        ent:SetModel("models/monstermash/gibs/deerhaunter_top.mdl")
    elseif ply_mdl == "models/monstermash/skeleton_final.mdl"  then
        ent:SetModel("models/monstermash/gibs/skeleton_top.mdl")
    elseif ply_mdl == "models/monstermash/guest_final.mdl" then
        ent:SetModel("models/monstermash/gibs/guest_top.mdl")
    elseif ply_mdl == "models/monstermash/vampire_final.mdl" then
        ent:SetModel("models/monstermash/gibs/vampire_top.mdl")
    elseif ply_mdl == "models/monstermash/stein_final.mdl" then
        ent:SetModel("models/monstermash/gibs/stein_top.mdl")
    elseif ply_mdl == "models/monstermash/witch_final.mdl" then
        ent:SetModel("models/monstermash/gibs/witch_top.mdl")
    elseif ply_mdl == "models/monstermash/headless_horseman_final.mdl" then
        ent:SetModel("models/monstermash/gibs/hhm_top.mdl")
    elseif ply_mdl == "models/monstermash/mummy_final.mdl" then
        ent:SetModel("models/monstermash/gibs/mummy_top.mdl")
    elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
        ent:SetModel("models/monstermash/gibs/scarecrow_top.mdl")
    elseif ply_mdl == "models/monstermash/nosferatu_final.mdl" then
        ent:SetModel("models/monstermash/gibs/nosferatu_top.mdl")
    elseif ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        ent:SetModel("models/monstermash/gibs/bm_top.mdl")
    end
    ent:SetSkin(ply_skn)
    ent:SetMaterial(ply_mat)
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    ent:SetBodygroup(1 ,0)
    ent:EmitSound("physics/flesh/flesh_bloody_break.wav")
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent) then return end ent:Remove() end)
    if ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        local RandomBlood = table.Random(RedBloodEffect)
        local BloodTrail = ents.Create( "info_particle_system" )
        BloodTrail:SetKeyValue( "effect_name", RandomBlood )
        BloodTrail:SetKeyValue( "start_active", tostring( 1 ) )
        BloodTrail:SetPos( ply_pos+Vector(0,0,10) )
        BloodTrail:SetAngles( ply_ang )
        BloodTrail:SetParent(ent)
        BloodTrail:Spawn()
        BloodTrail:Activate()
        BloodTrail:Fire( "Kill", nil, 0.4 )
    end
   
    if not ent:IsValid() then return end
    local plyvel = victim:GetVelocity()
   
    for i = 1, ent:GetPhysicsObjectCount() do
        local bone = ent:GetPhysicsObjectNum(i)
        if bone and bone.IsValid and bone:IsValid() then
            local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
            bone:SetPos(bonepos)
            bone:SetAngles(boneang)
            bone:AddVelocity(plyvel)
        end
    end
       
    if victim:IsOnFire() then ent:Ignite(math.Rand(6, 8), 0) end
    victim:SpectateEntity(ent)
    victim:Spectate(OBS_MODE_CHASE)
   
    local ent2 = ents.Create("prop_ragdoll")
    ent2:SetPos(ply_pos)
    ent2:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
    if ply_mdl == "models/monstermash/deer_haunter_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/deerhaunter_lower.mdl")
    elseif ply_mdl == "models/monstermash/skeleton_final.mdl"  then
        ent2:SetModel("models/monstermash/gibs/skeleton_lower.mdl")
    elseif ply_mdl == "models/monstermash/guest_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/guest_lower.mdl")
    elseif ply_mdl == "models/monstermash/vampire_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/vampire_lower.mdl")
    elseif ply_mdl == "models/monstermash/stein_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/stein_lower.mdl")
    elseif ply_mdl == "models/monstermash/witch_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/witch_lower.mdl")
    elseif ply_mdl == "models/monstermash/headless_horseman_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/hhm_lower.mdl")
    elseif ply_mdl == "models/monstermash/mummy_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/mummy_lower.mdl")
    elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/scarecrow_lower.mdl")
    elseif ply_mdl == "models/monstermash/nosferatu_final.mdl" then
        ent:SetModel("models/monstermash/gibs/nosferatu_lower.mdl")
    elseif ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        ent:SetModel("models/monstermash/gibs/bm_lower.mdl")
    end
    ent2:SetSkin(ply_skn)
    ent2:SetMaterial(ply_mat)
    ent2:Spawn()
    ent2:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    ent2:SetBodygroup(1 ,0)
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent2) then return end ent2:Remove() end)
    if not ent2:IsValid() then return end
    local plyvel = victim:GetVelocity()
       
    if victim:IsOnFire() then ent2:Ignite(math.Rand(6, 8), 0) end
end

function PlayerCorpse_ScriptedAcid(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply_pos)
    ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
    ent:SetModel(ply_mdl)
    ent:SetSkin(ply_skn)
    ent:SetMaterial(ply_mat)
    ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
    ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
    ent:SetNWFloat("Time", 0)
    ent:SetNWFloat("Melting",CurTime()+3)
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    ent:SetSequence( ent:LookupSequence( "taunt_zombie" ) )
end

function PlayerCorpse_Scripted(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    if victim:GetNWInt("LegMissing") != 3 then
        local ent = ents.Create("sent_mm_body")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:SetModel(ply_mdl)
        ent:SetSkin(ply_skn)
        if IsValid(inflictor) && (inflictor:GetClass() == "mm_flamethrower") then
            ent:SetMaterial("Models/player/monstermash/gibs/burn")
        else
            ent:SetMaterial(ply_mat)
        end
        ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
        ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
        if inflictor:GetClass() == "ent_stake" then
            ent:SetBodygroup(4, 1)
        end
        
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
   
        if inflictor:GetClass() == "ent_cleaver" || inflictor:GetClass() == "mm_cleaver" then
            ent:SetSequence( ent:LookupSequence( "death_01" ) )
            ent:SetBodygroup(1, 1)
            ent:SetNWFloat("Time", CurTime() + 0.75)
        elseif inflictor:GetClass() == "mm_stake" then
            ent:SetSequence( ent:LookupSequence( "death_04" ) )
            ent:SetNWFloat("Time", CurTime() + 2)
            ent:SetBodygroup(4, 1)
        else
            local chance = math.random(0,2)
            if chance == 0 then
                ent:SetSequence( ent:LookupSequence( "death_01" ) )
            elseif chance == 1 then
                ent:SetSequence( ent:LookupSequence( "death_02" ) )
            elseif chance == 2 then
                ent:SetSequence( ent:LookupSequence( "death_03" ) )
            end
            ent:SetNWFloat("Time", CurTime() + 0.75)
        end
    else
        local ent = ents.Create("prop_ragdoll")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:SetModel(ply_mdl)
        ent:SetSkin(ply_skn)
        ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
        ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
        if inflictor:GetClass() == "ent_cleaver" || inflictor:GetClass() == "mm_cleaver" then
            ent:SetBodygroup(1, 1)
        elseif inflictor:GetClass() == "mm_stake" then
            ent:SetBodygroup(4, 1)
        end
        if IsValid(inflictor) && inflictor:GetClass() != nil && inflictor:GetClass() == "mm_flamethrower" then
            ent:SetMaterial("Models/player/monstermash/gibs/burn")
        else
            ent:SetMaterial(ply_mat)
        end
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
        timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent) then return end ent:Remove() end)
        if not ent:IsValid() then return end
        local plyvel = victim:GetVelocity()
       
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
                bone:AddVelocity(plyvel)
            end
        end
           
        if victim:IsOnFire() then ent:Ignite(math.Rand(6, 8), 0) end
        victim:SpectateEntity(ent)
        victim:Spectate(OBS_MODE_CHASE)
    
        if inflictor:GetClass() == "ent_cleaver" || inflictor:GetClass() == "mm_cleaver" then
            ent:SetBodygroup(1, 1)
        elseif inflictor:GetClass() == "mm_stake" then
            ent:SetBodygroup(4, 1)
        end
        
        local plyvel = victim:GetVelocity()
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
                bone:AddVelocity(plyvel)
            end
        end
        ent:SetNWFloat("Time", 0)
    end
end

function PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    if inflictor:GetClass() == "mm_deanimator" then
        victim:SetMaterial("Models/player/monstermash/gibs/burn")
    end
    
    if ply_mdl != "models/monstermash/skeleton_final.mdl" && ply_mdl != "models/monstermash/guest_final.mdl" && ply_mdl != "models/monstermash/scarecrow_final.mdl" then
        local effectdata4 = EffectData()
        effectdata4:SetStart( ply_pos+Vector(0,0,50) ) 
        effectdata4:SetOrigin( ply_pos+Vector(0,0,50) )
        util.Effect( "gibs", effectdata4 )
    elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
        local effectdata4 = EffectData()
        effectdata4:SetStart( ply_pos+Vector(0,0,50) ) 
        effectdata4:SetOrigin( ply_pos+Vector(0,0,50) )
        util.Effect( "gibs_scarecrow", effectdata4 )
    end
    
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/head_deerhaunter.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
   
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/head_skull.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_10.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_11.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_12.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)      
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)		
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_10.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)	
   
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/head_vampire.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
   
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/head_stein.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/head_witch.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
   
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/head_pumpkin.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/head_mummy.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
   
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/head_scarecrow.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
   
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/head_nosferatu.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
   
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/head_mary.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    
    if ply_mdl != "models/monstermash/skeleton_final.mdl" && ply_mdl != "models/monstermash/guest_final.mdl" && ply_mdl != "models/monstermash/scarecrow_final.mdl" then
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
        for i=0,10 do
            local vPoint = ply_pos+Vector(0,0,60)
            local effectdata = EffectData()
            effectdata:SetOrigin( vPoint )
            util.Effect("bloodstream",effectdata)
        end
    elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    end
    
end

function PlayerCorpse_Normal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    local ent = ents.Create("prop_ragdoll")
    ent:SetPos(ply_pos)
    ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
    ent:SetModel(ply_mdl)
    ent:SetSkin(ply_skn)
    ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
    ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
    if inflictor:GetClass() == "ent_cleaver" || inflictor:GetClass() == "mm_cleaver" then
        ent:SetBodygroup(1, 1)
    elseif inflictor:GetClass() == "mm_stake" then
        ent:SetBodygroup(4, 1)
    end
    if IsValid(inflictor) && inflictor:GetClass() != nil && (inflictor:GetClass() == "mm_flamethrower") then
        ent:SetMaterial("Models/player/monstermash/gibs/burn")
    else
        ent:SetMaterial(ply_mat)
    end
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent) then return end ent:Remove() end)
    if not ent:IsValid() then return end
    local plyvel = victim:GetVelocity()
   
    for i = 1, ent:GetPhysicsObjectCount() do
        local bone = ent:GetPhysicsObjectNum(i)
        if bone and bone.IsValid and bone:IsValid() then
            local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
            bone:SetPos(bonepos)
            bone:SetAngles(boneang)
            bone:AddVelocity(plyvel)
        end
    end
       
    if victim:IsOnFire() then ent:Ignite(math.Rand(6, 8), 0) end
    victim:SpectateEntity(ent)
    victim:Spectate(OBS_MODE_CHASE)
end
 
function PlayerCorpse_DecapNormal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    local ent
    if victim:GetNWInt("LegMissing") != 3 then
        ent = ents.Create("sent_mm_body")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:SetModel(ply_mdl)
        ent:SetSkin(ply_skn)
        ent:SetMaterial(ply_mat)
        ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
        ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
        if (attacker:GetActiveWeapon():GetClass() == "mm_stake") then
            ent:SetBodygroup(4 ,1)
        elseif attacker:GetActiveWeapon():GetClass() != "mm_knife" then
            ent:SetBodygroup(1 ,2)
        end
        if victim:GetNWInt("LegMissing") != 3 then
            ent:SetSequence( ent:LookupSequence( "death_04" ) )
            ent:SetNWFloat("Time", CurTime() + 2)
        end
    else
        ent = ents.Create("prop_ragdoll")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:SetModel(ply_mdl)
        ent:SetSkin(ply_skn)
        ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
        ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
        ent:SetBodygroup(1 ,2)
        if inflictor:GetClass() == "mm_stake" then
            ent:SetBodygroup(4, 1)
        end
        if IsValid(inflictor) && inflictor:GetClass() != nil && ((inflictor:GetClass() == "mm_flamethrower") || (IsValid(attacker) && attacker:IsPlayer() && IsValid(attacker:GetActiveWeapon()) && attacker:GetActiveWeapon():GetClass() != nil && attacker:GetActiveWeapon():GetClass() == "mm_flamethrower")) then
            ent:SetMaterial("Models/player/monstermash/gibs/burn")
        else
            ent:SetMaterial(ply_mat)
        end
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
        timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent) then return end ent:Remove() end)
        if not ent:IsValid() then return end
        local plyvel = victim:GetVelocity()
       
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
                bone:AddVelocity(plyvel)
            end
        end
    end
    ent:EmitSound("physics/flesh/flesh_bloody_break.wav")
    if not ent:IsValid() then return end

    if attacker:GetActiveWeapon():GetClass() != "mm_knife" && attacker:GetActiveWeapon():GetClass() != "mm_stake" && (ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl") then
        ent.DoBlood = true
    end
    if victim:IsOnFire() then 
        ent:Ignite(math.Rand(6, 8), 0) 
    end
    
    if ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        local RandomBlood = table.Random(RedBloodEffect)
        local BloodTrail = ents.Create( "info_particle_system" )
        BloodTrail:SetKeyValue( "effect_name", RandomBlood )
        BloodTrail:SetKeyValue( "start_active", tostring( 1 ) )
        BloodTrail:SetPos( ply_pos+Vector(0,0,20) )
        BloodTrail:SetAngles( ply_ang )
        BloodTrail:SetParent(ent)
        BloodTrail:Spawn()
        BloodTrail:Activate()
        BloodTrail:Fire( "Kill", nil, 0.4 )
    end
           
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/head_deerhaunter.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/head_skull.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/head_skull.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/head_vampire.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/head_stein.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/head_witch.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/head_pumpkin.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/head_mummy.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/head_scarecrow.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,false)
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/head_nosferatu.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/head_mary.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,true)
end
 
function PlayerCorpse_DecapExplode(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
    local ent = ents.Create("sent_mm_body")
    ent:SetPos(ply_pos)
    ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
    ent:SetModel(ply_mdl)
    ent:SetSkin(ply_skn)
    ent:SetMaterial(ply_mat)
    ent:SetBodygroup(2, victim:GetNWInt("ArmMissing"))
    ent:SetBodygroup(3, victim:GetNWInt("LegMissing"))
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    if (attacker:GetActiveWeapon():GetClass() == "mm_stake") then
        ent:SetBodygroup(4 ,1)
    elseif attacker:GetActiveWeapon():GetClass() != "mm_knife" then
        ent:SetBodygroup(1 ,2)
    end
    if victim:GetNWInt("LegMissing") != 3 then
        ent:SetSequence( ent:LookupSequence( "death_04" ) )
        ent:SetNWFloat("Time", CurTime() + 2)
    end
    ent:EmitSound("physics/flesh/flesh_bloody_break.wav")
    if not ent:IsValid() then return end
    local plyvel = victim:GetVelocity()
   
    for i = 1, ent:GetPhysicsObjectCount() do
        local bone = ent:GetPhysicsObjectNum(i)
        if bone and bone.IsValid and bone:IsValid() then
            local bonepos, boneang = victim:GetBonePosition(ent:TranslatePhysBoneToBone(i))
            bone:SetPos(bonepos)
            bone:SetAngles(boneang)
            bone:AddVelocity(plyvel)
        end
    end
    if attacker:GetActiveWeapon():GetClass() != "mm_knife" && attacker:GetActiveWeapon():GetClass() != "mm_stake" && (ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl") then
    ent.DoBlood = true
    end
    if victim:IsOnFire() then ent:Ignite(math.Rand(6, 8), 0) end
    //if !(attacker:GetActiveWeapon():GetClass() == "mm_huntingrifle" || attacker:GetActiveWeapon():GetClass() == "mm_knife" || attacker:GetActiveWeapon():GetClass() == "mm_stake"  ||  attacker:GetActiveWeapon():GetClass() == "mm_musketpistol" || attacker:GetActiveWeapon():GetClass() == "mm_repeater" || attacker:GetActiveWeapon():GetClass() == "mm_pumpshotgun" || attacker:GetActiveWeapon():GetClass() == "mm_sawedoff") then
       
        if ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
            local RandomBlood = table.Random(RedBloodEffect)
            local BloodTrail = ents.Create( "info_particle_system" )
            BloodTrail:SetKeyValue( "effect_name", RandomBlood )
            BloodTrail:SetKeyValue( "start_active", tostring( 1 ) )
            BloodTrail:SetPos( ply_pos+Vector(0,0,20) )
            BloodTrail:SetAngles( ply_ang )
            BloodTrail:SetParent(ent)
            BloodTrail:Spawn()
            BloodTrail:Activate()
            BloodTrail:Fire( "Kill", nil, 0.4 )
        end

    //end
    if victim:IsOnFire() then if IsValid(ent2) then ent2:Ignite(math.Rand(6, 8), 0) end end
    victim:SpectateEntity(ent)
    victim:Spectate(OBS_MODE_CHASE)
end
 
function CreateGib(check,path,vector,angle,victim,dobleed)
	if victim:GetModel() == check then
		local ent2 = ents.Create("prop_physics")
		ent2:SetPos(vector)
		ent2:SetModel(path)
		ent2:SetAngles(angle)
		ent2:SetSkin(victim:GetSkin())
		ent2:SetMaterial(victim:GetMaterial())
		ent2:Spawn()
		
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

function stuff2( ply, hitgroup, dmginfo )
    if dmginfo:IsBulletDamage() then
        ply:SetNWInt("LastHitgroupMelee", -1)
        ply:SetNWInt("LastHitgroupBullet", hitgroup)
    else
        ply:SetNWInt("LastHitgroupBullet", 0)
    end
end
hook.Add("ScalePlayerDamage", "stuff2", stuff2)


function stuff3(ply)
    ply:RemoveAllDecals()
end
hook.Add("PlayerSpawn", "stuff3", stuff3)

 
function stuff4(victim,attacker,hpremain,dmgtaken)
	
	victim:SetNWFloat("RecentlyTookDamage",CurTime()+1)
    
	if IsValid(attacker) && attacker:IsPlayer() then
		if victim:GetNWString("Buff") == "armor" then
			if GetConVar("mm_tasermanmode"):GetInt() == 1 then
				attacker:SendLua("surface.PlaySound('weapons/sword/clang2.wav')")
			else
				attacker:SendLua("surface.PlaySound('physics/metal/metal_solid_impact_bullet'..math.random(1,4)..'.wav')")
			end
		else
			attacker:SendLua("surface.PlaySound('gameplay/hit_sound.wav')")
		end
	end
    
	
	if IsValid(victim) && victim:IsPlayer() then
		if victim:GetNWFloat("MM_FireDuration") > CurTime() then
			if victim:GetNWBool("FireSoundOn") == false then
				victim:SetNWBool("FireSoundOn", true)
				local filter = RecipientFilter()
				filter:AddPlayer( victim )
				victim.sound = CreateSound( game.GetWorld(), "player/general/flesh_burn.wav", filter ) 
				if victim.sound then
					victim.sound:SetSoundLevel( 0 )
					victim.sound:Play()
				end
			end
		else
			victim:SendLua("surface.PlaySound('gameplay/flesh_arm-0'..math.random(1,4)..'.wav')")
		end
	end
    
    if victim == attacker then
        attacker:SetNWBool("DamagedSelf", true)
        attacker:SetNWFloat("DamagedFrame", CurTime()+0.1)
    else
        attacker:SetNWBool("DamagedOther", true)
        attacker:SetNWFloat("DamagedFrame", CurTime()+0.1)
        attacker:SetNWEntity("DamagedPlayer", victim)
    end
    
    if (victim == attacker) then
        victim:SetNWFloat("DamageTaken", 0)
        victim:SetNWFloat("SuicideDamageTaken", dmgtaken)
    elseif victim:GetNWFloat("HealthRegen") >= CurTime()+1.9 then
        victim:SetNWFloat("DamageTaken", victim:GetNWFloat("DamageTaken") + dmgtaken)
    else
        victim:SetNWFloat("DamageTaken", dmgtaken)
    end
    victim:SetNWFloat("HealthRegen", CurTime()+GetConVar("mm_healthregentime"):GetInt())
end
hook.Add("PlayerHurt","stuff4",stuff4)

CreateConVar("sv_OrgasmicDeathSounds",0,FCVAR_ARCHIVE,"( ͡° ͜ʖ ͡°)")
util.PrecacheSound( "misc/freeze_cam.wav" )
 
function playerDies( victim, weapon, killer )

	if killer:GetClass() == "trigger_hurt" then return end
	if killer:GetClass() == "env_fire" then return end

	timer.Create( "Freeze", 1.5, 1, function()
	if !IsValid(killer) then return end
		if IsValid(victim) && victim == killer then
			victim:ConCommand("play misc/freeze_cam2.wav") 
		else
			victim:ConCommand("play misc/freeze_cam1.wav") 
		end
		victim:Spectate(OBS_MODE_FREEZECAM)
		victim:SpectateEntity( killer )
		if killer:GetName() == nil then return end --If the Name is nil, end
		victim:SetNWEntity("killa",killer)
		victim:SetNWBool("DisplayKilla",true)
	end )

end 
hook.Add( "PlayerDeath", "playerDeathTest", playerDies )