SWEP.SelectIcon = "vgui/entities/mm_undertaker"
SWEP.Cost = 30
SWEP.Points = 25

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_thompson" )

game.AddAmmoType( { 
 name = "ammo_thompson",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

SWEP.PrintName = "Undertaker"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_undertaker.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_undertaker.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = true

SWEP.HoldType = "ar2" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = Sound("weapons/thompson/nailgun_quiet.wav") 
SWEP.Primary.Sound2 = Sound("weapons/thompson/nailgun.wav") 
SWEP.Primary.Damage = 9
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 32
SWEP.Primary.Ammo = "ammo_thompson"
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Spread = 0.4
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Delay = 0.09
SWEP.Primary.Force = 2

SWEP.Secondary.Delay = 1
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CSMuzzleFlashes = true
SWEP.IsPistol = false

SWEP.UseDistance = true
SWEP.ShootDistance = 896

SWEP.TracerThing = "undertakertracer"

function SWEP:PrimaryAttack()

	if self:GetNextPrimaryFire() > CurTime() then return end
	
	if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
	else
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
            self.Owner:SetVelocity(-self.Owner:GetVelocity())
        end
		self:SetGun_FakeTimer1(CurTime()+0.5)
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = 1
		bullet.Src = pos
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
		bullet.Tracer = 1
		if self.UseDistance then
			bullet.Distance = self.ShootDistance
		end
		bullet.TracerName = "undertakertracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
		end

		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound),140) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
        
		self:TakePrimaryAmmo(1) 
		
		if self.Owner:GetNWFloat("Bloodied") > CurTime() then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
            self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay*4 ) 
            self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
		else
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
	end
end 

function SWEP:SecondaryAttack()

	if self:GetNextSecondaryFire() > CurTime() then return end
	
	if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
	else
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
            self.Owner:SetVelocity(-self.Owner:GetVelocity())
        end
		self:SetGun_FakeTimer1(CurTime()+0.5)
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = math.min(self:Clip1(),16)
		bullet.Src = pos
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*2
		bullet.Tracer = 1
		if self.UseDistance then
			bullet.Distance = self.ShootDistance
		end
		bullet.TracerName = "undertakertracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage/2
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetInflictor(self)
		end

		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound2),140) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*10*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
        
		self:TakePrimaryAmmo(math.min(self:Clip1(),16)) 
		
		if self.Owner:GetNWFloat("Bloodied") > CurTime() then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
            self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay*4 ) 
            self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
		else
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
	end
end 