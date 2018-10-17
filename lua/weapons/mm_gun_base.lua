/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Base"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= false
SWEP.AdminSpawnable= false
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_m1garand.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_m1garand.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "ar2" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = true

SWEP.Base = "mm_base_plain"

SWEP.DefaultWalkSpeed = 220
SWEP.WalkSpeed = 200
SWEP.ShootSpeed = 80
SWEP.ReloadSpeed = 120
SWEP.IsPistol = true

SWEP.CrouchPos = Vector(-1,-1,.5) -- Moves the gun when you crouch

SWEP.CrouchMovePos = Vector (0, 0, 0) -- Movement when crouching
SWEP.CrouchMoveAng = Vector (0, 0, 0)

SWEP.BobScale = 0 -- Real men code their own bob
SWEP.SwayScale = 0.2 -- I'm too lazy to code my own sway, plus this one works just fine soooooo....

SWEP.UseDistance = false
SWEP.ShootDistance = -1

SWEP.TracerThing = "Tracer"

SWEP.Secondary.Spread = 0 
SWEP.Secondary.Recoil = 0

function SWEP:IsSlotEmpty( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then return false end 
	end

	return true

end

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_CanShootTimer")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Initialize()
	if CLIENT then
		self.JumpTime = 0
		self.LandTime = 0
	end
    util.PrecacheSound(self.Primary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Deploy()
	self:SetNextPrimaryFire( CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:EmitSound("weapons/deploy.wav")
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self.Owner:GetNWInt("LegMissing") > 0 then
        self.Owner:SetWalkSpeed(1)
        self.Owner:SetRunSpeed(1)
    end
	return true 
end

function SWEP:FireAnimationEvent(pos,ang,event)

	if (event==5001) then 
		if IsValid(self.Owner) && IsValid(self.Owner:GetViewModel()) then
			local effectdata = EffectData()
			local vm = self.Owner:GetViewModel()
			if vm:GetAttachment(1) != nil then
				effectdata:SetOrigin( self.Owner:GetViewModel():GetAttachment(1).Pos )
				util.Effect( "mm_muzzle", effectdata )
			end
		end
	end

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
		pos = pos + self.Owner:GetUp() * -2
		effectdata:SetOrigin(pos)
		effectdata:SetAttachment( self:LookupAttachment("muzzle") )
		util.Effect( "mm_muzzle", effectdata )
	end

end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if self:Clip1() < self:GetMaxClip1() then
		self.Owner:SetAmmo(self.Primary.DefaultClip, self:GetPrimaryAmmoType())
        self.Weapon:DefaultReload( ACT_VM_RELOAD )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
            AnimationTime = self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate())
        end
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
        self:SetGun_FakeTimer2(CurTime() + AnimationTime)
        if self.Owner:GetNWInt("LegMissing") > 0  then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
        
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
        else
            self:SetHoldType("rpg")
        end
    end
	
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
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
        if self:GetClass() == "mm_coachgun" then
            bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
        else
            bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)*(1+bool_to_number(self:GetGun_MessWithArmStuff()))
		end
        bullet.Tracer = 1
		if self.UseDistance then
			bullet.Distance = self.ShootDistance
		end
		bullet.TraceName = self.TracerThing
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_BULLET)
		end

		 
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
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

function SWEP:ImpactTrace( trace, dmgtype, customimpactname )
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	util.Effect( "Explosion", effectdata )
	return true
end

function SWEP:Holster()
	if IsValid(self.Owner) then 
    if self.Owner:GetNWInt("LegMissing") == 3 then
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

function SWEP:ShouldDropOnDie() 
	return true
end

function SWEP:OnDrop()
	self.Owner = nil
	timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then  self:Remove() end end)
end

-- This is my super sexy CalcView. Don't touch it
local myfov = 75
local myfov_t = 90
function MySuperSexyCalcView(ply,origin,angles,fov,vm_origin,vm_angles)
	if ply:GetActiveWeapon() == "weapon_buu_base2" then
		local m_PlayerCam = GAMEMODE:CalcView(ply,origin,angles,fov,vm_origin,vm_angles)
		m_PlayerCam.origin = origin
		m_PlayerCam.angles = angles
		m_PlayerCam.fov = myfov
		myfov = Lerp(10*FrameTime(),myfov,myfov_t)
		if ply:KeyDown(IN_ATTACK2) then 	
			myfov_t = ply:GetActiveWeapon().IronsightFOV
		else 
			myfov_t = LocalPlayer():GetInfoNum("fov_desired",90)
		end
		myrecoil = Lerp(6*FrameTime(),myrecoil,0)
		myrecoilyaw = Lerp(6*FrameTime(),myrecoilyaw,0)
		e_recoilyaw = Lerp(6*FrameTime(),e_recoilyaw,myrecoilyaw)
		
		m_PlayerCam.angles = Angle(angles.p-myrecoil,angles.y-e_recoilyaw ,angles.r)
		
		return m_PlayerCam,GAMEMODE:CalcView(ply,origin,angles,fov,vm_origin,vm_angles)
	end
