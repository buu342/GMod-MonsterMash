AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Pumpkin 'Nade"

SWEP.SelectIcon = Material("vgui/entities/mm_pumpkinnade")
SWEP.Cost = 35
SWEP.Points = 20
SWEP.KillFeed = "%a played catch with %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 54
SWEP.ViewModel	   = "models/weapons/monstermash/c_pumpkin_nade.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_pumpkin_nade.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 200
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_pumpkinnade"
SWEP.Primary.HaulTime         = 1

SWEP.AnimHold  = ACT_VM_PULLPIN
SWEP.AnimThrow = ACT_VM_THROW

SWEP.KillFlags = KILL_GIBTHRESHOLD