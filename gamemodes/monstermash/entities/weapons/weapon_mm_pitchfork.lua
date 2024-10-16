AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Pitch Fork"

SWEP.SelectIcon = Material("vgui/entities/mm_pitchfork")
SWEP.Cost = 25
SWEP.Points = 40
SWEP.KillFeed = "%a chased %v out of town."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_pitchfork.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_pitchfork.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 42
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 1
SWEP.Primary.SwingSound     = Sound("crowbar/iceaxe_swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/axe/hit1.wav"), Sound("weapons/axe/hit2.wav"), Sound("weapons/axe/hit3.wav")}

SWEP.HoldType         = "melee2" 
SWEP.HoldTypeAttack   = "knife"

SWEP.SwingTime = 0.3
SWEP.Reach     = 80

SWEP.DecalLeaveBullethole = true
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= false
SWEP.DecalCount = 4

SWEP.BleedChance     = 75
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.BackBleed = true