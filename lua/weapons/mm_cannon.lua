SWEP.SelectIcon = "vgui/entities/mm_cannon"
SWEP.Cost = 70
SWEP.Points = 10

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairSize = 96
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )
SWEP.CrosshairChargeSize = 96

game.AddAmmoType( { 
 name = "ammo_cannon",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

SWEP.PrintName = "Cannon"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_cannon.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_cannon.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = true

SWEP.HoldType = "crossbow" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = Sound("weapons/cannon/cannon-1.wav") 
SWEP.Primary.Damage = 150
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1 
SWEP.Primary.Ammo = "ammo_cannon"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.18
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 10
SWEP.Primary.Delay = 0.12
SWEP.Primary.Force = 2

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CSMuzzleFlashes = true

SWEP.WalkSpeed = 175
SWEP.IsPistol = false

SWEP.ShootDistance = 1000

function SWEP:Initialize()
	if CLIENT then
		self.JumpTime = 0
		self.LandTime = 0
	end
	util.PrecacheSound(self.Primary.Sound) 
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Deploy()
	self:EmitSound("weapons/deploy.wav")
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self:SetGun_Charge(0)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true
end 

function SWEP:PrimaryAttack()
end

function SWEP:Think()

    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
		self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
	elseif self:GetGun_FakeTimer2() > 0 && CurTime() < self:GetGun_FakeTimer2() then
		self.Owner:SetWalkSpeed(self.ReloadSpeed)
		self.Owner:SetRunSpeed(self.ReloadSpeed)
	else
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end
    if CurTime() > self:GetGun_Reload() && self:GetGun_Reload() > 0 then
        self:SetGun_Reload(0)
        self:SendWeaponAnim(ACT_VM_DRAW)
        self:SetShield_Reloading(false)
        self:SetNextPrimaryFire( CurTime() + 1 )
        local ammo = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
        self.Owner:RemoveAmmo( self.Primary.ClipSize - self.Weapon:Clip1(), self.Weapon:GetPrimaryAmmoType() )
        if ammo > self.Primary.ClipSize then
            self.Weapon:SetClip1(self.Primary.ClipSize)
        else
            self.Weapon:SetClip1(math.min(self.Primary.ClipSize,self.Weapon:Clip1() + ammo))
        end
    end
	if self.Owner:KeyDown(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() > 0 && self.Owner:OnGround() then
        self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
		if self:GetGun_Charge() >= 5000 then
			self:SetGun_Charge(5000)
		else
			self:SetGun_Charge(self:GetGun_Charge()+45)
		end
	elseif self.Owner:KeyDown(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 && self.Owner:OnGround() then
		self:Reload()
	end
	
	if self.Owner:KeyReleased(IN_ATTACK) && self:GetGun_Charge() > 0 && self:GetNextPrimaryFire() < CurTime() then
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:ShootEffects()
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:EmitSound(self.Primary.Sound,75,100,1)
		if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        end
		if SERVER then
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			//self.Owner:ResetSequence("flinch_01")
			local grenade = ents.Create("ent_cannonball")
	 
			local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetForward() * 15
			pos = pos + self.Owner:GetRight() * 5
			pos = pos + self.Owner:GetUp() * 15
			
			grenade:SetPos(pos)
			grenade:SetAngles(Angle(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
			grenade:SetOwner(self.Owner)
			grenade.Owner = self.Owner
			grenade.Inflictor = self
			grenade:Spawn()
			grenade:Activate()
			 
			local phys = grenade:GetPhysicsObject()
		 
			phys:ApplyForceCenter((self.Owner:GetAimVector() * self:GetGun_Charge() * 1.2) + Vector(0, 0, 200))

			phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
		end
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
		self:SetGun_Charge(0)
	end
    
    if self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 && self.Owner:GetNWInt("MM_AutoReload") == 1 && self:GetGun_FakeTimer2() < CurTime() && self:GetGun_FakeTimer2() == 0 then
        self:Reload()
    end
    
    if self:GetGun_FakeTimer2() < CurTime() then
        self:SetGun_FakeTimer2(0)
    end
    
	if CLIENT then

		if !self.Owner:IsOnGround() then
			self.LandTime = RealTime() + 0.31
		end

		if (self.Owner:GetMoveType() == MOVETYPE_NOCLIP || self.Owner:GetMoveType() == MOVETYPE_LADDER || self.Owner:WaterLevel() > 1 ) || (self.LandTime < RealTime() && self.LandTime != 0) then
			self.LandTime = 0
			self.JumpTime = 0
		end

		if self.Owner:KeyDownLast( IN_JUMP ) then
			if self.JumpTime == 0 then
				self.JumpTime = RealTime() + 0.31
				self.LandTime = 0
			end
		end
	end
	self:LegsDismembered()
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if SERVER then
	local effectdata = EffectData()
	local pos = self.Owner:GetShootPos()
	pos = pos + self.Owner:GetForward() * 45
	pos = pos + self.Owner:GetRight() * 20
	pos = pos + self.Owner:GetUp() * -30
	effectdata:SetOrigin(pos)
	effectdata:SetAttachment( self:LookupAttachment("muzzle") )
	util.Effect( "mm_muzzle", effectdata )
	end

end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool",0,"Shield_Reloading")
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_Reload")
	self:NetworkVar("Float",3,"Gun_Charge")
    self:NetworkVar("Bool",1,"Gun_MessWithArmStuff")
end

function SWEP:Reload()
	if self:Clip1() < self:GetMaxClip1() && self:GetShield_Reloading() == false then
        self:SendWeaponAnim(ACT_VM_HOLSTER)
		self.Owner:SetAmmo(self.Primary.DefaultClip, self:GetPrimaryAmmoType())
		self:EmitSound("weapons/deploy.wav",75,100,1,CHAN_ITEM)
		timer.Simple(1,function() if !IsValid(self) then return end self:EmitSound("weapons/cannon/reload.wav") end)
        self:SetShield_Reloading(true)
		self:SetGun_FakeTimer2(CurTime()+0.5)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
        self:SetGun_Reload(CurTime()+2.5)
	end
end