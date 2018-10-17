SWEP.SelectIcon = "vgui/entities/mm_repeater"
SWEP.Cost = 40

game.AddAmmoType( { 
 name = "ammo_repeater",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Repeater"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_repeater.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_repeater.mdl"
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

SWEP.Primary.Sound = "weapons/repeater/fire.wav" 
SWEP.Primary.Damage = 35
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 10 
SWEP.Primary.Ammo = "ammo_repeater"
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Spread = 0.15
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsPistol = false

SWEP.ReloadAmmoTime = 0.7 -- When does the ammo appear in the mag?

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"MM_ReloadTimer")
    self:NetworkVar("Float",3,"MM_ReloadGiveAmmo")
    self:NetworkVar("Float",4,"MM_StartShotgunReload")
	self:NetworkVar("Float",5,"Gun_Charge")
    self:NetworkVar("Bool",0,"MM_Reloading")
    self:NetworkVar("Bool",1,"MM_CanCancelReloading")
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
	
	if self.Owner:KeyDown(IN_ATTACK2) && self:GetNextPrimaryFire() < CurTime() && self:Clip1() >= 3 then
		if self:GetGun_Charge() == 0 then
			self.Owner:SetFOV(40, 1.5)
		end
		if self:GetGun_Charge() < 8 then
			self:SetGun_Charge(self:GetGun_Charge()+0.1)
			//self.Owner:ChatPrint(math.floor(self.Primary.Damage + self.Primary.Damage*(self:GetGun_Charge()/8)))
		end
		self.Owner:SetWalkSpeed(1)
		self.Owner:SetRunSpeed(1)
	end
	if (self.Owner:KeyReleased(IN_ATTACK2) && self:GetGun_Charge() != 0) || self.Owner:IsOnGround() == false then
		if self.Owner:IsOnGround() then
			self:Shoot()
		end
		self.Owner:SetFOV(0, 0)
		self:SetGun_Charge(0)
	end
    
    self:DoMyReload()
	self:LegsDismembered()
end

function SWEP:PrimaryAttack()
	if self:GetGun_Charge() != 0 then return end
	if self:GetMM_Reloading() && self:GetMM_CanCancelReloading() == true then
        self:FinishMyReload()
    end
	if ( !self:CanPrimaryAttack() ) || !self.Owner:OnGround() then return end
	if self:GetMM_Reloading() == true then return end
    
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
    
	self:SetGun_FakeTimer1(CurTime()+0.5)
	 
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
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
	if self.Owner:GetNWFloat("Bloodied") > CurTime() then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
		self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
	else
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
end 
 


function SWEP:Reload() 
end

function SWEP:StartMyReload()
    self:SetMM_Reloading(true)
	self.Owner:SetAmmo(self.Primary.DefaultClip+5, self:GetPrimaryAmmoType())
    self:SetMM_CanCancelReloading(false)
    self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    self:SetMM_StartShotgunReload(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

function SWEP:DoMyReload()
    if self:GetMM_StartShotgunReload() < CurTime() && !(self:GetMM_StartShotgunReload() == 0) then
        self:SetMM_CanCancelReloading(true)
        self:SetMM_StartShotgunReload(0)
        if self:Clip1() == self.Primary.ClipSize then
            self:FinishMyReload()
        else
           self:SendWeaponAnim(ACT_VM_RELOAD)
           self:SetMM_ReloadGiveAmmo(CurTime() + self.Owner:GetViewModel():SequenceDuration()*self.ReloadAmmoTime)
           self:SetMM_StartShotgunReload(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            if self.Owner:GetNWInt("LegMissing") == 3 then
                self.Owner:SetWalkSpeed(85)
                self.Owner:SetRunSpeed(85)
            else
                self.Owner:SetWalkSpeed(self.ReloadSpeed)
                self.Owner:SetRunSpeed(self.ReloadSpeed)
            end
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

function SWEP:Shoot()
	if self:GetMM_Reloading() && self:GetMM_CanCancelReloading() == true then
        self:FinishMyReload()
		return
    end
	if self:GetNextPrimaryFire() > CurTime() then return end
	
	if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
	else
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = pos
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
		bullet.Spread = 0.1 + 0.05*(1 - self:GetGun_Charge()/8)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
		bullet.Tracer = 1
		bullet.TraceName = "Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = math.floor(self.Primary.Damage + self.Primary.Damage*(self:GetGun_Charge()/8))
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
			if ( SERVER && tr.Hit ) && tr.Entity:IsPlayer() && tr.Entity:Team() != attacker:Team() then
				local chance = math.random(1,10)
				if chance == 1 then
					local phys = tr.Entity:GetPhysicsObject()
					if ( IsValid( phys ) ) then
						local dir = attacker:GetAimVector()-Vector(0,0,attacker:GetAimVector().z)
						dir:Normalize()
						tr.Entity:SetVelocity(dir*300)
					end
				end
			end
		end
		
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
		self:ShootEffects()
		 
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound),140) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
		self:TakePrimaryAmmo(3) 
		
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetGun_Charge() > 0 && self.Owner:KeyDown(IN_ATTACK2) then
		return (math.min((9 - self:GetGun_Charge())/5,1))
	else
		return 1
	end
end

function SWEP:Holster()
	if IsValid(self.Owner) then 
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
		self:SetGun_FakeTimer1(0)
		self:SetGun_FakeTimer2(0)
		self.Owner:SetFOV(0, 0)
		self:SetGun_Charge(0)
		return true
	end
end
