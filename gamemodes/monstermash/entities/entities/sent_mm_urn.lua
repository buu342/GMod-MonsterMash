AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.PrintName = "Haunted Urn"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_urn.mdl"
ENT.Damage = 0
ENT.ExplodeOnImpact = true
ENT.ExplodeSound = Sound("physics/glass/glass_largesheet_break3.wav")
ENT.ThrowAngle = Angle(-30,90,30)
ENT.ApplyEffectDistance = 256
ENT.ApplyEffectType = STATUS_SPOOKED
ENT.ApplyEffectDuration = 2.5

local floordecal = Material("models/weapons/monstermash/urn/urn_shatter")

function ENT:ExplodeEffect()
    local i
    for i=1,1 do
        local effectdata2 = EffectData()
        effectdata2:SetOrigin(self:GetPos())
        effectdata2:SetScale(50)
        util.Effect("ThumperDust", effectdata2)
    end    

    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_urn_explosion", effectdata4)
end

function ENT:OnRemove()
    if CLIENT then
        local models = {
            "models/weapons/monstermash/urn_piece1.mdl",
            "models/weapons/monstermash/urn_piece2.mdl", 
            "models/weapons/monstermash/urn_piece3.mdl",        
            "models/weapons/monstermash/urn_piece1.mdl",
            "models/weapons/monstermash/urn_piece2.mdl", 
            "models/weapons/monstermash/urn_piece3.mdl"
        }
        for i=1, #models do
            local gib = ents.CreateClientProp(models[i])
            gib:SetPos(self:GetPos())
            gib:SetModel(models[i])
            gib:Spawn()
            gib:SetVelocity((VectorRand()+Vector(0,0,100))*100)
            gib:Activate()
            timer.Simple(5, function() if !IsValid(gib) then return end gib:Remove() end)
        end
        local startp = self:GetPos()
        local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
        local trace = util.TraceLine(traceinfo)
        if (trace.Entity:IsWorld()) then
            util.DecalEx(floordecal, trace.Entity, trace.HitPos, trace.HitNormal, Color(255, 255, 255, 255), 1, 1)
        end
    end
end