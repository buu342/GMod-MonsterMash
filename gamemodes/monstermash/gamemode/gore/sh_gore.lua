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

local haydecalmat = Material("models/player/monstermash/gibs/hay_splat")
function GibModelCallbackHay(ent, data)
    if SERVER then
        if ent:GetVelocity():Length() >= 100 then
            net.Start("DoHayDecal", true)
                net.WriteEntity(ent)
                net.WriteTable({HitPos = data.HitPos, Ent = data.Entity, HitNormal = data.HitNormal})
            net.Broadcast()
        end
    else
        util.DecalEx(haydecalmat, game.GetWorld(), data.HitPos, data.HitNormal, Color(255,255,255,255), 0.2, 0.2)
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
            print(pos)
        else
            ent = ents.CreateClientProp(model)
        end
    end
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetSkin(ply:GetSkin())
    ent:SetMaterial(ply:GetMaterial())
    if SERVER then
        ent:Spawn()
    end
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
                    if SERVER then
                        util.SpriteTrail(bone:GetEntity(), 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "particle/mm_bloodtrail1.vmt")
                    end
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
            if SERVER then
                util.SpriteTrail(ent, 0, color, false, 7, 1, 1, 1/(15+1)*0.5, "particle/mm_bloodtrail1.vmt")
            end
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

function GM:GoreCreateRagdoll(ply, model, pos, ang, matchbones, extra, remove, wep)
    if (ply == nil) then
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
        self:GoreEmitParticleClient(ent, "mm_corpse_smoke", "ValveBiped.Bip01_Spine2", nil, nil, t)
    end
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
    function GM:GoreEmitParticleClient(ent, effect, attachment, pos, angle, duration)
        timer.Simple(0.1, function() 
            net.Start("EmitGoreParticleClientside", true)
                net.WriteEntity(ent)
                net.WriteString(effect)
                if (isstring(attachment)) then
                    net.WriteInt(0, 32)
                    net.WriteString(attachment)
                else
                    net.WriteInt(attachment or 0, 32)
                    net.WriteString("")
                end
                net.WriteVector(pos or Vector(0, 0, 0))
                net.WriteAngle(angle or Angle(0, 0, 0))
                net.WriteInt(duration, 32)
            net.Broadcast()
        end)
    end

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