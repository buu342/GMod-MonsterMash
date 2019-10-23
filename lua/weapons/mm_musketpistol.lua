SWEP.SelectIcon = "vgui/entities/mm_musketpistol"
SWEP.Cost = 40
SWEP.Points = 40

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairRechargeMaterial = Material( "vgui/hud/crosshair_carbine" )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Dueling Pistol"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_musketpistol.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_musketpistol.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "pistol" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/musket/sawedoff-1.wav" 
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1 
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.05
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 6
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ShootDistance = 1536

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"DuelGun_Charge")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:SetDuelGun_Charge(0)
	self:SetNextPrimaryFire(CurTime()+1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end

function SWEP:PrimaryAttack()	
    return false
end 

function SWEP:Initialize()
    util.PrecacheSound(self.Primary.Sound) 
	self:SetWeaponHoldType( self.HoldType )
	self.Owner:SetNWFloat("mm_musketpistol_recharge", 0)
    self:SetDuelGun_Charge(0)
	if CLIENT then
		self.JumpTime = 0
		self.LandTime = 0
	end
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
        if self.Owner:KeyDown(IN_DUCK) || self.Owner:KeyPressed(IN_RELOAD) then
        self:SetHoldType("ar2")
        else
        self:SetHoldType("rpg")
        end
    end
	
	if !self.Owner:IsOnGround() then
		self:SetDuelGun_Charge(0)
	end
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:SetDuelGun_Charge(0)	
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
		self:SetNextPrimaryFire(CurTime()+0.5)
	elseif self.Owner:KeyDown(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self:Clip1() > 0 then
		if self:GetDuelGun_Charge() <= 115 then
			self:SetDuelGun_Charge(self:GetDuelGun_Charge()+1)
		end
		self.Owner:SetWalkSpeed(1)
		self.Owner:SetRunSpeed(1)
	elseif self.Weapon:Clip1() <= 0 && self.Owner:KeyPressed(IN_ATTACK) then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,CHAN_ITEM)
	end
	if self.Weapon:Clip1() > 0 && self.Owner:KeyReleased(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self:GetDuelGun_Charge() > 0 then
		if !self.Owner:OnGround() then return end

		self:SetGun_FakeTimer1(CurTime()+0.5)
		
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = self.Owner:GetShootPos() 
		bullet.Dir = self.Owner:GetAimVector() 
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 1
		bullet.Distance = self.ShootDistance
		bullet.TraceName = "Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage + self:GetDuelGun_Charge()*0.7
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_BULLET)
		end

		self:SetDuelGun_Charge(0)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
		self:ShootEffects()
		
		self.Owner:SetNWFloat("mm_musketpistol_recharge", CurTime()+20)
		 
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound),140) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		 
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
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

function SWEP:FireAnimationEvent(pos,ang,event)
	if (event==5001) then 
		if IsValid(self.Owner) && IsValid(self.Owner:GetViewModel()) then
			local effectdata = EffectData()
			local pos = self.Owner:GetViewModel():GetAttachment(self.Owner:GetViewModel():LookupAttachment("1"))
			local offset = pos.Ang:Right() * 0 + pos.Ang:Forward() * 0 + pos.Ang:Up() * 10
			effectdata:SetOrigin( pos.Pos + offset )
			util.Effect( "mm_muzzle", effectdata )
		end
	end
end

function SWEP:Reload()
end

hook.Add("StartCommand", "DisableCrouchWithMusket", function( ply, cmd )

    if IsValid(ply) && ply:Alive() && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon() != nil && ply:GetActiveWeapon():GetClass() == "mm_musketpistol" && ply:GetActiveWeapon():GetDuelGun_Charge() != 0 then
        cmd:RemoveKey(IN_DUCK)
    end

end)