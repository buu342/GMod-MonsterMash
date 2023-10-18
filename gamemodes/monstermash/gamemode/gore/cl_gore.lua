net.Receive("DoHayDecal", function()
    local ent = net.ReadEntity()
    local data = net.ReadTable()
    GibModelCallbackHay(ent, data)
end)

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

function EmitEffect(effect, ent, attachment, pos, ang)
    local effectdata = EffectData()
    local attach = nil

    if (ent != nil && IsValid(ent) && attachment != nil) then
        if (isstring(attachment)) then
            bpos, bang = ent:GetBonePosition(ent:LookupBone(attachment))
            attach = {Pos = bpos, Ang = bang}
        else
            attach = ent:GetAttachment(attachment)
            attach = {Pos = attach.Pos, Ang = attach.Ang, Num = attachment}
        end
    end

    if (attach != nil) then
        effectdata:SetOrigin(attach.Pos+pos)
        effectdata:SetEntity(ent)
        effectdata:SetStart(attach.Pos+pos) 
        effectdata:SetNormal((attach.Ang+ang):Forward())
        effectdata:SetAngles(attach.Ang+ang)
        if (attach.Num != nil) then
            effectdata:SetAttachment(attach.Num)
        end
    else
        effectdata:SetStart(pos) 
        effectdata:SetOrigin(pos)
        effectdata:SetAngles(ang)
    end
    if (effect == "bloodspray") then
        effectdata:SetFlags(3)
        effectdata:SetScale(7)
    end
    util.Effect(effect, effectdata)
end

net.Receive("EmitGoreParticleClientside", function()
    local ent = net.ReadEntity()
    local effect = net.ReadString()
    local attachmentnum = net.ReadInt(32)
    local attachmentstr = net.ReadString()
    local pos = net.ReadVector()
    local ang = net.ReadAngle()
    local duration = net.ReadInt(32)
    local effectdata = EffectData()
    local posoffset = Vector(0,0,0)
    local angoffset = Angle(0,0,0)
    local attachment = nil

    // Get the attachment
    if (attachmentnum == 0 && attachmentstr != "") then
        attachment = attachmentstr
    elseif (attachmentnum != 0) then
        attachment = attachmentnum
    end

    // Set position/angle offsets relative to the entity
    if (ent != nil && IsValid(ent) && attachment == nil) then
        posoffset = ent:GetPos()
        angoffset = ent:GetAngles()
    end

    // Emit the effect
    EmitEffect(effect, ent, attachment, pos + posoffset, ang + angoffset)
    if (duration > 0) then
        timer.Create("EmitEffect"..tostring(CurTime()), 0.1, duration/0.1, function()
            if (ent != nil && IsValid(ent) && attachment == nil) then
                posoffset = ent:GetPos()
                angoffset = ent:GetAngles()
            end
            EmitEffect(effect, ent, attachment, pos + posoffset, ang + angoffset)
        end)
    end
end)