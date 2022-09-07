function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
	
	for i=1, 10 do	
		local particle = emitter:Add("effects/blood_core" , Pos + Vector(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2)))
		particle:SetVelocity(Vector(math.random(-20, 20), math.random(-20, 20), math.random(10, 50)))
		particle:SetGravity(Vector(0,0,-50))
		particle:SetDieTime(1)
		particle:SetStartAlpha(math.random(100, 200))
		particle:SetStartSize(math.random(10,30))
		particle:SetEndSize(math.random(1,2))
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,2))
		particle:SetColor(255, 255, 255)
		particle:SetCollide(true)
		particle:SetCollideCallback(function(part, hitpos, hitnormal) 
			part:SetDieTime(0.1)
		end)
	end
    
    for i=1, 10 do	
        local emitter = ParticleEmitter(Pos)
        local thing = math.random(1,16)
        local mat = ""
        if thing > 9 then
        mat = "particle/smokesprites_00"..tostring(thing)
        else
        mat = "particle/smokesprites_000"..tostring(thing)
        end
        local particle = emitter:Add(mat, Pos + Vector(math.random(-3, 3), math.random(-3, 3), 0))
        particle:SetVelocity(Vector(math.random(-3, 3), math.random(-3, 3), math.random(1, 3)))
        particle:SetGravity(Vector(0,0,-2))
        particle:SetDieTime(math.random(0.2, 1))
        particle:SetStartAlpha(math.random(155, 255))
        particle:SetStartSize(math.random(2,5))
        particle:SetEndSize(math.random(5,8))
        particle:SetRoll(math.random(-360, 360))
        particle:SetRollDelta(math.random(0,2))
        particle:SetColor(255, 255, 255)
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
        local particle = emitter:Add(mat, Pos + Vector(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3)))
        particle:SetVelocity(Vector(math.random(-4, 4), math.random(-4, 4), math.random(2, 4)))
        particle:SetGravity(Vector(0,0,-5))
        particle:SetDieTime(math.random(0.2, 1))
        particle:SetStartAlpha(math.random(150, 255))
        particle:SetStartSize(math.random(1, 4))
        particle:SetEndSize(math.random(1, 2))
        particle:SetRoll(math.random(-360, 360))
        particle:SetRollDelta(math.random(-0.8, 0.8))
        particle:SetColor(255, 255, 255)
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