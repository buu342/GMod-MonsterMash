AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Wand"

SWEP.SelectIcon = Material("vgui/entities/mm_wand")
SWEP.Cost = 65
SWEP.Points = 10
SWEP.KillFeed = "%a put a curse on %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_wand.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_wand.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound       = "weapons/wand/wand_fire.wav"
SWEP.Primary.Damage      = 60
SWEP.Primary.TakeAmmo    = 1
SWEP.Primary.Recoil      = 0.1
SWEP.Primary.Delay       = 1
SWEP.Primary.ClipSize    = 6
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.FireMode    = FIREMODE_PROJECTILE
SWEP.Primary.Chargeup    = true
SWEP.Primary.ChargeTime  = 2
SWEP.Primary.ProjectileForce  = 1000
SWEP.Primary.ChargeForce      = 2000
SWEP.Primary.ProjectileEntity = "sent_mm_wandball"

SWEP.Secondary.Sound         = "weapons/wand/wand_deflect.wav"
SWEP.Secondary.TakeAmmo    = 2
SWEP.Secondary.Delay       = 1.5
SWEP.Secondary.Recoil      = 0.1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.FireMode    = FIREMODE_PROJECTILE
SWEP.Secondary.ProjectileEntity = "sent_mm_wandbarrier"
SWEP.Secondary.TakeAmmoAffectsShootability = true

SWEP.HoldType         = "knife" 
SWEP.HoldTypeAttack   = "knife"
SWEP.HoldTypeReload   = "knife"
SWEP.HoldTypeCrouch   = "knife"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )
SWEP.CrosshairSize = 96
SWEP.CrosshairChargeSize = 96
SWEP.CrosshairChargeType = CHARGETYPE_BAR
SWEP.CrosshairYDisplacement = 20

SWEP.ReloadOutTime = 0.7
SWEP.ReloadInTime  = 0.0

SWEP.AttackAnim = ACT_VM_HITCENTER
SWEP.ReloadAmount = 2

SWEP.KillFlags = KILL_ZAP

SWEP.MuzzleEffect = "mm_muzzle_wand"
SWEP.EjectEffect = ""