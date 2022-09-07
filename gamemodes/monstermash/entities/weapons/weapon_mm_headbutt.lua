AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Headbutt"

SWEP.Points = 200
SWEP.KillFeed = "%a gave %v a killer headache."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel     = ""
SWEP.WorldModel    = ""
SWEP.ViewModelFOV  = 54
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 20
SWEP.Primary.Recoil         = Angle(10,0,0)
SWEP.Primary.Delay          = 0.62
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/bone/boner1.wav"), Sound("weapons/bone/boner2.wav")}

SWEP.HoldType         = "passive" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = false
SWEP.DecalUse	= false

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 100
SWEP.DismemberChance = 0
SWEP.DoViewPunch = true

function SWEP:ShouldDropOnDie() 
	return false
end