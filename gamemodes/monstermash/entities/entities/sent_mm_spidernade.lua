AddCSLuaFile()
DEFINE_BASECLASS( "sent_mm_thrownbase" )

ENT.PrintName = "Spider grenade"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_web.mdl"
ENT.Damage = 0
ENT.ExplodeOnImpact = true
ENT.ExplodeSound = Sound("weapons/webgrenade/agrub_squish1.wav")
ENT.CreateEntOnRemove = "sent_mm_web"
ENT.CanAffectOwner = true
ENT.ThrowAngle = Angle(60,-40,0)

ENT.ApplyEffectDistance = 96
ENT.ApplyEffectType = STATUS_SPIDERWEBBED
ENT.ApplyEffectDuration = 4

function ENT:ExplodeEffect()
    local effectdata4 = EffectData()
    effectdata4:SetStart( self:GetPos() ) 
    effectdata4:SetOrigin( self:GetPos() )
    effectdata4:SetScale( 1 )
    util.Effect( "mm_spidernade_explosion", effectdata4 )
end