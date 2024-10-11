function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
	
	for i=1, 30 do
        local particle
        local istrail = math.random(0, 5)
        if (istrail != 1) then
            particle = emitter:Add("particle/confetti"..math.random(1, 8), Pos + Vector(math.random(-2, 2), math.random(-2, 2), math.random( 0, 4)))
            particle:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(10, 300)))
            particle:SetGravity(Vector(0,0,math.random(-300, -10)))
            particle:SetDieTime(1)
            particle:SetStartSize(math.Rand(2, 4))
            particle:SetEndSize(math.Rand(0, 0.1))
        else
            particle = emitter:Add("particle/confetti_trail"..math.random(1, 2), Pos + Vector(math.random(-2, 2), math.random(-2, 2), math.random( 0, 4)))
            particle:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(10, 300)))
            particle:SetGravity(Vector(0,0,math.random(-100, -10)))
            particle:SetDieTime(3)
            particle:SetStartSize(math.Rand(2, 4)*2)
            particle:SetEndSize(math.Rand(1, 2))
        end
        particle:SetStartAlpha(math.random(100, 200))
        particle:SetRoll(math.random(-360, 360))
        particle:SetRollDelta(math.random(0, 2))
        particle:SetColor(50+math.random(0, 155), 50+math.random(0, 155), 50+math.random(0, 155))
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