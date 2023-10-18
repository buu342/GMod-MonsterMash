AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Acid Flask"

SWEP.SelectIcon = Material("vgui/entities/mm_acidflask")
SWEP.Cost = 30
SWEP.Points = 20
SWEP.KillFeed = "%a handed %v some corrosive materials."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/c_acid.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_acid_flask.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 100
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_acidflask"

SWEP.AnimHold  = ACT_VM_HAULBACK
SWEP.AnimThrow = ACT_VM_THROW
