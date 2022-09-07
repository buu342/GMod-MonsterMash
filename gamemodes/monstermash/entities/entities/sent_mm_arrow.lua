AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.PrintName = "Arrow"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/arrow.mdl"
ENT.ExplodeSound = {"weapons/crossbow/hitbod1.wav", "weapons/crossbow/hitbod2.wav"}
ENT.Arrow = true
ENT.Gravity = 0.3
ENT.LifeTime = 10
ENT.SwooshSound = Sound("weapons/fx/nearmiss/bulletltor13.wav")

ENT.DamageType = DMG_SNIPER