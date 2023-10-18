AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Sawblade Launcher"

SWEP.SelectIcon = Material("vgui/entities/mm_sawblade")
SWEP.Cost = 60
SWEP.Points = 10
SWEP.KillFeed = "%a trimmed a little off %v's top."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_sawblade_launcher.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_sawblade_launcher.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound       = "weapons/crossbow/fire.wav" 
SWEP.Primary.Damage      = 50
SWEP.Primary.TakeAmmo    = 1
SWEP.Primary.Delay       = 0.5
SWEP.Primary.Recoil      = 0.3
SWEP.Primary.ClipSize    = 1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.FireMode    = FIREMODE_PROJECTILE
SWEP.Primary.ProjectileEntity = "sent_mm_sawblade"
SWEP.Primary.ProjectileForce = 3500

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 1200

SWEP.HoldType         = "crossbow" 
SWEP.HoldTypeAttack   = "crossbow"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "crossbow"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_cannon")
SWEP.CrosshairSize = 48
SWEP.CrosshairYDisplacement = 20

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 0.7

SWEP.KillFlags = KILL_BIFURCATE

SWEP.MuzzleEffect = ""
SWEP.EjectEffect = ""