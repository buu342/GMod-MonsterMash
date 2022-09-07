AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/props_phx/misc/smallcannonball.mdl"
ENT.ExplodeRadius = 256
ENT.ExplodeSound = Sound("ambient/explosions/explode_9.wav")
ENT.ExplodeOnImpact = true
ENT.ThrowAngle = Angle(0,90,0)
ENT.ApplyEffectDistance = 256   
ENT.ApplyEffectType = STATUS_ONFIRE
ENT.ApplyEffectDuration = 6
ENT.CanAffectOwner = true
ENT.ActivateTime = -1
ENT.DoDamage = false
ENT.NoGravity = true
ENT.FireTrail = true
ENT.Material = "models/effects/comball_tape"
ENT.LoopSound = "ambient/fire/fire_small_loop1.wav"

ENT.DamageType = DMG_BLAST

ENT.LightSize = 256
ENT.LightColor = Color(240, 104, 0)
ENT.LightBrightness = 3
ENT.LightDecay = 2048
ENT.LightTime = 0.25

function ENT:ExplodeEffect()
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("flare_explosion", effectdata4)        
    
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("HelicopterMegaBomb", effectdata4)
        
    local startp = self:GetPos()
    local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    util.Decal("Scorch", todecal1, todecal2)
end

function ENT:Draw()
    if self.LightSize != 0 then
        local dlight = DynamicLight(self:EntIndex())
        if (dlight) then
            local r, g, b, a = self:GetColor()
            dlight.Pos = self:GetPos()
            dlight.r = self.LightColor.r
            dlight.g = self.LightColor.g
            dlight.b = self.LightColor.b
            dlight.brightness = self.LightBrightness
            dlight.Decay = self.LightDecay
            dlight.Size = self.LightSize
            dlight.DieTime = CurTime() + self.LightTime
        end  
    end
end