function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter(Pos)
	
	local particle = emitter:Add("particle/spoopyghost" , Pos + Vector(0,0,32))
	particle:SetVelocity(Vector(0,0, math.random(350, 500)))
	particle:SetDieTime(0.5)
	particle:SetStartAlpha(math.random(100, 150))
	particle:SetStartLength(-64)
	particle:SetStartSize(32)
	particle:SetEndSize(32)
	particle:SetEndLength(-math.random(194, 256))
	particle:SetEndAlpha(0)
	particle:SetRollDelta(math.random(0,1))
	particle:SetCollide(true)
	particle:SetCollideCallback(function(part, hitpos, hitnormal) 
		part:SetDieTime(0.1)
	end)
	local dist = 0.5-self:GetPos():Distance(LocalPlayer():GetPos())/1024
	
	if dist < 0 then
		dist = 0
	end
	
	EmitSound("death/ghost.wav",self:GetPos(),self:EntIndex(),CHAN_AUTO,dist)

end

function EFFECT:Think()

	return false	
end


function EFFECT:Render()
end

