function GibModelCallbackBlood(ent, data)
    local character = GAMEMODE.Characters[ent:GetNWEntity("GibletPlayer"):GetNWString("MM_Character")] // For some reason, GetCharacter() isn't working, so this workaround is necessary
    if ent:GetVelocity():Length() >= 100 then
        GAMEMODE:EmitBlood(character, BLOODEFFECT_IMPACT, data.HitPos)
        GAMEMODE:EmitBlood(character, BLOODEFFECT_DECAL, data.HitPos, data.HitNormal)
    end
end

function GM:GoreCreateGib(ply, model, pos, ang, overrideforce, ragdoll, remove)
    // Create the gib model
    local ent
    if SERVER then
        if ragdoll then
            ent = ents.Create("prop_ragdoll")
        else
            ent = ents.Create("prop_physics")
        end
        ent:SetModel(model)
    else
        if ragdoll then
            ent = ClientsideRagdoll(model)
            ent:SetNoDraw(false)
            ent:DrawShadow(true)
        else
            ent = ents.CreateClientProp(model)
        end
    end
    ent:SetNWEntity("GibletPlayer", ply)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    if SERVER then
        ent:Spawn()
    end
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    
    // Add a collision callback depending on the bloodtype
    ent:AddCallback("PhysicsCollide", GibModelCallbackBlood)
    
    // If the player was on fire, set the gib on fire
    if ply:IsOnFire() then 
        ent:SetMaterial("Models/player/monstermash/gibs/burn")
        if SERVER then
            ent:Ignite(math.Rand(6, 8), 0)
        end
    end
    
    // Apply some physics to the gib
    if ragdoll then
        local force = overrideforce or 250
        for i=0, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                bone:AddVelocity(VectorRand()*force)
            end
        end
    else
        local phys = ent:GetPhysicsObject()
        local force = overrideforce or 375
        if (!IsValid(phys)) then 
            ent:Remove() return 
        end
        phys:AddVelocity(VectorRand()*force)
    end
    
    // Make the gib bleed a bunch
    if ragdoll then
        local num = math.Rand(1,3)
        for i=0, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                GAMEMODE:EmitBlood(ply:GetCharacter(), BLOODEFFECT_IMPACT, nil, nil, bone:GetEntity(), "ent", num)
            end
        end
    else
        local num = math.Rand(1,3)
        GAMEMODE:EmitBlood(ply:GetCharacter(), BLOODEFFECT_IMPACT, nil, nil, ent, "ent", num)
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

function GM:GoreCreateRagdoll(ply, model, pos, ang, matchbones, extra, remove, wep)
    if (ply == nil || !IsValid(ply)) then
        return nil
    end

    if (model == nil) then
        matchbones = true
    end
    model = model or ply:GetModel()
    pos = pos or ply:GetPos()
    ang = ang or ply:GetAngles()

    // Create the ragdoll
    local ent
    if (SERVER) then 
        ent = ents.Create("prop_ragdoll")
        ent:SetModel(model)
    else
        ent = ClientsideRagdoll(model)
    end
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    if (!ply:IsPlayer()) then
        constraint.NoCollide(ent, ply)
    end
    if (SERVER) then
        ent:Spawn()
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    end

    if (extra == "skeletize" || extra == "fire" || ply:IsOnFire() ) then
        local t = 4
        if (extra == "fire" || ply:IsOnFire() ) then
            t = 10
            ent:Ignite(math.Rand(6, 8), 0)
        end
        ent:SetMaterial("models/player/monstermash/gibs/burn")
        timer.Create("CorpseSmoke"..tostring(ent), 0.1, t/0.1, function()
            if (IsValid(ent)) then
                local effectdata = EffectData()
                local bonepos, boneang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Spine2"))
                effectdata:SetOrigin(bonepos)
                util.Effect("mm_corpse_smoke", effectdata)
            end
        end)
    end
    if wep != nil && IsValid(wep) && wep:IsWeapon() && wep:GetClass() == "weapon_mm_stake" then
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
    ent:SetBodygroup(GIBGROUP_HEAD, ply:GetBodygroup(GIBGROUP_HEAD))
    
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

if SERVER then
    util.AddNetworkString("CreateGorePropClientside")
    function GM:GoreCreateGibClient(ply, model, pos, ang, overrideforce, ragdoll, remove)
        net.Start("CreateGorePropClientside", true)
            net.WriteEntity(ply)
            net.WriteString(model)
            net.WriteVector(pos)
            net.WriteAngle(ang)
            net.WriteInt(overrideforce or 0, 32)
            net.WriteBool(ragdoll)
            net.WriteBool(remove)
        net.Broadcast()
    end
end

if CLIENT then
    net.Receive("CreateGorePropClientside", function()
        local ply = net.ReadEntity()
        local model = net.ReadString()
        local pos = net.ReadVector()
        local ang = net.ReadAngle()
        local overrideforce = net.ReadInt(32)
        local ragdoll = net.ReadBool()
        local remove = net.ReadBool()
        GAMEMODE:GoreCreateGib(ply, model, pos, ang, overrideforce, ragdoll, remove)
    end)
end