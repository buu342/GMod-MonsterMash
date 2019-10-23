AddCSLuaFile( "shared.lua" )
include("shared.lua")

ENT.Type = "anim"
ENT.Name = "Skull"
ENT.PrintName = "Skull"

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/w_skull.mdl")
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
			pCaller:Give("mm_skull")
            pCaller:SetNWFloat("mm_skull_recharge", CurTime()-1)
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
	if ent:IsValid() && self:GetNWBool("HitAlready") == false && ent:GetNWFloat("DivingRight") < CurTime() && ent:GetNWFloat("DivingLeft") < CurTime() then
		local damage = 25
        if GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 2 then
            damage = 9001
        end
        self.NotStuck = false
		local d = DamageInfo()
		d:SetDamage(damage)
		d:SetDamageType(DMG_SLASH)
		d:SetAttacker( self.MyOwner )
		d:SetInflictor(self.Inflictor)
		ent:TakeDamageInfo(d)
		self.Owner = nil
		self:SetOwner(nil)
    end
    self:SetNWBool("HitAlready", true)
end

function ENT:Think()
	if self:IsValid() then
		self.Owner = nil
		self:SetOwner(nil)
	end
	if self.RemoveEnt and CurTime()>self.RemoveEnt then self:Remove() end
	self:NextThink(CurTime()) return true
end

util.AddNetworkString("MMGiveSkull")
function MMGiveSkull(len,client)
	if IsValid(client) then
		local ent = net.ReadEntity()
        ent:Give("mm_skull",false)
        ent:SetNWFloat("mm_skull_recharge", CurTime()-1)
	end
end
net.Receive("MMGiveSkull", MMGiveSkull)