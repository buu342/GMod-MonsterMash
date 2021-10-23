function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	for i=1, 40 do	
		local particle = emitter:Add( "effects/blood_core" , Pos + Vector( math.Rand( -3, 3 ), math.Rand( -3, 3 ), math.Rand(  -3, 3 ) ) )
		particle:SetVelocity( Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random( -50, 50 ) ) )
		particle:SetGravity( Vector(0,0,-20) )
		particle:SetDieTime( 0.2 )
		particle:SetStartAlpha( math.random( 100, 200 ) )
		particle:SetStartSize( math.random(3,5))
		particle:SetEndSize( math.random(1, 10) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 181, 230, 29 )
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