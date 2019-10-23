SWEP.SelectIcon = "vgui/entities/mm_electricrifle"
SWEP.Cost = 55
SWEP.Points = 25

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_caution" )
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_caution_fill" )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Shock Rifle"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/monstermash/c_electricrifle.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_electricrifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "rpg" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/shockrifle/shockrifle_1.wav" 
SWEP.Primary.Damage = 22
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = "ammo_colt"
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.2875
SWEP.Primary.Delay = 0.18
SWEP.Primary.Force = 0

SWEP.Secondary.Sound = "weapons/shockrifle/shockrifle_2.wav" 
SWEP.Secondary.Damage = 50
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IsPistol = false

SWEP.UseDistance = false
SWEP.ShootDistance = 896

SWEP.TracerThing = "ToolTracer"

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_CanShootTimer")
	self:NetworkVar("Float",3,"ElectricRifleHeat")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if SERVER then
        local effectdata = EffectData()
        local pos = self.Owner:GetShootPos()
        pos = pos + self.Owner:GetForward() * 45
        pos = pos + self.Owner:GetRight() * 2
        pos = pos + self.Owner:GetUp() * -4
        effectdata:SetOrigin(pos)
        effectdata:SetAttachment( self:LookupAttachment("muzzle") )
        util.Effect( "mm_muzzle", effectdata )
	end

end

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
		self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
	elseif self:GetGun_FakeTimer2() > 0 && CurTime() < self:GetGun_FakeTimer2() then
		self.Owner:SetWalkSpeed(self.ReloadSpeed)
		self.Owner:SetRunSpeed(self.ReloadSpeed)
	else
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end
    
    if !self.IsPistol then
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self:SetHoldType("duel")
        elseif self.Owner:KeyDown(IN_DUCK) || self.Owner:KeyPressed(IN_RELOAD) then
            self:SetHoldType("ar2")
		elseif self.Owner:GetActiveWeapon():GetClass() == "mm_coachgun" then
            self:SetHoldType("shotgun")
        elseif self.Owner:GetActiveWeapon():GetClass() == "mm_minigun" then
            self:SetHoldType("crossbow")
        else
            self:SetHoldType("rpg")
        end
    end
    
    if self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 && self.Owner:GetNWInt("MM_AutoReload") == 1 && self:GetGun_FakeTimer2() < CurTime() && self:GetGun_FakeTimer2() == 0 then
        self:Reload()
    end
    
    if self:GetGun_FakeTimer2() < CurTime() then
        self:SetGun_FakeTimer2(0)
    end
    
    if self:GetElectricRifleHeat() >= 26 then
        self.Owner:EmitSound("weapons/cannon/explosion1.wav",140)
        if SERVER then
            util.BlastDamage(self, self.Owner, self.Owner:GetPos()+Vector(0,0,70), 200, 140)
            if self.Owner:IsValid() then
                self.Owner:Ignite(7) 
            end
        end
        
        if IsValid(self.Owner) then
            local dir = -self.Owner:GetAimVector()-Vector(0,0,self.Owner:GetAimVector().z)
            dir:Normalize()
            self.Owner:SetVelocity(dir*250)
        end
        local effectdata5 = EffectData()
        effectdata5:SetOrigin( self:GetPos() )
        util.Effect( "Fireball_Explosion", effectdata5 ) 
            
        local effectdata3 = EffectData()
        effectdata3:SetOrigin( self:GetPos() )
        effectdata3:SetScale( 1 )
        util.Effect( "ManhackSparks", effectdata3 )
            
        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "HelicopterMegaBomb", effectdata4 )
        if SERVER then
            self:Remove()
            return
        end
    elseif self:GetElectricRifleHeat() > 0 then
        self:SetElectricRifleHeat(self:GetElectricRifleHeat()-0.1)
    elseif self:GetElectricRifleHeat() < 0 then
        self:SetElectricRifleHeat(0)
    end
       
    /*
    if self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 then
        self:Reload()
        return
    end
    */
	
	if CLIENT then

		if !self.Owner:IsOnGround() then
			self.LandTime = RealTime() + 0.31
		end

		if (self.Owner:GetMoveType() == MOVETYPE_NOCLIP || self.Owner:GetMoveType() == MOVETYPE_LADDER || self.Owner:WaterLevel() > 1 ) || (self.LandTime < RealTime() && self.LandTime != 0) then
			self.LandTime = 0
			self.JumpTime = 0
		end

		if self.Owner:KeyDownLast( IN_JUMP ) then
			if self.JumpTime == 0 then
				self.JumpTime = RealTime() + 0.31
				self.LandTime = 0
			end
		end
	end
	self:LegsDismembered()
end

