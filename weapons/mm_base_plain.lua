SWEP.Spawnable= false
SWEP.AdminSpawnable= false
SWEP.AdminOnly = false

SWEP.CrosshairMaterial = Material( "" )
SWEP.CrosshairSize = 0
SWEP.CrosshairChargeMaterial = Material("")
SWEP.CrosshairChargeSize = 0
SWEP.CrosshairRechargeMaterial = Material( "" )
SWEP.CrosshairRechargeSize = 0

SWEP.MessedWithArmStuff = false

SWEP.Base = "weapon_base"

if SERVER then
    util.AddNetworkString("GetAutoReloadMM")
end


function bool_to_number(value)
    if value == true then
        return 2
    else
        return 0
    end
end

function SWEP:LegsDismembered()
    self:ArmsDismembered()
    self:DodgeStuff()
    if CLIENT then
        self:CheckAutoReload()
    end
    if IsValid(self.Owner) then
        if self.Owner:GetNWFloat("Sticky") > CurTime() then
            self.Owner:SetJumpPower(0)
            return
        else
            self.Owner:SetJumpPower(200)
        end
    end
    if IsValid(self.Owner) then
        if self.Owner:GetNWInt("LegMissing") == 3 then
            if self.Owner:GetNWInt("ArmMissing") == 0 then
                self:SetHoldType(self.HoldType)
            elseif self.Owner:GetNWInt("ArmMissing") != 3 then
                self:SetHoldType("duel")
            end
            self.Owner:SetViewOffset( Vector(0,0,20) )
            self.Owner:SetViewOffsetDucked( Vector(0,0,20) )
            
            local bottom, top = self.Owner:GetHull()
            local bottom2, top2 = self.Owner:GetHullDuck()
            self.Owner:SetHull(bottom, Vector(16,16,25))
            self.Owner:SetHullDuck(bottom2, Vector(16,16,25))
        else
            self.Owner:SetViewOffset( Vector(0,0,64) )
            self.Owner:SetViewOffsetDucked( Vector(0,0,28) )
            
            local bottom, top = self.Owner:GetHull()
            local bottom2, top2 = self.Owner:GetHullDuck()
            self.Owner:SetHull(bottom, Vector(16,16,72))
            self.Owner:SetHullDuck(bottom2, Vector(16,16,36))
        end
    end
    if self.Owner:GetNWInt("LegMissing") == 3 then
        if self.Base == "mm_gun_base" && self:GetNextPrimaryFire() > CurTime() then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)    
        else
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        end
    elseif self.Owner:GetNWInt("LegMissing") != 0 && self.Owner:IsOnGround() == true then
		self.Owner:SetWalkSpeed(1)
		self.Owner:SetRunSpeed(1)

		local power_jump = 150
		local power_forward = 200
		if self.Owner:GetNWFloat("NextHop") == 0 then
			self.Owner:SetNWFloat("NextHop", CurTime() + 0.35)
		end
		
		if self.Owner:GetNWFloat("NextHop") < CurTime() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT)) then
			self.Owner:SetGroundEntity(NULL)
			self.Owner:SetNWFloat("NextHop",0)
			local vPoint
			if self.Owner:GetBodygroup(3) != 3 then
				if self.Owner:GetBodygroup(3) == 1 then
					vPoint = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Thigh"))
				elseif self.Owner:GetBodygroup(3) == 2 then
					vPoint = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Thigh"))
				end
                if (vPoint == nil) then return end
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "BloodImpact", effectdata )
			end
			
			local start = self.Owner:GetPos()
			local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
			util.Decal("Blood", btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal,self.Owner)
			
			if self.Owner:KeyDown(IN_FORWARD) && !(self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT) || self.Owner:KeyDown(IN_BACK)) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_BACK) && !(self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT) || self.Owner:KeyDown(IN_FORWARD)) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + -vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_MOVELEFT) && !(self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVERIGHT)) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,-90,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + -vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_MOVERIGHT) && !(self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT)) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,90,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + -vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_FORWARD) && self.Owner:KeyDown(IN_MOVERIGHT) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,-45,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_FORWARD) && self.Owner:KeyDown(IN_MOVELEFT) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,45,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_BACK) && self.Owner:KeyDown(IN_MOVERIGHT) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,45,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + -vec*power_forward + Vector(0,0,1)*power_jump )
			elseif self.Owner:KeyDown(IN_BACK) && self.Owner:KeyDown(IN_MOVELEFT) then
				local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0)
				vec:Rotate( Angle(0,-45,0) )
				self.Owner:SetVelocity( -self.Owner:GetVelocity() + -vec*power_forward + Vector(0,0,1)*power_jump )
			end
		end
	end
