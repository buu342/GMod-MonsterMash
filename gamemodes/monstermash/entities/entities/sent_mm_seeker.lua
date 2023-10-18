AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/hunter/misc/sphere025x025.mdl"
ENT.Damage = 5
ENT.ExplodeSound = Sound("")
ENT.ExplodeOnImpact = false
ENT.DoDamage = true
ENT.NoGravity = true
ENT.Seeker = true
ENT.RemoveBounces = true
ENT.GibOnContact = false
ENT.SwooshSound = {
    Sound("weapons/tormentor/tormentor_phantom1.wav"),
    Sound("weapons/tormentor/tormentor_phantom2.wav"),
    Sound("weapons/tormentor/tormentor_phantom3.wav"),
    Sound("weapons/tormentor/tormentor_phantom4.wav"),
    Sound("weapons/tormentor/tormentor_phantom5.wav"),
}
ENT.DamageType = DMG_SNIPER


function ENT:ExplodeEffect()
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_ghost_explosion", effectdata4)
end

function ENT:Draw()

	render.SetMaterial(Material("models/weapons/monstermash/graverifle/phantom"))

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting(pos, Vector(0, 0, 1))
	local c = Vector(81/255, 221/255, 40/255)

	lcolor.x = c.x * (math.Clamp(lcolor.x, 0, 1) + 0.5) * 255
	lcolor.y = c.y * (math.Clamp(lcolor.y, 0, 1) + 0.5) * 255
	lcolor.z = c.z * (math.Clamp(lcolor.z, 0, 1) + 0.5) * 255

	local size = 25
	render.DrawSprite(pos, size, size, Color(lcolor.x, lcolor.y, lcolor.z, 255))

end

function ENT:ExplodeExtra(data, phys)
    if (IsValid(self.Inflictor) && IsValid(self.Target)) then
        self.Damage = 5*self.Inflictor:GetWeaponDamageScale(self.Target)
        if (data.HitEntity == self.Target) then
            self.Inflictor:IncreaseWeaponDamageScale(self.Target)
        end
    end
end