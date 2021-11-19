AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Chainsaw"

SWEP.SelectIcon = Material("vgui/entities/mm_chainsaw")
SWEP.Cost = 45
SWEP.Points = 20
SWEP.KillFeed = "%a massacred %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_chainsaw.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_chainsaw.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 30
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 1
SWEP.Primary.SwingSound     = Sound("weapons/chainsaw/swing.wav")
SWEP.Primary.SwingHitSound  = nil
SWEP.Primary.SwingHold      = true
SWEP.Primary.Automatic      = false
SWEP.Primary.LoopSound      = Sound("weapons/chainsaw/sawloop.wav")

SWEP.Secondary.Damage         = 3
SWEP.Secondary.Delay          = 0.0375

SWEP.AttackAnim = ACT_VM_HITCENTER

SWEP.HoldType         = "shotgun" 
SWEP.HoldTypeAttack   = "melee2"

SWEP.SwingTime = 0.2
SWEP.Reach     = 70

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= false

SWEP.BleedChance     = 100
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 100

SWEP.KillFlags = KILL_BIFURCATE
SWEP.BackKill = true

SWEP.EquipSound = Sound("Weapons/chainsaw/equip.wav")
SWEP.IdleSound = Sound("Weapons/chainsaw/idle.wav")