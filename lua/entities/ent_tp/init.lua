AddCSLuaFile( "shared.lua" )
include("shared.lua")

ENT.Type = "anim"
ENT.Name = "Toilet Paper"
ENT.PrintName = "Toilet Paper"

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/w_tp.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	if (SERVER) then
		self:SetUseType(SIMPLE_USE)
	end
	self.Entity:DrawShadow( false )
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.MyOwner = self.Owner
	self:SetNWBool("HitAlready",false)
	local trail = util.SpriteTrail( self, 0, Color( 255, 255, 255 ), true, 5, 0, 1, 1 / ( 5 + 0 ) * 0.5, "models/weapons/monstermash/tp/tp_trail" )
	self.RemoveEnt = CurTime() + GetConVar( "mm_cleanup_time" ):GetInt()
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
if (SERVER) then
	function ENT:Use(_, pCaller)
		if (pCaller:IsPlayer()) then
			pCaller:Give("mm_toiletpaper")
            pCaller:SetNWFloat("mm_tp_recharge", CurTime()-1)
			self.Entity:Remove()
		end
	end
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )
    if ent:GetClass() == "trigger_soundscape" then return end
	local speed = self:GetVelocity():Length()
	if ent:IsValid() && (ent:IsPlayer() || ent:IsWorld()) && self:GetNWBool("HitAlready") == false && ent:GetNWFloat("DivingRight") < CurTime() && ent:GetNWFloat("DivingLeft") < CurTime() then
        AddMedal(self.Owner, "tp")
        self:SetNWBool("HitAlready", true)
    end
end

function ENT:Think()
	if self.RemoveEnt and CurTime()>self.RemoveEnt then self:Remove() end
	self:NextThink(CurTime()) return true
end

util.AddNetworkString("MMGiveTP")
function MMGiveTP(len,client)
	if IsValid(client) then
		local ent = net.ReadEntity()
        ent:Give("mm_toiletpaper",false)
        ent:SetNWFloat("mm_tp_recharge", CurTime()-1)
	end
end
net.Receive("MMGiveTP", MMGiveTP)