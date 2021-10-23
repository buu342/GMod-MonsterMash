AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Scythe"

SWEP.SelectIcon = Material("vgui/entities/mm_scythe")
SWEP.Cost = 40
SWEP.Points = 20
SWEP.KillFeed = "%a guided %v's soul to the next realm."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_scythe.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_scythe.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 50
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 1.6
SWEP.Primary.SwingSound     = Sound("crowbar/iceaxe_swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/sword/sword1.wav"), Sound("weapons/sword/sword2.wav"), Sound("weapons/sword/sword3.wav")}

SWEP.HoldType         = "melee2" 
SWEP.HoldTypeAttack   = "melee2"

SWEP.SwingTime = 0.3
SWEP.Reach     = 100

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= true

SWEP.BleedChance     = 50
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 100

SWEP.KillFlags = KILL_BIFURCATE

SWEP.BackDoubleDamage = true