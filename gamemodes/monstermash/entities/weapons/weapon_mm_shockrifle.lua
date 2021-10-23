AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Shock Rifle"

SWEP.SelectIcon = Material("vgui/entities/mm_electricrifle")
SWEP.Cost = 55
SWEP.Points = 25
SWEP.KillFeed = "%a zapped %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/monstermash/c_electricrifle.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_electricrifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/shockrifle/shockrifle_1.wav" 
SWEP.Primary.Damage        = 18
SWEP.Primary.ClipSize      = 10
SWEP.Primary.Spread        = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 0.2875
SWEP.Primary.Delay         = 0.2
SWEP.Primary.Chargeup      = true
SWEP.Primary.ChargeDamage  = SWEP.Primary.Damage 
SWEP.Primary.BulletArc     = true
SWEP.Primary.ShockTime     = 0.1
SWEP.Primary.IgniteIfDamage = (SWEP.Primary.Damage + SWEP.Primary.Damage/2)

SWEP.Secondary.FireMode      = FIREMODE_BULLET
SWEP.Secondary.Sound         = SWEP.Primary.Sound
SWEP.Secondary.Damage        = SWEP.Primary.Damage/3
SWEP.Secondary.Spread        = 1.0
SWEP.Secondary.NumberofShots = SWEP.Primary.ClipSize
SWEP.Secondary.TakeAmmo      = SWEP.Primary.ClipSize
SWEP.Secondary.Automatic     = false
SWEP.Secondary.Recoil        = 10
SWEP.Secondary.Delay         = 1
SWEP.Secondary.TakeAmmoAffectsBulletCount = true
SWEP.Secondary.BulletForce   = 5000
SWEP.Secondary.ShockTime     = 2
SWEP.Secondary.Magnetism = false

SWEP.Primary.UseRange = false
SWEP.Secondary.UseRange = false

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_garand" )
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_carbine_fill" )
SWEP.CrosshairSize = 64
SWEP.CrosshairChargeSize = 36
SWEP.CrosshairChargeType = CHARGETYPE_CIRCLE

SWEP.ReloadOutTime = 0
SWEP.ReloadInTime  = 2.2

SWEP.KillFlags = KILL_SKELETIZE

SWEP.ChargeSpeed = 80
SWEP.TracerName = "ToolTracer"
SWEP.ImpactEffect = "MetalSpark"
SWEP.ImpactDecal = Material("decals/scorchfade_subrect") // util.DecalMaterial( "FadingScorch" )
SWEP.ImpactDecalSize = 0.5
SWEP.ImpactEffectOnPlayers = true

SWEP.MuzzleEffect = "AirboatMuzzleFlash"
SWEP.EjectEffect = ""
SWEP.SlowMoTracer = false