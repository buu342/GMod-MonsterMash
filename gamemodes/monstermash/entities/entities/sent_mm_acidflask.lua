AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.PrintName = "Acid Flask"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_acid.mdl"
ENT.Damage = 0
ENT.ExplodeOnImpact = true
ENT.ThrowAngle = Angle(70,-90,0)
ENT.ExplodeSound = Sound("physics/glass/glass_largesheet_break3.wav")
ENT.CreateEntOnRemove = "sent_mm_acidpuddle"

ENT.ApplyEffectDistance = 64
ENT.ApplyEffectType = STATUS_SUPERACID
ENT.ApplyEffectDuration = 7.5

ENT.ApplyEffectDistance2 = 256
ENT.ApplyEffectType2 = STATUS_ACID
ENT.ApplyEffectDuration2 = 7.5

function ENT:ExplodeEffect()
    self:EmitSound(Sound("physics/glass/glass_largesheet_break3.wav"))
    self:EmitSound(Sound("ambient/levels/canals/toxic_slime_sizzle4.wav"))
    
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_acidflask_explosion", effectdata4)		
    
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("VortDispel", effectdata4)
end