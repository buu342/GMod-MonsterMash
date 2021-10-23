function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	for i=1, 30 do	
		local chance = math.random(1,300)
		local thing = math.random(1,8)
		if chance == 300 then
			thing = 9
		end
		local mat = "models/player/monstermash/gibs/gib"..tostring(thing)..".png"
		

		local particle = emitter:Add( Material(mat), Pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), 0 ) )
		particle:SetVelocity( Vector( math.random( -100, 100), math.random( -100, 100 ), math.random( 10, 300 ) ) )
		particle:SetGravity( Vector(0,0,-600) )
		particle:SetDieTime( math.random( 2.5,4 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		local size = math.random(2,5)
		particle:SetStartSize( size )
		particle:SetEndSize(size)
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random(0,2) )
		particle:SetColor( 255, 255, 255 )
		particle:SetCollide( true )
		particle:SetCollideCallback( function( part, hitpos, hitnormal ) 
			part:SetDieTime( 0.1 )
			local startp = part:GetPos()
			local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
			local trace = util.TraceLine(traceinfo)
			local todecal1 = trace.HitPos + trace.HitNormal
			local todecal2 = trace.HitPos - trace.HitNormal
			util.Decal("Blood", todecal1, todecal2)
		end )
	end
end

function EFFECT:Think( )

	return false	
end

function EFFECT:Render()
end