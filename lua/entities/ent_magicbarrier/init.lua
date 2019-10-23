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

	self.Entity:SetModel("models/XQM/Rails/gumball_1.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
    self:SetNoDraw(true)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true) 
	end
	
    timer.Simple(1, function() self:Remove() end)
end

function ENT:Think()
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 196)) do
        local ent = v
        local entlist = {
            "ent_acidflask",
            "ent_arrow",
            "ent_arrow_fire",
            "ent_cannonball",
            "ent_cleaver",
            "ent_fireball",
            "ent_fireballsmol",
            "ent_flare",
            "ent_gorejar",
            "ent_pumpkin_nade",
            "ent_sawblade",
            "ent_skull",
            "ent_smokenade",
            "ent_spidernade",
            "ent_tp",
            "ent_urn"
        }
        if table.HasValue(entlist, ent:GetClass()) then
            local pos = ent:GetPos()
            local effectdata = EffectData()
            effectdata:SetStart( pos ) 
            effectdata:SetOrigin( pos )
            effectdata:SetScale( 1 )
            util.Effect( "ManhackSparks", effectdata )
            ent:Remove()
        end
    end
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