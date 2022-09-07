function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)

	local mat = "models/misc/dirt"..tostring(math.random(1,4))..".png"
	
	local particle = emitter:Add(Material(mat), Pos + Vector(math.random(-35, 35), math.random(-35, 35), 0))
	particle:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(10, 300)))
	particle:SetGravity(Vector(0,0,-600))
	particle:SetDieTime(math.random(2.5,4))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	local size = math.random(2,5)
	particle:SetStartSize(size)
	particle:SetEndSize(size)
	particle:SetRoll(math.random(-360, 360))
	particle:SetRollDelta(math.random(0,2))
	particle:SetColor(255, 255, 255)
	particle:SetCollide(true)
	particle:SetCollideCallback(function(part, hitpos, hitnormal) 
		part:SetDieTime(0.1)
	end)

end

function EFFECT:Think()

	return false	
end

function EFFECT:Render()
end