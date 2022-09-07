function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
			
	for i=1, 30 do	
		local particle = emitter:Add("particle/flamelet"..math.random(1,5), Pos + Vector(math.random(-8, 8), math.random(-8, 8), math.random(-8, 8)))

		particle:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))*4)
		particle:SetDieTime(1)
		particle:SetStartAlpha(math.random(155, 255))
		particle:SetColor(255, 0, 0)
		particle:SetStartSize(math.random(20, 40))
		particle:SetEndSize(0)
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,2)) 
		particle:SetCollide(true)
		particle:SetCollideCallback(function(part, hitpos, hitnormal) 
			part:SetDieTime(0.1)
		end)
	end

end

function EFFECT:Think()

	return false	
end

function EFFECT:Render()
end