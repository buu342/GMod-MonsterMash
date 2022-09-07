AddCSLuaFile()

ENT.PrintName = "Hallucination Grenade"
ENT.Type = "anim"
ENT.Mdl = "models/weapons/monstermash/demon.mdl"
ENT.ContinuousEffect = "mm_grenadesmoke"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "SmokeTime")
end

function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/acid_puddle.mdl")
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
    
    self:SetSmokeTime(CurTime()+5)
    if SERVER then
	timer.Simple(self:GetSmokeTime()-CurTime(), function() if IsValid(self) then self:Remove() end end)
    end
    
    self.LoopSound = CreateSound(self, "weapons/flaregun/burn.wav") 
    if self.LoopSound then
        self.LoopSound:SetSoundLevel(65) 
        self.LoopSound:Play()
    end
end

function ENT:OnRemove()
    if self.LoopSound then 
        self.LoopSound:Stop() 
    end 
end
	
function ENT:Think()
    if SERVER then
        for k, v in pairs(player.GetAll()) do
            if v:GetPos():Distance(self:GetPos()) < 256 && self:Visible(v) && v:CanBeDamagedBy(self.Owner) then
                local dmginfo = DamageInfo()
                if IsValid(self.Owner) && self.Owner != nil then
                    dmginfo:SetAttacker(self.Owner)
                end
                if IsValid(self.Inflictor) && self.Inflictor != nil then
                    dmginfo:SetInflictor(self.Inflictor)
                end
                dmginfo:SetDamageType(DMG_POISON)
                v:SetStatusEffect(STATUS_HALLUCINATING, dmginfo, 0.5)
            end
        end
    end
    
    if CLIENT then
        local effectdata = EffectData()
        effectdata:SetStart(self:GetPos()) 
        effectdata:SetOrigin(self:GetPos())
        effectdata:SetScale(1)
        util.Effect("mm_grenadesmoke", effectdata)
    end
    
    self:NextThink(CurTime()) return true
end

function ENT:Draw()
    local dlight = DynamicLight(self:EntIndex())
    if (dlight) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 163
        dlight.g = 73
        dlight.b = 164
        dlight.brightness = 3
        dlight.Decay = 2048
        dlight.Size = 512
        dlight.DieTime = CurTime() + 1
    end  
end

function ENT:Touch(ent)
end

function ENT:PhysicsCollide(data, phys)
end