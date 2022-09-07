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

	self.Dir = self.EndPos - self.StartPos
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
    local fDelta = (self.DieTime - CurTime()) / self.TracerTime
    fDelta = math.Clamp(fDelta, 0, 1) ^ 0.5
    local sinWave = math.sin(fDelta * math.pi)
    local pos = self.EndPos - self.Dir * (fDelta - sinWave * self.Length)
    local ang = self.Dir:Angle()
        
    if (pos-self.StartPos):Length() < 768 then
        local effectdata = EffectData()
        effectdata:SetOrigin(pos)
        util.Effect("mm_melterimpact", effectdata)
    end
end
