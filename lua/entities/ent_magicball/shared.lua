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

	render.SetMaterial( Material("particle/wandball") )

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector( 81/255, 221/255, 40/255 )

	lcolor.x = c.x * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
	lcolor.y = c.y * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
	lcolor.z = c.z * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255

	local size = 25
	render.DrawSprite( pos, size, size, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	render.SetMaterial( Material("particle/wandball2") )
	render.DrawSprite( pos, size, size, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
    
    local dlight = DynamicLight( self:EntIndex() )
    if ( dlight ) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 0
        dlight.g = 255
        dlight.b = 0
        dlight.brightness = 3
        dlight.Decay = 2048
        dlight.Size = 512
        dlight.DieTime = CurTime() + 0.25
    end  

end