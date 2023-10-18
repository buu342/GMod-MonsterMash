AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Sword"

SWEP.SelectIcon = Material("vgui/entities/mm_sword")
SWEP.Cost = 30
SWEP.Points = 40
SWEP.KillFeed = "%a revealed to %v that they were not left-handed."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_sword.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_sword.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 50
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 1.1
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/sword/sword1.wav"), Sound("weapons/sword/sword2.wav"), Sound("weapons/sword/sword3.wav")}

SWEP.HoldType         = "knife" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.25
SWEP.Reach     = 80

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= true
SWEP.DecalDirection = -1
SWEP.DecalSpeed = 0.03

SWEP.BleedChance     = 30
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 75

SWEP.KillFlags = KILL_DECAPITATE

SWEP.BackDoubleDamage = true
SWEP.BackBifurcate = true