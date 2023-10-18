AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_pumpkin.mdl"
ENT.DoDamage = true
ENT.ExplodeSound = nil
ENT.ExplodeOnImpact = false
ENT.DamageType = DMG_DISSOLVE
ENT.GibOnContact = false
ENT.ContinuousEffect = "mm_wandtrail"
ENT.RemoveBounces = true
ENT.NumBounces = 4

ENT.LightSize = 256
ENT.LightColor = Color(0, 255, 0)
ENT.LightBrightness = 3
ENT.LightDecay = 2048
ENT.LightTime = 0.25

function ENT:ExplodeEffect()
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_magic_explosion", effectdata4)
end

function ENT:Draw()

	render.SetMaterial(Material("particle/wandball"))

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting(pos, Vector(0, 0, 1))
	local c = Vector(81/255, 221/255, 40/255)

	lcolor.x = c.x * (math.Clamp(lcolor.x, 0, 1) + 0.5) * 255
	lcolor.y = c.y * (math.Clamp(lcolor.y, 0, 1) + 0.5) * 255
	lcolor.z = c.z * (math.Clamp(lcolor.z, 0, 1) + 0.5) * 255

	local size = 25
	render.DrawSprite(pos, size, size, Color(lcolor.x, lcolor.y, lcolor.z, 255))
	render.SetMaterial(Material("particle/wandball2"))
	render.DrawSprite(pos, size, size, Color(lcolor.x, lcolor.y, lcolor.z, 255))
    
    local dlight = DynamicLight(self:EntIndex())
    if (dlight) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 0
        dlight.g = 255
        dlight.b = 0
        dlight.brightness = 3
        dlight.Decay = 2048
        dlight.Size = 512
        dlight.DieTime = CurTime() + 0.25
    end  
    
    if self.ContinuousEffect != nil then
        local effectdata2 = EffectData()
		effectdata2:SetOrigin(self:GetPos())
		util.Effect(self.ContinuousEffect, effectdata2)
    end

end