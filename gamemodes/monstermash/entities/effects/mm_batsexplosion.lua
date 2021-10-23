local mat = Material("particle/boo")

function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    self.particle = nil
    self.Life = CurTime()+1
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
    self.particle = emitter:Add( "particle/boo", Pos + Vector( 0,0,0 ) )
    self.particle:SetVelocity( Vector(0,0,0) )
    self.particle:SetDieTime( self.Life-CurTime() )
    self.particle:SetStartAlpha( 255 )
    self.particle:SetColor( 255, 255, 255 )
    self.particle:SetStartSize( 75 )
    self.particle:SetEndSize( 30 )
    self.particle:SetRoll( 0 )
    self.particle:SetRollDelta( 0 )
    emitter:Finish()
    
    local emitter = ParticleEmitter( Pos )
    for i=0, 20 do
        local part = emitter:Add( "animated/bat", Pos + Vector( 0,0,math.random(-70,-20) ) )
        part:SetVelocity( Vector(math.random(-100,100),math.random(-100,100),math.random(-50,50)) )
        part:SetDieTime( 2 )
        part:SetGravity( Vector(0,0,math.random(0,100)) )
        part:SetStartAlpha( 255 )
        part:SetColor( 255, 255, 255 )
        part:SetStartSize( 30 )
        part:SetEndSize( 0 )
        part:SetRoll( 0 )
        part:SetRollDelta( 0 )
    end
    emitter:Finish()
    
end

function EFFECT:Think()
    self.particle:SetRoll( math.sin(CurTime()*10)/2 )
    if (self.Life > CurTime()) then
        return true	
    else
        return false
    end
end

function EFFECT:Render()
end