SWEP.SelectIcon = "vgui/entities/mm_sawblade"
SWEP.Cost = 60
SWEP.Points = 10

game.AddAmmoType( { 
 name = "ammo_crossbow",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Sawblade Launcher"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_sawblade_launcher.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_sawblade_launcher.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "shotgun" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/crossbow/fire.wav" 
SWEP.Primary.Damage = 50
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "ammo_crossbow"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Delay = 0.22
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ShootDistance = 1200

function SWEP:PrimaryAttack()
	
	if ( !self:CanPrimaryAttack() ) || !self.Owner:OnGround() then return end
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
    self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
    self:EmitSound(self.Primary.Sound)
	if self.Owner:GetNWFloat("Bloodied") > CurTime() then
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
	self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
	else
	self.Owner:GetViewModel():SetPlaybackRate( 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
    self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER then
		local Arrow = ents.Create("ent_sawblade")
		local eAng = self.Owner:EyeAngles()

		Arrow:SetPos(self.Owner:GetShootPos() - eAng:Right()*-2)
		Arrow:SetOwner(self.Owner)
        Arrow:SetNWEntity("OriginalOwner", self.Owner)
		Arrow:SetAngles(eAng)
		Arrow.ArrowType = self.ArrowType
        Arrow.Inflictor = self
		Arrow:Spawn()
		Arrow:SetVelocity(Arrow:GetForward()*3500)
        Arrow:SetNWVector("OriginalSpeed", Arrow:GetForward()*3500)
        Arrow:SetNWAngle("OriginalAngle", eAng)
		Arrow:SetGravity(Lerp(80/100, 1.1, 0.0655))
	end
    local rnda = self.Primary.Recoil * -1 
    local rndb = self.Primary.Recoil * math.random(-1, 1) 
    self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
end