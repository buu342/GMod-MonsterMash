

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	local emitter = ParticleEmitter(self.Position)
		

	local i = 3
	local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
	particle:SetVelocity(Vector(0,0,75)+ 8*VectorRand())
	particle:SetDieTime(math.Rand(1,3))
	particle:SetStartAlpha(255)
	particle:SetStartSize(math.random(10,15)*i)
	particle:SetEndSize(math.Rand(30,40)*i)
	particle:SetRoll(math.Rand(180,480))
	particle:SetRollDelta(math.Rand(-1,1))
	particle:SetColor(0,0,0)


	emitter:Finish()

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end