function SWEP:PrimaryAttack()

	if self:GetNextPrimaryFire() > CurTime() then return end
	
	if self.Weapon:Clip1() <= 0 || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
	else
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
            self.Owner:SetVelocity(-self.Owner:GetVelocity())
        end
		self:SetGun_FakeTimer1(CurTime()+0.5)
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = pos
        local traceply = self.Owner:GetEyeTrace()
        if (traceply.Entity:IsPlayer()) then
            bullet.Dir = (traceply.Entity:GetBonePosition( traceply.Entity:LookupBone("ValveBiped.Bip01_Spine4") )-self.Owner:EyePos()):Angle():Forward()
        else
            bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
        end
        bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
        bullet.Tracer = 1
		bullet.TracerName = self.TracerThing
		if self.UseDistance then
			bullet.Distance = self.ShootDistance
		end
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_BULLET)
            tr.Entity:SetNWFloat("Zappy",CurTime()+0.1)
		end
        self:SetElectricRifleHeat(self:GetElectricRifleHeat() + 6)
		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
        
        if SERVER then
            net.Start("EmitElectricRifleLight")
            net.WriteEntity(self.Owner)
            net.Broadcast()
		end
        
		self:ShootEffects()
		 
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound),140) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		
		if self.Owner:GetNWFloat("Bloodied") > CurTime() then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
            self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
		else
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	end
end 

function SWEP:SecondaryAttack()

	if self:GetNextPrimaryFire() > CurTime() then return end
	
	if self.Weapon:Clip1() <= 0 || self.Weapon:Clip1() != self:GetMaxClip1() || !self.Owner:OnGround() then 
		self:EmitSound( "Weapon_Pistol.Empty",75,100,1,CHAN_ITEM )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
	else
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
            self.Owner:SetVelocity(-self.Owner:GetVelocity())
        end
		self:SetGun_FakeTimer1(CurTime()+0.5)
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = pos
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
        bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
        bullet.Tracer = 1
		bullet.TracerName = self.TracerThing
		if self.UseDistance then
			bullet.Distance = self.ShootDistance
		end
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Secondary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_BULLET)
            dmginfo:SetAttacker(self.Owner)
            tr.Entity:SetNWFloat("MM_Deanimatorstun",CurTime()+1)

            if tr.Entity:IsPlayer() then
                local HitList = {
                    //self.Owner,
                    tr.Entity
                }
                self:BounceCallback(tr, HitList, 1)                
            end
		end
        self:SetElectricRifleHeat(self:GetElectricRifleHeat() + 6)
		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
        
        if SERVER then
            net.Start("EmitElectricRifleLight")
            net.WriteEntity(self.Owner)
            net.Broadcast()
		end
        
		self:ShootEffects()
		 
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Secondary.Sound),140) 
		if !IsValid(self.Owner) then return end
        self.Owner:ViewPunch( Angle( rnda,rndb,rnda )*(1+bool_to_number(self:GetGun_MessWithArmStuff())) ) 
		self:TakePrimaryAmmo(self:GetMaxClip1()) 
		
		if self.Owner:GetNWFloat("Bloodied") > CurTime() then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
            self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
		else
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	end
end 

function SWEP:BounceCallback(tr, HitList, num)
    num = num + 1
    if num == 4 then return end
    local dist = 384
    local ent = tr.Entity
    for k, v in pairs( player.GetAll()) do
        if !table.HasValue(HitList, v) && v:GetPos():Distance(tr.HitPos) < dist then
            dist = v:GetPos():Distance(tr.HitPos)
            ent = v
            table.insert(HitList, v)
        end
    end
    
    if ent == tr.Entity then 
        return
    else
        local bullet = {} 
        bullet.Num = 1
        bullet.Src = tr.HitPos
        bullet.Dir = (ent:GetPos()+Vector(0,0,50)-tr.HitPos):Angle():Forward()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 1
        bullet.TracerName = self.TracerThing
        if self.UseDistance then
            bullet.Distance = self.ShootDistance
        end
        bullet.Force = self.Primary.Force 
        bullet.Damage = self.Secondary.Damage 
        bullet.AmmoType = self.Primary.Ammo 
        bullet.IgnoreEntity = tr.Entity
        bullet.Callback = function(attacker, tr2, dmginfo)
            dmginfo:SetInflictor(self)
            dmginfo:SetAttacker(self.Owner)
            dmginfo:SetDamageType(DMG_BULLET)
            tr2.Entity:SetNWFloat("MM_Deanimatorstun",CurTime()+1)
            self:BounceCallback(tr2, HitList, num)                
		end
        tr.Entity:FireBullets( bullet ) 
    end
end

function SWEP:FireAnimationEvent(pos,ang,event)
    
    if event == 6001 then return end

end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    local effectdata = EffectData( );
	effectdata:SetOrigin( self.Owner:GetViewModel():GetAttachment(1).Pos );
	effectdata:SetEntity( self.Owner:GetViewModel() );
	effectdata:SetStart( self.Owner:GetViewModel():GetAttachment(1).Pos );
	effectdata:SetNormal( self.Owner:GetAimVector( ) );
	effectdata:SetAttachment( 1 );
    effectdata:SetScale(0.1)
    util.Effect( "AirboatMuzzleFlash", effectdata );

end


if SERVER then
util.AddNetworkString( "EmitElectricRifleLight" )
end

net.Receive( "EmitElectricRifleLight", function(ply, len)

    local v = net.ReadEntity()
    if !IsValid(v) then return end
    local dlight = DynamicLight( v:EntIndex() )
    if ( dlight ) then
        local r, g, b, a = v:GetColor()
        dlight.Pos = v:GetPos()
        dlight.r = 33
        dlight.g = 144
        dlight.b = 255
        dlight.brightness = 5
        dlight.Decay = 1000
        dlight.Size = 256
        dlight.DieTime = CurTime() + 1
    end

end )