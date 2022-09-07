AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Axe"

SWEP.SelectIcon = Material("vgui/entities/mm_axe")
SWEP.Cost = 25
SWEP.Points = 40
SWEP.KillFeed = "%a had a question for %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_axe.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_axe.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 37
SWEP.Primary.Recoil         = Angle(0,2,0)
SWEP.Primary.Delay          = 1.4
SWEP.Primary.SwingSound     = Sound("crowbar/iceaxe_swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/axe/hit1.wav"), Sound("weapons/axe/hit2.wav"), Sound("weapons/axe/hit3.wav")}

SWEP.HoldType         = "melee2" 
SWEP.HoldTypeAttack   = "melee2"

SWEP.SwingTime = 0.35
SWEP.Reach     = 70

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood       = true
SWEP.DecalUse	          = true
SWEP.DecalDirection       = 1
SWEP.DecalSpeed           = 0.03

SWEP.BleedChance     = 35
SWEP.ConcussChance   = 35
SWEP.DismemberChance = 35
SWEP.BurnChance      = 0

SWEP.KillFlags = KILL_DECAPITATE

SWEP.BackBleed = true
SWEP.BackConcuss = true