AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Candlestick"

SWEP.Points = 75
SWEP.KillFeed = "%a shed some light on %v's murder."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_candlestick.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_candlestick.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 12
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 0.62
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("physics/plaster/ceiling_tile_impact_hard1.wav"), Sound("physics/plaster/ceiling_tile_impact_hard2.wav"), Sound("physics/plaster/ceiling_tile_impact_hard3.wav")}

SWEP.HoldType         = "slam" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = false
SWEP.DecalUse	= false

SWEP.BleedChance     = 0
SWEP.BurnChance      = 13
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0