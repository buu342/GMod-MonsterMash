AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Battle Rifle"

SWEP.SelectIcon = Material("vgui/entities/mm_battlerifle")
SWEP.Cost = 50
SWEP.Points = 25
SWEP.KillFeed = "%a rifled through %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_battlerifle.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_battlerifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"
 
SWEP.Primary.Sound         = "weapons/battlerifle/fire.wav" 
SWEP.Primary.Damage        = 17
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 18
SWEP.Primary.Spread        = 0.0675
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 0.3
SWEP.Primary.Delay         = 0.7

SWEP.Primary.BurstFire = true
SWEP.Primary.BurstTime = 0.075
SWEP.Primary.Magnetism = false

SWEP.Secondary.Sound       = "weapons/mortar/mortar_fire1.wav" 
SWEP.Secondary.Damage      = 25
SWEP.Secondary.TakeAmmo    = 0
SWEP.Secondary.Delay       = 1
SWEP.Secondary.Recoil      = 0.3
SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Secondary.FireMode        = FIREMODE_PROJECTILE
SWEP.Secondary.SpecialCooldown = 15
SWEP.Secondary.ProjectileEntity = "sent_mm_hallucinationnade"
SWEP.Secondary.ProjectileForce = 2500

SWEP.Primary.UseRange = false

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_BAR")
SWEP.CrosshairSize = 34
SWEP.CrosshairRechargeMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairRechargeSize     = 96

SWEP.ReloadOutTime = 0.8
SWEP.ReloadInTime  = 1.1

SWEP.Attack2Anim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.KillFlags = KILL_HEADEXPLODE

SWEP.EjectEffect = "RifleShellEject"