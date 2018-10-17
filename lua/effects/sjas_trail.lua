function EFFECT:Init(data)

	self.Position = data:GetOrigin()	
	self.countframe = 1
	self.lastframe = 1
	self.Speed = 0
	self.Resistance = 1
	
end


function EFFECT:Think()

	local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*10)	
	
	if self.lastframe != doomframe then
		self.countframe = self.countframe+1
		self.lastframe = doomframe
	end
	
	if self.countframe >= 10 then
		return false
	end

	return true
	
end

local sequence_idle = "B"

function EFFECT:Render()
	
	local target_frame = string.sub(sequence_idle, (self.countframe%string.len(sequence_idle))+1, (self.countframe%string.len(sequence_idle))+1)
	local mat = Material( "ghouls/SJAS"..target_frame.."0.png" )
	render.SetMaterial( mat )

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector(1,1,1)

	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255
	
	local width = mat:Width()/3
	local height = mat:Height()/2
	local offset = 17
	if target_frame == "A" then
		width = mat:Width()/1.5
	end
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 32-(32*(self.countframe)/10) ) )

end

