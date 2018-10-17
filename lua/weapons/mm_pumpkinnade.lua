SWEP.SelectIcon = "vgui/entities/mm_pumpkinnade"
SWEP.Cost = 35

local soundData = {
    name   = "Weapon_pnade.PinPull" ,
    channel  = CHAN_WEAPON,
    volume   = 0.7,
    soundlevel  = 100,
    pitchstart  = 100,
    pitchend  = 100,
    sound   = "physics/flesh/flesh_squishy_impact_hard1.wav"
}
sound.Add(soundData)

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/
 
SWEP.PrintName = "Pumpkin Grenade"
   
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"
 
SWEP.Category = "Monster Mash"
 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
 
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_pumpkin_nade.mdl"
SWEP.WorldModel = "models/weapons/monstermash/w_pumpkin_nade.mdl"
SWEP.ViewModelFlip = false
 
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
 
SWEP.Slot = 3
SWEP.SlotPos = 1
 
SWEP.UseHands = true
 
SWEP.HoldType = "grenade"
 
SWEP.FiresUnderwater = false
 
SWEP.DrawCrosshair = false
 
SWEP.DrawAmmo = true
 
SWEP.ReloadSound = "sound/epicreload.wav"
 
SWEP.Base = "mm_base_plain"
 
SWEP.Primary.Sound = "weapons/revolver/fire1.wav"
SWEP.Primary.Damage = 200
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "strider"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.2
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 0
 
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CrouchPos = Vector(-1,-1,.5) -- Moves the gun when you crouch

SWEP.CrouchMovePos = Vector (0, 0, 0) -- Movement when crouching
SWEP.CrouchMoveAng = Vector (0, 0, 0)
 
SWEP.BobScale = 0 -- Real men code their own bob
SWEP.SwayScale = 0.2 -- I'm too lazy to code my own sway, plus this one works just fine soooooo....

SWEP.MyOwner = nil
 
function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
    self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"MM_PrimeTime")
    self:NetworkVar("Bool",0,"Primed")
    self:NetworkVar("Bool",1,"Gun_MessWithArmStuff")
end
 
 
function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
    self:SetWeaponHoldType( self.HoldType )
	self.Owner:SetNWFloat("mm_pumpkinnade_recharge", 0)
end
 
function SWEP:Deploy()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	self:EmitSound("weapons/deploy.wav")
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    self:SetWeaponHoldType(self.HoldType)
	self:SetPrimed(false)
	self.MyOwner = self.Owner
	self:SetMM_PrimeTime(0)
	self:SetNextPrimaryFire(CurTime()+0.5)
	return true 
end
 
function SWEP:PrimaryAttack()
end
 
function SWEP:SecondaryAttack()
end
 
function SWEP:Reload()
        self.Weapon:DefaultReload( ACT_VM_RELOAD );
end
 
function SWEP:Think()
	self:LegsDismembered()
	if self.Weapon:Clip1() < 1 then
		self.Owner:GetViewModel():SetPlaybackRate( 0 )
		return
	elseif self.Owner:GetNWFloat("mm_pumpkinnade_recharge") != 0 then
		self.Owner:GetViewModel():SetPlaybackRate( 1 )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:SetNextPrimaryFire(CurTime()+0.5)
		self.Owner:SetNWFloat("mm_pumpkinnade_recharge",0)
	end
	
    if self:GetNextPrimaryFire() < CurTime() && self.Owner:KeyPressed(IN_ATTACK) && self:GetMM_PrimeTime() == 0 then
        self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
        self:SetGun_FakeTimer1(CurTime()+1)
        self:SetMM_PrimeTime(self:GetMM_PrimeTime() + 175)
    end
	
    if self:GetMM_PrimeTime() != 0 && self.Owner:KeyDown(IN_ATTACK) then
        if self:GetMM_PrimeTime() < 825 then
            self:SetMM_PrimeTime(self:GetMM_PrimeTime() + 10)
        end
    end
    if self:GetPrimed() == true then
		if self:GetMM_PrimeTime() != 0 && self:GetNextPrimaryFire() < CurTime() && !self.Owner:KeyDown(IN_ATTACK) then
			self:SetPrimed(false)
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Weapon:SetGun_FakeTimer2(CurTime()+0.2)
			self:EmitSound("weapons/bone/swing1.wav")
			if SERVER then
				self.Owner:SetAnimation(PLAYER_ATTACK1)
				local grenade = ents.Create("ent_pumpkin_nade")
		 
				local pos = self.Owner:GetShootPos()
				pos = pos + self.Owner:GetForward() * 1
				pos = pos + self.Owner:GetRight() * 9
			 
				if self.Owner:KeyDown(IN_SPEED) then
					pos = pos + self.Owner:GetUp() * -4
				else
					pos = pos + self.Owner:GetUp() * -1
				end
				grenade:SetPos(pos)
				grenade:SetAngles(Angle(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
				grenade:SetOwner(self.Owner)
				grenade:Spawn()
				grenade:Activate()
				 
				local phys = grenade:GetPhysicsObject()
			 
				self.Force = self:GetMM_PrimeTime()
			 
				phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))
	 
				phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
			end
			self:TakePrimaryAmmo(1) 
			local rnda = self.Primary.Recoil * -1
			local rndb = self.Primary.Recoil * math.random(-1, 1)
			self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
			self.Owner:SetNWFloat("mm_pumpkinnade_recharge", CurTime()+20)
			if SERVER then
				self.Owner:SelectWeapon("mm_candlestick")
				self.Owner:SelectWeapon(self.Owner:GetNWString("Melee"))
				self.Owner:SelectWeapon(self.Owner:GetNWString("Small"))
				self.Owner:SelectWeapon(self.Owner:GetNWString("Primary"))
			end
		end
    end
	
    if self:GetGun_FakeTimer1() > 0 && CurTime() > self:GetGun_FakeTimer1() then
        self:SetPrimed(true)
        self:SetGun_FakeTimer1(0)
    end
    if self:GetGun_FakeTimer2() > 0 && CurTime() > self:GetGun_FakeTimer2() then
        self:SetGun_FakeTimer2(0)
    end
