EFFECT.Mat = Material( "trails/tube" )

function EFFECT:Init( data )

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if ( IsValid( ent ) && att > 0 ) then
		if ( ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer() ) then ent = ent.Owner:GetViewModel() end

		local att = ent:GetAttachment( att )
		if ( att ) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.TracerTime = math.min( 1, self.StartPos:Distance( self.EndPos ) / 10000 )
	self.Length = math.Rand( 0.1, 0.15 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then
		return false
	end

	return true

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5

	render.SetMaterial( self.Mat )

	local sinWave = math.sin( fDelta * math.pi )

	render.DrawBeam( self.StartPos, self.EndPos,
		2*((self.DieTime-CurTime())/self.TracerTime), 0+CurTime(), 10+CurTime(), Color( 255, 255, 255, 255 ) )

end
