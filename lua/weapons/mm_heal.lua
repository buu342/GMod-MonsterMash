SWEP.SelectIcon = "vgui/entities/mm_thompson"

SWEP.PrintName = "Heal"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash"

SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/monstermash/c_candycorn.mdl" 
SWEP.WorldModel = ""
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 6
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = true

SWEP.HoldType = "normal" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = Sound("weapons/thompson/ump45-1.wav") 
SWEP.Primary.Damage = 12
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "ammo_thompson"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0.15
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Delay = 0.115
SWEP.Primary.Force = 2

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CSMuzzleFlashes = true
SWEP.IsPistol = false

SWEP.UseDistance = true
SWEP.ShootDistance = 768

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"FakeTimer1")
    self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Int",0,"State")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Deploy()
	self:SetState(0)
	self:SetFakeTimer1(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Owner:GetViewModel( ):SetPlaybackRate( 1 )
	self.Owner:GetViewModel():SetSequence( "Draw" )	
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    else
        self.Owner:SetWalkSpeed(self.ShootSpeed)
        self.Owner:SetRunSpeed(self.ShootSpeed)
    end
end

function SWEP:Holster()
	if IsValid(self.Owner) && self:GetState() == 7 then 
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
		return true
	end
end

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
	if self:GetState() == 0 && self:GetFakeTimer1() < CurTime() then
		self.Owner:GetViewModel( ):SetPlaybackRate( 1.5 )
		self.Owner:GetViewModel():SetSequence( "Pills" )
		self:SetState(1)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(0,-2,0))
	end
	
	if self:GetState() == 1 && self:GetFakeTimer1() < CurTime() then
		self:SetState(2)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(0,1,0))
	end
	if self:GetState() == 2 && self:GetFakeTimer1() < CurTime() then
		self:SetState(3)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(0,1,0))
	end
	if self:GetState() == 3 && self:GetFakeTimer1() < CurTime() then
		self:SetState(4)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(2,2,0))
	end
	if self:GetState() == 4 && self:GetFakeTimer1() < CurTime() then
		self:SetState(5)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(2,2,0))
	end
	if self:GetState() == 5 && self:GetFakeTimer1() < CurTime() then
		self:SetState(6)
		self:SetFakeTimer1(CurTime() + 0.3)
		self.Owner:ViewPunch(Angle(-5,0,0))
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + 35, 0, self.Owner:GetMaxHealth()))
	end
	if self:GetState() == 6 && self:GetFakeTimer1() < CurTime() then
		self:SetState(7)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
        self.Owner:EmitSound("weapons/healing/nom.wav", 75, 100, 0.5, CHAN_VOICE2)
		if SERVER then
            self.Owner:SelectWeapon(self.Owner:GetNWString("LastWeapon"))
			self:Remove()
		end
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

function SWEP:PrimaryAttack()
end

function SWEP:OnDrop()
	self:Remove()
end