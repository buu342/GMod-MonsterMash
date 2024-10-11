function EFFECT:Init(data)

	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
	
	for i=1, 1 do
		local mat = GAMEMODE:GetBloodMatList(BLOODTYPE_BLACK)[math.random(GAMEMODE:GetBloodMatList_Count(BLOODTYPE_BLACK))]

		local particle = emitter:Add(mat, Pos + Vector(math.random(-5, 5), math.random(-5, 5), 0))
		particle:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(10, 100)))
		particle:SetGravity(Vector(0,0,-600))
		particle:SetDieTime(math.random(2.5,4))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		local size = 8
		particle:SetStartSize(size)
		particle:SetEndSize(size)
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,2))
		particle:SetColor(0, 0, 0)
		particle:SetCollide(true)
		particle:SetCollideCallback(function(part, hitpos, hitnormal) 
            if (math.random(4) == 1) then
                GAMEMODE:EmitBlood_Client(BLOODTYPE_BLACK, BLOODEFFECT_DECAL, hitpos, hitnormal)
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