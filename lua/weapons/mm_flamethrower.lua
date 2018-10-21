SWEP.SelectIcon = "vgui/entities/mm_flamethrower"
SWEP.Cost = 55

game.AddAmmoType( { 
 name = "ammo_revolver",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Flamethrower"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_flamethrower.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_flamethrower.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "shotgun" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/revolver/fire1.wav" 
SWEP.Primary.Damage = 7
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 150
SWEP.Primary.Ammo = "flame"
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Delay = 0.02
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ShootDistance = 900

SWEP.IsFlameThrower = true

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"Gun_Charge")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
    self:NetworkVar("Bool",1,"Gun_Reloading")
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
    //self.Owner:DrawViewModel(false)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
		self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
	elseif self:GetGun_Reloading() == false then
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end

	if self.Owner:KeyPressed(IN_ATTACK) && self.Owner:OnGround() && self:Clip1() > 0 && self:GetGun_Reloading() == false && self.Owner:GetNWFloat("Bloodied") < CurTime() then
		vm:SetSequence(vm:LookupSequence("shootloop_start"))
		self:SetGun_FakeTimer1(vm:SequenceDuration(vm:LookupSequence("shootloop_start"))+CurTime())
        self:EmitSound("weapons/flamethrower/flamethrower_start.wav", 75, 100, 0.2)
        if self.LoopSound then
            self.LoopSound:Stop()
        end
        self.LoopSound = CreateSound( self, "weapons/flamethrower/flamethrower_looping.wav" ) 
        if self.LoopSound then
            self.LoopSound:SetSoundLevel( 150 ) 
            self.LoopSound:Play()
        end
	end
    
	if self.Owner:KeyDown(IN_ATTACK) && self.Owner:OnGround() && self:Clip1() > 0 && self:GetGun_Reloading() == false && self.Owner:GetNWFloat("Bloodied") < CurTime() then
		if (self:GetGun_FakeTimer1() < CurTime()) then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("shootloop_loop"))
			self:SetGun_FakeTimer1(vm:SequenceDuration(vm:LookupSequence("shootloop_loop"))+CurTime())
		end
        if self.LoopSound && !self.LoopSound:IsPlaying() then
            self.LoopSound = CreateSound( self, "weapons/flamethrower/flamethrower_looping.wav" ) 
            self.LoopSound:SetSoundLevel( 150 ) 
            self.LoopSound:Play()
        end
	end
	if self:GetGun_Reloading() == false && (IsValid(self.Owner) && ((self.Owner:KeyReleased(IN_ATTACK) && self:Clip1() > 0)|| (!self.Owner:OnGround() && self:GetGun_FakeTimer1() > CurTime())) || (self:Clip1() < 1 && vm:GetSequence() == vm:LookupSequence("shootloop_loop")) || (self:Clip1() < 1 && vm:GetSequence() == vm:LookupSequence("shootloop_start"))) then
		vm:SetSequence(vm:LookupSequence("shootloop_end"))
		self:SetGun_FakeTimer1(CurTime())
        self:EmitSound("weapons/flamethrower/flamethrower_end.wav")
        if self.LoopSound then
            self.LoopSound:Stop()
        end
	end
    
    if !self.Owner:KeyDown(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self.Owner:KeyDown(IN_ATTACK2) && self:Clip1() >= 75 && self.Owner:GetNWFloat("Bloodied") < CurTime() then
        if self:GetGun_Charge() >= 100 then
            self:EmitSound("weapons/flamethrower/fireball.mp3",75,100,1,CHAN_ITEM)
            vm:SendViewModelMatchingSequence(vm:LookupSequence("shootloop_end"))
            self:TakePrimaryAmmo(75)
            self:SetGun_Charge(0)
            if SERVER then
                local ent = ents.Create("ent_fireball")
                local pos = self.Owner:GetShootPos()
                pos = pos + self.Owner:GetForward() * 15
                pos = pos + self.Owner:GetRight() * 10
                pos = pos + self.Owner:GetUp() * -15
                ent:SetPos(pos)
                ent:SetAngles(self.Owner:EyeAngles())
                ent:SetOwner(self.Owner)
                ent.Own = self.Owner
                ent:SetNWEntity("FlamethrowerDamageInflictor", self)
                ent:Spawn()
                ent:Activate()
                ent:SetOwner(self.Owner)
                
                local phys = ent:GetPhysicsObject()

                self.Force = 100000
                phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))
            end
            self.Owner:ViewPunch( Angle( -2, 0, 0 ) )
        else
            self.Owner:SetWalkSpeed(self.ShootSpeed)
            self.Owner:SetRunSpeed(self.ShootSpeed)
			self:SetGun_Charge(self:GetGun_Charge()+1.5)
            if CLIENT then
                local effectdata4 = EffectData()
                effectdata4:SetStart( self.Owner:GetViewModel():GetAttachment("1").Pos ) 
                effectdata4:SetOrigin( self.Owner:GetViewModel():GetAttachment("1").Pos )
                effectdata4:SetAngles( self.Owner:EyeAngles() )
                effectdata4:SetScale( 1 )
                util.Effect( "flamethrower_charge", effectdata4 )
            end
            if SERVER then
                local effectdata = EffectData()
                local pos = self.Owner:GetShootPos()
                pos = pos + self.Owner:GetForward() * 45
                pos = pos + self.Owner:GetRight() * 2
                pos = pos + self.Owner:GetUp() * -2
                effectdata:SetOrigin(pos)
                effectdata:SetAttachment( self:LookupAttachment("muzzle") )
                util.Effect( "flamethrower_charge", effectdata )
            end
		end
        if self.Owner:KeyPressed(IN_ATTACK2) then
            self:EmitSound("weapons/flamethrower/firecharge.mp3")
            vm:SendViewModelMatchingSequence(vm:LookupSequence("guncheck_1"))
        end
    end
    
    if IsValid(self.Owner) && (self.Owner:KeyReleased(IN_ATTACK2) || !self.Owner:OnGround() )   then
		self:SetGun_Charge(0)
        self:EmitSound("common/null.wav",75,100,1,CHAN_WEAPON)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
    end
    
    if self.Owner:KeyPressed(IN_RELOAD) && self:GetGun_Reloading() == false && self:Clip1() != 150  then
        self:SetGun_Reloading(true)
        self:SetGun_Charge(0)
        vm:SendViewModelMatchingSequence(vm:LookupSequence("guncheck_2"))
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()*0.7
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
            AnimationTime = self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate())*0.7
        end
        self:SetNextPrimaryFire( CurTime() + AnimationTime )
        self:SetNextSecondaryFire( CurTime() + AnimationTime )
        self:SetGun_FakeTimer2(CurTime() + AnimationTime)
        if self.Owner:GetNWInt("LegMissing") > 0 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
    end
    
    if self:GetGun_Reloading() == true && self:GetGun_FakeTimer2() < CurTime() then
        self:SetGun_Reloading(false)
        self:SetClip1( math.min(self:Clip1() + 35, 150) )
    end
    if self:GetGun_Reloading() == false then
        self:LegsDismembered()
    end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if self.Owner:GetNWFloat("Bloodied") > CurTime() then return end
    if self:Clip1() < 1 then return end
    if self:GetGun_Reloading() == true then return end
	if !self.Owner:OnGround() then return end
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
	if CLIENT && GetViewEntity() == self.Owner then
		local effectdata4 = EffectData()
		effectdata4:SetStart( self.Owner:GetViewModel():GetAttachment("1").Pos ) 
		effectdata4:SetOrigin( self.Owner:GetViewModel():GetAttachment("1").Pos )
		effectdata4:SetAngles( self.Owner:EyeAngles() )
		effectdata4:SetScale( 1 )
		util.Effect( "flamethrower_flame", effectdata4 )
	end
	
	if SERVER then
		local effectdata4 = EffectData()
		local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetAngles():Up() 	* -20
			pos = pos + self.Owner:GetAngles():Right()	* 10
			pos = pos + self.Owner:GetAngles():Forward()* 30
		effectdata4:SetStart( pos ) 
		effectdata4:SetOrigin( pos )
		effectdata4:SetAngles( self.Owner:EyeAngles() )
		effectdata4:SetScale( 1 )
		util.Effect( "flamethrower_flame", effectdata4 )
	end
		
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	 	 
	//self.Owner:FireBullets( bullet ) 
	//self:EmitSound(Sound(self.Primary.Sound),140) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	 
	if self.Owner:GetNWFloat("Bloodied") > CurTime() then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
		self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
	else
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	
	
	if SERVER then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		local grenade = ents.Create("ent_flamehitbox")

		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 40
		pos = pos + self.Owner:GetRight() * 10
		pos = pos + self.Owner:GetUp() * -20
		
		 
		local ang = self.Owner:EyeAngles()
		ang = ang:Forward()
		
		grenade:SetPos(pos)
		grenade:SetAngles(self.Owner:GetAngles())
		grenade:SetOwner(self.Owner)
		grenade:Spawn()
		grenade:Activate()
		grenade:SetVelocity( ( ang ):GetNormalized() * 500 + self.Owner:GetVelocity() * 1 )
        grenade:SetNWEntity("FlamethrowerDamageInflictor", self)
	end
	
end


function SWEP:FireAnimationEvent(pos,ang,event)
	if (event==5001) then 
		return true
	end
end

function SWEP:Holster()
    if self.LoopSound then
        self.LoopSound:Stop()
    end
	if IsValid(self.Owner) then 
        self.Owner:DrawViewModel(true)
        if self.Owner:GetNWInt("LegMissing") > 0 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
        self:SetGun_FakeTimer1(0)
        self:SetGun_FakeTimer2(0)
        return true
	end
end

function SWEP:OnDrop()
    if self.LoopSound then
        self.LoopSound:Stop()
    end
end

function SWEP:OnRemove()
    if self.LoopSound then
        self.LoopSound:Stop()
    end
end