AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Stake"

SWEP.SelectIcon = Material("vgui/entities/mm_stake")
SWEP.Cost = 35
SWEP.Points = 20
SWEP.KillFeed = "%a gave %v one hell of a splinter."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/v_stake.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_stake.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairSize = 18
SWEP.CrosshairRechargeMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairRechargeSize     = 96

SWEP.Primary.Damage         = 9001
SWEP.Primary.Recoil         = Angle(0,0,0)
SWEP.Primary.Delay          = 0.5
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("physics/wood/wood_solid_impact_bullet1.wav"), Sound("physics/wood/wood_solid_impact_bullet2.wav"), Sound("physics/wood/wood_solid_impact_bullet3.wav")}
SWEP.Primary.SpecialCooldown = 15

SWEP.HoldType         = "knife" 
SWEP.HoldTypeAttack   = "knife"

SWEP.SwingTime = 0.16
SWEP.Reach     = 56

SWEP.DecalLeaveBullethole = true
SWEP.DecalMakeBlood       = true
SWEP.DecalUse	          = false

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.BackKill = true

SWEP.KillFlags = KILL_SCRIPTED