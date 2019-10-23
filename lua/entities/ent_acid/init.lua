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

ENT.PrintName = "Test"
ENT.Spawnable = true
ENT.Category = "Test"

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/acid_puddle.mdl")
	self.Entity:PhysicsInit( SOLID_OBB )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow( false )
	self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetModelScale( 0, 0)
	-- Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	timer.Simple(20, function() if IsValid(self) then if self.LoopSound then self.LoopSound:Stop() end self:Remove() end end)
	self:SetNWFloat("AcidScale", 0)
	self:SetNWFloat("AcidTime", CurTime()+20)
	self:SetNWInt("AcidAlpha", 255)
    self.LoopSound = CreateSound( self, "ambient/levels/canals/toxic_slime_loop1.wav" ) 
    if self.LoopSound then
        self.LoopSound:SetSoundLevel( 65 ) 
        self.LoopSound:Play()
    end
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

function ENT:Think()
	if self:GetNWFloat("AcidTime")-4 > CurTime() then
		self:SetModelScale(1, 0.3)
	else
		self:SetModelScale(0, 1)
	end
    for k, v in pairs(player.GetAll()) do
        if v:GetPos():Distance(self:GetPos()) < self:GetModelScale()*100 && v:GetPos().z > self:GetPos().z-5 && v:GetPos().z < self:GetPos().z+10 && self:Visible(v) && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() then
            if !v:HasGodMode() then
                if v:GetNWFloat("Acidied")-CurTime() < 1 then
                    v:SetNWFloat("Acidied",CurTime()+1)
                end
                if v:GetNWInt("MM_AcidDamage") != 9 then
                    v:SetNWInt("MM_AcidDamage", 5)
                end
                v:SetNWEntity("MM_AcidOwner", self:GetNWEntity("Acid_Attacker"))
                v:SetNWEntity("MM_AcidInflictor", self:GetNWEntity("Acid_Inflictor"))
            end
        end
    end
end

function ENT:PhysicsCollide(data)

end

function ENT:Touch()
end