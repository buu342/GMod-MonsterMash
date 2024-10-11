AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Undertaker"

SWEP.SelectIcon = Material("vgui/entities/mm_undertaker")
SWEP.Cost = 30
SWEP.Points = 25
SWEP.KillFeed = "%a nailed %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_undertaker.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_undertaker.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/undertaker/nailgun.wav" 
SWEP.Primary.Damage        = 9
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 32
SWEP.Primary.Spread        = 0.4
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = true
SWEP.Primary.Recoil        = 0.3
SWEP.Primary.Delay         = 0.09
SWEP.Primary.Magnetism     = false

SWEP.Secondary.FireMode      = FIREMODE_BULLET
SWEP.Secondary.Sound         = "weapons/undertaker/nailgun_alt.wav" 
SWEP.Secondary.Damage        = 5
SWEP.Secondary.TakeAmmo      = 16
SWEP.Secondary.Spread        = 0.8
SWEP.Secondary.NumberofShots = 16
SWEP.Secondary.Automatic     = true
SWEP.Secondary.Recoil        = 6
SWEP.Secondary.Delay         = 1
SWEP.Secondary.TakeAmmoAffectsBulletCount = true
SWEP.Secondary.Magnetism = false

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 896
SWEP.Secondary.UseRange = true
SWEP.Secondary.Range    = 896

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_thompson")
SWEP.CrosshairSize = 128

SWEP.ReloadOutTime = 0.8
SWEP.ReloadInTime  = 1.2

SWEP.TracerName = "mm_undertakertracer"
SWEP.MuzzleEffect = ""
SWEP.EjectEffect = ""