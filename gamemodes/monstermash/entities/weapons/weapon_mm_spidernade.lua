AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Spider 'Nade"

SWEP.SelectIcon = Material("vgui/entities/mm_spidernade")
SWEP.Cost = 20
SWEP.Points = 20
SWEP.KillFeed = "%a exploited %v's arachnophobia."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/c_webnade.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_webgrenade.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 24
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_spidernade"

SWEP.AnimHold  = ACT_VM_HAULBACK
SWEP.AnimThrow = ACT_VM_THROW
