AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/cannonball.mdl"
ENT.ExplodeRadius = 200
ENT.ExplodeSound = {Sound("weapons/cannon/explosion1.wav"), Sound("weapons/cannon/explosion2.wav")}
ENT.ExplodeOnImpact = true
ENT.ContinuousEffect = "mm_smoketrail"

ENT.DamageType = DMG_BLAST

function ENT:ExplodeEffect()
    local explo = ents.Create("env_explosion")
    explo:SetOwner(self.Owner)
    explo:SetPos(self.Entity:GetPos())
    explo:SetKeyValue("iMagnitude", "100")
    explo:Spawn()
    explo:Activate()

    local i
    for i=1,10 do
        local effectdata2 = EffectData()
        effectdata2:SetOrigin(self:GetPos())
        effectdata2:SetScale(24)
        util.Effect("ThumperDust", effectdata2)
    end    
    
    local effectdata5 = EffectData()
    effectdata5:SetOrigin(self:GetPos())
    util.Effect("Fireball_Explosion", effectdata5) 
        
    local effectdata3 = EffectData()
    effectdata3:SetOrigin(self:GetPos())
    effectdata3:SetScale(1)
    util.Effect("ManhackSparks", effectdata3)
        
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("HelicopterMegaBomb", effectdata4)
        
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
    util.Decal("Scorch", todecal1, todecal2)
end