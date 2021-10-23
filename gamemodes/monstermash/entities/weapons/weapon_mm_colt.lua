AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )


SWEP.PrintName = "Pistol"

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false


SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_pistol.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_pistol.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.SelectIcon = Material("vgui/entities/mm_colt")
SWEP.Cost = 25
SWEP.Points = 40
SWEP.KillFeed = "%a asked %v if they approve of their party favors."
 
SWEP.Primary.Sound         = "weapons/colt/colt_fire.wav" 
SWEP.Primary.Damage        = 20
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Spread        = 0.165
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 0.2875
SWEP.Primary.Delay         = 0.35

SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 896

SWEP.HoldType         = "revolver" 
SWEP.HoldTypeAttack   = "revolver"
SWEP.HoldTypeReload   = "pistol"
SWEP.HoldTypeCrouch   = "revolver"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )
SWEP.CrosshairSize = 40

SWEP.ReloadOutTime = 0.3
SWEP.ReloadInTime  = 0.7