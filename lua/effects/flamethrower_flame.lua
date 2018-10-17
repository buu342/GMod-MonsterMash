function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	self.Angles = data:GetAngles()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )

		
	for i=1, 2 do	
		local pp = Pos
			pp = pp + self.Angles:Up()		* 0
			pp = pp + self.Angles:Right()	* 0
			pp = pp + self.Angles:Forward()	* i*5
		local particle = emitter:Add( "effects/fire_cloud"..tostring( math.random( 1, 2 ) ), pp  )

		particle:SetVelocity( Vector( self.Angles:Forward()*500,self.Angles:Right(), self.Angles:Up()) )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetDieTime( 1 )
		particle:SetStartAlpha( math.random( 155, 255 ) )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 50 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 255, 255 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	end
			
	//for i=1, 30 do	
		local particle = emitter:Add( "particle/flamelet"..tostring( math.random( 1, 5 ) ), Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), 0 ) )
		particle:SetVelocity( Vector( math.random( -20, 20), math.random( -20, 20 ), math.random( 20, 100 ) ) )
		particle:SetGravity( Vector(0,0,-400) )
		particle:SetDieTime( math.random( 8, 10 ) )
		particle:SetStartAlpha( math.random( 155, 255 ) )
		particle:SetStartSize( 3 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,10) )
		particle:SetColor( 255, 255, 255 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	//end
	


end

function EFFECT:Think( )

	return false	
end

function EFFECT:Render()
end