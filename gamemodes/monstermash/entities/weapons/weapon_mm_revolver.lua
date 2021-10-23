AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Revolver"
    
SWEP.SelectIcon = Material("vgui/entities/mm_revolver")
SWEP.Cost = 15
SWEP.Points = 40
SWEP.KillFeed = "%a asked %v if they were feeling lucky."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_revolver.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_revolver.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound = Sound("weapons/revolver/fire1.wav")
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6 
SWEP.Primary.Ammo = "None"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Primary.UseRange = true
SWEP.Primary.Range = 1152

SWEP.HoldType         = "revolver" 
SWEP.HoldTypeAttack   = "revolver"
SWEP.HoldTypeReload   = "revolver"
SWEP.HoldTypeCrouch   = "revolver"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )
SWEP.CrosshairSize = 40

SWEP.ReloadOutTime = 0.7
SWEP.ReloadInTime  = 2.1

SWEP.EjectEffect = ""