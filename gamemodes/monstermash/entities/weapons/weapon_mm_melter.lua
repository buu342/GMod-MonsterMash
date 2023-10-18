AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Melter"

SWEP.SelectIcon = Material("vgui/entities/mm_melter")
SWEP.Cost = 45
SWEP.Points = 25
SWEP.KillFeed = "%a melted %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_melter.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_melter.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound         = "weapons/melter/melter.wav" 
SWEP.Primary.Damage        = 15
SWEP.Primary.TakeAmmo      = 5
SWEP.Primary.ClipSize      = 50
SWEP.Primary.Spread        = 0.25
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 0.3
SWEP.Primary.Delay         = 0.3
SWEP.Primary.TakeAmmoAffectsShootability = true

SWEP.Secondary.FireMode      = FIREMODE_BULLET
SWEP.Secondary.Sound         = "weapons/melter/melter_spray_loop.wav" 
SWEP.Secondary.Damage        = 1
SWEP.Secondary.TakeAmmo      = 1
SWEP.Secondary.Spread        = 3
SWEP.Secondary.NumberofShots = 7
SWEP.Secondary.Automatic     = false
SWEP.Secondary.Recoil        = 1
SWEP.Secondary.Delay         = 0.02
SWEP.Secondary.TakeAmmoAffectsBulletCount = true
SWEP.Secondary.BurstFire = true
SWEP.Secondary.BurstTime = 0.02
SWEP.Secondary.BurstCount = SWEP.Primary.ClipSize
SWEP.Secondary.LoopSound = true
SWEP.Secondary.LoopStartSound = Sound("weapons/melter/melter_spray_start.wav")
SWEP.Secondary.LoopEndSound = Sound("weapons/melter/melter_spray_end.wav")
SWEP.Secondary.ArmMissingAffectsAim = false
SWEP.Secondary.Magnetism = false

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 768
SWEP.Secondary.UseRange = true
SWEP.Secondary.Range  = 256

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "pistol"
SWEP.HoldTypeCrouch   = "ar2"
SWEP.HoldTypeProne    = "pistol"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_thompson")
SWEP.CrosshairSize = 96

SWEP.ReloadOutTime = 0.2
SWEP.ReloadInTime  = 1.2

SWEP.IsAcidic = true
SWEP.TracerName = "mm_meltertracer"
SWEP.TracerName2 = "mm_meltertracer2"
SWEP.ImpactEffect = "mm_melterimpact"
SWEP.ImpactDecal = {Material("models/weapons/monstermash/acid/acid_splat1"), Material("models/weapons/monstermash/acid/acid_splat2"), Material("models/weapons/monstermash/acid/acid_splat3")} 
SWEP.ImpactDecalSize = 0.1

SWEP.KillFlags = KILL_MELTER

SWEP.MuzzleEffect = "mm_muzzle_melter"
SWEP.EjectEffect = ""
SWEP.SlowMoTracer = false