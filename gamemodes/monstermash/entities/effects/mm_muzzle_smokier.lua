

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	if !(IsValid(self.WeaponEnt) && self.WeaponEnt:GetOwner() != nil) then return end
	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)
		
	for i=1,3 do 
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(Vector(math.random(-20,20),math.random(-20,20),math.random(-20,20)))
		particle:SetDieTime(math.Rand(1, 3))
		particle:SetStartAlpha(math.Rand(50,155))
		particle:SetStartSize(math.random(2,4)*i)
		particle:SetEndSize(math.Rand(5,7)*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(200,200,200)
		particle:SetAirResistance(140)
	end

	emitter:Finish()

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end



