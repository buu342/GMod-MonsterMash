AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Crossbow"

SWEP.SelectIcon = Material("vgui/entities/mm_crossbow")
SWEP.Cost = 25
SWEP.Points = 40
SWEP.KillFeed = "%a practiced their archery on %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_crossbow.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_crossbow.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/crossbow/fire.wav" 
SWEP.Primary.Damage      = 53
SWEP.Primary.TakeAmmo    = 1
SWEP.Primary.Delay       = 0.5
SWEP.Primary.Recoil      = 0.3
SWEP.Primary.ClipSize    = 1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.FireMode    = FIREMODE_PROJECTILE
SWEP.Primary.ProjectileEntity = "sent_mm_arrow"
SWEP.Primary.ProjectileForce = 3500

SWEP.Secondary.Sound         = "weapons/crossbow/fire.wav" 
SWEP.Secondary.TakeAmmo    = 1
SWEP.Secondary.Delay       = 0.5
SWEP.Secondary.Recoil      = 0.3
SWEP.Secondary.ClipSize    = 1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.FireMode    = FIREMODE_PROJECTILE
SWEP.Secondary.SpecialCooldown = 15
SWEP.Secondary.ProjectileEntity = "sent_mm_arrowfire"
SWEP.Secondary.ProjectileForce = 3500

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 1200

SWEP.HoldType         = "ar2" 
SWEP.HoldTypeAttack   = "ar2"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairRechargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )
SWEP.CrosshairSize = 56
SWEP.CrosshairRechargeType = CHARGETYPE_BAR
SWEP.CrosshairRechargeColor = Color(0,255,0, 100)
SWEP.CrosshairYDisplacement = 20

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 0.7

SWEP.MuzzleEffect = ""
SWEP.EjectEffect = ""