AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Skull"

SWEP.SelectIcon = Material("vgui/entities/mm_skull")
SWEP.Cost = 10
SWEP.Points = 40
SWEP.KillFeed = "%a recited Hamlet with %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/c_skull.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_skull.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 25
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_skull"


SWEP.AnimHold  = ACT_VM_HAULBACK
SWEP.AnimThrow = ACT_VM_THROW
