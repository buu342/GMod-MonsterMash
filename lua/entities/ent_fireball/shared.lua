ENT.Type 		= "anim"
ENT.Base 		= "base_anim"

ENT.PrintName	= ""
ENT.Author		= ""
ENT.Contact		= ""


function ENT:Draw()
    self:DrawModel()
    local dlight = DynamicLight( self:EntIndex() )
    if ( dlight ) then
        local r, g, b, a = self:GetColor()
        dlight.Pos = self:GetPos()
        dlight.r = 240
        dlight.g = 104
        dlight.b = 0
        dlight.brightness = 2
        dlight.Decay = 1000
        dlight.Size = 160
        dlight.DieTime = CurTime() + 1
    end  

end