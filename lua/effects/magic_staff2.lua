function EFFECT:Init( data )

	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	for i=1, 60 do	
		local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos )
		local xx = math.random( -16, 16 )
		local yy = math.random( -16, 16 )
		local zz = math.random( -16, 16 )
		particle:SetVelocity( Vector(xx,yy,zz) )
		particle:SetGravity( Vector(-xx/2,-yy/2,-zz/2) )
		particle:SetColor(116,176,158)
		particle:SetDieTime( math.random(0.2,1) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	end
	
end

function EFFECT:Think( )
	
	return false
end

function EFFECT:Render()
end