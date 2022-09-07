AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Butcher Knife"

SWEP.SelectIcon = Material("vgui/entities/mm_knife")
SWEP.Cost = 5
SWEP.Points = 75
SWEP.KillFeed = "%a made a jack o' lantern out of %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_knife.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_knife.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 15
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 0.6
SWEP.Primary.SwingHitSound  = Sound("weapons/knife/ree.wav")
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")

SWEP.HoldType         = "knife" 
SWEP.HoldTypeAttack   = "knife"

SWEP.SwingTime = 0.16
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = true
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= false

SWEP.BleedChance     = 35
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.BackDoubleDamage = true
SWEP.BackBleed = true