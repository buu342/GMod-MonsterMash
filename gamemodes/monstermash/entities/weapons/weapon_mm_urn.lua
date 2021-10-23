AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Haunted Urn"

SWEP.SelectIcon = Material("vgui/entities/mm_urn")
SWEP.Cost = 25
SWEP.Points = 20
SWEP.KillFeed = "%a scared %v to death."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/c_urn.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_urn.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 0
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_urn"

SWEP.AnimHold  = ACT_VM_HAULBACK
SWEP.AnimThrow = ACT_VM_THROW
