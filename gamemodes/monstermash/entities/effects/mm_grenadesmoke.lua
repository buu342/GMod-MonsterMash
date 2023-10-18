function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
		local thing = math.random(1,16)
		local mat = ""
		if thing > 9 then
		mat = "particle/smokesprites_00"..tostring(thing)
		else
		mat = "particle/smokesprites_000"..tostring(thing)
		end
		local particle = emitter:Add(mat, Pos + Vector(math.random(-200, 200), math.random(-200, 200), 0))
		particle:SetVelocity(Vector(math.random(-10, 10), math.random(-10, 10), math.random(50, 100)))
		particle:SetGravity(Vector(0,0,-20))
		particle:SetDieTime(math.random(1,2))
		particle:SetStartAlpha(math.random(155, 255))
		particle:SetStartSize(math.random(20,40))
		particle:SetEndSize(math.random(10,15))
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,2))
		particle:SetColor(163, 73, 164)
		particle:SetCollide(true)
		particle:SetCollideCallback(function(part, hitpos, hitnormal) 
			part:SetDieTime(0.1)
		end)
	
		local thing = math.random(1,16)
		local mat = ""
		if thing > 9 then
		mat = "particle/smokesprites_00"..tostring(thing)
		else
		mat = "particle/smokesprites_000"..tostring(thing)
		end
		local particle = emitter:Add(mat, Pos + Vector(math.random(-30, 30), math.random(-30, 30), math.random(4, 20)))
		particle:SetVelocity(Vector(math.random(-40, 40), math.random(-40, 40), math.random(50, 100)))
		particle:SetGravity(Vector(0,0,-50))
		particle:SetDieTime(math.random(2, 3))
		particle:SetStartAlpha(math.random(150, 255))
		particle:SetStartSize(math.random(20, 40))
		particle:SetEndSize(math.random(10, 15))
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(-0.8, 0.8))
		particle:SetColor(163, 73, 164)
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