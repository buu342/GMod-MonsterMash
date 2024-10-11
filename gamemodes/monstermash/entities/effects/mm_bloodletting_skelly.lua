function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)

	for i=1, 10 do	
		local particle = emitter:Add("particle/particle_smokegrenade" , Pos + Vector(math.random(-10, 10), math.random(-10, 10), math.random(0, 30)))
		particle:SetVelocity(Vector(math.random(-20, 20), math.random(-20, 20), math.random(10, 50)))
		particle:SetGravity(Vector(0,0,-50))
		particle:SetDieTime(1)
		particle:SetStartAlpha(math.random(100, 200))
		particle:SetStartSize(math.random(30, 50))
		particle:SetEndSize(math.random(40, 60))
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0, 2))
		particle:SetColor(150, 150, 150)
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