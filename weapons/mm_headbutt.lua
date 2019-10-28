SWEP.SelectIcon = "vgui/entities/mm_skull"
SWEP.Cost = 10

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType 			= "normal"

SWEP.FiresUnderwater        = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage         = 20
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1.5

SWEP.Slot = 6
SWEP.SlotPos = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "HeadButt"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit          = 0.3
SWEP.Reach              = 33
SWEP.HitSound1 = Sound("weapons/bone/boner1.wav")
SWEP.HitSound2 = Sound("weapons/bone/boner2.wav")
SWEP.HitSound3 = Sound("weapons/bone/boner1.wav")
SWEP.HitSound4 = Sound("weapons/bone/boner2.wav")
SWEP.MissSound = Sound("weapons/bone/swing1.wav")

SWEP.MeleeDecal_LeaveBullethole = false
SWEP.MeleeDecal_MakeBlood = false
SWEP.MeleeDecal_Use	= false

SWEP.ConcussChance		= 100
SWEP.BleedChance		= 0
SWEP.DismemberChance	= 0

function SWEP:PrimaryAttack()
	
    self:SetHoldType("melee")
    self:SetWeaponHoldType("melee")
    self.Owner:SetNWFloat("MeleeAttackAim", CurTime() +1)
    if SERVER then
        net.Start( "DoStupidStuff" )
            net.WriteEntity(self)
        net.Broadcast()
    end
    timer.Simple(0.2,function() if !IsValid(self) then return end self:SetHoldType("normal") self:SetWeaponHoldType("normal") end)
	self.Weapon:EmitSound(self.MissSound)
	
    self:SetFaketimer(CurTime() + self.TimeToHit)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    
end

function SWEP:DamageStuff()
	if self.Owner:GetNWFloat("LastKeyDown4") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown3") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown2") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown1") >= CurTime() then return end
	if CurTime() > self:GetFaketimer2() && self:GetFaketimer2() > 0 then
		self:SetFaketimer2(0)
		self.Weapon:EmitSound(self.MissSound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self.Owner:ViewPunch(Angle(-10,0,0))
	end
    
    if CurTime() > self:GetFaketimer() && self:GetFaketimer() > 0 then 
        self:SetFaketimer(0)
        self.Owner:ViewPunch(Angle(30,0,0))
		
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
			if tr.Entity:IsPlayer() && (math.Rand(0,1)*100 < self.ConcussChance || (self.ConcussChance != 0 && self:Backstab())) then
				dmginfo:SetDamageType(DMG_SLASH)
			end
            dmginfo:SetDamageForce( self.Owner:GetForward() * 5 )
            if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:GetClass() == "sent_skellington" || tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0  )) && IsFirstTimePredicted() then
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
			if tr.Entity:IsPlayer() && (math.Rand(0,1)*100 < self.BleedChance || (self.BleedChance != 0 && self:Backstab())) then
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
			if self.MeleeDecal_LeaveBullethole == true || (self.MeleeDecal_MakeBlood == true && IsValid( tr.Entity )) then
				self.Owner:FireBullets(bullet) 
			end
			if self.MeleeDecal_Use == true then
				self:MeleeDecal( tr, self.MeleeDecal_Decal ) 
			end
		end
    end
end

function SWEP:LegsDismembered()
end

function SWEP:ArmsDismembered()
end

function SWEP:ShouldDropOnDie() 
	return false
end

if SERVER then
util.AddNetworkString( "DoStupidStuff" )
end

net.Receive( "DoStupidStuff", function( len, ply )
    self = net.ReadEntity()
    self:SetHoldType("melee")
    self:SetWeaponHoldType("melee")
    timer.Simple(0.2,function() if !IsValid(self) then return end self:SetHoldType("normal") self:SetWeaponHoldType("normal") end)
end )