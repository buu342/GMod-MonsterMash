SWEP.SelectIcon = "vgui/entities/mm_fencepost"
SWEP.Cost = 20

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_fencepost.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_fencepost.mdl"
SWEP.HoldType 			= "melee2"


SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage			= 40
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1.25

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Fence Post"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.30
SWEP.Reach 	   = 128
SWEP.HitSound1 = Sound("weapons/sword/knife_hit_01.wav")
SWEP.HitSound2 = Sound("weapons/sword/knife_hit_02.wav")
SWEP.HitSound3 = Sound("weapons/sword/knife_hit_03.wav")
SWEP.HitSound4 = Sound("weapons/sword/knife_hit_04.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")

SWEP.MeleeDecal_Use	= false

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 40
SWEP.DismemberChance	= 0

function SWEP:PrimaryAttack()
    self.Weapon:EmitSound(self.MissSound)
    self:SetFaketimer(CurTime() + self.TimeToHit)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self:SetHoldType("knife")
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
    timer.Simple(0.4,function() if !IsValid(self.Weapon) then return end self:SetHoldType("melee2") end)
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
	if self.Owner:GetNWFloat("LastKeyDown4") > CurTime() or self.Owner:GetNWFloat("LastKeyDown3") > CurTime() or self.Owner:GetNWFloat("LastKeyDown2") > CurTime() or self.Owner:GetNWFloat("LastKeyDown1") > CurTime() then return end
	if  CurTime() > self:GetFaketimer2() && self:GetFaketimer2() > 0 then
		self:SetFaketimer2(0)
		self.Weapon:EmitSound(self.MissSound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end

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
			if tr.Entity:IsPlayer() && math.Rand(0,1)*100 < self.ConcussChance then
				dmginfo:SetDamageType(DMG_SLASH)
			end
            if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:GetClass() == "sent_skellington" || tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0  )) && IsFirstTimePredicted() then
                if self:Backstab() && tr.Entity:Health() - dmginfo:GetDamage() <= 0 then
                    self.Owner:SetNWBool("KillFromBackstab", true)
                end
                tr.Entity:TakeDamageInfo( dmginfo )
            end
			if tr.Entity:IsPlayer() && (math.Rand(0,1)*100 < self.BleedChance  || (self.BleedChance != 0 && self:Backstab())) then
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
			local direc = self.Owner:GetAimVector()
			direc = direc + self.Owner:GetForward() * 0
			direc = direc + self.Owner:GetRight() * 0
			direc = direc + self.Owner:GetUp() * 0.1
			bullet.Dir    = direc
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 0
			self.Owner:FireBullets(bullet) 
		end
    end
end