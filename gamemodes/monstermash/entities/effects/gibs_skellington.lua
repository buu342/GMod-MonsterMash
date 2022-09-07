local gibs = {
    "particle/skeleton/gib1.png",
    "particle/skeleton/gib2.png",
    "particle/skeleton/gib3.png",
    "particle/skeleton/gib4.png",
    "particle/skeleton/gib5.png",
    "particle/skeleton/gib6.png",
    "particle/skeleton/gib6.png",
    "particle/skeleton/gib6.png",
    "particle/skeleton/gib6.png",
    "particle/skeleton/gib6.png",
    "particle/skeleton/gib7.png",
    "particle/skeleton/gib7.png",
    "particle/skeleton/gib7.png",
    "particle/skeleton/gib7.png",
    "particle/skeleton/gib7.png",
    "particle/skeleton/gib8.png",
    "particle/skeleton/gib9.png",
}

function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting(pos, Vector(0, 0, 1))
	local c = Vector(1,1,1)

	lcolor.x = c.r * (math.Clamp(lcolor.x, 0, 1) + 0.25) * 255
	lcolor.y = c.g * (math.Clamp(lcolor.y, 0, 1) + 0.25) * 255
	lcolor.z = c.b * (math.Clamp(lcolor.z, 0, 1) + 0.25) * 255
	
	local emitter = ParticleEmitter(Pos)
	
	for i=1, #gibs do	
		local mat = gibs[i]
		local particle = emitter:Add(Material(mat), Pos + Vector(math.random(-10, 10), math.random(-10, 10), 3*i))
		particle:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(10, 300)))
		particle:SetGravity(Vector(0,0,-600))
		particle:SetDieTime(math.random(2.5,4))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		local size = math.random(3, 5)
		particle:SetStartSize(size)
		particle:SetEndSize(size)
		particle:SetRoll(math.random(-360, 360))
		particle:SetRollDelta(math.random(0,2))
		particle:SetColor(lcolor.x, lcolor.y, lcolor.z)
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
	local mat = Material("animated/skeleton_run")
	
	render.SetMaterial(mat)

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting(pos, Vector(0, 0, 1))
	local c = Vector(1,1,1)

	lcolor.x = c.r * (math.Clamp(lcolor.x, 0, 1) + 0.25) * 255
	lcolor.y = c.g * (math.Clamp(lcolor.y, 0, 1) + 0.25) * 255
	lcolor.z = c.b * (math.Clamp(lcolor.z, 0, 1) + 0.25) * 255
    
	local width = mat:Width()/3
	local height = mat:Height()/3
	local offset = 8
	//render.DrawSprite(pos+Vector(0,0,offset), width, height, Color(lcolor.x, lcolor.y, lcolor.z, 255))
end