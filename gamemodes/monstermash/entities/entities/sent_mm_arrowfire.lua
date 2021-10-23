AddCSLuaFile()
DEFINE_BASECLASS( "sent_mm_thrownbase" )

ENT.PrintName = "Fire Arrow"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/arrow.mdl"
ENT.Damage = 53
ENT.ExplodeSound = {"weapons/crossbow/hitbod1.wav", "weapons/crossbow/hitbod2.wav"}
ENT.Arrow = true
ENT.OnFire = true
ENT.Gravity = 0.3
ENT.LifeTime = 10
ENT.SwooshSound = Sound("weapons/fx/nearmiss/bulletltor13.wav")

ENT.BurnChance = 100

ENT.FireLight = true
ENT.LightSize = 256
ENT.LightColor = Color(240, 104, 0)
ENT.LightBrightness = 3
ENT.LightDecay = 2048
ENT.LightTime = 0.25