end

function SWEP:ArmsDismembered()
    if self.Owner:GetNWInt("ArmMissing") > 0 && self:GetGun_MessWithArmStuff() == false && self:GetClass() != "mm_sawedoff" && self:GetClass() != "mm_musketpistol" then
        self:SetGun_MessWithArmStuff(true)
    end

    if (self.Owner:GetNWInt("ArmMissing") > 0 && self.Owner:GetNWInt("ArmMissing") != 3) && self.Base != "mm_melee_base" && self:GetClass() != "mm_wand" then
        self:SetHoldType("duel")
    elseif (self.Owner:GetNWInt("ArmMissing") > 0 && self.Owner:GetNWInt("ArmMissing") != 3) then
        self:SetHoldType("fist")
    elseif self.Owner:GetNWInt("ArmMissing") == 3 && self:GetHoldType() != "melee" then
        self:SetHoldType("normal")
    end
    if CLIENT then
        if IsValid(self.Owner:GetHands()) then
            if self.Owner:GetNWInt("ArmMissing") == 0 then
                self.Owner:GetHands():SetBodygroup(1,0)
            elseif self.Owner:GetNWInt("ArmMissing") != 0 then
                self.Owner:GetHands():SetBodygroup(1,1)
            end
            if self.Owner:GetNWInt("ArmMissing") == 2 then
                self.ViewModelFlip = true
            else
                self.ViewModelFlip = false
            end
        end
    end
    if IsValid(self.Owner) && self.Owner:GetNWFloat("MM_Deanimatorstun") > CurTime() then 
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetBonePosition( self.Owner:LookupBone("ValveBiped.Bip01_Spine1") ) )
		util.Effect( "StunstickImpact", effectdata )
        if GetConVar("mm_deanimatorshake") != nil && GetConVar("mm_deanimatorshake"):GetInt() == 1 then
            self.Owner:ViewPunch(Angle(math.Rand(-2,2),math.Rand(-2,2),0))
        end
    end
    if IsValid(self.Owner) && self.Owner:GetNWFloat("MM_Hallucinate") < CurTime() && self.Owner:GetNWFloat("MM_Hallucinate") != 0 then
    self.Owner:SetNWFloat("MM_Hallucinate", 0)
    self.Owner:SetDSP(0, false)
    end
end

local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end
	//print(self.Owner:Name().." - "..self.Owner:GetNWInt("LegMissing"))
	
    self.ActivityTranslate = {}
    self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
    self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
    self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
    self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
    self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
    self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
    self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
    self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
    self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
    self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
    self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
    self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9

	
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

	self:SetupWeaponHoldTypeForAI( t )

end

function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
		if ( self.ActivityTranslateAI[ act ] ) then
			return self.ActivityTranslateAI[ act ]
		end
		return -1
	end

    if ( self.ActivityTranslate[ act ] != nil ) then
        if self.Owner:GetNWInt("LegMissing") == 3 && (self.HoldType == "pistol" || self.HoldType == "revolver") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_PISTOL end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_PISTOL end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_RELOAD_PRONE_PISTOL end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_RELOAD_PRONE_PISTOL end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_PISTOL end
        elseif self.Owner:GetNWInt("LegMissing") == 3 && (self.HoldType == "melee" || self.HoldType == "melee2" || self.HoldType == "knife" || self.HoldType == "slam") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_AIM_KNIFE end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_AIM_KNIFE end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_AIM_KNIFE end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_SPADE end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_SPADE end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_SPADE end
        elseif self.Owner:GetNWInt("LegMissing") == 3 && (self.HoldType == "ar2" || self.HoldType == "smg" || self.HoldType == "crossbow" || self.HoldType == "rpg" || self.HoldType == "shotgun") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_30CAL end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_30CAL end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_RELOAD_BAR end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_RELOAD_BAR end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_30CAL end
        elseif self.Owner:GetNWInt("LegMissing") == 3 && (self.HoldType == "grenade"|| self.HoldType == "normal") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_GREN_FRAG end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_GREN_FRAG end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_GREN_FRAG end
        else
            return self.ActivityTranslate[ act ]
        end
    end

	return -1

