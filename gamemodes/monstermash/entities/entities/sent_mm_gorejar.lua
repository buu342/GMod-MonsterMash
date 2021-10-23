AddCSLuaFile()
DEFINE_BASECLASS( "sent_mm_thrownbase" )

ENT.PrintName = "Gore Jar"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_gore.mdl"
ENT.Damage = 0
ENT.ExplodeOnImpact = true
ENT.ExplodeSound = Sound("physics/glass/glass_largesheet_break3.wav")
ENT.ThrowAngle = Angle(-45,45,0)

ENT.ApplyEffectDistance = 256
ENT.ApplyEffectType = STATUS_GOREJARED
ENT.ApplyEffectDuration = 7.5

function ENT:ExplodeEffect()
    for i=0,10 do
        local vPoint = self:GetPos()+Vector(0,0,60)
        local effectdata = EffectData()
        effectdata:SetOrigin( vPoint )
        util.Effect("bloodstream",effectdata)
    end
    local effectdata4 = EffectData()
    effectdata4:SetStart( self:GetPos() ) 
    effectdata4:SetOrigin( self:GetPos() )
    effectdata4:SetScale( 1 )
    util.Effect( "mm_gorejar_explosion", effectdata4 )
    
    local effectdata4 = EffectData()
    effectdata4:SetStart( self:GetPos() ) 
    effectdata4:SetOrigin( self:GetPos() )
    effectdata4:SetScale( 1 )
    util.Effect( "gibs", effectdata4 )
end