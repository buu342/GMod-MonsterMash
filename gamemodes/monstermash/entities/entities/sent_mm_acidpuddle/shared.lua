ENT.Type = "anim"
ENT.Name = "Acid Puddle"

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

function ENT:Draw()
    self:DrawModel()
    local dlight = DynamicLight(self:EntIndex())
    if (dlight) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 181
        dlight.g = 230
        dlight.b = 29
        dlight.brightness = 2
        dlight.Decay = 512
        dlight.Size = 100*self:GetModelScale()*5
        dlight.DieTime = CurTime() + 1
    end  
end