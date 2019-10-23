SWEP.SelectIcon = "vgui/entities/mm_minigun"
SWEP.Cost = 65
SWEP.Points = 10

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_thompson" )

game.AddAmmoType( { 
 name = "ammo_thompson",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

SWEP.PrintName = "Minigun"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_minigun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_minigun.mdl"
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

SWEP.Primary.Sound = Sound("weapons/minigun/minigun_fire.wav") 
SWEP.Primary.Damage = 2
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 100
SWEP.Primary.Ammo = "ammo_thompson"
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Spread = 0.75
SWEP.Primary.NumberofShots = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Delay = 0.0375
SWEP.Primary.Force = 2

SWEP.Secondary.Delay = 1
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CSMuzzleFlashes = true
SWEP.IsPistol = false

SWEP.UseDistance = true
SWEP.ShootDistance = 1536

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_CanShootTimer")
	self:NetworkVar("Float",3,"Gun_Windup")
	self:NetworkVar("Float",4,"Gun_AmmoGive")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif (self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1()) || self:GetGun_Windup() != 0 then
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
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self:SetHoldType("duel")
        elseif self.Owner:KeyDown(IN_DUCK) || self.Owner:KeyPressed(IN_RELOAD) then
            self:SetHoldType("ar2")
		elseif self.Owner:GetActiveWeapon():GetClass() == "mm_coachgun" then
            self:SetHoldType("shotgun")
        elseif self.Owner:GetActiveWeapon():GetClass() == "mm_minigun" then
            self:SetHoldType("crossbow")
        else
            self:SetHoldType("rpg")
        end
    end
    
    if (self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2)) && self:GetGun_Windup() == 0 then
        self:SetGun_Windup(CurTime() + 1)
        self:EmitSound("weapons/minigun/minigun_wind_up.wav", 75, 85)
        self:SendWeaponAnim( ACT_VM_RECOIL3 )
    elseif (self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2)) && self:GetGun_Windup() > CurTime() then
    
    elseif (self.Owner:KeyDown(IN_ATTACK2) && self:GetGun_Windup() < CurTime()) && !self.Owner:KeyDown(IN_ATTACK) then
        self:EmitSound("weapons/minigun/minigun_spin.wav")
    elseif !(self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2)) && self:GetGun_Windup() != 0  then
        self:EmitSound("weapons/minigun/minigun_wind_down.wav", 75, 90)
        self:SetGun_Windup(0)
    elseif !(self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2)) && self:GetGun_Windup() == 0 then
        if self:Clip1() < self.Primary.DefaultClip && self:GetGun_AmmoGive() < CurTime() then
            self:SetGun_AmmoGive(CurTime()+0.1)
            self:SetClip1(self:Clip1()+1)
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

function SWEP:Reload()
end

function SWEP:PrimaryAttack()

	if self:GetNextPrimaryFire() > CurTime() then return end
    
    self.Owner:SetWalkSpeed(self.ShootSpeed)
    self.Owner:SetRunSpeed(self.ShootSpeed)
    
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
        self.Owner:SetVelocity(-self.Owner:GetVelocity())
    end
    
    if self:GetGun_Windup() != 0 && self:GetGun_Windup() < CurTime() then
        if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
            self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
            self:SetNextPrimaryFire( CurTime() + 0.2 )
        else
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
            if self.UseDistance then
                bullet.Distance = self.ShootDistance
            end
            bullet.TracerName = "Tracer"
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
            
            if self.Owner:GetNWFloat("Bloodied") > CurTime() then
                self:EmitSound(Sound(self.Primary.Sound),140, 50) 
            else
                self:EmitSound(Sound(self.Primary.Sound),140) 
            end
            
            self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
            
            self:TakePrimaryAmmo(1) 
            
            if self.Owner:GetNWFloat("Bloodied") > CurTime() then
                self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*12 )
                self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay*12 ) 
                self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
            else
                self.Owner:GetViewModel():SetPlaybackRate( 1 )
                self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
            end
            self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
        end
    end
end 

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if SERVER then
		local effectdata = EffectData()
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 0
		pos = pos + self.Owner:GetRight() * 0
		pos = pos + self.Owner:GetUp() * 0
		effectdata:SetOrigin(pos)
		effectdata:SetAttachment( self:LookupAttachment("1") )
		util.Effect( "mm_muzzle", effectdata )
	end

end
