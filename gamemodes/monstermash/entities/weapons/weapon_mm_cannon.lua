AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Cannon"

SWEP.SelectIcon = Material("vgui/entities/mm_cannon")
SWEP.Cost = 70
SWEP.Points = 10
SWEP.KillFeed = "%a had a ball with %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_cannon.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_cannon.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound       = "weapons/cannon/cannon-1.wav"
SWEP.Primary.Damage      = 200
SWEP.Primary.TakeAmmo    = 1
SWEP.Primary.Recoil      = 10
SWEP.Primary.Delay       = 1
SWEP.Primary.ClipSize    = 1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.FireMode    = FIREMODE_PROJECTILE
SWEP.Primary.Chargeup    = true
SWEP.Primary.ChargeTime  = 1
SWEP.Primary.ChargeForce = 10000
SWEP.Primary.ProjectileForce = 300
SWEP.Primary.ProjectileEntity = "sent_mm_cannonball"

SWEP.HoldType       = "shotgun" 
SWEP.HoldTypeAttack = "shotgun"
SWEP.HoldTypeReload = "crossbow"
SWEP.HoldTypeCrouch = "shotgun" 

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_cannon")
SWEP.CrosshairChargeMaterial = Material("vgui/hud/crosshair_cannon_fill")
SWEP.CrosshairSize = 96
SWEP.CrosshairChargeSize = 96
SWEP.CrosshairChargeType = CHARGETYPE_BAR
SWEP.CrosshairYDisplacement = 20

SWEP.ReloadOutTime = 0.7
SWEP.ReloadInTime  = 0.0

SWEP.RunSpeed = 175

SWEP.MuzzleEffect = "mm_muzzle_smokier"
SWEP.EjectEffect = ""