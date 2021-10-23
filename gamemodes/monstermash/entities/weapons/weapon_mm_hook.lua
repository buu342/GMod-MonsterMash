AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Hook"

SWEP.SelectIcon = Material("vgui/entities/mm_hook")
SWEP.Cost = 15
SWEP.Points = 75
SWEP.KillFeed = "%a was %v's hooker."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_meathook.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_meathook.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 34
SWEP.Primary.Recoil         = Angle(2,-2,0)
SWEP.Primary.Delay          = 1.1
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("crowbar/crowbar_hit-1.wav"), Sound("crowbar/crowbar_hit-2.wav"), Sound("crowbar/crowbar_hit-3.wav"), Sound("crowbar/crowbar_hit-4.wav")}

SWEP.HoldType         = "melee" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = true
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= false

SWEP.BleedChance     = 20
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 20
SWEP.DismemberChance = 0

SWEP.BackDoubleDamage = true