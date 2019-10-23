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
	"models/monstermash/bloody_mary_final.mdl",
    "models/monstermash/invisible_man_final.mdl",
    "models/monstermash/mad_scientist_final.mdl",
    "models/monstermash/banshee_final.mdl",
    "models/monstermash/bride_final.mdl",
    "models/monstermash/zombie_final.mdl",
    "models/monstermash/rex_final.mdl",
}

/*---------------------------------------------------*/
 
local Weps_CanBifurcate = {
	"mm_battleaxe",
	"mm_chainsaw",
	"mm_sawblade",
	"mm_scythe"
}

local Weps_CanHeadOff = {
	"mm_axe",
	"mm_battleaxe",
	"mm_scythe",
	"mm_sword",
	"mm_hacksaw",
	"mm_chainsaw"
}

local Weps_CanGib = {
    "mm_pumpkinnade",
    "mm_cannon",
    "mm_flaregun",
    "ent_flare"
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
	"mm_electricrifle",
    "mm_acidflask",
    "mm_cleaver",
    "ent_cleaver"
}

local Weps_CanGiblets = {
	"mm_sawedoff",
    "mm_musketpistol",
    "mm_pumpshotgun", 
    "mm_repeater",
    "mm_coachgun"
}

local Weps_Cannot1Hit = {
	"mm_minigun",
}


