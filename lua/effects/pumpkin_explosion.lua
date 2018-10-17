function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	for i=1, 10 do	
		local particle = emitter:Add( "effects/blood_core" , Pos + Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random(  0, 50 ) ) )
		particle:SetVelocity( Vector( math.random( -10, 10), math.random( -10, 10 ), math.random( 10, 100 ) ) )
		particle:SetGravity( Vector(0,0,-20) )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( math.random( 100, 200 ) )
		particle:SetStartSize( math.random(10,15))
		particle:SetEndSize( math.random(100,200) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 215, 0 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	end
	
	for i=1, 10 do	
		local particle = emitter:Add( "effects/splashwake1" , Pos + Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random(  0, 50 ) ) )
		particle:SetVelocity( Vector( math.random( -10, 10), math.random( -10, 10 ), math.random( 10, 100 ) ) )
		particle:SetGravity( Vector(0,0,-20) )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( math.random( 100, 200 ) )
		particle:SetStartSize( math.random(10,15))
		particle:SetEndSize( math.random(100,200) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 215, 0 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	end

	for i=1, 10 do	
		local particle = emitter:Add( "effects/blood_core" , Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), math.random(  10, 40 ) ) )
		particle:SetVelocity( Vector( math.random( -20, 20), math.random( -20, 20 ), math.random( 10, 50 ) ) )
		particle:SetGravity( Vector(0,0,-50) )
		particle:SetDieTime( 1 )
		particle:SetStartAlpha( math.random( 100, 200 ) )
		particle:SetStartSize( math.random(20,30))
		particle:SetEndSize( math.random(40,60) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 215, 0 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
		end )
	end
	
	for i=1, 10 do	
		local particle = emitter:Add( "effects/blood2" , Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), math.random(  10, 40 ) ) )
		particle:SetVelocity( Vector( math.random( -200, 200), math.random( -200, 200 ), math.random( 100, 300 ) ) )
		particle:SetGravity( Vector(0,0,-400) )
		particle:SetDieTime(math.random(1,2) )
		particle:SetStartAlpha( math.random( 100, 200 ) )
		particle:SetStartSize( math.random(5,10))
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 215, 0 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
			local startp = part:GetPos()
			local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
			local trace = util.TraceLine(traceinfo)
			local todecal1 = trace.HitPos + trace.HitNormal
			local todecal2 = trace.HitPos - trace.HitNormal
			util.Decal("YellowBlood", todecal1, todecal2)
		end )
	end
	
	local particle = emitter:Add( "effects/blood_puff" , Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), math.random(  10, 40 ) ) )
	particle:SetVelocity( Vector( math.random( -10, 10), math.random( -10, 10 ), math.random( 10, 30 ) ) )
	particle:SetDieTime(math.random(1,2) )
	particle:SetStartAlpha( math.random( 100, 120 ) )
	particle:SetStartSize( math.random(30,40))
	particle:SetEndSize( math.random(90,100) )
	particle:SetRoll( math.random( 0, 360 ) )
	particle:SetRollDelta( math.random(0,1) )
	particle:SetColor( 255, 215, 0 )
	particle:SetCollide( true )
	particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
		part:SetDieTime( 0.1 )
	end )
	
end

function EFFECT:Think( )

	return false	
end

function EFFECT:Render()
end