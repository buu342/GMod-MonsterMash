SWEP.SelectIcon = "vgui/entities/mm_stick"

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_coolstick.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_coolstick.mdl"
SWEP.HoldType 			= "melee"


SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage		    = 1337
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Cool Stick"			
SWEP.Slot			= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.TimeToHit = 0.10
SWEP.Reach = 140
SWEP.HitSound1 = Sound("weapons/stick/clang2.wav")
SWEP.HitSound2 = Sound("weapons/stick/clang2.wav")
SWEP.HitSound3 = Sound("weapons/stick/clang2.wav")
SWEP.HitSound4 = Sound("weapons/stick/clang2.wav")
SWEP.MissSound = Sound("weapons/sword/clang1.wav")

SWEP.MeleeDecal_LeaveBullethole = false
SWEP.MeleeDecal_MakeBlood = true

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Faketimer")
	self:NetworkVar("Float",1,"Faketimer2")
	self:NetworkVar("Float",2,"Faketimer3")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Deploy()
	self:EmitSound("weapons/deploy.wav")
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:SetNextPrimaryFire(CurTime()+1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end

function SWEP:Holster()
	if IsValid(self) && IsValid(self.Owner) then 
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
        self:SetFaketimer(0)
        self:SetFaketimer2(0)

        
        return true
	end
end

function SWEP:SecondaryAttack()
    if self:GetFaketimer3() < CurTime() then
        self:SetFaketimer3(CurTime()+10)
        self:EmitSound("weapons/stick/griffisu.wav", 75, 100, 0.3)
        self.Owner:SetVelocity(Vector( self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0.125 )*2000)
        if SERVER then
            self.Trail = util.SpriteTrail(self.Owner, 1, Color(255,255,255), false, 75, 0, 1, 1/(75+0)*0.5,"trails/tube.vmt")
        end        
    end
end

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    else
        self.Owner:SetWalkSpeed(self.WalkSpeed)
        self.Owner:SetRunSpeed(self.WalkSpeed)
    end
    self:DamageStuff()
	self:LegsDismembered()
    self:DoOtherStuff()
    if self.Owner:OnGround() && SERVER && IsValid(self.Trail) then
        self.Trail:Remove()
    end
end