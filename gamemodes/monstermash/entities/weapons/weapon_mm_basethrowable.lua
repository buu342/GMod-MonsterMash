AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basebase" )

SWEP.PrintName = "Throwable base"
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel  = "models/weapons/monstermash/c_skull.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_skull.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
 
SWEP.UseHands = true

SWEP.Base = "weapon_mm_basebase"

SWEP.Primary.Damage           = 35
SWEP.Primary.ClipSize         = 1
SWEP.Primary.DefaultClip      = 1
SWEP.Primary.Ammo             = "None"
SWEP.Primary.Recoil           = Angle(0,0,0)
SWEP.Primary.ThrowSound       = Sound("weapons/bone/swing1.wav")
SWEP.Primary.ChargeAmount     = 1
SWEP.Primary.RechargeTime     = 15
SWEP.Primary.ProjectileEntity = "prop_physics"
SWEP.Primary.ProjectileForce  = 600
SWEP.Primary.ChargeForce      = 1100
SWEP.Primary.ChargeCrouch     = true
SWEP.Primary.HaulTime         = 0.1

/*------------------------------------------------
                Monster Mash Settings
------------------------------------------------*/

SWEP.KillFlags = 0

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairSize = 96
SWEP.CrosshairRechargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )
SWEP.CrosshairRechargeSize     = 96
SWEP.CrosshairRechargeType     = CHARGETYPE_BAR
SWEP.CrosshairRechargeColor    = Color(0,255,0, 100)
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )
SWEP.CrosshairChargeType       = CHARGETYPE_BAR
SWEP.CrosshairChargeColor      = Color(255,0,0, 100)
SWEP.CrosshairChargeSize       = 96

SWEP.EntSpin = false

SWEP.RunSpeed    = 220
SWEP.ShootSpeed  = SWEP.RunSpeed 

SWEP.HoldType         = "grenade" 
SWEP.HoldTypeAttack   = "grenade"

SWEP.AnimDraw  = ACT_VM_DRAW
SWEP.AnimHold  = ACT_VM_PULLPIN
SWEP.AnimThrow = ACT_VM_THROW

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 0, "MMBase_PrimeTime")
    self:NetworkVar("Bool", 0, "MMBase_Primed")
end

function SWEP:MM_SetAnimation(act)
    local vm = self.Owner:GetViewModel()
    if !IsValid(vm) then return end
    vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( act ) )
end

function SWEP:Holster(wep)
    self:SetMMBase_Primed(false)
    self:SetMMBase_Charge(0)
    self:SetMMBase_PrimeTime(0)
    if self.IdleSound != nil then
        self:EmitSound("empty.wav", 75, 100, 1, CHAN_VOICE2)
    end
    self.Owner.PrevWeapon = self
    return true
end

function SWEP:HandleHoldTypes()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
    BaseClass.Think(self)
        
    if self:GetMMBase_PrimeTime() < CurTime() && self:GetNextPrimaryFire() < CurTime() then
        if self.Owner:GetWeaponCooldown(self) > 0 then
            self:MM_SetAnimation( self.AnimDraw )
            self.Owner:GetViewModel():SetPlaybackRate( 0 )
            self:SetClip1(0)
            return
        elseif self:Clip1() == 0 then
            self.Owner:SetWeaponCooldown(self, 0)
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:MM_SetAnimation( self.AnimDraw )
            self:SetNextPrimaryFire(CurTime()+0.5)
            self:SetClip1(1)
            self:SetMMBase_PrimeTime(0)
        end
    end
    
    if (self.Owner:GetWeaponCooldown(self) == 0 && self.Owner:GetMoveType() != MOVETYPE_LADDER) then
        if self.Owner:KeyPressed(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self:GetMMBase_PrimeTime() == 0 && !self:GetMMBase_Primed() then
            self:MM_SetAnimation(self.AnimHold)
            self:SetMMBase_Primed(true)
            self:SetMMBase_PrimeTime(CurTime()+self.Primary.HaulTime)
        end
        
        if self.Owner:KeyDown(IN_ATTACK) && self:GetMMBase_Primed() then
            self:SetMMBase_Charge(self:GetMMBase_Charge()+self.Primary.ChargeAmount)
            if (self:GetMMBase_Charge() > 100) then
                self:SetMMBase_Charge(100)
            end
        end
         
        if !self.Owner:KeyDown(IN_ATTACK) && self:GetMMBase_Primed() && self:GetMMBase_PrimeTime() < CurTime() then
            self:MM_SetAnimation(self.AnimThrow)
            self:EmitSound(self.Primary.ThrowSound)
            self:SetMMBase_Primed(false)
            self:SetMMBase_PrimeTime(CurTime()+0.5)
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            timer.Simple(0, function() if !IsValid(self) || !IsValid(self.Owner) then return end self.Owner:SetWeaponCooldown(self, self.Primary.RechargeTime) end)
            self:SetNextPrimaryFire(CurTime()+0.5)
            self:ThrowEntity(self.Primary)
            self:SetMMBase_Charge(0)
            self:SetClip1(0)
        end
    end
end

function SWEP:ThrowEntity(mode, dropped)
    if CLIENT then return end 
    local ent = ents.Create( mode.ProjectileEntity )

    if ( !IsValid( ent ) ) then return end
    
    ent:SetOwner(self.Owner)
    ent:Spawn()
    ent.Force = mode.ProjectileForce + mode.ChargeForce*self:GetMMBase_Charge()/100
    ent.Inflictor = self
    ent.Owner = self.Owner
    if !dropped then
        ent:SetPos( self.Owner:EyePos() + (self.Owner:GetAimVector() * 1) )
        ent:SetAngles( self.Owner:EyeAngles() )
    else
        ent:SetPos( self:GetPos() )
        ent:SetAngles( self:GetAngles() )
    end
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then 
        if dropped then return end
        local velocity = self.Owner:GetAimVector()
        velocity = velocity * ent.Force
        phys:ApplyForceCenter( velocity )
        
        if self.EntSpin then
            phys:AddAngleVelocity(Vector(0,1500,0))
        end
    else
        ent:Remove()
    end
    
end

function SWEP:OnDrop()
	if self.Weapon:Clip1() > 0 && !self.Ownership:Alive() then
        self.Owner = self.Ownership
        self:SetOwner(self.Ownership)
        self.Primary.ProjectileForce = 0
        self.Primary.ChargeForce = 0
		self:ThrowEntity(self.Primary, true)
        self:SetNoDraw(true)
        timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then self:Remove() end end)
	else
		self.Owner = nil
		timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then self:Remove() end end)
	end
end