end
hook.Add( "CalcView", "BuusSuperSexyCalcView", MySuperSexyCalcView )

SWEP.BuuSwayScale = 60

if CLIENT then
	-- This is where all the sexy movement in the viewmodel happens. This shit is bootyfull
	-- If you guys get the chance, go give Kudo's to MushroomGuy for teaching me Lerp
	-- Lerp is one of the coolest and most sexy things to come to Garry's Mod
	-- Wow are these comments that interesting that you're still reading them?
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	local Current_Aim = Angle(0,0,0)
	local Off, Off2, Off3, dist = 0, 0, 0, 0
	SWEP.LastEyePosition = Angle(0,0,0)
	SWEP.EyePosition = Angle(0,0,0)
	
	function SWEP:GetViewModelPosition(pos, ang)
		if !IsValid(self.Owner) then return end
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
		
		/*--------------------------------------------
				  Animation Transition Speed 
		--------------------------------------------*/
		
        if self:GetGun_FakeTimer2() > CurTime() || ((self:GetClass() == "mm_pumpshotgun" || self:GetClass() == "mm_repeater") && self:GetMM_Reloading() && self.Owner:GetNWInt("ArmMissing") != 0) then
            TestVector = LerpVector(1*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(1*FrameTime(),TestVectorAngle,TestVectorAngleTarget)
		elseif self.LandTime > RealTime() then
			TestVector = LerpVector(20*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(20*FrameTime(),TestVectorAngle,TestVectorAngleTarget)
        elseif IsValid(self.Owner) && !self.Owner:KeyDown(IN_SPEED) && !(self.Owner:KeyDown(IN_DUCK) && walkspeed > 40) then
            TestVector = LerpVector(10*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(10*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
        elseif self.Owner:KeyDown(IN_DUCK) && walkspeed > 40 then 
			TestVector = LerpVector(10*FrameTime(),TestVector,TestVectorTarget) 
			TestVectorAngle = LerpVector(10*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
		else
            TestVector = LerpVector(5*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(5*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
        end
		
		ang:RotateAroundAxis(ang:Right(),TestVectorAngle.x  )
		ang:RotateAroundAxis(ang:Up(),TestVectorAngle.y )
		ang:RotateAroundAxis(ang:Forward(),TestVectorAngle.z)
		
		pos = pos + TestVector.z * ang:Up()
		pos = pos + TestVector.y * ang:Forward()
		pos = pos + TestVector.x * ang:Right()
		if !IsValid(self.Owner) then return end
		local Tr = self.Owner:GetEyeTrace()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
        if self.Owner:Crouching() then 
            TestVectorTarget = self.CrouchPos
            TestVectorAngleTarget = Vector(0,0,0)
        else
            TestVectorTarget = Vector(0,0,0)
            TestVectorAngleTarget = Vector(0,0,0)
        end
        
		
		/*--------------------------------------------
					 Viewmodel Jump Sway
		--------------------------------------------*/
		
		-- Use this if you gotta https://www.desmos.com/calculator/cahqdxeshd
		local function BezierY(f,a,b,c)
			f = f*3.2258
			return (1-f)^2 *a + 2*(1-f)*f*b + (f^2)*c
		end
		if self.Owner:WaterLevel() < 1 then
			if self.JumpTime > RealTime() then
				local f = 0.31 - (self.JumpTime-RealTime())

				local xx = BezierY(f,0,-4,0)
				local yy = 0
				local zz = BezierY(f,0,-2,-5)
				
				local pt = BezierY(f,0,-4.36,10)
				local yw = xx
				local rl = BezierY(f,0,-10.82,-5)
				
				TestVectorTarget = TestVectorTarget + Vector(xx, yy, zz)
				TestVectorAngleTarget = TestVectorAngleTarget + Vector(pt, yw, rl)
			elseif !ply:IsOnGround() && ply:GetMoveType() != MOVETYPE_NOCLIP then
				local BreatheTime = RealTime() * 30
				TestVectorTarget = TestVectorTarget + Vector(math.cos(BreatheTime/2)/16, 0, -5+(math.sin(BreatheTime/3)/16))
				TestVectorAngleTarget = TestVectorAngleTarget + Vector(10-(math.sin(BreatheTime/3)/4), math.cos(BreatheTime/2)/4, -5)
			elseif self.LandTime > RealTime() then
				local f = (self.LandTime-RealTime())
				
				local xx = BezierY(f,0,-4,0)
				local yy = 0
				local zz = BezierY(f,0,-2,-5)
				
				local pt = BezierY(f,0,-4.36,10)
				local yw = xx
				local rl = BezierY(f,0,-10.82,-5)
				
				TestVectorTarget = TestVectorTarget + Vector(xx, yy, zz)
				TestVectorAngleTarget = TestVectorAngleTarget + Vector(pt, yw, rl)
			end
		else
			TestVectorTarget = TestVectorTarget + Vector(0 ,0 , math.Clamp(self.Owner:GetVelocity().z / 1000,-1,1))
		end
		
		
		/*--------------------------------------------
					  Viewmodel Bobbing
		--------------------------------------------*/
		
        if ply:IsOnGround() then
			if walkspeed > 20 then
				local BreatheTime = RealTime() * 16
				TestVectorTarget = TestVectorTarget - Vector((-math.cos(BreatheTime/2)/5)*walkspeed/200,0,0)
				TestVectorAngleTarget = TestVectorAngleTarget - Vector((math.Clamp(math.cos(BreatheTime),-0.3,0.3)*1.2)*walkspeed/200,(-math.cos(BreatheTime/2)*1.2)*walkspeed/200,0)
			end
		end
        
        /*--------------------------------------------
                        1 arm reload
        --------------------------------------------*/
		
        if (self.Owner:GetNWInt("ArmMissing") > 0 && self:GetGun_FakeTimer2() > CurTime() && ((self:GetGun_FakeTimer2()-CurTime())/(self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate()))) > 0.1)  || ((self:GetClass() == "mm_pumpshotgun" || self:GetClass() == "mm_repeater") && self:GetMM_Reloading()  && self.Owner:GetNWInt("ArmMissing") != 0) then
            TestVectorTarget = TestVectorTarget + Vector(50,0,0)
            TestVectorAngleTarget = TestVectorAngleTarget + Vector(-90,0,0)
        elseif self.Owner:GetNWInt("ArmMissing") > 0 && self:GetGun_FakeTimer2() > CurTime() && ((self:GetGun_FakeTimer2()-CurTime())/(self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate()))) <= 0.1 then
            TestVectorAngleTarget = TestVectorAngleTarget + Vector(5,0,0)
        end
		
		/*--------------------------------------------
						Viewmodel Sway
		--------------------------------------------*/
		
		self.LastEyePosition = self.EyePosition
		
		Current_Aim = LerpAngle(5*FrameTime(), Current_Aim, ply:EyeAngles())
		
		self.EyePosition = Current_Aim - ply:EyeAngles()
		self.EyePosition.y = math.AngleDifference( Current_Aim.y, ply:EyeAngles().y ) -- Thank you MushroomGuy for telling me this function even existed
		
		ang:RotateAroundAxis(ang:Right(), math.Clamp(4*self.EyePosition.p/self.BuuSwayScale,-4,4))
		ang:RotateAroundAxis(ang:Up(), math.Clamp(-4*self.EyePosition.y/self.BuuSwayScale,-4,4))

		pos = pos + math.Clamp((-1.5*self.EyePosition.p/self.BuuSwayScale),-1.5,1.5) * ang:Up()
		pos = pos + math.Clamp((-1.5*self.EyePosition.y/self.BuuSwayScale),-1.5,1.5) * ang:Right()
		
		return pos, ang
	end
end

-- Now comes Ironsight swaying. 
function CalcMoveForce(ply)
	if !IsValid(LocalPlayer()) then return end
	local weapon = ply:GetActiveWeapon()
	MoveForce = ply:GetFOV()
	if !ply:Crouching() then
		if IsValid(weapon) && !weapon:GetDTBool( 2 ) then
			MoveForce = ply:GetFOV() * 10
		else
			MoveForce = ply:GetFOV() * 50
		end
	else
		MoveForce = ply:GetFOV() * 120
	end
	
	return MoveForce
end

function IronIdleMove(cmd)
        local ply = LocalPlayer()
        local weapon = ply:GetActiveWeapon()
        if !IsValid(ply) then return end
        if weapon.Base == "weapon_buu_base2" && weapon:GetBuu_Ironsights() then
            local ang = cmd:GetViewAngles()

            local ft = FrameTime()
            local BreatTime = RealTime() * weapon.IronsightMoveIntensity
            local MoveForce = CalcMoveForce(ply)
                   
            ang.pitch = ang.pitch + math.cos(BreatTime) / MoveForce
            ang.yaw = ang.yaw + math.cos(BreatTime /2
            ) / MoveForce
            if !IsValid(weapon) then return end
            cmd:SetViewAngles(ang) 
        end
end
hook.Add ("CreateMove", "BuuIronIdleMove", IronIdleMove)