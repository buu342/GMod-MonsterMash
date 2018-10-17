SWEP.SelectIcon = "vgui/entities/mm_hacksaw"
SWEP.Cost = 20

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 65
SWEP.ViewModel			= "models/weapons/monstermash/v_saw.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_saw.mdl"
SWEP.HoldType 			= "knife"


SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage			= 28
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Hack Saw"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.12
SWEP.Reach = 72

SWEP.HitSound1 = Sound("weapons/sword/sword1.wav")
SWEP.HitSound2 = Sound("weapons/sword/sword2.wav")
SWEP.HitSound3 = Sound("weapons/sword/sword3.wav")
SWEP.MissSound = Sound("weapons/bone/swing1.wav")

SWEP.MeleeDecal_Direction = -1
SWEP.MeleeDecal_Speed = 0.03

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 25
SWEP.DismemberChance	= 20


function SWEP:DamageStuff()
		if self.Owner:GetNWFloat("LastKeyDown4") > CurTime() or self.Owner:GetNWFloat("LastKeyDown3") > CurTime() or self.Owner:GetNWFloat("LastKeyDown2") > CurTime() or self.Owner:GetNWFloat("LastKeyDown1") > CurTime() then return end
	if  CurTime() > self:GetFaketimer2() && self:GetFaketimer2() > 0 then
		self:SetFaketimer2(0)
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
			local g = math.random(1,3)
			if g == 1 then
			self.Weapon:EmitSound(self.HitSound1)
			elseif g == 2 then
			self.Weapon:EmitSound(self.HitSound2)
			else
			self.Weapon:EmitSound(self.HitSound3)
			end
            
			local dmginfo = DamageInfo()
            local attacker = self.Owner
            if ( !IsValid( attacker ) ) then attacker = self end
            dmginfo:SetAttacker( attacker )
            dmginfo:SetInflictor( self )
            if self:Backstab() then
				dmginfo:SetDamage( self.Primary.Damage )
			else
				dmginfo:SetDamage( self.Primary.Damage )
			end
            dmginfo:SetDamageForce( self.Owner:GetForward() * 5 )
			if tr.Entity:IsPlayer() && math.Rand(0,1)*100 < self.ConcussChance then
				dmginfo:SetDamageType(DMG_SLASH)
			end
            if SERVER && IsValid( tr.Entity ) &&  tr.Entity:IsPlayer() then
                tr.Entity:SetNWInt("LastHitgroupMelee", tr.HitGroup)
                tr.Entity:SetNWInt("LastHitgroupBullet", 0)
				if math.Rand(0,1)*100 < self.DismemberChance then
					tr.Entity:SetNWInt("Dismember", 1)
				end
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
			if tr.Entity then
            self.Owner:FireBullets(bullet) 
			end
			self:MeleeDecal( tr, self.MeleeDecal_Decal ) 
        end
        
    end
	
end
	
function SWEP:PrimaryAttack()
	
    self:SetHoldType("melee")
    self:SetWeaponHoldType("melee")
    timer.Simple(0.2,function() if !IsValid(self) then return end self:SetHoldType("knife") self:SetWeaponHoldType("knife") end)
	self.Weapon:EmitSound(self.MissSound)
	
    self:SetFaketimer(CurTime() + self.TimeToHit)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
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
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Faketimer")
	self:NetworkVar("Float",1,"Faketimer2")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end