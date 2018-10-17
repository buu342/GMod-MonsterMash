function EFFECT:Init(data)

	self.Position = data:GetOrigin()
	self.countframe = 1
	self.lastframe = 1
	self.Direction = data:GetNormal()
	self.Speed = self.Direction * 6
	self.Resistance = 0.1
	
end


function EFFECT:Think()

	local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*25)	
	
	if self.lastframe != doomframe then
		self.countframe = self.countframe+1
		self.lastframe = doomframe
	end
	
	if self.countframe >= 30 then
		return false
	end

	return true
	
end

local sequence_idle = "ABABCBCBCDCDCDEDEDEFEFEFGHGHGH"

function EFFECT:Render()
	
	local target_sequence
	target_sequence = sequence_idle
	local target_frame = string.sub(target_sequence, (self.countframe%string.len(target_sequence))+1, (self.countframe%string.len(target_sequence))+1)
	local mat = Material( "ghouls/FIRE"..target_frame.."0.png" )
	render.SetMaterial( mat )

	self.Position = self.Position + self.Speed
	self.Speed = self.Speed*(1-self.Resistance)
	
	local pos = self.Position
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector(1,1,1)

	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255
	
	
	local offset
	if 		target_frame == "A" then offset = -5-24
	elseif 	target_frame == "B" then offset = 10-24
	elseif 	target_frame == "C" then offset = 39-24
	elseif 	target_frame == "D" then offset = 37-24
	elseif 	target_frame == "E" then offset = 20+37-24
	elseif 	target_frame == "F" then offset = 38+37-24
	elseif 	target_frame == "G" then offset = 67+37-24
	elseif 	target_frame == "H" then offset = 92+37-24
	end

	local width = mat:Width()
	local height = mat:Height()
	render.DrawSprite( pos+Vector(0,0,16 + offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 128 ) )
end

