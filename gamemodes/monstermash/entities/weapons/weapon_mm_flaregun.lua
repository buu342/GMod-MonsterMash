AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Flaregun"

SWEP.SelectIcon = Material("vgui/entities/mm_flaregun")
SWEP.Cost = 35
SWEP.Points = 10
SWEP.KillFeed = "%a signaled %v to get in their grave."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_flaregun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_flaregun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound       = "weapons/flaregun/flare_shot.wav" 
SWEP.Primary.TakeAmmo    = 1
SWEP.Primary.Delay       = 0.5
SWEP.Primary.Recoil      = 0.1
SWEP.Primary.ClipSize    = 1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.FireMode    = FIREMODE_PROJECTILE
SWEP.Primary.ProjectileEntity = "sent_mm_flare"
SWEP.Primary.ProjectileForce = 3500

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 1200

SWEP.HoldType         = "pistol" 
SWEP.HoldTypeAttack   = "pistol"
SWEP.HoldTypeReload   = "pistol"
SWEP.HoldTypeCrouch   = "pistol"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairSize = 48
SWEP.CrosshairYDisplacement = 20

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 1.0

SWEP.MuzzleEffect = "mm_muzzle_smoke"
SWEP.EjectEffect = ""