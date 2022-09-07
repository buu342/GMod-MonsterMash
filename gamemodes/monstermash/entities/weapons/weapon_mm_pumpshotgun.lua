AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Pump shotgun"

SWEP.SelectIcon = Material("vgui/entities/mm_pumpshotgun")
SWEP.Cost = 35
SWEP.Points = 25
SWEP.KillFeed = "%a declared open season on %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_pumpshotgun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_pumpshotgun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/pumpaction/fire.wav" 
SWEP.Primary.Damage        = 8
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 6
SWEP.Primary.Spread        = 4
SWEP.Primary.NumberofShots = 8
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 2
SWEP.Primary.Delay         = 1.1
SWEP.Primary.FireMode      = FIREMODE_CUSTOM

SWEP.Secondary.FireMode      = FIREMODE_CUSTOM
SWEP.Secondary.Sound         = "weapons/pumpaction/fire.wav" 
SWEP.Secondary.Damage        = 6
SWEP.Secondary.TakeAmmo      = 2
SWEP.Secondary.ClipSize      = 6
SWEP.Secondary.Spread        = 4
SWEP.Secondary.NumberofShots = 8
SWEP.Secondary.Automatic     = true
SWEP.Secondary.Recoil        = 2
SWEP.Secondary.Delay         = 0.3
SWEP.Secondary.TakeAmmoAffectsShootability = true

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 448
SWEP.Secondary.UseRange = true
SWEP.Secondary.Range    = 448

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "shotgun"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairSize = 112

SWEP.ShotgunReload = true
SWEP.ReloadOutTime = 0.3

SWEP.KillFlags = bit.bor(KILL_HEADEXPLODE, KILL_SCRIPTED)

SWEP.EjectEffect = ""

function SWEP:MM_ShootCustom(mode)
    self:MM_ShootSpiral(mode)
end