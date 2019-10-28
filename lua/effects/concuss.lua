local stars = 5

function EFFECT:Init( data )
	
    self.Owner = data:GetEntity()
	self.AttachmentPos = self.Owner:GetBonePosition(self.Owner:LookupBone( "ValveBiped.Bip01_Head1" ))
    self.particles = {}
    self.Life = CurTime()+1
	local Pos = self.AttachmentPos
	local Norm = Vector(0,0,1)
	Pos = Pos + Norm * 2

    local emitter = ParticleEmitter( Pos )
    for i=0, stars do
        self.particles[i+1] = emitter:Add( "particle/concuss_star", Pos + Vector( math.cos(2*3.14159*(i/stars))*10, math.sin(2*3.14159*(i/stars))*10, 0 ) )
        self.particles[i+1]:SetVelocity( Vector(0, 0, 0) )
        self.particles[i+1]:SetDieTime( 8 )
        self.particles[i+1]:SetGravity( Vector(0,0,0) )
        self.particles[i+1]:SetStartAlpha( 255 )
        self.particles[i+1]:SetEndAlpha( 255 )
        self.particles[i+1]:SetColor( 255, 255, 255 )
        self.particles[i+1]:SetStartSize( 2 )
        self.particles[i+1]:SetEndSize( 2 )
        self.particles[i+1]:SetRoll( 0 )
        self.particles[i+1]:SetRollDelta( 0 )
    end
    emitter:Finish()
    
end

function EFFECT:Think()
    if (!IsValid(self.Owner) || !self.Owner:Alive()) then 
        self:Remove()
        return false
    end
    
    self.AttachmentPos = self.Owner:GetBonePosition(self.Owner:LookupBone( "ValveBiped.Bip01_Head1" ))
    for i=0, stars do
        self.particles[i+1]:SetPos(Vector(self.AttachmentPos.x + math.cos(2*3.14159*(i/stars)+CurTime()*3)*10, self.AttachmentPos.y + math.sin(2*3.14159*(i/stars)+CurTime()*3)*10, self.AttachmentPos.z+16))
    end
    return true	
end

function EFFECT:Render()
end