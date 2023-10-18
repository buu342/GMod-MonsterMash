AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Repeater"

SWEP.SelectIcon = Material("vgui/entities/mm_repeater")
SWEP.Cost = 40
SWEP.Points = 25
SWEP.KillFeed = "%a shot %v's eye out."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_repeater.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_repeater.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/repeater/fire.wav" 
SWEP.Primary.Damage        = 35
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Spread        = 0.275
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 1
SWEP.Primary.Delay         = 0.75
SWEP.Primary.Chargeup      = true
SWEP.Primary.ChargeShrinksXHair = true
SWEP.Primary.ChargeDamage = 0
SWEP.Primary.ChargeTime   = 3
SWEP.Primary.HideCharge   = true
SWEP.Primary.MaxChargeToMagnetise = true

SWEP.Secondary.FireMode      = FIREMODE_BULLET
SWEP.Secondary.Sound         = "weapons/repeater/fire.wav" 
SWEP.Secondary.Damage        = 35
SWEP.Secondary.Spread        = 0.275
SWEP.Secondary.NumberofShots = 1
SWEP.Secondary.Automatic     = false
SWEP.Secondary.Recoil        = 1
SWEP.Secondary.Delay         = 1
SWEP.Secondary.TakeAmmo      = 4
SWEP.Secondary.Chargeup      = true
SWEP.Secondary.ChargeShrinksXHair = true
SWEP.Secondary.ChargeDamage = 35
SWEP.Secondary.Zoom          = true
SWEP.Secondary.ZoomMax       = 45
SWEP.Secondary.ChargeEarly   = true
SWEP.Secondary.MaxChargeToMagnetise = true

SWEP.Primary.UseRange = false
SWEP.Secondary.UseRange = false

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "shotgun"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_garand")
SWEP.CrosshairSize = 96
SWEP.CrosshairChargeSize = 60
SWEP.CrosshairChargeType = CHARGETYPE_CIRCLE

SWEP.ShotgunReload = true
SWEP.ReloadOutTime = 0.3

SWEP.KillFlags = KILL_HEADEXPLODE

SWEP.ChargeSpeed = 1

SWEP.EjectEffect = "RifleShellEject"