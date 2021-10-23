AddCSLuaFile()
DEFINE_BASECLASS( "sent_mm_thrownbase" )

ENT.PrintName = "Cleaver"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_cleaver.mdl"
ENT.Damage = 30
ENT.BleedChance = 100
ENT.Retrievable = false
ENT.SwooshSound = Sound("weapons/cleaver_fly.wav")
ENT.RemoveOnDamage = true