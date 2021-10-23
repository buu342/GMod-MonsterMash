AddCSLuaFile( "shared.lua" )
include("shared.lua")

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "AcidTime" )
end

function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/acid_puddle.mdl")
	self.Entity:PhysicsInit( SOLID_OBB )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow( false )
	self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetModelScale(0, 0)
    
	-- Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
    
    self:SetAcidTime(CurTime()+20)
	timer.Simple(self:GetAcidTime()-CurTime(), function() if IsValid(self) then self:Remove() end end)
    
    self.LoopSound = CreateSound( self, "ambient/levels/canals/toxic_slime_loop1.wav" ) 
    if self.LoopSound then
        self.LoopSound:SetSoundLevel( 65 ) 
        self.LoopSound:Play()
    end
end

function ENT:OnRemove()
    if self.LoopSound then 
        self.LoopSound:Stop() 
    end 
end
	
function ENT:Think()
	if self:GetAcidTime()-4 > CurTime() then
		self:SetModelScale(1, 0.3)
	else
		self:SetModelScale(0, 1)
	end
    for k, v in pairs(player.GetAll()) do
        if v:GetPos():Distance(self:GetPos()) < self:GetModelScale()*100 && v:GetPos().z > self:GetPos().z-20 && v:GetPos().z < self:GetPos().z+10 && self:Visible(v) then
            if !v:HasStatusEffect(STATUS_SUPERACID) && (!v:HasStatusEffect(STATUS_ACID) || (v:HasStatusEffect(STATUS_ACID) && v:GetStatusEffectTime(STATUS_ACID) < 0.4)) then
                local dmginfo = DamageInfo()
                if IsValid(self.Owner) && self.Owner != nil then
                    dmginfo:SetAttacker(self.Owner)
                end
                if IsValid(self.Inflictor) && self.Inflictor != nil then
                    dmginfo:SetInflictor(self.Inflictor)
                end
                v:SetStatusEffect(STATUS_ACID, dmginfo, 0.4)
            end
        end
    end
end