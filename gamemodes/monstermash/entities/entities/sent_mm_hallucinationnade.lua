AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.PrintName = "Hallucination Grenade"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/demon.mdl"
ENT.LoopSound = "weapons/flaregun/burn.wav"
ENT.Gravity = 0.3
ENT.ExplodeRadius = 200
ENT.Damage = 25
ENT.ExplodeSound = {Sound("weapons/cannon/explosion1.wav"), Sound("weapons/cannon/explosion2.wav")}
ENT.ExplodeOnImpact = true
ENT.ContinuousEffect = "mm_smoketrail"

ENT.DamageType = DMG_BLAST

ENT.LightSize = 512
ENT.LightColor = Color(163,73,164)
ENT.LightBrightness = 3
ENT.LightDecay = 2048

function ENT:ExplodeEffect()
    
    local effectdata = EffectData()
    effectdata:SetStart(self:GetPos()) 
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetScale(1)
    util.Effect("mm_hallucinate_explosion", effectdata)
    
    local startp = self:GetPos()
    local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    util.Decal("Scorch", todecal1, todecal2)
end

function ENT:DoRemoveStuff()
    local smoke = ents.Create("sent_mm_hallucinationsmoke")
    smoke:SetPos(self:GetPos())
    smoke.Owner = self.Owner
    smoke.Inflictor = self.Inflictor
    smoke:Spawn()
    smoke:Activate()
end