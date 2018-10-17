/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Dueling Pistol"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= false
SWEP.AdminSpawnable= false
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_musketpistol.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_musketpistol.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "melee" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = true

SWEP.Base = "mm_base_plain"

SWEP.Primary.Sound = "weapons/revolver/fire1.wav" 
SWEP.Primary.Damage = 85
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1 
SWEP.Primary.Ammo = "strider"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.2
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 6
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Spread = 0
SWEP.Secondary.Recoil = 0

SWEP.TimeToHit = 0.1
SWEP.Reach = 75
SWEP.HitSound1 = Sound("crowbar/crowbar_hit-1.wav")
SWEP.HitSound2 = Sound("crowbar/crowbar_hit-2.wav")
SWEP.HitSound3 = Sound("crowbar/crowbar_hit-3.wav")
SWEP.HitSound4 = Sound("crowbar/crowbar_hit-4.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")

SWEP.WalkSpeed = 220
SWEP.DefaultWalkSpeed = 220

SWEP.CrouchPos = Vector(-1,-1,.5) -- Moves the gun when you crouch

SWEP.CrouchMovePos = Vector (0, 0, 0) -- Movement when crouching
SWEP.CrouchMoveAng = Vector (0, 0, 0)

SWEP.BobScale = 0 -- Real men code their own bob
SWEP.SwayScale = 0.2 -- I'm too lazy to code my own sway, plus this one works just fine soooooo....

SWEP.MeleeDecal_LeaveBullethole = true -- Should the weapon leave bullet holes/blood?
SWEP.MeleeDecal_MakeBlood = false -- Only set this to true if bulletholes is false and/or MeleeDecal_Use is true

SWEP.MeleeDecal_Use	= true -- Use sexy melee decals
SWEP.MeleeDecal_Amount = 5 -- How many decals to make
SWEP.MeleeDecal_Spread = 20	-- How spread is each decal? Use wisely to avoid green crap
SWEP.MeleeDecal_Speed = 0.002 -- How quickly are the decals generated?
SWEP.MeleeDecal_Direction = 1 -- Set to -1 to go from left to right
SWEP.MeleeDecal_Decal = "ManhackCut" -- Decal, duh

SWEP.ConcussChance		= 0
SWEP.BleedChance		= 0
SWEP.DismemberChance	= 0
SWEP.CanAssassinate		= true

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Faketimer")
	self:NetworkVar("Float",1,"Faketimer2")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
	self:EmitSound("weapons/deploy.wav")
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:SetNextPrimaryFire(CurTime()+1)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end
	
function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
    self:SetFaketimer(CurTime() + self.TimeToHit)
	self:SetFaketimer2(CurTime() + self.TimeToHit/2)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
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
    self:DoOtherStuff()
end

function SWEP:DoOtherStuff()

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
	
	if self.Owner:GetNWFloat("LastKeyDown4") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown3") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown2") >= CurTime() or self.Owner:GetNWFloat("LastKeyDown1") >= CurTime() then return end
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

function SWEP:MeleeDecal( trace, decal ) 
	if self.MeleeDecal_Use == true then
		for loop = 1,self.MeleeDecal_Amount do 
			timer.Simple( self.MeleeDecal_Speed*loop, function() 
				if not IsValid(self) || not IsValid(self.Owner) then return end 
				local INC = (self.MeleeDecal_Spread - (((2*self.MeleeDecal_Spread)/self.MeleeDecal_Amount)*loop))*self.MeleeDecal_Direction
				local OWNER = self.Owner 
				local TR = trace 
				TR.endpos = TR.endpos + OWNER:EyeAngles():Forward()*5 
				local TRACE1 = util.TraceLine(TR) 
				local TR2 = {} 
				TR2.start = TRACE1.HitPos + TRACE1.HitNormal*2 + OWNER:EyeAngles():Right()*INC 
				TR2.endpos = TR2.start - TRACE1.HitNormal*5 
				TR2.mask = MASK_PLAYERSOLID 
				TR2.filter = self.Owner 
				local TRACE = util.TraceLine(TR2) 
				local TP = TRACE.HitPos + TRACE.HitNormal 
				local TM = TRACE.HitPos - TRACE.HitNormal 
				if TRACE.HitWorld then 
					util.Decal( decal, TP, TM ) 
				end 
			end) 
		end 
	end
end 

function SWEP:SecondaryAttack()
/*
	self.Owner:SetNWBool("DoingTauntCamera", true)
	timer.Simple(3, function() self.Owner:SetNWBool("DoingTauntCamera", false) end)
*/
end

function SWEP:Holster()
	if IsValid(self) && IsValid(self.Owner) then 
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    else
        self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
        self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
    end
    self:SetFaketimer(0)
	self:SetFaketimer2(0)
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

SWEP.BuuSwayScale = 60

if CLIENT then
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	local Current_Aim = Angle(0,0,0)
	SWEP.LastEyeSpeed = Angle(0,0,0)
	SWEP.EyeSpeed = Angle(0,0,0)
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
		
		/*--------------------------------------------
		--				Viewmodel Sway				--
		--------------------------------------------*/
		
		self.LastEyeSpeed = self.EyeSpeed
		
		Current_Aim = LerpAngle(5*FrameTime(), Current_Aim, ply:EyeAngles())
		
		self.EyeSpeed = Current_Aim - ply:EyeAngles()
		self.EyeSpeed.y = math.AngleDifference( Current_Aim.y, ply:EyeAngles().y ) -- Thank you MushroomGuy for telling me this function even existed
		
		ang:RotateAroundAxis(ang:Right(), math.Clamp(4*self.EyeSpeed.p/self.BuuSwayScale,-4,4))
		ang:RotateAroundAxis(ang:Up(), math.Clamp(-4*self.EyeSpeed.y/self.BuuSwayScale,-4,4))

		pos = pos + math.Clamp((-1.5*self.EyeSpeed.p/self.BuuSwayScale),-1.5,1.5) * ang:Up()
		pos = pos + math.Clamp((-1.5*self.EyeSpeed.y/self.BuuSwayScale),-1.5,1.5) * ang:Right()
		
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
                ang.yaw = ang.yaw + math.cos(BreatTime /2) / MoveForce
                if !IsValid(weapon) then return end
                cmd:SetViewAngles(ang) 
        end
end
hook.Add ("CreateMove", "BuuIronIdleMove", IronIdleMove)