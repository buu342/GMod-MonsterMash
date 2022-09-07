function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	self.Angles = data:GetAngles()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)

    //for i=1, 30 do	
		local particle = emitter:Add("particle/flamelet"..tostring(math.random(1, 5)), Pos + Vector(math.random(-10, 10), math.random(-10, 10), 0))
		particle:SetVelocity(Vector(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20)))
		particle:SetDieTime(math.Rand(0, 4))
		particle:SetStartAlpha(math.random(155, 255))
		particle:SetStartSize(3)
		particle:SetEndSize(0)
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,10))
		particle:SetColor(255, 255, 255)
		particle:SetCollide(true)
		particle:SetCollideCallback(function(part, hitpos, hitnormal) 
			part:SetDieTime(0.1)
		end)
	//end

end

function EFFECT:Think()

	return false	
end

function EFFECT:Render()
end