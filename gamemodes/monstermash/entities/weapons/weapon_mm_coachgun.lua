AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Coach Gun"

SWEP.SelectIcon = Material("vgui/entities/mm_coachgun")
SWEP.Cost = 60
SWEP.Points = 10
SWEP.KillFeed = "%a told %v to shop smart; shop S-Mart."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_coachgun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_coachgun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/coachgun/fire1.wav" 
SWEP.Primary.Damage        = 10
SWEP.Primary.TakeAmmo      = 2
SWEP.Primary.ClipSize      = 2 
SWEP.Primary.Spread        = 5
SWEP.Primary.NumberofShots = 14
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 10
SWEP.Primary.Delay         = 0.5
SWEP.Primary.FireMode      = FIREMODE_CUSTOM

SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 320

SWEP.HoldType         = "shotgun" 
SWEP.HoldTypeAttack   = "shotgun"
SWEP.HoldTypeReload   = "shotgun"
SWEP.HoldTypeCrouch   = "shotgun"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairSize = 128

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 1.5

SWEP.MakeThumperDust = true
SWEP.KillFlags = bit.bor(KILL_GIBTHRESHOLD, KILL_SCRIPTED)

SWEP.MuzzleEffect = "mm_muzzle_bigger"
SWEP.EjectEffect = ""

SWEP.MakeThumperDust = true

function SWEP:MM_ShootCustom(mode)
    self:MM_ShootSpiral(mode)
end