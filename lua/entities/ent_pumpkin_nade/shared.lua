ENT.Type = "anim"
ENT.Name = "Pumpkin Grenade"

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
    local dlight = DynamicLight( self:EntIndex() )
    if ( dlight ) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 240
        dlight.g = 104
        dlight.b = 0
        dlight.brightness = 3
        dlight.Decay = 2048
        dlight.Size = 512
        dlight.DieTime = CurTime() + 0.25
    end  

end