function EFFECT:Init( data )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	self.MySize = 0
end

function EFFECT:Think( )
	self.MySize = self.MySize + 0.5
    if self.MySize > 13 then
        self:Remove()
    end
	return true	
end

util.PrecacheModel("models/XQM/Rails/gumball_1.mdl")
function EFFECT:Render()
    local mdl = ClientsideModel("models/XQM/Rails/gumball_1.mdl")
    mdl:SetModelScale(self.MySize, 0)
    mdl:SetPos(self.Position)
    mdl:SetMaterial("models/props_combine/portalball001_sheet")
    mdl:DrawModel()
    mdl:Remove()
end

//models/Combine_Helicopter/helicopter_bomb01.mdl