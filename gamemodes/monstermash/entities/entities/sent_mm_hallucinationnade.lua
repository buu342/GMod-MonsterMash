AddCSLuaFile()
DEFINE_BASECLASS( "sent_mm_thrownbase" )

ENT.PrintName = "Hallucination Grenade"
ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/demon.mdl"
ENT.Damage = 0
ENT.Arrow = true
ENT.Gravity = 0.3
ENT.ContinuousEffect = "mm_grenadesmoke"
ENT.LoopSound = "weapons/flaregun/burn.wav"
ENT.LifeTime = 20
ENT.CanAffectOwner = true
ENT.ActivateTime = 1

ENT.ApplyEffectAlways = true
ENT.ApplyEffectDistance = 256
ENT.ApplyEffectType = STATUS_HALLUCINATING
ENT.ApplyEffectDuration = 1

ENT.LightSize = 512
ENT.LightColor = Color(163,73,164)
ENT.LightBrightness = 3
ENT.LightDecay = 2048