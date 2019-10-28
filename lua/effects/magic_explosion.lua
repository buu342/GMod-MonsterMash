function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
			
	for i=1, 30 do	
		local particle = emitter:Add( "particle/flamelet"..math.random(1,5), Pos + Vector( math.random( -30, 30 ), math.random( -30, 30 ), math.random( 0, 32 ) ) )

		particle:SetVelocity( Vector( math.random( -50, 50), math.random( -50, 50), math.random( 25, 75 ) ) )
		particle:SetGravity( Vector(0,0,-300) )
		particle:SetDieTime( math.random( 8, 10 ) )
		particle:SetStartAlpha( math.random( 55, 155 ) )
		local blue = math.random(200,255)
		particle:SetColor( 81, 221, 40 )
		particle:SetStartSize( math.random(5,10))
		particle:SetEndSize( math.random(0,1) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) ) 
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	end

end

function EFFECT:Think( )

	return false	
end

function EFFECT:Render()
end