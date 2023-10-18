AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Time = 0
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
 
local fadetime = 1.5
function ENT:Initialize()
 
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE) 
    self:SetSolid(SOLID_NONE)  

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableGravity(true)
    end
    
    self.Time = CurTime()+fadetime
    //self:SetMaterial("models/flesh")
    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
    if SERVER then
        timer.Simple(self.Time-CurTime(), function() if !IsValid(self) then return end self:Remove() end)
    end
end
 
function ENT:Use(activator, caller)
    return
end
 
function ENT:Think()
    return true;
end

function ENT:DrawTranslucent()
    self:SetColor(Color(255, 255, 255, math.max(0, 255*((self.Time-CurTime())/fadetime))))
    self:DrawModel()
end