/*---------------------------------------------------*/

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

    
    if victim != attacker && attacker:GetNWEntity("LastKiller") == victim then
        AddMedal(attacker, "revenge")
        attacker:SetNWEntity("LastKiller", NULL)
    end
    if victim != attacker then
        victim:SetNWEntity("LastKiller", attacker)
    end
    
    if victim == attacker && attacker:GetNWBool("DamagedSelf") == true && attacker:GetNWBool("DamagedOther") == true && attacker:GetNWFloat("DamagedFrame") >= CurTime() && attacker:GetNWEntity("DamagedPlayer") != NULL then
        AddMedal(attacker, "youtried")
    end
    
    if victim != attacker && victim:IsPlayer() && attacker:IsPlayer() && attacker:GetNWFloat("MM_Charge")+0.5 > CurTime() then
        AddMedal(attacker, "dash")
    end    
    
    if victim != attacker && victim:IsPlayer() && attacker:IsPlayer() && attacker:GetNWFloat("MM_Hallucinate") > CurTime() then
        AddMedal(attacker, "while_tripping")
    end    
    
    if victim != attacker && victim:IsPlayer() && attacker:IsPlayer() && victim:GetNWFloat("MM_Charge") > CurTime() then
        AddMedal(attacker, "dash_kill")
    end    
    
    if victim != attacker && victim:IsPlayer() && attacker:IsPlayer() && attacker:GetNWFloat("Bloodied") > CurTime() then
        AddMedal(attacker, "killwhilegorejar")
    end
    
    if victim != attacker && attacker:IsPlayer() && attacker:Alive() then
        attacker:SetNWInt("MM_KillsInLife", attacker:GetNWInt("MM_KillsInLife") + 1)
        if attacker:GetNWInt("MM_KillsInLife") == 3 then
            AddMedal(attacker, "killstreak")
        end
    end

    if (victim == attacker || attacker:IsWorld()) && victim:GetNWEntity("MM_Assister") != NULL then
        attacker = victim:GetNWEntity("MM_Assister")
        inflictor = victim:GetNWEntity("MM_AssisterInflictor")
        AddMedal(attacker, "assisted_suicide")
    end
    
    local oldkillc = attacker:GetNWInt("killcounter")
    if !(victim == attacker) && inflictor:IsValid() && attacker:IsPlayer() then
    
        if table.HasValue( Weps_CanGiblets, inflictor:GetClass() ) then
            if victim:GetNWFloat("DamageTaken") >= 30 && !victim:GetNWBool("DiedFromBleed") && victim:GetNWInt("LastHitgroupBullet") != HITGROUP_HEAD && inflictor.Base != "mm_melee_base" then
                if (victim:GetModel() == "models/monstermash/skeleton_final.mdl" || victim:GetModel() == "models/monstermash/guest_final.mdl") then
                    local choice = {4, 6, 8, 9, 10}
                    victim:EmitSound("death/damage_bones.wav")
                    CreateGib(victim:GetModel(),"models/monstermash/gibs/sk_gib_"..table.Random(choice)..".mdl",victim:GetPos()+Vector(0,0,72),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"None")
                    CreateGib(victim:GetModel(),"models/monstermash/gibs/sk_gib_"..table.Random(choice)..".mdl",victim:GetPos()+Vector(0,0,72),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"None")
                elseif victim:GetModel() == "models/monstermash/scarecrow_final.mdl" then
                    victim:EmitSound("death/damage_bones.wav")
                    CreateGib(victim:GetModel(),"models/monstermash/gibs/scarecrow_gib_"..math.random(6,9)..".mdl",victim:GetPos()+Vector(0,0,72),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"Hay")
                    CreateGib(victim:GetModel(),"models/monstermash/gibs/scarecrow_gib_"..math.random(6,9)..".mdl",victim:GetPos()+Vector(0,0,72),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"Hay")
                else
                    victim:EmitSound("death/damage_flesh.wav")
                    
                    for i=1, 10 do
                        CreateGib(victim:GetModel(),"models/monstermash/gibs/gib_large.mdl",victim:GetPos()+Vector(0,0,72),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"Blood")
                    end
                end
            end
        end
        
        if inflictor:GetClass() == "mm_urn" then
            attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 10)
        elseif inflictor:GetClass() == "mm_headbutt" then
            attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + 150)
		elseif inflictor != nil && inflictor.Points != nil then
            attacker:SetNWInt("killcounter", attacker:GetNWInt("killcounter") + inflictor.Points)
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
        if math.ceil(victim:Health()+victim:GetNWFloat("DamageTaken")) >= victim:GetMaxHealth() && victim:Health() <= 0 && !table.HasValue(Weps_Cannot1Hit, inflictor:GetClass()) then
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
        if victim:GetNWFloat("MM_Deanimatorstun") > CurTime() && victim != attacker then
            AddMedal(attacker, "immobilized")
        end
        if victim:GetNWBool("DiedFromBleed") then
            AddMedal(attacker, "bleed")
        end
        if victim:GetNWBool("DiedFromFire") && inflictor:GetClass() != "mm_battlerifle" then
            AddMedal(attacker, "fire")
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
    local gibbed = false
    if (GetConVarNumber("mm_ludicrousgibs") != 1 && IsValid(attacker) && attacker:IsPlayer()) then
        if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_COOPOther") == victim then
            PlayerCorpse_Normal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif victim == attacker && victim:GetNWFloat("SuicideDamageTaken") > 119 then
            PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
            gibbed = true
        elseif victim == attacker && victim:GetNWFloat("SuicideDamageTaken") <= 119 then
            PlayerCorpse_Normal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif (GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 3) || (table.HasValue( Weps_CanGib, inflictor:GetClass() ) || (victim:GetNWFloat("DamageTaken") >= 119 && inflictor:GetClass() != "mm_stake" && inflictor:GetClass() != "mm_chainsaw") || (victim:GetPos():Distance(attacker:GetPos()) <= 96 && inflictor:GetClass() == "mm_coachgun")) && !victim:GetNWBool("DiedFromFire") && !victim:GetNWBool("DiedFromBleed") then
            PlayerCorpse_Gib(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
            AddMedal(attacker, "gib")
            gibbed = true
        elseif IsValid(attacker:GetActiveWeapon()) && inflictor:GetClass() == "mm_acidflask" then
            PlayerCorpse_ScriptedAcid(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif victim != attacker && IsValid(attacker:GetActiveWeapon()) && attacker:GetActiveWeapon():GetClass() == "mm_shovel" then
            PlayerCorpse_Grave(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif victim:GetNWInt("LegMissing") != 3 && (table.HasValue( Weps_CanBifurcate, inflictor:GetClass() ) && !victim:GetNWBool("DiedFromBleed") || (inflictor:GetClass() == "mm_sword" && victim:GetNWFloat("DamageTaken") == 100)) then
            PlayerCorpse_Bifurcate(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif (!victim:GetNWBool("DiedFromBleed") && table.HasValue( Weps_CanHeadOff, inflictor:GetClass() ) && victim:GetNWInt("LastHitgroupMelee") == HITGROUP_HEAD) || inflictor:GetClass() == "mm_sawblade" || inflictor:GetClass() == "mm_decapattack" then
            PlayerCorpse_DecapNormal(ply_pos, ply_ang, ply_mdl, ply_skn, ply_col, ply_mat, attacker, victim, inflictor)
        elseif !victim:GetNWBool("DiedFromBleed") && table.HasValue( Weps_CanHeadExplode, inflictor:GetClass() ) && !victim:GetNWBool("DiedFromFire") && !victim:GetNWBool("DiedFromBleed") && victim:GetNWInt("LastHitgroupBullet") == HITGROUP_HEAD then
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
        gibbed = true
    end
	
    if (IsValid(attacker) && !(victim == attacker) && attacker:IsPlayer() && (inflictor:GetClass() == "mm_boner")) then
        local ent = ents.Create("item_healthkit")
        ent:SetPos(ply_pos)
        ent:SetAngles(ply_ang - Angle(ply_ang.p,0,0))
        ent:Spawn()
    end
    
    attacker:SetNWInt("LastScore", attacker:GetNWInt("killcounter")-oldkillc)
    attacker:SetNWFloat("LastScoreTime", CurTime()+1)
    
    if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("Game_Over") == false && GetGlobalVariable("WackyRound_COOP") then
        victim:SetTeam(5)
    end
    
    victim:SetNWInt("LegMissing", 0)
	victim:SetNWInt("ArmMissing", 0)
    net.Start("ResetLimbs")
    net.Send(victim)
    
    // Skeleton popped out
    if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 4 then
        local skull = NULL
        if gibbed && attacker:IsPlayer() then
            skull = ents.Create("sent_jitterskull")
        else
            skull = ents.Create("sent_skellington")
        end
        skull:SetPos(victim:GetPos()+Vector(0,0,60))
        skull:Spawn()
        skull:Activate()
    end
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
        ent:SetModel("models/monstermash/gibs/nos_test.mdl")
    elseif ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        ent:SetModel("models/monstermash/gibs/bm_top.mdl")
    elseif ply_mdl == "models/monstermash/invisible_man_final.mdl" then
        ent:SetModel("models/monstermash/gibs/invisible_man_top.mdl")
    elseif ply_mdl == "models/monstermash/mad_scientist_final.mdl" then
        ent:SetModel("models/monstermash/gibs/scientist_top.mdl")
    elseif ply_mdl == "models/monstermash/banshee_final.mdl" then
        ent:SetModel("models/monstermash/gibs/banshee_top.mdl")
    elseif ply_mdl == "models/monstermash/bride_final.mdl" then
        ent:SetModel("models/monstermash/gibs/bride_top.mdl")    
    elseif ply_mdl == "models/monstermash/zombie_final.mdl" then
        ent:SetModel("models/monstermash/gibs/zombie_top.mdl")    
    elseif ply_mdl == "models/monstermash/rex_final.mdl" then
        ent:SetModel("models/monstermash/gibs/rex_top.mdl")
    end
    ent:SetSkin(ply_skn)
    ent:SetMaterial(ply_mat)
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    ent:SetBodygroup(0, victim:GetNWInt("ArmMissing"))
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
        ent2:SetModel("models/monstermash/gibs/nos_leg_test.mdl")
    elseif ply_mdl == "models/monstermash/bloody_mary_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/bm_lower.mdl")
    elseif ply_mdl == "models/monstermash/invisible_man_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/invisible_man_lower.mdl")
    elseif ply_mdl == "models/monstermash/mad_scientist_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/scientist_lower.mdl")
    elseif ply_mdl == "models/monstermash/banshee_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/banshee_lower.mdl")    
    elseif ply_mdl == "models/monstermash/bride_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/bride_lower.mdl")    
    elseif ply_mdl == "models/monstermash/zombie_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/zombie_lower.mdl")    
    elseif ply_mdl == "models/monstermash/rex_final.mdl" then
        ent2:SetModel("models/monstermash/gibs/rex_lower.mdl")
    end
    ent2:SetSkin(ply_skn)
    ent2:SetMaterial(ply_mat)
    ent2:Spawn()
    ent2:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    ent2:SetBodygroup(0 ,victim:GetNWInt("LegMissing"))
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(), function() if !IsValid(ent2) then return end ent2:Remove() end)
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
        if IsValid(inflictor) && (inflictor:GetClass() == "mm_flamethrower" || inflictor:GetClass() == "mm_flaregun" || inflictor:GetClass() == "ent_flare") then
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
        elseif inflictor:GetClass() == "mm_electricrifle" then
            ent:SetSequence( ent:LookupSequence( "death_04" ) )
            ent:SetNWFloat("Time", CurTime() + 2)
            ent:SetNWBool("Zappy", true)
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
        if IsValid(inflictor) && inflictor:GetClass() != nil && (inflictor:GetClass() == "mm_flamethrower" || inflictor:GetClass() == "mm_flaregun" || inflictor:GetClass() == "ent_flare") then
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
    
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/head_deerhaunter.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/dh_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
   
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/head_skull.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_10.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_11.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/sk_gib_12.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")      
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/guest_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")		
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/sk_gib_10.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")	
   
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/head_vampire.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/vampire_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
   
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/head_stein.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/stein_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/head_witch.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/witch_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
   
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/head_pumpkin.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/hhm_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/head_mummy.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/mummy_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
   
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/head_scarecrow.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
   
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/head_nosferatu.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/nosferatu_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
   
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/head_mary.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/bm_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/head_invisible_man.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/invisible_man_gib8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/head_mad_scientist.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/scientist_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/head_banshee.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/banshee_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/banshee_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/banshee_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/banshee_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/banshee_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")    
    
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/head_bride.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl", "models/monstermash/gibs/bride_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/head_zombie.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/zombie_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")    
    
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/head_rex.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/rex_gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/rex_gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/rex_gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/rex_gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/rex_leg_left.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    
    if ply_mdl != "models/monstermash/skeleton_final.mdl" && ply_mdl != "models/monstermash/guest_final.mdl" && ply_mdl != "models/monstermash/scarecrow_final.mdl" then
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_10.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_11.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_12.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        for i=0,10 do
            local vPoint = ply_pos+Vector(0,0,60)
            local effectdata = EffectData()
            effectdata:SetOrigin( vPoint )
            util.Effect("bloodstream",effectdata)
        end
    elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib(ply_mdl,"models/monstermash/gibs/scarecrow_gib_9.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
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
    if IsValid(inflictor) && inflictor:GetClass() != nil && (inflictor:GetClass() == "mm_flamethrower" || inflictor:GetClass() == "mm_flaregun" || inflictor:GetClass() == "ent_flare") then
        ent:SetMaterial("Models/player/monstermash/gibs/burn")
    else
        ent:SetMaterial(ply_mat)
    end
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
    timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(), function() if !IsValid(ent) then return end ent:Remove() end)
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
        if IsValid(inflictor) && inflictor:GetClass() != nil && ((inflictor:GetClass() == "mm_flamethrower" || inflictor:GetClass() == "mm_flaregun" || inflictor:GetClass() == "ent_flare") || (IsValid(attacker) && attacker:IsPlayer() && IsValid(attacker:GetActiveWeapon()) && attacker:GetActiveWeapon():GetClass() != nil && (attacker:GetActiveWeapon():GetClass() == "mm_flamethrower" || attacker:GetActiveWeapon():GetClass() == "mm_flaregun"))) then
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
           
    CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/head_deerhaunter.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/head_skull.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/head_guest.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    CreateGib("models/monstermash/vampire_final.mdl","models/monstermash/gibs/head_vampire.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/stein_final.mdl","models/monstermash/gibs/head_stein.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/head_witch.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/head_pumpkin.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mummy_final.mdl","models/monstermash/gibs/head_mummy.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/head_scarecrow.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
    CreateGib("models/monstermash/nosferatu_final.mdl","models/monstermash/gibs/head_nosferatu.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bloody_mary_final.mdl","models/monstermash/gibs/head_mary.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/head_invisible_man.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/head_mad_scientist.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/banshee_final.mdl","models/monstermash/gibs/head_banshee.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/bride_final.mdl","models/monstermash/gibs/head_bride.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/zombie_final.mdl","models/monstermash/gibs/head_zombie.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
    CreateGib("models/monstermash/rex_final.mdl","models/monstermash/gibs/head_rex.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
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

    if attacker:GetActiveWeapon() != nil then
        if (attacker:GetActiveWeapon():GetClass() == "mm_stake") then
            ent:SetBodygroup(4 ,1)
        elseif attacker:GetActiveWeapon():GetClass() != "mm_knife" then
            ent:SetBodygroup(1 ,2)
        end
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
    if attacker:GetActiveWeapon():GetClass() != "mm_knife" && attacker:GetActiveWeapon():GetClass() != "mm_stake" && (ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl" || ply_mdl == "models/monstermash/invisible_man_final.mdl" || ply_mdl == "models/monstermash/banshee_final.mdl" || ply_mdl == "models/monstermash/bride_final.mdl" || ply_mdl == "models/monstermash/zombie_final.mdl") then
        ent.DoBlood = true
    end
    if victim:IsOnFire() then ent:Ignite(math.Rand(6, 8), 0) end
    //if !(attacker:GetActiveWeapon():GetClass() == "mm_huntingrifle" || attacker:GetActiveWeapon():GetClass() == "mm_knife" || attacker:GetActiveWeapon():GetClass() == "mm_stake"  ||  attacker:GetActiveWeapon():GetClass() == "mm_musketpistol" || attacker:GetActiveWeapon():GetClass() == "mm_repeater" || attacker:GetActiveWeapon():GetClass() == "mm_pumpshotgun" || attacker:GetActiveWeapon():GetClass() == "mm_sawedoff") then
       
        if ply_mdl == "models/monstermash/mummy_final.mdl" || ply_mdl == "models/monstermash/deer_haunter_final.mdl" || ply_mdl == "models/monstermash/vampire_final.mdl" || ply_mdl == "models/monstermash/stein_final.mdl" || ply_mdl == "models/monstermash/witch_final.mdl" || ply_mdl == "models/monstermash/nosferatu_final.mdl" || ply_mdl == "models/monstermash/bloody_mary_final.mdl" || ply_mdl == "models/monstermash/invisible_man_final.mdl" || ply_mdl == "models/monstermash/banshee_final.mdl" || ply_mdl == "models/monstermash/bride_final.mdl" || ply_mdl == "models/monstermash/zombie_final.mdl" then
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
        elseif ply_mdl == "models/monstermash/mad_scientist_final.mdl" then
            local effectdata = EffectData()
            effectdata:SetOrigin( ply_pos+Vector(0,0,60) )
            util.Effect( "watersplash", effectdata )  
            local effectdata = EffectData()
            effectdata:SetOrigin( ply_pos+Vector(0,0,60) )
            util.Effect( "GlassImpact", effectdata )  
        elseif ply_mdl == "models/monstermash/headless_horseman_final.mdl" then
            local effectdata = EffectData()
            effectdata:SetOrigin( ply_pos+Vector(0,0,60) )
            util.Effect( "pumpkin_explosion", effectdata )          
        elseif ply_mdl == "models/monstermash/scarecrow_final.mdl" then
            local effectdata = EffectData()
            effectdata:SetOrigin( ply_pos+Vector(0,0,60) )
            util.Effect( "gibs_scarecrow", effectdata )  
        end

    //end
    if victim:IsOnFire() then if IsValid(ent2) then ent2:Ignite(math.Rand(6, 8), 0) end end
    victim:SpectateEntity(ent)
    victim:Spectate(OBS_MODE_CHASE)
    
    local nogenericheadgib = {
        "models/monstermash/skeleton_final.mdl",
        "models/monstermash/guest_final.mdl",
        "models/monstermash/scarecrow_final.mdl",
        "models/monstermash/headless_horseman_final.mdl",
        "models/monstermash/invisible_man_final.mdl",
        "models/monstermash/mad_scientist_final.mdl",
        "models/monstermash/deer_haunter_final.mdl"
    }
    
    if !table.HasValue(nogenericheadgib, ply_mdl) then
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_1.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_2.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_3.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib(ply_mdl,"models/monstermash/gibs/gib_headshot_5.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        
        for i=1, 4 do
            CreateGib(ply_mdl,"models/monstermash/gibs/gib_medium.mdl",victim:GetPos()+Vector(0,0,0),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"Blood")
        end
        
        CreateGib("models/monstermash/witch_final.mdl","models/monstermash/gibs/gib_headshot_witch_hat.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
    else
        CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/gib_headshot_guest_1.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/gib_headshot_guest_2.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/gib_headshot_guest_3.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/guest_final.mdl","models/monstermash/gibs/gib_headshot_guest_4.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")

        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_2.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_5.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_dh_antler1.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_headshot_dh_antler2.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        for i=1, 4 do
            CreateGib("models/monstermash/deer_haunter_final.mdl","models/monstermash/gibs/gib_medium.mdl",victim:GetPos()+Vector(0,0,0),victim:GetAngles() - Angle(victim:GetAngles().p,0,0),victim,"Blood")
        end

        CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/gib_headshot_skeleton_1.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/gib_headshot_skeleton_2.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/gib_headshot_skeleton_3.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/skeleton_final.mdl","models/monstermash/gibs/gib_headshot_skeleton_4.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        
        CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/gib_headshot_im_goggles.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/invisible_man_final.mdl","models/monstermash/gibs/gib_headshot_im_hat.mdl",ply_pos+Vector(0,0,6),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_headshot_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_headshot_scientist_1.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_large.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_large.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        CreateGib("models/monstermash/mad_scientist_final.mdl","models/monstermash/gibs/gib_large.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Blood")
        
        CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/gib_headshot_scarecrow_hat.mdl",ply_pos+Vector(0,0,0),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_"..math.random(6,9)..".mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")
        CreateGib("models/monstermash/scarecrow_final.mdl","models/monstermash/gibs/scarecrow_gib_"..math.random(6,9)..".mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"Hay")

        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_1.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_2.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_3.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_4.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_5.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")   
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_6.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")   
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_7.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")   
        CreateGib("models/monstermash/headless_horseman_final.mdl","models/monstermash/gibs/gib_headshot_hhm_8.mdl",ply_pos+Vector(0,0,60),ply_ang - Angle(ply_ang.p,0,0),victim,"None")   
    end
end

function GibModelCallback(ent, data)
    local startp = data.HitPos
    local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = ent, mask = MASK_SOLID_BRUSHONLY}
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    
    util.Decal("Blood", todecal1, todecal2)
    local effect = EffectData()  
    local origin = data.HitPos
    effect:SetOrigin( origin )
    util.Effect( "bloodimpact", effect ) 
end

if SERVER then
    util.AddNetworkString("DoHayDecal")
end

function GibModelCallbackHay(ent, data)
    if ent:GetVelocity():Length() >= 100 then
        net.Start("DoHayDecal")
            net.WriteTable({HitPos = data.HitPos, Ent = data.Entity, HitNormal = data.HitNormal})
        net.Broadcast()
    end
end
 
function CreateGib(check,path,vector,angle,victim,bleedtype)
	if victim:GetModel() == check then
		local ent2 = ents.Create("prop_physics")
		ent2:SetPos(vector)
		ent2:SetModel(path)
		ent2:SetAngles(angle)
		ent2:SetSkin(victim:GetSkin())
		ent2:SetMaterial(victim:GetMaterial())
		ent2:Spawn()
        if bleedtype == "Blood" then
            ent2:AddCallback("PhysicsCollide", GibModelCallback)
        elseif bleedtype == "Hay" then
            ent2:AddCallback("PhysicsCollide", GibModelCallbackHay)
		end
        if victim:IsOnFire() then 
            ent2:SetMaterial("Models/player/monstermash/gibs/burn")
        end
        
		local phys = ent2:GetPhysicsObject()
		if ( !IsValid( phys ) ) then ent2:Remove() return end
		phys:ApplyForceCenter( Vector( math.random(-200,200), math.random(-200,200), 100 ) )
		
        if victim:IsOnFire() then ent2:Ignite(math.Rand(6, 8), 0) end
        
		local num = math.Rand(1,3)
		if bleedtype == "Blood" then
			for i = 0.1, num, 0.1 do
				timer.Simple(i,function()
					if !IsValid(ent2) then return end
					local effectdata = EffectData()
					effectdata:SetOrigin( ent2:GetPos() )
					util.Effect( "BloodImpact", effectdata )  
				end)
			end
			
			local color = Color( 105, 0, 0, 255 )
			local trail = util.SpriteTrail(ent2, 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "effects/bloodstream.vmt")
		else
			for i = 0.1, num, 0.1 do
				timer.Simple(i,function()
					if !IsValid(ent2) then return end
					local effectdata = EffectData()
					effectdata:SetOrigin( ent2:GetPos() )
					util.Effect( "WheelDust", effectdata )  
				end)
			end        
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
        attacker:SetNWFloat("DamagedFrame", CurTime()+0.02)
    else
        attacker:SetNWBool("DamagedOther", true)
        attacker:SetNWFloat("DamagedFrame", CurTime()+0.02)
        attacker:SetNWEntity("DamagedPlayer", victim)
    end
    
    if (victim == attacker) then
        victim:SetNWFloat("DamageTaken", 0)
        victim:SetNWFloat("SuicideDamageTaken", dmgtaken)
    elseif victim:GetNWFloat("HealthRegen") >= CurTime()+(GetConVar("mm_healthregentime"):GetInt()-0.0001) then
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

local YellowBlood = {
"npc_headcrab",
"npc_headcrab_fast",
"npc_headcrab_black",
"npc_headcrab_poison",
"npc_antlion",
"npc_zombine",
"npc_antlion_worker",
"npc_zombie",
"npc_zombie_torso",
"npc_fastzombie",
"npc_poisonzombie"}

local RedBlood = {
"npc_citizen",
"npc_kliener",
"npc_magnason",
"npc_alyx",
"npc_barney",
"npc_mossman",
"npc_combine_s",
"ShotgunSoldier",
"npc_metropolice",
"npc_breen",
"npc_stalker",
"player"}

local WhiteBlood = {
"npc_hunter"}

local NoBlood = {
"npc_manhack",
"npc_clawscanner",
"npc_helicopter",
"npc_combinegunship",
"npc_combinedropship",
"npc_turret_ceiling",
"npc_turret_floor",
"npc_turret_ground"}

function ScreenBloodEffect( ent, dmginfo )
    if (ent:IsNPC() || ent:IsPlayer()) and dmginfo:GetAttacker():IsPlayer() && dmginfo:GetAttacker() != ent then
        if table.HasValue(RedBlood,ent:GetClass()) and ent:GetPos():Distance(dmginfo:GetAttacker():GetPos()) < 125 then
            net.Start("RedScreenBlood")
            net.Send(dmginfo:GetAttacker())
        end
        if table.HasValue(YellowBlood,ent:GetClass()) and ent:GetPos():Distance(dmginfo:GetAttacker():GetPos()) < 125 then
            net.Start("YellowScreenBlood")
            net.Send(dmginfo:GetAttacker())
        end
    end
end
hook.Add("EntityTakeDamage","ScreenBloodEffect",ScreenBloodEffect)