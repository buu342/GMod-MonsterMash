SWEP.SelectIcon = "vgui/entities/mm_battlerifle"
SWEP.Cost = 50
SWEP.Points = 25

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_BAR" )
SWEP.CrosshairSize = 34
SWEP.CrosshairChargeSize = 0
SWEP.CrosshairChargeMaterial = Material("")
SWEP.CrosshairRechargeMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairRechargeSize = 16

game.AddAmmoType( { 
 name = "ammo_battlerifle",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Battle Rifle"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_battlerifle.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_battlerifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "rpg" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/battlerifle/fire.wav" 
SWEP.Primary.Damage = 17
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 18
SWEP.Primary.Ammo = "ammo_battlerifle"
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Spread = 0.0675
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Delay = 0.7
SWEP.Primary.BurstDelay = 0.075
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsPistol = false

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",4,"Gun_FakeTimer3")
	self:NetworkVar("Float",0,"Gun_CanShootTimer")
	self:NetworkVar("Int",0,"BurstCount")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:PrimaryAttack()
end 

function SWEP:Deploy()
	self:SetBurstCount(0)
	self:SetNextPrimaryFire( CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:EmitSound("weapons/deploy.wav")
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
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
    if !self.IsPistol then
        if self.Owner:GetNWInt("ArmMissing") != 0 then
            self:SetHoldType("dual")
        elseif self.Owner:KeyDown(IN_DUCK) || self.Owner:KeyPressed(IN_RELOAD) then
            self:SetHoldType("ar2")
        else
            self:SetHoldType("rpg")
        end
    end
	
	if self:GetBurstCount() == 1 || self:GetBurstCount() == 2 then
		if self:GetNextPrimaryFire() < CurTime() then
			self:Shoot()
			self:SetBurstCount((self:GetBurstCount()+1)%3)
		end
	end
	
	if self.Owner:KeyPressed(IN_ATTACK) && self:GetBurstCount() == 0 then
		if self:GetNextPrimaryFire() < CurTime() then
			self:Shoot()
			self:SetBurstCount(1)
		end
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

function SWEP:ShootEffects2()

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:Shoot()
	if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextPrimaryFire( CurTime() + 0.3 )
	else
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        end
		self:SetGun_FakeTimer1(CurTime()+0.5)
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = pos
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
		bullet.Tracer = 1
		bullet.TraceName = "Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
		end

		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
		self:ShootEffects()
		 
		self.Owner:FireBullets( bullet ) 

		self:EmitSound(Sound(self.Primary.Sound),140) 

		self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		local delay
		if self:GetBurstCount() < 2 then
			delay = self.Primary.BurstDelay
		else
			delay = self.Primary.Delay 
		end
		
		if self.Owner:GetNWFloat("Bloodied") > CurTime() then
			self:SetNextPrimaryFire( CurTime() + delay*4 )
			self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
		else
			self.Owner:GetViewModel():SetPlaybackRate( 1 )
			self:SetNextPrimaryFire( CurTime() + delay )
		end

		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:GetNWFloat("Battlerifle_alt") > CurTime() then return end
	self:EmitSound("weapons/cannon/cannon-1.wav")
	if SERVER then
		self.Owner:SetNWFloat("Battlerifle_alt", CurTime()+20)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		local grenade = ents.Create("ent_smokenade")
 
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 1
		pos = pos + self.Owner:GetRight() * 9
	 
		if self.Owner:KeyDown(IN_SPEED) then
			pos = pos + self.Owner:GetUp() * -4
		else
			pos = pos + self.Owner:GetUp() * -1
		end
		grenade:SetPos(pos)
		grenade:SetAngles(Angle(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
		grenade:SetOwner(self.Owner)
        grenade:SetOwner(self.Owner)
        grenade.Own = self.Owner
        grenade:SetNWEntity("FlamethrowerDamageInflictor", self)
        grenade:Spawn()
        grenade:Activate()
        grenade:SetOwner(self.Owner)
		self:ShootEffects2()
		local phys = grenade:GetPhysicsObject()
	 
		self.Force = 2500
	 
		phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))

		phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
	end
	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) )
end

function SWEP:Reload()
	if self:Clip1() < self:GetMaxClip1() then
		self.Owner:SetAmmo(self.Primary.DefaultClip, self:GetPrimaryAmmoType())
        self.Weapon:DefaultReload( ACT_VM_RELOAD_EMPTY )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
            AnimationTime = self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate())
        end
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
        self:SetGun_FakeTimer2(CurTime() + AnimationTime)
        if self.Owner:GetNWInt("LegMissing") > 0  then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
        
	end
	self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD,  ACT_GESTURE_RELOAD_SMG1, true )
end

function SWEP:FireAnimationEvent(pos,ang,event)

	if (event==21) then 
		if IsValid(self.Owner) && IsValid(self.Owner:GetViewModel()) then
			local effectdata = EffectData()
			local vm = self.Owner:GetViewModel()
			if vm:GetAttachment(1) != nil then
				effectdata:SetOrigin( self.Owner:GetViewModel():GetAttachment(1).Pos )
				util.Effect( "mm_muzzle", effectdata )
			end
		end
	end

end
