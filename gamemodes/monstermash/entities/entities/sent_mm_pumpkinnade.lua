AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_pumpkin.mdl"
ENT.ExplodeRadius = 200
ENT.Damage = 175
ENT.ExplodeSound = {Sound("weapons/pumpkin/pumpkin_explode1.wav"), Sound("weapons/pumpkin/pumpkin_explode2.wav"), Sound("weapons/pumpkin/pumpkin_explode3.wav")}
ENT.ExplodeOnImpact = true
ENT.ThrowAngle = Angle(0,90,0)
ENT.DoDamage = false
ENT.GibOnContact = true

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
    util.Effect("HelicopterMegaBomb", effectdata4)
    
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_pumpkin_explosion", effectdata4)
        
    local shake = ents.Create("env_shake")
    shake:SetOwner(self.Owner)
    shake:SetPos(self.Entity:GetPos())
    shake:SetKeyValue("amplitude", "2000")	// Power of the shake
    shake:SetKeyValue("radius", "500")		// Radius of the shake
    shake:SetKeyValue("duration", "2.5")	// Time of shake
    shake:SetKeyValue("frequency", "255")	// How hard should the screenshake be
    shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
    shake:Spawn()
    shake:Activate()
    shake:Fire("StartShake", "", 0)
    
    local startp = self:GetPos()
    local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    util.Decal("Antlion.Splat", todecal1, todecal2)
end