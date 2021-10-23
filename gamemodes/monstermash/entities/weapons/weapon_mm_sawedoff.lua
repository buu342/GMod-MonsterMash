AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Sawed-Off"

SWEP.SelectIcon = Material("vgui/entities/mm_sawedoff")
SWEP.Cost = 30
SWEP.Points = 40
SWEP.KillFeed = "%a gave %v both barrels."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_sawedoff.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_sawedoff.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/coachgun/fire2.wav" 
SWEP.Primary.Damage        = 10
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 2 
SWEP.Primary.Spread        = 5
SWEP.Primary.NumberofShots = 7
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 6
SWEP.Primary.Delay         = 0.5
SWEP.Primary.FireMode      = FIREMODE_CUSTOM

SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 288

SWEP.HoldType         = "pistol" 
SWEP.HoldTypeAttack   = "pistol"
SWEP.HoldTypeReload   = "pistol"
SWEP.HoldTypeCrouch   = "pistol"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairSize = 128

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 1.5

SWEP.KillFlags = KILL_HEADEXPLODE
SWEP.TraceName = "None"

SWEP.EjectEffect = ""

function SWEP:MM_ShootCustom(mode)
    self:MM_ShootSpiral(mode)
end