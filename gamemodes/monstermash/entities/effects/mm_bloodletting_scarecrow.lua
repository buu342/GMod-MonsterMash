function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	//Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
    local haymaterial = math.random(GAMEMODE:GetBloodMatList_Count(BLOODTYPE_HAY))

    for i=1, 10 do
        local particle = emitter:Add(GAMEMODE:GetBloodMatList(BLOODTYPE_HAY)[haymaterial], Pos + Vector(math.random(-5, 5), math.random(-5, 5), 20))
        particle:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(10, 100)))
        particle:SetGravity(Vector(0,0,-600))
        particle:SetDieTime(math.random(2.5,4))
        particle:SetStartAlpha(255)
        particle:SetEndAlpha(255)
        local size = math.random(5,10)
        particle:SetStartSize(size)
        particle:SetEndSize(size)
        particle:SetRoll(math.random(-360, 360))
        particle:SetRollDelta(math.random(0,2))
        particle:SetColor(255, 255, 255)
        particle:SetCollide(true)
        particle:SetCollideCallback(function(part, hitpos, hitnormal)
            if (haymaterial == 1) then
                GAMEMODE:EmitBlood_Client(BLOODTYPE_HAY, BLOODEFFECT_DECAL, hitpos, hitnormal)
            end
            part:SetDieTime(0.1)
        end)
    end
	
end

function EFFECT:Think()

	return false	
end

function EFFECT:Render()
end