SWEP.SelectIcon = "vgui/entities/mm_chainsaw"
SWEP.Cost = 45
SWEP.Points = 20

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 70
SWEP.ViewModel			= "models/weapons/monstermash/v_chainsaw.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_chainsaw.mdl"
SWEP.HoldType 			= "shotgun"

SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage			= 30
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1.35

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Chainsaw"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.35
SWEP.Reach = 70
SWEP.HitSound1 = Sound("")
SWEP.HitSound2 = Sound("")
SWEP.HitSound3 = Sound("")
SWEP.HitSound4 = Sound("")
SWEP.MissSound = Sound("")

SWEP.MeleeDecal_LeaveBullethole = true
SWEP.MeleeDecal_Use	= false
SWEP.MeleeDecal_MakeBlood = false

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 100
SWEP.DismemberChance	= 100

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Faketimer")
	self:NetworkVar("Float",1,"Faketimer2")
	self:NetworkVar("Float",2,"Faketimer3")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Deploy()
	self:EmitSound("weapons/chainsaw/equip.wav")
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:SetNextPrimaryFire(CurTime()+1)
    self:SetFaketimer3(CurTime() + 1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end

function SWEP:OnDrop()
	self.Owner = nil
    if IsValid(self) then
        self:EmitSound("empty.wav")
    end
	timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then  self:Remove() end end)
end

function SWEP:Holster()
    if IsValid(self) then
        self:EmitSound("empty.wav")
    end
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

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self.Owner:GetNWFloat("MM_Charge") > CurTime() then
        self.Owner:SetWalkSpeed(self.ChargeSpeed)
        self.Owner:SetRunSpeed(self.ChargeSpeed)
        
        local tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + ( Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0) * 64 ),
            filter = self.Owner,
            mins = Vector( -10, -10, -10 ),
            maxs = Vector( 10, 10, 10 ),
            mask = MASK_SHOT_HULL
        } )
        if tr && tr.Hit && tr.Entity:IsPlayer() then
            self.Owner:SetNWFloat("MM_Charge", CurTime())
            self.Owner:SetVelocity(self.Owner:GetAimVector(), 0)
            if SERVER then
                self.Owner:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(80, 100), math.Rand(90, 120)) 
                tr.Entity:TakeDamage( 5, self.Owner, self )
                local shake = ents.Create( "env_shake" )
                shake:SetOwner(self.Owner)
                shake:SetPos( tr.HitPos )
                shake:SetKeyValue( "amplitude", "2500" )
                shake:SetKeyValue( "radius", "100" )
                shake:SetKeyValue( "duration", "0.5" )
                shake:SetKeyValue( "frequency", "255" )
                shake:SetKeyValue( "spawnflags", "4" )	
                shake:Spawn()
                shake:Activate()
                shake:Fire( "StartShake", "", 0 )
            end
        end
    else
        self.Owner:SetWalkSpeed(self.WalkSpeed)
        self.Owner:SetRunSpeed(self.WalkSpeed)
    end
    
    if self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 && CLIENT && self.Owner:GetNWInt("MM_AutoReload") == 1 then
        self.Owner:ConCommand("+reload")
        timer.Simple(0, function() if !IsValid(self.Owner) then return end self.Owner:ConCommand("-reload") end)
        return
    end
    
    if self.Owner:GetNWFloat("MM_Charge")+0.5 > CurTime() then
        self.Primary.Damage = self.OriginalDamage * 2
    else
        self.Primary.Damage = self.OriginalDamage
    end
    
    if self:GetFaketimer3() < CurTime() then
        self:EmitSound("weapons/chainsaw/idle.wav")
    end
    
    self:DamageStuff()
	self:LegsDismembered()
    self:DoOtherStuff()
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
    self:SetHoldType("melee2")
    self:SetWeaponHoldType("melee2")
    self:EmitSound("weapons/chainsaw/swing.wav")
    timer.Simple(0.5,function() if !IsValid(self) then return end self:SetHoldType("shotgun") self:SetWeaponHoldType("shotgun") end)
    self:SetFaketimer(CurTime() + self.TimeToHit)
	self:SetFaketimer2(CurTime() + self.TimeToHit/2)
	self:SetFaketimer3(CurTime() + self.Primary.Delay)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self.Owner:SetNWFloat("MeleeAttackAim", CurTime() +1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
end