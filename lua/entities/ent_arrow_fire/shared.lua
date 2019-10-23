ENT.Type = "anim"
ENT.PrintName		= "Arrow"
ENT.Author			= "Buu342"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.RemoveArrow = 0

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

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound("weapons/baseball_hitworld"..math.random(1,3)..".wav")
	end
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
        dlight.brightness = 1
        dlight.Decay = 2048
        dlight.Size = 512
        dlight.DieTime = CurTime() + 0.25
    end  

end