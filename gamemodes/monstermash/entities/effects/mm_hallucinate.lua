function EFFECT:Init( data )
	
    self.Owner = data:GetEntity()
	self.AttachmentPos = self.Owner:GetBonePosition(self.Owner:LookupBone( "ValveBiped.Bip01_Head1" ))
    self.Life = CurTime()+1
	local Pos = self.AttachmentPos
	local Norm = Vector(0,0,1)
	Pos = Pos + Norm * 2

    self.particle = emitter:Add( "animated/tripping_swirly", Pos )
    self.particle:SetVelocity( Vector(0, 0, 0) )
    self.particle:SetDieTime( self.Owner:GetStatusEffectTime(STATUS_HALLUCINATING) )
    self.particle:SetGravity( Vector(0,0,0) )
    self.particle:SetStartAlpha( 255 )
    self.particle:SetEndAlpha( 255 )
    self.particle:SetColor( 255, 255, 255 )
    self.particle:SetStartSize( 2 )
    self.particle:SetEndSize( 2 )
    self.particle:SetRoll( 0 )
    self.particle:SetRollDelta( 0 )
    emitter:Finish()
    
end

function EFFECT:Think()
    if !self.Owner:Alive() then 
            self.particle:SetDieTime( 0 )
        self:Remove()
        return false
    end
    
    self.AttachmentPos = self.Owner:GetBonePosition(self.Owner:LookupBone( "ValveBiped.Bip01_Head1" ))
    return true	
end

function EFFECT:Render()
end