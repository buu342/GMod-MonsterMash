SWEP.SelectIcon = "vgui/entities/mm_pumpshotgun"
SWEP.Cost = 30

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Pump-Action"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_pumpshotgun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_pumpshotgun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "ar2" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/pumpaction/fire.wav" 
SWEP.Primary.Damage = 7
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "ammo_shotgun"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.5
SWEP.Primary.NumberofShots = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 1
SWEP.Primary.BurstDelay = 0.3
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsPistol = false

SWEP.ReloadAmmoTime = 0.7 -- When does the ammo appear in the mag?
SWEP.ReloadSpeed = 120

SWEP.UseDistance = true
SWEP.ShootDistance = 640

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"MM_ReloadTimer")
    self:NetworkVar("Float",3,"MM_ReloadGiveAmmo")
    self:NetworkVar("Float",4,"MM_StartShotgunReload")
    self:NetworkVar("Bool",0,"MM_Reloading")
    self:NetworkVar("Bool",1,"MM_CanCancelReloading")
	self:NetworkVar("Int",0,"BurstCount")
    self:NetworkVar("Bool",2,"Gun_MessWithArmStuff")
end

function SWEP:Think()
	if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
		self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
	elseif self:GetMM_Reloading() == true || (self:GetGun_FakeTimer2() > 0 && CurTime() < self:GetGun_FakeTimer2()) then
		self.Owner:SetWalkSpeed(self.ReloadSpeed)
		self.Owner:SetRunSpeed(self.ReloadSpeed)
	else
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end
    if !self.IsPistol then
        if self.Owner:KeyDown(IN_DUCK) || self.Owner:KeyPressed(IN_RELOAD) then
        self:SetHoldType("ar2")
        else
        self:SetHoldType("rpg")
        end
    end
    if self.Owner:KeyPressed(IN_RELOAD) && CurTime() > self:GetNextPrimaryFire() && !self:GetMM_Reloading() == true && self.Weapon:Clip1() < self.Primary.ClipSize then
        self:SetMM_Reloading(true)
        self:StartMyReload()
    end
    
	self:LegsDismembered()
	
    if self:GetMM_ReloadTimer() < CurTime() && !(self:GetMM_ReloadTimer() == 0) then
        self:SetMM_Reloading(false)
        self:SetMM_ReloadTimer(0)
        self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
    end
    
    if self:GetMM_ReloadGiveAmmo() < CurTime() && !(self:GetMM_ReloadGiveAmmo() == 0) then
        local ammo = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
        if ammo > 0 then
            self.Owner:RemoveAmmo( 1, self.Weapon:GetPrimaryAmmoType() )
            self.Weapon:SetClip1(self:Clip1()+1)
            self:SetMM_ReloadGiveAmmo(0)
        end
    end
	
	if self.Owner:KeyDown(IN_ATTACK2) && (self:GetBurstCount() == 1 || self:GetBurstCount() == 2) && self:Clip1() > 1 then
		if self:GetNextPrimaryFire() < CurTime() then
			self:ShootBurst()
			self:SetBurstCount((self:GetBurstCount()+1)%3)
		end
	end
	
	if self.Owner:KeyPressed(IN_ATTACK2) && self:GetBurstCount() == 0 && self:Clip1() > 1 then
		if self:GetNextPrimaryFire() < CurTime() then
			self:ShootBurst()
			self:SetBurstCount(1)
		end
	elseif !self.Owner:KeyDown(IN_ATTACK2) then
		self:SetBurstCount(0)
	end
	
	if self.Primary.Spread > 0.5 then
		self.Primary.Spread = self.Primary.Spread*0.99
	end
    
    self:DoMyReload()
	self:LegsDismembered()
end

function SWEP:PrimaryAttack()

	if self:GetMM_Reloading() && self:GetMM_CanCancelReloading() == true then
        self:FinishMyReload()
    end
	if ( !self:CanPrimaryAttack() ) || !self.Owner:OnGround() then return end
	if self:GetMM_Reloading() == true then return end
    
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
    
	self.Primary.Spread = 0.5
	self:SetGun_FakeTimer1(CurTime()+0.5)
	 
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
	if self.UseDistance then
		bullet.Distance = self.ShootDistance
	end
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
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
	local delay
	if self:GetBurstCount() < 2 then
		delay = self.Primary.BurstDelay
	else
		delay = self.Primary.Delay 
	end
	 
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound),140) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	 
	if self.Owner:GetNWFloat("Bloodied") > CurTime() then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
		self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
	else
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
end 

function SWEP:ShootBurst()

	if self:GetMM_Reloading() && self:GetMM_CanCancelReloading() == true then
        self:FinishMyReload()
    end
	if ( !self:CanPrimaryAttack() ) || !self.Owner:OnGround() then return end
	if self:GetMM_Reloading() == true then return end
	self.Primary.Spread = 0.75
	self:SetGun_FakeTimer1(CurTime()+0.5)
	 
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
	if self.UseDistance then
		bullet.Distance = self.ShootDistance
	end
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.TraceName = "Tracer"
	bullet.Force = self.Primary.Force 
	bullet.Damage = 5
	bullet.AmmoType = self.Primary.Ammo 
	bullet.Callback = function(attacker, tr, dmginfo)
		dmginfo:SetInflictor(self)
	end

	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	local delay
	if self:GetBurstCount() < 2 then
		delay = self.Primary.BurstDelay
	else
		delay = self.Primary.Delay 
	end
	 
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound),140) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
	self:TakePrimaryAmmo(2) 
	 
	if self.Owner:GetNWFloat("Bloodied") > CurTime() then
		self:SetNextPrimaryFire( CurTime() + delay*4 )
		self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
	else
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self:SetNextPrimaryFire( CurTime() + delay )
	end
	self:SetNextSecondaryFire( CurTime() + delay ) 
end 
 
function SWEP:Reload() 
end

function SWEP:StartMyReload()
	self.Owner:SetAmmo(self.Primary.DefaultClip+5, self:GetPrimaryAmmoType())
    self:SetMM_Reloading(true)
    self:SetMM_CanCancelReloading(false)
    self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    self:SetMM_StartShotgunReload(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

function SWEP:DoMyReload()
    if self:GetMM_StartShotgunReload() < CurTime() && !(self:GetMM_StartShotgunReload() == 0) then
        self:SetMM_CanCancelReloading(true)
        self:SetMM_StartShotgunReload(0)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        end
        if self:Clip1() == self.Primary.ClipSize then
            self:FinishMyReload()
        else
            if self.Owner:GetNWInt("LegMissing") == 3 then
                self.Owner:SetWalkSpeed(85)
                self.Owner:SetRunSpeed(85)
            else
                self.Owner:SetWalkSpeed(self.ReloadSpeed)
                self.Owner:SetRunSpeed(self.ReloadSpeed)
            end
            self:SendWeaponAnim(ACT_VM_RELOAD)
            self:SetMM_ReloadGiveAmmo(CurTime() + self.Owner:GetViewModel():SequenceDuration()*self.ReloadAmmoTime)
            self:SetMM_StartShotgunReload(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        end
    end 
end

function SWEP:FinishMyReload()
    if (self:GetMM_Reloading() == true) then
        self:SetMM_StartShotgunReload(0)
        self:SetMM_ReloadGiveAmmo(0)
        self:SetMM_CanCancelReloading(false)
        self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
        self:SetMM_ReloadTimer(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    end
end