end

function SWEP:OnDrop()
	if self:GetMM_PrimeTime() > 0  && self.Weapon:Clip1() > 0 then
		local grenade = ents.Create("ent_pumpkin_nade")
 		grenade:SetPos(self:GetPos())
		grenade:SetAngles(Angle(0,0,0))
		grenade:SetOwner(self.Owner)
		grenade:Spawn()
		grenade:Activate()
		grenade.MyOwner = self.MyOwner
		self:Remove()
	else
		self.Owner = nil
		timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then  self:Remove() end end)
	end
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

if CLIENT then
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	function SWEP:GetViewModelPosition(pos, ang)
		if !IsValid(self.Owner) then return end
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
        if IsValid(self.Owner) && !self.Owner:KeyDown(IN_SPEED) && !(self.Owner:KeyDown(IN_DUCK) && walkspeed > 40) then
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
        if self.Owner:KeyDown(IN_DUCK) && !(Tr.Hit and Tr.HitPos:Distance(self.Owner:GetShootPos()) < 40) then 
			if walkspeed > 40 then
			TestVectorTarget = self.CrouchMovePos
            TestVectorAngleTarget = self.CrouchMoveAng
			else
            TestVectorTarget = self.CrouchPos
            TestVectorAngleTarget = Vector(0,0,0)
			end
        else
            TestVectorTarget = Vector(0,0,0)
            TestVectorAngleTarget = Vector(0,0,0)
        end
        
		
		local BreatTime = RealTime() * walkspeed/200
		local MoveForce = CalcMoveForce(LocalPlayer())
		TestVectorTarget = TestVectorTarget + Vector(0 ,0 , 0- math.Clamp(self.Owner:GetVelocity().z / 300,-1,1))
        
        -- This I don't like however. I REALLY need to redo this part
        -- Be wary of tears
		if (self.Owner:KeyDown(IN_DUCK) && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT))) then
			mynum1 = 5
			mynum2 =  2
        elseif !self.Owner:KeyDown(IN_WALK) && !self.Owner:KeyDown(IN_DUCK) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			mynum1 = 15
			mynum2 =  3
		elseif (self.Owner:KeyDown(IN_WALK)|| self.Owner:KeyDown(IN_DUCK)) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			mynum1 = 10
			mynum2 =  20
		elseif walkspeed < 1 && !self.Owner:KeyDown(IN_DUCK) then
			mynum1 = 1
			mynum2 =  10
        else
            mynum1 = 0
			mynum2 =  100000
		end

		
		local BreatTime = RealTime() * mynum1
		local MoveForce = CalcMoveForce(ply)
			
		TestVectorAngleTarget = TestVectorAngleTarget + Vector(math.cos(BreatTime) / mynum2, (math.cos(BreatTime / 2) / mynum2),0)
        
		if self.Owner:KeyDown(IN_DUCK) then
			if CrouchAng < 1 then
				CrouchAng = CrouchAng + 0.01
				CrouchAng2 = CrouchAng2 - 0.01
			end
		else
			if CrouchAng > 0 then
				CrouchAng = CrouchAng - 0.01
				CrouchAng2 = CrouchAng2 + 0.01
			end
		end
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
