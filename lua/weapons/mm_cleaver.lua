SWEP.SelectIcon = "vgui/entities/mm_cleaver"
SWEP.Cost = 5

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 40
SWEP.ViewModel			= "models/weapons/monstermash/v_cleaver.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_cleaver.mdl"
SWEP.HoldType 			= "melee"


SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage		= 25
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "strider"
SWEP.Primary.Delay 			= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Meat Cleaver"			
SWEP.Slot			= 3
SWEP.SlotPos			= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.TimeToHit = 0.35
SWEP.Reach = 70
SWEP.HitSound1 = Sound("crowbar/crowbar_hit-1.wav")
SWEP.HitSound2 = Sound("crowbar/crowbar_hit-2.wav")
SWEP.HitSound3 = Sound("crowbar/crowbar_hit-3.wav")
SWEP.HitSound4 = Sound("crowbar/crowbar_hit-4.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")


function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
    self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"MM_PrimeTime")
    self:NetworkVar("Bool",0,"Primed")
    self:NetworkVar("Bool",1,"Gun_MessWithArmStuff")
end

function SWEP:Holster()
	if IsValid(self) && IsValid(self.Owner) then 
	self:SetPrimed(false)
	self:SetMM_PrimeTime(0)
    return true
	end
end
 
 
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
    self:SetWeaponHoldType( self.HoldType )
	self:SetNextPrimaryFire( CurTime()+1 )
	self.Owner:SetNWFloat("mm_cleaver_recharge", 0)
end
 
function SWEP:Deploy()
	self:SetPrimed(false)
	self:SetMM_PrimeTime(0)
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    self:SetWeaponHoldType(self.HoldType)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end
 
function SWEP:PrimaryAttack()
end
 
function SWEP:SecondaryAttack()
end
 
function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
end
 
function SWEP:Think()
	self:LegsDismembered()
	if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	if self.Weapon:Clip1() < 1 then
		self.Owner:GetViewModel():SetPlaybackRate( 0 )
		return
	elseif self.Owner:GetNWFloat("mm_cleaver_recharge") != 0 then
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:SetNextPrimaryFire(CurTime()+0.5)
		self.Owner:SetNWFloat("mm_cleaver_recharge",0)
	end
	
    if self.Owner:KeyPressed(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self:GetMM_PrimeTime() == 0 then
        self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
        self:SetGun_FakeTimer1(CurTime()+0.4)
    end
     
    if !self.Owner:KeyDown(IN_ATTACK) && self:GetPrimed() == true then
        self:SetPrimed(false)
		self:EmitSound("weapons/bone/swing1.wav")
        self.Weapon:SendWeaponAnim(ACT_VM_THROW)
        self.Weapon:SetGun_FakeTimer2(CurTime()+0.2)
        if SERVER then
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            local grenade = ents.Create("ent_cleaver")
     
            local pos = self.Owner:GetShootPos()
            pos = pos + self.Owner:GetForward() * 1
            pos = pos + self.Owner:GetRight() * 9
            pos = pos + self.Owner:GetUp() * 10
            grenade:SetPos(pos)
            grenade:SetAngles(Angle(self.Owner:GetAngles().p+90,self.Owner:GetAngles().y,0))
            grenade:SetOwner(self.Owner)
            grenade:Spawn()
            grenade:SetNWEntity("Cleaver_Inflictor",self)
            grenade:SetNWEntity("Cleaver_Attacker",self.Owner)
            grenade:Activate()
             
            local phys = grenade:GetPhysicsObject()
         
            self.Force = 10000
         
            phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))
 
            phys:AddAngleVelocity(Vector(0,1500,0))
        end
		self:TakePrimaryAmmo(1) 
        local rnda = self.Primary.Recoil * -1
        local rndb = self.Primary.Recoil * math.random(-1, 1)
        self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
		self.Owner:SetNWFloat("mm_cleaver_recharge", CurTime()+20)
		if SERVER then
			self.Owner:SelectWeapon("mm_candlestick")
			self.Owner:SelectWeapon(self.Owner:GetNWString("Melee"))
			self.Owner:SelectWeapon(self.Owner:GetNWString("Small"))
			self.Owner:SelectWeapon(self.Owner:GetNWString("Primary"))
		end
    end
   
    if self:GetGun_FakeTimer1() > 0 && CurTime() > self:GetGun_FakeTimer1() then
        self:SetPrimed(true)
        self:SetGun_FakeTimer1(0)
    end
    if self:GetGun_FakeTimer2() > 0 && CurTime() > self:GetGun_FakeTimer2() then
        self:SetGun_FakeTimer2(0)
    end
end

function SWEP:OnDrop()
	self.Owner = nil
	timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then  self:Remove() end end)
end