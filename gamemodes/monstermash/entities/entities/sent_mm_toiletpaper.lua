AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.PrintName = "Toilet Paper"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_tp.mdl"
ENT.Damage = 0
ENT.Trail = "models/weapons/monstermash/tp/tp_trail"
ENT.ThrowAngle = Angle(60,-40,0)
ENT.DoSomethingCollide = true
ENT.DoDamage = true
ENT.Retrievable = true
ENT.SoftSeeker = true

function ENT:DoCollideThing(data, phys)
    if data.HitEntity:IsPlayer() && data.HitEntity != self.Owner && data.HitEntity:CanBeDamagedBy(self.Owner) then
        self.Owner:GiveTreat("tp")
    end
end