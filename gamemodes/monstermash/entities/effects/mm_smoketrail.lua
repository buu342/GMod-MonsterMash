

function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
		
    local particle = emitter:Add("particle/particle_smokegrenade", Pos)
    particle:SetVelocity(Vector(math.random(-20,20),math.random(-20,20),math.random(-20,20)))
    particle:SetDieTime(1)
    particle:SetStartAlpha(200)
    particle:SetStartSize(5)
    particle:SetEndSize(7)
    particle:SetRoll(math.Rand(180,480))
    particle:SetRollDelta(math.Rand(-1,1))
    particle:SetColor(100,100,100)
    particle:SetAirResistance(140)

	emitter:Finish()

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end



