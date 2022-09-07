AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Meat Cleaver"

SWEP.SelectIcon = Material("vgui/entities/mm_cleaver")
SWEP.Cost = 5
SWEP.Points = 40
SWEP.KillFeed = "%a showed %v what real cleavage looks like."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = false

SWEP.ViewModelFOV  = 40
SWEP.ViewModel			= "models/weapons/monstermash/v_cleaver.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_cleaver.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = false

SWEP.Slot = 3
SWEP.Base = "weapon_mm_basethrowable"

SWEP.Primary.Damage           = 25
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.Delay            = 0.5
SWEP.Primary.ProjectileEntity = "sent_mm_cleaver"

SWEP.EntSpin = true

SWEP.AnimDraw  = ACT_VM_DRAW
SWEP.AnimHold  = ACT_VM_PULLPIN
SWEP.AnimThrow = ACT_VM_THROW
