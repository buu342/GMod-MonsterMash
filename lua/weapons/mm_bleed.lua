SWEP.SelectIcon = "vgui/entities/mm_axe"

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable= false
SWEP.AdminSpawnable= false
SWEP.AdminOnly = false
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_axe.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_axe.mdl"
SWEP.HoldType 			= "melee2"

SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage		= 55
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Axe"			
SWEP.Slot				= 7
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.35
SWEP.Reach = 70
SWEP.HitSound1 = Sound("weapons/axe/hit1.wav")
SWEP.HitSound2 = Sound("weapons/axe/hit2.wav")
SWEP.HitSound3 = Sound("weapons/axe/hit3.wav")
SWEP.HitSound4 = Sound("weapons/axe/hit2.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")

function SWEP:Deploy()
    self.Owner:SelectWeapon("mm_candlestick")
end