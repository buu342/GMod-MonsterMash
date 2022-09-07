EFFECT.Mat = Material("Particle/wandball")
EFFECT.Mat2 = Material("Particle/wandball2")

local shrink = 0.1

function EFFECT:Init(data)

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
    

	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if (IsValid(ent) && att > 0) then
		if (ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer()) then ent = ent.Owner:GetViewModel() end

		local att = ent:GetAttachment(att)
		if (att) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = (self.EndPos - self.StartPos):GetNormalized()
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.TracerTime = math.min(1, self.StartPos:Distance(self.EndPos) / 10000)
	self.Length = math.Rand(0.1, 0.15)

	-- Die when it reaches its target
    self.ShrinkTime = CurTime() + shrink
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if (CurTime() > self.DieTime) then
		return false
	end

	return true

end

function EFFECT:Render()
	local emitter = ParticleEmitter(self.StartPos)
	
    local particle = emitter:Add("effects/blood_core" , self.StartPos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand( -3, 3)))
    particle:SetVelocity(self.Dir*500)
    particle:SetGravity(Vector(0,0,-20))
    particle:SetDieTime(0.5)
    particle:SetStartAlpha(math.random(100, 200))
    particle:SetStartSize(math.random(3,5))
    particle:SetEndSize(math.random(1, 10))
    particle:SetRoll(math.random(-360, 360))
    particle:SetRollDelta(math.random(0,2))
    particle:SetColor(181, 230, 29)
    particle:SetCollide(true)
    particle:SetCollideCallback(function(part, hitpos, hitnormal) 
        part:SetDieTime(0.1)
    end)
end
