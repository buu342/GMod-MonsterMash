if GM.BloodEffects then return end

local redbloodmats = {}
local bloodmatcount = 42
for i=1, bloodmatcount do
    redbloodmats[i] = Material("particle/blood/red/"..tostring(i))
end
local blackbloodmats = {}
for i=1, bloodmatcount do
    blackbloodmats[i] = Material("particle/blood/black/"..tostring(i))
end
local haymats = {
    Material("models/player/monstermash/gibs/straw.png"),
    Material("models/player/monstermash/gibs/stick1.png"),
    Material("models/player/monstermash/gibs/stick2.png"),
    Material("models/player/monstermash/gibs/stick3.png"),
    Material("models/player/monstermash/gibs/stick4.png"),
    Material("models/player/monstermash/gibs/stick5.png")
}
local hamatscount = 6
local confettibloodmats = {}
local confettimatcount = 2
for i=1, confettimatcount do
    confettibloodmats[i] = Material("particle/confetti_splat"..tostring(i))
end
local bonechunks = {
    Material("particle/skeleton/gib6.png"),
    Material("particle/skeleton/gib7.png"),
    Material("particle/skeleton/gib2.png"),
    Material("particle/skeleton/gib3.png"),
    Material("particle/skeleton/gib5.png"),
    Material("particle/skeleton/gib8.png")
}
local bonechunkcount = 6

GM.BloodEffects = {
    [BLOODTYPE_NORMAL] = {
        impact = "mm_blood",
        spray = "mm_bloodspray",
        bloodlet = "mm_bloodletting",
        trail = {mat="particle/mm_bloodtrail1.vmt", col=Color(105, 0, 0, 255)},
        decal = {mat=redbloodmats, col=Color(255, 255, 255, 255), scale=0.05},
        gibplosion = "mm_gibs"
    },
    [BLOODTYPE_DUST] = {
        impact = "mm_blood_skelly",
        spray = "",
        bloodlet = "mm_bloodletting_skelly",
        trail = "",
        decal = "",
        gibplosion = "mm_gibs_skeleton"
    },
    [BLOODTYPE_HAY] = {
        impact = "mm_blood_scarecrow",
        spray = "",
        bloodlet = "mm_bloodletting_scarecrow",
        trail = "",
        decal = {mat=Material("models/player/monstermash/gibs/hay_splat"), col=Color(255, 255, 255, 255), scale=0.2},
        gibplosion = "mm_gibs_scarecrow"
    },
    [BLOODTYPE_GREEN] = {
        impact = "",
        spray = "",
        bloodlet = "",
        trail = "",
        decal = "",
        gibplosion = ""
    },
    [BLOODTYPE_BLACK] = {
        impact = "mm_blood_black",
        spray = "mm_bloodspray_black",
        bloodlet = "mm_bloodletting_black",
        trail = "",
        decal = {mat=blackbloodmats, col=Color(255, 255, 255, 255), scale=0.05},
        gibplosion = "mm_gibs_black"
    },
    [BLOODTYPE_PARTY] = {
        impact = "mm_confetti",
        spray = "mm_confettispray",
        bloodlet = "mm_confetti",
        trail = "",
        decal = {mat=confettibloodmats, col=Color(255, 255, 255, 255), scale=0.025},
        gibplosion = "mm_confettigib"
    },
}

GM.BloodMats = {
    [BLOODTYPE_NORMAL] = {
        list = redbloodmats,
        count = bloodmatcount
    },
    [BLOODTYPE_BLACK] = {
        list = blackbloodmats,
        count = bloodmatcount
    },
    [BLOODTYPE_HAY] = {
        list = haymats,
        count = hamatscount
    },
    [BLOODTYPE_PARTY] = {
        list = redbloodmats,
        count = bloodmatcount
    },
    [BLOODTYPE_DUST] = {
        list = bonechunks,
        count = bonechunkcount
    },
}

function GM:EmitBlood(character, effecttype, position, normal, entity, attachment, duration)

    bloodtype = character
    if (istable(character)) then
        bloodtype = character.bloodtype
    end
    if (effecttype == BLOODEFFECT_TRAIL) then
        local effecttbl = GAMEMODE.BloodEffects[bloodtype]
        if SERVER then
            util.SpriteTrail(entity, 0, effecttbl.trail.col, false, 7, 1, 1, 1/(15+1)*0.5, effecttbl.trail.mat)
        end
        return
    end

    if (CLIENT) then
        self:EmitBlood_Client(bloodtype, effecttype, position or Vector(0, 0, 0), normal or Vector(0, 0, 1), entity, attachment or "", duration or 0)
        net.Start("MM_EmitBloodEffect", true)
            net.WriteInt(bloodtype, 32)
            net.WriteInt(effecttype, 32)
            net.WriteVector(position or Vector(0, 0, 1))
            net.WriteVector(normal or Vector(0, 0, 1))
            net.WriteString(attachment or "")
            net.WriteEntity(entity)
            net.WriteFloat(duration or 0)
        net.SendToServer()
    else
        timer.Simple(0, function()
            EmitBlood_Server(nil, bloodtype, effecttype, position or Vector(0, 0, 0), normal or Vector(0, 0, 1), entity, attachment or "", duration or 0)
        end)
    end
end

