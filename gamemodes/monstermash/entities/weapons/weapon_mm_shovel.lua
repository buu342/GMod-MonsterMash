AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Shovel"

SWEP.SelectIcon = Material("vgui/entities/mm_shovel")
SWEP.Cost = 15
SWEP.Points = 75
SWEP.KillFeed = "%a dug %v's grave."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_shovel.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_shovel.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 28
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 1.1
SWEP.Primary.SwingSound     = Sound("weapons/shovel/swing.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/shovel/hit1.wav"), Sound("weapons/shovel/hit2.wav"), Sound("weapons/shovel/hit3.wav")}

SWEP.HoldType         = "melee2" 
SWEP.HoldTypeAttack   = "melee2"

SWEP.SwingTime = 0.4
SWEP.Reach     = 80

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = false
SWEP.DecalUse	= false

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 45
SWEP.DismemberChance = 0

SWEP.KillFlags = KILL_GRAVE

SWEP.BackConcuss = true