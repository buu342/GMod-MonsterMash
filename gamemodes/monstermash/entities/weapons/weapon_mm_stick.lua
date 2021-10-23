AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Cool Stick"

SWEP.SelectIcon = Material("vgui/entities/mm_stick")
SWEP.Cost = 0
SWEP.Points = 0
SWEP.KillFeed = "%a showed %v the cool stick they found at the park, thanks mom for taking me it was really fun."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_coolstick.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_coolstick.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 1337
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 0.8
SWEP.Primary.SwingSound     = Sound("weapons/sword/clang1.wav")
SWEP.Primary.SwingHitSound  = Sound("weapons/stick/clang2.wav")

SWEP.HoldType         = "melee" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.1
SWEP.Reach     = 140

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= true

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 20
SWEP.DismemberChance = 0

SWEP.KillFlags = KILL_GIB