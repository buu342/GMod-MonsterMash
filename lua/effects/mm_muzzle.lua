function EFFECT:Init(data)
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
		
	for i=1,2 do 
		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), Pos)
		particle:SetVelocity(Vector(0,0,0))
		particle:SetDieTime(0.18)
		particle:SetStartAlpha(160)
		particle:SetEndAlpha(0)
		particle:SetStartSize(6*i)
		particle:SetEndSize(8*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,255,255)	
		particle:SetAirResistance(160)
	end
	
	for i=1,3 do 
		local particle = emitter:Add("particle/particle_smokegrenade", Pos)
		particle:SetVelocity(Vector(math.random(-3,3),math.random(-3,3),math.random(0,100)))
		particle:SetDieTime(math.Rand(0.28,0.34))
		particle:SetStartAlpha(math.Rand(30,60))
		particle:SetStartSize(math.random(0.08,0.16)*i)
		particle:SetEndSize(math.Rand(3,5)*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(200,200,200)
		particle:SetAirResistance(140)
	end
	
	emitter:Finish()
end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()
	
end



