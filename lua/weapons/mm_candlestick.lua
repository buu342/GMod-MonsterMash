SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_candlestick.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_candlestick.mdl"
SWEP.HoldType 			= "slam"

SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage		= 12
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.62

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Candle Stick"			
SWEP.Slot				= 8
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.3
SWEP.Reach = 50
SWEP.HitSound1 = Sound("physics/plaster/ceiling_tile_impact_hard1.wav")
SWEP.HitSound2 = Sound("physics/plaster/ceiling_tile_impact_hard2.wav")
SWEP.HitSound3 = Sound("physics/plaster/ceiling_tile_impact_hard3.wav")
SWEP.HitSound4 = Sound("physics/plaster/ceiling_tile_impact_hard1.wav")
SWEP.MissSound = Sound("weapons/bone/swing1.wav")

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 0
SWEP.DismemberChance	= 0

function SWEP:PrimaryAttack()
    self:SetHoldType("melee")
    self:SetWeaponHoldType("melee")
    timer.Simple(0.2,function() if !IsValid(self) then return end self:SetHoldType("slam") self:SetWeaponHoldType("slam") end)
    self.Weapon:EmitSound(self.MissSound)
    self:SetFaketimer(CurTime() + self.TimeToHit)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
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
end

function SWEP:DamageStuff()
    if  CurTime() > self:GetFaketimer() && self:GetFaketimer() > 0 then 
        self:SetFaketimer(0)
        
      
        local tr = util.TraceLine( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Reach,
            filter = self.Owner,
            mask = MASK_SHOT_HULL
        } )

        if ( !IsValid( tr.Entity ) ) then 
            tr = util.TraceHull( {
                start = self.Owner:GetShootPos(),
                endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Reach,
                filter = self.Owner,
                mins = Vector( -10, -10, -8 ),
                maxs = Vector( 10, 10, 8 ),
                mask = MASK_SHOT_HULL
            } )
        end
        
        if tr.Hit then
            local g = math.random(1,4)
            if g == 1 then
            self.Weapon:EmitSound(self.HitSound1)
            elseif g == 2 then
            self.Weapon:EmitSound(self.HitSound2)
            elseif g == 3 then
            self.Weapon:EmitSound(self.HitSound3)
            else
            self.Weapon:EmitSound(self.HitSound4)
            end
            local dmginfo = DamageInfo()
                
            local attacker = self.Owner
            if ( !IsValid( attacker ) ) then attacker = self end
            dmginfo:SetAttacker( attacker )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamage( self.Primary.Damage )
            dmginfo:SetDamageForce( self.Owner:GetForward() * 5 )
            if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:GetClass() == "sent_skellington" || tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0  )) && IsFirstTimePredicted() then
                if self:Backstab() && tr.Entity:Health() - dmginfo:GetDamage() <= 0 then
                    self.Owner:SetNWBool("KillFromBackstab", true)
                end
                tr.Entity:TakeDamageInfo( dmginfo )
            end
            if SERVER then
                local g = math.random(1,8)
                if g == 1 then
                    if tr.Entity:IsPlayer() then
                    tr.Entity:Ignite(6)
                    end
					tr.Entity:SetNWFloat("MM_FireDuration", CurTime() + 6)
					tr.Entity:SetNWFloat("MM_FireTime", CurTime() + 0.1)
					tr.Entity:SetNWInt("MM_FireDamage", 3)
					tr.Entity:SetNWEntity("MM_FireOwner", self.Owner)
					tr.Entity:SetNWEntity("MM_FireInflictor", self)
                end
            end
        end
        if ( SERVER && IsValid( tr.Entity ) ) then
            local phys = tr.Entity:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:ApplyForceOffset( self.Owner:GetAimVector()  * self.Reach * phys:GetMass(), tr.HitPos )
            end
        end
        
    end
end