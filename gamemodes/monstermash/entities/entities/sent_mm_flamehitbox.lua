AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/hunter/blocks/cube075x5x075.mdl"

ENT.LightSize = 512
ENT.LightColor = Color(240, 104, 0)
ENT.LightBrightness = 3
ENT.LightDecay = 2048
ENT.LightTime = 0.25

function ENT:Initialize()
    self:SetModel(self.Mdl)
    self:SetAngles(self:GetAngles())
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    
    if SERVER then
        self:SetTrigger(true)
    end

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:OnRemove()
end
	
function ENT:Think()
    if SERVER then
        if (self.Owner != nil && IsValid(self.Owner)) then
            if (!self.Owner:Alive()) then
                self:Remove()
            end
        else
            self:Remove()
        end
    end
    self:NextThink(CurTime()) return true
end


function ENT:Touch(ent)

    if ent != self.Owner then
        local dmginfo = DamageInfo()

        if ent.LastDamageFThrower == nil then
            ent.LastDamageFThrower = 0
        end
        if (ent.LastDamageFThrower < CurTime() && (!ent:IsPlayer() || (ent:CanBeDamagedBy(self.Owner) && self.Owner:VisibleVec(ent:GetPos()+Vector(0,0,50))))) then
            ent.LastDamageFThrower = CurTime() + (ent:GetPos():Distance(self.Owner:GetPos())/(256*20))
            dmginfo:SetDamage(1)
            if (self.Owner != nil && IsValid(self.Owner)) then
                dmginfo:SetAttacker(self.Owner)
            end
            if (self.Inflictor != nil && IsValid(self.Inflictor)) then
                dmginfo:SetInflictor(self.Inflictor)
            end
            ent:TakeDamageInfo(dmginfo)
            if (ent:IsPlayer()) then
                ent:SetStatusEffect(STATUS_ONFIRE, dmginfo, 6)
            else
                ent:Ignite(6)
            end
        end
    end
    
end

function ENT:PhysicsCollide(data, phys)
end

function ENT:Draw()
    if self.LightSize != 0 then
        local dlight = DynamicLight(self:EntIndex())
        if (dlight) then
            local r, g, b, a = self:GetColor()
            dlight.Pos = self:GetPos()
            dlight.r = self.LightColor.r
            dlight.g = self.LightColor.g
            dlight.b = self.LightColor.b
            dlight.brightness = self.LightBrightness
            dlight.Decay = self.LightDecay
            dlight.Size = self.LightSize
            dlight.DieTime = CurTime() + self.LightTime
        end  
    end
end