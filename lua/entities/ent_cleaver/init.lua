AddCSLuaFile( "shared.lua" )
include("shared.lua")

local function simplifyangle(angle)
	while (angle >= 180) do
		angle = angle - 360;
	end

	while (angle <= -180) do
		angle = angle + 360;
	end

	return angle;
end

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/w_cleaver.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.NotStuck = true
	self.RemoveEnt = CurTime() + GetConVar( "mm_cleanup_time" ):GetInt()
end

function ENT:Think()
	soundfx = CreateSound( self, Sound("weapons/cleaver_fly.wav") )
	if self.NotStuck == true then
		for k, v in pairs( player.GetAll() ) do
			if v:GetPos():Distance(self:GetPos()) < 128 then
				soundfx:Play()
			end
		end
	end
	if self.RemoveEnt and CurTime()>self.RemoveEnt then self:Remove() end
	self:NextThink(CurTime()) return true
end

/*---------------------------------------------------------
Explode
---------------------------------------------------------*/
function ENT:OnRemove()
end
	
/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage()
end

/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use()
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )
    if ent:GetClass() == "trigger_soundscape" then return end
	if ent:IsValid() then
		local damage = 25
        self.NotStuck = false
        self:SetNetworkedBool("HitAlready", true)
        self:SetParent(ent)
		if ent:IsPlayer() && ent:GetNWFloat("DivingRight") < CurTime() && ent:GetNWFloat("DivingLeft") < CurTime() then
			ent:TakeDamage(damage, self:GetNWEntity("Cleaver_Attacker"), self:GetNWEntity("Cleaver_Inflictor"))
            ent:SetNWFloat("MM_BleedTime", CurTime() + 1)
            ent:SetNWInt("MM_BleedDamage", 7)
            ent:SetNWEntity("MM_BleedOwner", self:GetNWEntity("Cleaver_Attacker"))
            ent:SetNWEntity("MM_BleedInflictor", self:GetNWEntity("Cleaver_Inflictor"))
		end
        self:Remove()
    end
	if ent:IsPlayer() then
		self.Parenty = 1
	elseif ent:IsNPC() then
		self.Parenty = 2
	end
    self:SetPos(self:GetPos() + self:GetForward()*0)
end