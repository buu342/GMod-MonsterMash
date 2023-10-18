AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/webbing_floor.mdl")
	self.Entity:PhysicsInit(SOLID_OBB)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:DrawShadow(false)
	self.Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetModelScale(0, 0)
	-- Don't collide with the player
	self.Entity:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	timer.Simple(20, function() if IsValid(self) then self:Remove() end end)
	self:SetNWFloat("AcidScale", 0)
	self:SetNWFloat("AcidTime", CurTime()+20)
	self:SetNWInt("AcidAlpha", 255)
    self.ListOfVictims = {}
end

function ENT:Think()
	if self:GetNWFloat("AcidTime")-4 > CurTime() then
		self:SetModelScale(1, 0.3)
	else
		self:SetModelScale(0, 1)
	end
    for k, v in pairs(player.GetAll()) do
        if v != self.Owner && v:GetPos():Distance(self:GetPos()) < self:GetModelScale()*90 && v:GetPos().z > self:GetPos().z-5 && v:GetPos().z < self:GetPos().z+10 && self:VisibleVec(v:GetPos()+Vector(0,0,50)) && v:CanBeDamagedBy(self.Owner) then
            if !table.HasValue(self.ListOfVictims, v) then
                local dmginfo = DamageInfo()
                if IsValid(self.Owner) && self.Owner != nil then
                    dmginfo:SetAttacker(self.Owner)
                end
                if IsValid(self.Inflictor) && self.Inflictor != nil then
                    dmginfo:SetInflictor(self.Inflictor)
                end
                v:SetStatusEffect(STATUS_SPIDERWEBBED, dmginfo, 4)
                table.insert(self.ListOfVictims, v)
            end
        end
    end
end

function ENT:PhysicsCollide(data)

end

function ENT:Touch()
end