function GM:EmitBlood_Client(bloodtype, effecttype, position, normal, entity, attachment, duration)
    position = position or Vector(0, 0, 0)
    normal = normal or Vector(0, 0, 1)
    entity = entity or nil
    attachment = attachment or ""
    if (entity != nil && !IsValid(entity)) then return end
    EmitBloodEffect(bloodtype, effecttype, position, normal, entity, attachment)
    if (duration != nil && duration > 0) then
        timer.Create("EmitEffect_"..tostring(entity), 0.1, duration/0.1, function()
            if (entity != nil && !IsValid(entity)) then return end
            EmitBloodEffect(bloodtype, effecttype, position, normal, entity, attachment)
        end)
    end
end

function EmitBloodEffect(bloodtype, effecttype, position, normal, entity, attachment)
    local effect = ""
    local effecttbl = GAMEMODE.BloodEffects[bloodtype]
    local finalpos = position
    local finalnorm = normal
    local isutileffect = false
    if (GetConVar("mm_confetti"):GetBool()) then
        effecttbl = GAMEMODE.BloodEffects[BLOODTYPE_PARTY]
    end

    if (attachment != "" && IsValid(entity)) then
        if (attachment == "ent") then
            finalpos = entity:GetPos()
        elseif (string.StartsWith(attachment, "ValveBiped")) then
            local attach = entity:LookupBone(attachment)
            if (attach == nil) then return end
            local bonepos, boneang = entity:GetBonePosition(attach)
            finalpos = bonepos + position
            finalnorm = boneang:Forward()
        else
            local attach = entity:LookupAttachment(attachment)
            if (attach == nil) then return end
            attach = entity:GetAttachment(attach)
            if (attach == nil) then return end
            finalpos = attach.Pos + position
            if (attachment == "blood_splurt") then
                finalnorm = -attach.Ang:Right()
            else
                finalnorm = attach.Ang:Forward()
            end
        end
    end

    if (effecttype == BLOODEFFECT_IMPACT) then
        effect = effecttbl.impact
        isutileffect = true
    elseif (effecttype == BLOODEFFECT_BLOODLETTER) then
        effect = effecttbl.bloodlet
        isutileffect = true
    elseif (effecttype == BLOODEFFECT_SPRAY) then
        effect = effecttbl.spray
        isutileffect = true
    elseif (effecttype == BLOODEFFECT_GIBPLOSION) then
        effect = effecttbl.gibplosion
        isutileffect = true
    end

    if (isutileffect) then
        if (effect == "" || entity == LocalPlayer()) then return end

        local effectdata = EffectData()
        effectdata:SetOrigin(finalpos)
        effectdata:SetNormal(finalnorm)
        util.Effect(effect, effectdata)
    elseif (effecttype == BLOODEFFECT_DECAL) then
        effect = effecttbl.decal
        if (effect == "") then return end

        local effectmat = effect.mat
        if (istable(effectmat)) then
            if (GetConVar("mm_confetti"):GetBool()) then
                effectmat = effect.mat[math.random(confettimatcount)]
            else
                effectmat = effect.mat[math.random(bloodmatcount)]
            end
        end

        local traceinfo = {
            start = finalpos - normal*100, 
            endpos = finalpos + normal*100,
            filter = entity, 
            mask = MASK_SOLID
        }
        local trace = util.TraceHull(traceinfo)
        local todecal1 = trace.HitPos + trace.HitNormal
        local todecal2 = trace.HitPos - trace.HitNormal
        if (IsValid(trace.Entity) || trace.Entity:IsWorld()) then
            util.DecalEx(effectmat, trace.Entity, trace.HitPos, trace.HitNormal, effect.col, effect.scale, effect.scale)
        end
    end
end

function EmitBlood_Server(ply, bloodtype, effecttype, position, normal, entity, attachment, duration)
    net.Start("MM_EmitBloodEffectToClient")
        net.WriteInt(bloodtype, 32)
        net.WriteInt(effecttype, 32)
        net.WriteVector(position)
        net.WriteVector(normal)
        net.WriteEntity(entity)
        net.WriteString(attachment)
        net.WriteFloat(duration)
    if (ply != nil) then
        net.SendOmit(ply)
    else
        net.Broadcast()
    end
end

function GM:GetBloodMatList(type)
    return self.BloodMats[type].list
end

function GM:GetBloodMatList_Count(type)
    return self.BloodMats[type].count
end

if SERVER then
    util.AddNetworkString("MM_EmitBloodEffect")
    util.AddNetworkString("MM_EmitBloodEffectToClient")

    net.Receive("MM_EmitBloodEffect", function(len, ply)
        local bloodtype = net.ReadInt(32)
        local effecttype = net.ReadInt(32)
        local position = net.ReadVector()
        local normal = net.ReadVector()
        local entity = net.ReadEntity()
        local attachment = net.ReadString()
        local duration = net.ReadFloat()
        EmitBlood_Server(ply, bloodtype, effecttype, position, normal, entity, attachment, duration)
    end)
end

if CLIENT then
    net.Receive("MM_EmitBloodEffectToClient", function(len, ply)
        local bloodtype = net.ReadInt(32)
        local effecttype = net.ReadInt(32)
        local position = net.ReadVector()
        local normal = net.ReadVector()
        local entity = net.ReadEntity()
        local attachment = net.ReadString()
        local duration = net.ReadFloat()
        GAMEMODE:EmitBlood_Client(bloodtype, effecttype, position, normal, entity, attachment, duration)
    end)
end