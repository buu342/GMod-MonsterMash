SWEP.SelectIcon = "vgui/entities/mm_colt"
SWEP.Cost = 25
SWEP.Points = 40

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )


/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Pistol"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_pistol.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_pistol.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "revolver" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/colt/colt_fire.wav" 
SWEP.Primary.Damage = 20
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = "ammo_colt"
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Spread = 0.165
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.2875
SWEP.Primary.Delay = 0.35
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseDistance = true
SWEP.ShootDistance = 896

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if SERVER then
	local effectdata = EffectData()
	local pos = self.Owner:GetShootPos()
	pos = pos + self.Owner:GetForward() * 35
	pos = pos + self.Owner:GetRight() * 2
	pos = pos + self.Owner:GetUp() * -2
	effectdata:SetOrigin(pos)
	effectdata:SetAttachment( self:LookupAttachment("muzzle") )
	util.Effect( "mm_muzzle", effectdata )
	end

end