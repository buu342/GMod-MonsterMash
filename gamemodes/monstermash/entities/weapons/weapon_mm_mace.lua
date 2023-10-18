AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Mace"

SWEP.SelectIcon = Material("vgui/entities/mm_mace")
SWEP.Cost = 30
SWEP.Points = 40
SWEP.KillFeed = "%a's mace was introduced to %v's face."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_mace.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_mace.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 60
SWEP.Primary.Recoil         = Angle(-2,2,0)
SWEP.Primary.Delay          = 1.5
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("crowbar/crowbar_hit-1.wav"), Sound("crowbar/crowbar_hit-2.wav"), Sound("crowbar/crowbar_hit-3.wav"), Sound("crowbar/crowbar_hit-4.wav")}

SWEP.HoldType         = "melee" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 64

SWEP.DecalLeaveBullethole = true
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= false

SWEP.BleedChance     = 60
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 60
SWEP.DismemberChance = 0

SWEP.BackBleed = true
SWEP.BackConcuss = true

SWEP.KillFlags = KILL_HEADEXPLODE