AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Sickle"

SWEP.SelectIcon = Material("vgui/entities/mm_sickle")
SWEP.Cost = 20
SWEP.Points = 40
SWEP.KillFeed = "%a harvested %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel			= "models/weapons/monstermash/v_sickle.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_sickle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 25
SWEP.Primary.Recoil         = Angle(2,-2,0)
SWEP.Primary.Delay          = 1
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/sword/sword1.wav"), Sound("weapons/sword/sword2.wav"), Sound("weapons/sword/sword3.wav")}

SWEP.HoldType         = "knife" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood       = true
SWEP.DecalUse	          = true
SWEP.DecalDirection       = 1
SWEP.DecalSpeed           = 0.04

SWEP.BleedChance     = 25
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 25

SWEP.KillFlags = KILL_DECAPITATE

SWEP.BackBleed = true