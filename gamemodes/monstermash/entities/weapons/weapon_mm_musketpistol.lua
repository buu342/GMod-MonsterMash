AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Dueling Pistol"

SWEP.SelectIcon = Material("vgui/entities/mm_musketpistol")
SWEP.Cost = 40
SWEP.Points = 40
SWEP.KillFeed = "%a settled their dispute with %v like a gentlemen."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_musketpistol.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_musketpistol.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/musket/sawedoff-1.wav" 
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1 
SWEP.Primary.Spread = 0.05
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 6
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 0
SWEP.Primary.Chargeup = true
SWEP.Primary.ChargeDamage = 75
SWEP.Primary.ChargeCrouch = false
SWEP.Primary.SpecialCooldown = 15
SWEP.Primary.SpecialCooldownGivesAmmo = true

SWEP.Secondary.ChargeCancel = true

SWEP.CanReload = false

SWEP.HoldType         = "pistol" 
SWEP.HoldTypeAttack   = "pistol"
SWEP.HoldTypeCrouch   = "pistol"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairSize = 18
SWEP.CrosshairChargeSize = 16
SWEP.CrosshairChargeType = CHARGETYPE_CIRCLE
SWEP.CrosshairRechargeMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairRechargeSize     = 96

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 896

SWEP.KillFlags = KILL_HEADEXPLODE

SWEP.ChargeSpeed = 1

SWEP.MuzzleEffect = "mm_muzzle_black"
SWEP.EjectEffect = ""