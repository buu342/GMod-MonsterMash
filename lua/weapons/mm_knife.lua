SWEP.SelectIcon = "vgui/entities/mm_knife"
SWEP.Cost = 10
SWEP.Points = 75

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_knife.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_knife.mdl"
SWEP.HoldType 			= "knife"

SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage			= 15
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.6

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Butcher Knife"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.16
SWEP.Reach = 64
SWEP.HitSound1 = Sound("weapons/knife/ree.wav")
SWEP.MissSound = Sound("weapons/bone/swing1.wav")

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 35
SWEP.DismemberChance	= 0

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
    self.Weapon:EmitSound(self.MissSound)
    self:SetFaketimer(CurTime() + self.TimeToHit)
    self.Owner:SetNWFloat("MeleeAttackAim", CurTime() +1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
	
	self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( ( "attack_stab" ) ))
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:DoOtherStuff()
	self.Owner:GetViewModel():SetPlaybackRate( 1.5 )
end

function SWEP:Backstab()
    local tr = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    } )

    if ( !IsValid( tr.Entity ) ) then 
        tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
            filter = self.Owner,
            mins = Vector( -10, -10, -8 ),
            maxs = Vector( 10, 10, 8 ),
            mask = MASK_SHOT_HULL
        } )
    end
	
    if tr.Hit && IsValid( tr.Entity ) && (tr.Entity:IsPlayer() && (math.abs(math.AngleDifference(tr.Entity:GetAngles().y,self.Owner:GetAngles().y)) <= 50)) then
		//self.Owner:SetVelocity(Vector( self.Owner:GetAimVector(), self.Owner:GetAimVector(), 0 )*500)
        return true
    else
        return false
    end
end

function SWEP:DamageStuff()

	if self.Owner:GetNWFloat("LastKeyDown4") > CurTime() or self.Owner:GetNWFloat("LastKeyDown3") > CurTime() or self.Owner:GetNWFloat("LastKeyDown2") > CurTime() or self.Owner:GetNWFloat("LastKeyDown1") > CurTime() then return end
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
                mins = Vector( -20, -20, -16 ),
                maxs = Vector( 20, 20, 16 ),
                mask = MASK_SHOT_HULL
            } )
        end
	
		if ( tr.Hit ) then
            local g = math.random(1,4)
            if g == 1 then
			self.Weapon:EmitSound(self.HitSound1)
            elseif g == 2 then
			self.Weapon:EmitSound(self.HitSound1)
            elseif g == 3 then
			self.Weapon:EmitSound(self.HitSound1)
            else
			self.Weapon:EmitSound(self.HitSound1)
            end
            local dmginfo = DamageInfo()
                
            local attacker = self.Owner
            if ( !IsValid( attacker ) ) then attacker = self end
            dmginfo:SetAttacker( attacker )
            dmginfo:SetInflictor( self )
			if self:Backstab() then
				self.Weapon:SendWeaponAnim( ACT_VM_HITKILL )
				dmginfo:SetDamage( self.Primary.Damage*2 )
			else
				dmginfo:SetDamage( self.Primary.Damage )
			end
			if tr.Entity:IsPlayer() && math.Rand(0,1)*100 < self.ConcussChance then
				dmginfo:SetDamageType(DMG_SLASH)
                if (self:Backstab() && self:GetClass() != "mm_candlestick" && GetConVar("mm_assassination"):GetInt() == 1) then
                    dmginfo:SetDamage( self.Primary.Damage*10 )
                end
			end
            dmginfo:SetDamageForce( self.Owner:GetForward() * 5 )
            if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:GetClass() == "sent_skellington" || tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0  )) && IsFirstTimePredicted() then
                if self:Backstab() && tr.Entity:Health() - dmginfo:GetDamage() <= 0 then
                    self.Owner:SetNWBool("KillFromBackstab", true)
                end
                tr.Entity:TakeDamageInfo( dmginfo )
			end
			if tr.Entity:IsPlayer() && (math.Rand(0,1)*100 < self.BleedChance || self:Backstab()) then
				tr.Entity:SetNWFloat("MM_BleedTime", CurTime() + 1)
				tr.Entity:SetNWInt("MM_BleedDamage", 7)
				tr.Entity:SetNWEntity("MM_BleedOwner", self.Owner)
				tr.Entity:SetNWEntity("MM_BleedInflictor", self)
			end
        end
		if ( SERVER && IsValid( tr.Entity ) ) then
            local phys = tr.Entity:GetPhysicsObject()
            if ( IsValid( phys ) ) then
                phys:ApplyForceOffset( self.Owner:GetAimVector()  * self.Reach * phys:GetMass(), tr.HitPos )
            end
        end
		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.Reach+10.7) )
		tr.filter = self.Owner
		tr.mask = MASK_SHOT
		local trace = util.TraceLine( tr )
		
		if ( trace.Hit ) then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 0
				self.Owner:FireBullets(bullet) 
		end
    end
end
