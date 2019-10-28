function EFFECT:Init( data )

	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	for i=1, 2 do	
		local particle = emitter:Add( "particle/flamelet"..math.random(1,5), Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), -3 ) )
		particle:SetColor( 81, 221, 40 )
		particle:SetVelocity( Vector(math.Rand(-10,10),math.Rand(-10,10),math.Rand(-10,10)) )
		particle:SetDieTime( math.random(0.2,1) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	end
	
end

function EFFECT:Think( )
	
	return false
end

function EFFECT:Render()
end