SWEP.SelectIcon = "vgui/entities/mm_shield"
SWEP.Cost = 20
SWEP.Points = 40

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Shield + Revolver"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_revolver_1hand.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_shield.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "duel" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/revolver/fire1.wav" 
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6 
SWEP.Primary.Ammo = "ammo_revolver"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 0.8
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseDistance = true
SWEP.ShootDistance = 1152

SWEP.CrouchPos = Vector(-1,-1,.5) -- Moves the gun when you crouch

SWEP.CrouchMovePos = Vector (0, 0, 0) -- Movement when crouching
SWEP.CrouchMoveAng = Vector (0, 0, 0)

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Shield_Reloading")
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_Reload")
    self:NetworkVar("Bool",1,"Gun_MessWithArmStuff")
end

function SWEP:Holster()
	if SERVER then
		if(self.Shield and self.Shield:IsValid()) then
			self.Shield:Remove()
			self.Shield = nil
		end
	end
	if IsValid(self.Owner) then 
		if IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():SetSubMaterial( 0, "" )
		end
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
        return true
	end
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool",0,"Shield_Reloading")
	self:NetworkVar("Bool",1,"Shield_Shielding")
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_Reload")
	self:NetworkVar("Float",3,"Gun_ShieldTimer")
    self:NetworkVar("Bool",2,"Gun_MessWithArmStuff")
end

function SWEP:Reload()
	if self:Clip1() < self:GetMaxClip1() && self:GetShield_Reloading() == false && !self:GetShield_Shielding()  then
        self:SetShield_Reloading(true)
		self.Owner:SetAmmo(self.Primary.DefaultClip, self:GetPrimaryAmmoType())	
		self:SendWeaponAnim( ACT_VM_HOLSTER )
		self:SetGun_FakeTimer2(CurTime()+0.5)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
        end
        self:SetGun_Reload(CurTime()+2.9)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        end
	end
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() || !self.Owner:IsOnGround() then return end
	if ( !self:CanPrimaryAttack() ) || self:GetShield_Reloading() == true || self:GetShield_Shielding() then return end
	if self:Clip1() > 0 then
		self:SetGun_FakeTimer1(CurTime()+0.5)
		 
		local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = self.Owner:GetShootPos() 
		bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 1
		bullet.TraceName = "Tracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		bullet.Callback = function(attacker, tr, dmginfo)
            dmginfo:SetInflictor(self)
		end
	
		local rnda = self.Primary.Recoil * -1 
		local rndb = self.Primary.Recoil * math.random(-1, 1) 
		 
		self:ShootEffects()
		 
		self.Owner:FireBullets( bullet ) 
		self:EmitSound(Sound(self.Primary.Sound)) 
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
	end
end 


function SWEP:Think()
	if self:GetShield_Shielding() == true then
		self.Owner:GetViewModel():SetSkin(1)
	else
		self.Owner:GetViewModel():SetSkin(0)
	end
    
    if self:GetNextPrimaryFire() < CurTime() && self.Weapon:Clip1() == 0 && self.Owner:GetNWInt("MM_AutoReload") == 1 && self:GetGun_FakeTimer2() < CurTime() && self:GetGun_FakeTimer2() == 0 then
        self:Reload()
    end
    
    if self:GetGun_FakeTimer2() < CurTime() then
        self:SetGun_FakeTimer2(0)
    end

	if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
        self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:GetViewModel():SetPlaybackRate(1)
	elseif (self:GetGun_FakeTimer2() > 0 && CurTime() < self:GetGun_FakeTimer2()) || self:GetShield_Reloading() == true then
        self.Owner:SetWalkSpeed(self.ReloadSpeed)
	else
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end
    if CurTime() > self:GetGun_Reload() && self:GetGun_Reload() > 0 then
        self:SetGun_Reload(0)
		self:SetNextPrimaryFire( CurTime() + 0.7 )
		self:SendWeaponAnim( ACT_VM_DRAW )
        self:SetShield_Reloading(false)
        local ammo = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
        self.Owner:RemoveAmmo( self.Primary.ClipSize - self.Weapon:Clip1(), self.Weapon:GetPrimaryAmmoType() )
        if ammo > self.Primary.ClipSize then
            self.Weapon:SetClip1(self.Primary.ClipSize)
        else
            self.Weapon:SetClip1(math.min(self.Primary.ClipSize,self.Weapon:Clip1() + ammo))
        end
    end
    if self.Owner:KeyDown(IN_ATTACK2) && self:GetShield_Reloading() == false && self:GetNextPrimaryFire() < CurTime() && self:GetNextPrimaryFire() < CurTime() then
		if self:GetShield_Shielding() == false then
			self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "idle_to_blocked" ))
			self.Owner:GetViewModel():SetPlaybackRate(2)
			self:SetGun_ShieldTimer(CurTime() + 0.2)
		end
		
		self:SetShield_Shielding(true)
        self:SetHoldType("smg")
		self:SetNextPrimaryFire( CurTime() + 0.1 )
		
		if SERVER && !self.Shield && self:GetGun_ShieldTimer() < CurTime() then
			local Ent = ents.Create("prop_physics")
			Ent:SetModel("models/weapons/monstermash/shield_physics.mdl")
			Ent:SetOwner(self.Owner)
			Ent:Spawn()
			Ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			Ent:SetRenderMode( RENDERMODE_TRANSALPHA )
			Ent:SetColor( Color( 255, 255, 255,0) )
			local phys = Ent:GetPhysicsObject()
			phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
			phys:EnableMotion(false)
			self.Shield = Ent
		end
	end
    if !self.Owner:KeyDown(IN_ATTACK2) && self:GetShield_Shielding() == true && self:GetGun_ShieldTimer()+0.3 < CurTime() then
		self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "blocked_to_idle" ))
		self.Owner:GetViewModel():SetPlaybackRate(2)
		self:SetNextPrimaryFire( CurTime() + 0.3 )
        self:SetHoldType("duel")
		self:SetShield_Shielding(false)
		if SERVER then
            if(self.Shield and self.Shield:IsValid()) then
                self.Shield:Remove()
				self.Shield = nil
            end
        end
    end
    if SERVER then
        if(self.Shield and self.Shield:IsValid()) then
            local Offset = Vector(0,0,48)
            if(self.Owner:Crouching()) then
                Offset.z = Offset.z - 0
                Offset.x = Offset.x + 0
            end
			
			local hand
			hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

			offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 + hand.Ang:Up() * 0

			hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
			hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
			hand.Ang:RotateAroundAxis(hand.Ang:Up(), -90)

            self.Shield:SetPos(hand.Pos + offset)
            self.Shield:SetAngles(hand.Ang)
        end
    end
    
    if self.Owner:GetNWInt("LegMissing") == 3 || self.Owner:GetNWInt("ArmMissing") != 0 then
        if SERVER then
            self.Owner:Give("mm_revolver")
            self.Owner:SelectWeapon("mm_revolver")
        end
        self.Owner:GetActiveWeapon():SetClip1( self:Clip1() )
        self:Remove()
    end
	self:LegsDismembered()
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetNextPrimaryFire( CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:EmitSound("weapons/deploy.wav")
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
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