end

local CMoveData = FindMetaTable( "CMoveData" )
function CMoveData:RemoveKeys( keys )
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

hook.Add( "SetupMove", "DisableStuffIfNoLegs", function( ply, mvd, cmd )
	if ply:GetBodygroup(3) == 3 then
		if mvd:KeyDown( IN_JUMP ) then
			mvd:RemoveKeys( IN_JUMP )
		end
		if mvd:KeyDown( IN_DUCK ) then
			mvd:RemoveKeys( IN_DUCK )
		end
	end
end )

function SWEP:DodgeStuff()
    if gmod.GetGamemode().Name == "Monster Mash" then
        local ply = self.Owner
        if !IsValid(ply) || !ply:Alive() then return end
        if ply:GetNWFloat("Sticky") > CurTime() || ply:GetNWFloat("Spooked") > CurTime() || ply:GetNWFloat("LegMissing") == 3 || ply:GetNWFloat("DiveCooldown") < 5 then return end
        if ply:KeyDown(IN_MOVELEFT) && ply:KeyDown(IN_SPEED) then
            ply:SetNWFloat("DiveCooldown", 0)
            ply:AnimRestartMainSequence()
            ply:SetCycle(0.17)
            ply:Freeze(true)
            ply:SetNWFloat("DivingLeft", CurTime()+0.5)
            if SERVER then
                net.Start( "DoLeftDive" )
                    net.WriteEntity(ply)
                net.Broadcast()
            end
        elseif ply:KeyDown(IN_MOVERIGHT) && ply:KeyDown(IN_SPEED) then
            ply:SetNWFloat("DiveCooldown", 0)
            ply:AnimRestartMainSequence()
            ply:SetCycle(0)
            ply:Freeze(true)
            ply:SetNWFloat("DivingRight", CurTime()+0.5)
            if SERVER then
                net.Start( "DoRightDive" )
                    net.WriteEntity(ply)
                net.Broadcast()
            end
        end
    end
end

function SWEP:GetBoneOrientation( ent, bonename )
	
	local pos, ang

	if (!ent:LookupBone(bonename)) then return nil, nil end
	
	local bone = ent:GetBoneMatrix(ent:LookupBone(bonename))
	if (bone) then
		pos, ang = bone:GetTranslation(), bone:GetAngles()
	else
		pos, ang = Vector(0,0,0), Angle(0,0,0)
	end
	
	return pos, ang
end

function SWEP:DrawWorldModel()
    if !IsValid(self.Owner) then self:DrawModel() return end
    if self.Owner:GetNWBool("MM_UsingInvisibility") then return end
    if self:GetClass() == "mm_shield" || self.Owner:GetNWInt("ArmMissing") == 0 || self.Owner:GetNWInt("ArmMissing") == 1 then
        self:DrawModel()
    else
        self:SetModel(string.sub( self.WorldModel, 1, string.len(self.WorldModel)-4 ).."_left.mdl")
        self:DrawModel()
    end
end

if CLIENT then
    local lastvalue = 2 
    function SWEP:CheckAutoReload()
        if GetConVar("mm_autoreload"):GetInt() != lastvalue then
            net.Start("GetAutoReloadMM")
                net.WriteInt(GetConVar("mm_autoreload"):GetInt(), 32)
            net.SendToServer()
            lastvalue = GetConVar("mm_autoreload"):GetInt()
        end
    end
end

net.Receive("GetAutoReloadMM", function(len, ply)
    local autoreload = net.ReadInt(32)
    ply:SetNWInt("MM_AutoReload", autoreload)
end)