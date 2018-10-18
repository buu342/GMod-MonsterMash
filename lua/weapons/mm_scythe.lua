SWEP.SelectIcon = "vgui/entities/mm_scythe"
SWEP.Cost = 40

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.UseHands 		= true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 54
SWEP.ViewModel			= "models/weapons/monstermash/v_scythe.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_scythe.mdl"
SWEP.HoldType 			= "melee2"


SWEP.FiresUnderwater = true
SWEP.Base					= "mm_melee_base"
SWEP.Primary.Damage			= 50
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 1.6

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Monster Mash"
SWEP.PrintName			= "Scythe"			
SWEP.Slot			= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.TimeToHit = 0.30
SWEP.Reach = 100
SWEP.HitSound1 = Sound("weapons/sword/sword1.wav")
SWEP.HitSound2 = Sound("weapons/sword/sword2.wav")
SWEP.HitSound3 = Sound("weapons/sword/sword3.wav")
SWEP.HitSound4 = Sound("weapons/sword/sword3.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")

SWEP.MeleeDecal_LeaveBullethole = false
SWEP.MeleeDecal_MakeBlood = true
SWEP.MeleeDecal_Speed = 0.03

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 35
SWEP.DismemberChance	= 100

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
				dmginfo:SetDamage( self.Primary.Damage*2 )
			else
				dmginfo:SetDamage( self.Primary.Damage )
			end
            dmginfo:SetDamageForce( self.Owner:GetForward() * 5 )
			if tr.Entity:IsPlayer() && math.Rand(0,1)*100 < self.ConcussChance then
				dmginfo:SetDamageType(DMG_SLASH)
			end
            if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:GetClass() == "sent_skellington" || tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0  )) && IsFirstTimePredicted() then
                if self:Backstab() && tr.Entity:Health() - dmginfo:GetDamage() <= 0 then
                    self.Owner:SetNWBool("KillFromBackstab", true)
                end
                tr.Entity:SetNWInt("Dismember", 1)
                tr.Entity:TakeDamageInfo( dmginfo )
				tr.Entity:SetNWInt("LastHitgroupMelee", tr.HitGroup)
            end
			if tr.Entity:IsPlayer() && math.Rand(0,1)*100 < self.BleedChance then
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