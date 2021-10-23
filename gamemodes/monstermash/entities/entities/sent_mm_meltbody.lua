AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Decapitated = false
ENT.RagdollTime = 0
ENT.BloodType = 0
ENT.Electrocuted = false
ENT.Acided = false
ENT.Character = nil
ENT.Ply = nil

ENT.ZOrigin = 30
 
function ENT:Initialize()
 
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE ) 
    self:SetSolid( SOLID_VPHYSICS )   

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableGravity( true )
    end
    
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
    self:NextThink(CurTime())
end

if SERVER then return end

function surface.DrawCirc( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ENT:ModelStencilMM(mdl, pos, ang, animation, animationspeed, scale)
    
	local ent = ClientsideModel( mdl, RENDERGROUP_OTHER )

	if ( !IsValid( ent ) ) then return end

	ent:SetModel( mdl )
	ent:SetNoDraw( true )

	ent:SetPos( pos )
	ent:SetAngles( ang )
    if animation != nil then
        ent:ResetSequence( ent:LookupSequence( animation ) )
        ent:SetCycle( animationspeed )
    end
	ent:SetModelScale(scale)
	ent:SetMaterial(self:GetNWString("KickPlayerMat") or "")
	ent:SetSkin(self:GetNWInt("KickPlayerSkin") or 0)
    ent:SetBodygroup(1, self:GetNWInt("KickPlayerBG1"))
    ent:SetBodygroup(2, self:GetNWInt("KickPlayerBG2"))
    ent:SetBodygroup(3, self:GetNWInt("KickPlayerBG3"))
    ent:SetBodygroup(4, self:GetNWInt("KickPlayerBG4"))
	ent:DrawModel()
	//local returnpos, returnang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_R_Hand"))
	
	ent:Remove()
    //return returnpos, returnang
end

function ENT:RenderOverride()

    // Garry's halos are mean to us so we need to reset some values
    render.SetStencilWriteMask( 255 )
    render.SetStencilTestMask( 255 )
    render.SetStencilReferenceValue( 0 ) 
    render.SetStencilCompareFunction( STENCIL_ALWAYS )
    render.SetStencilPassOperation( STENCIL_KEEP )
    render.SetStencilFailOperation( STENCIL_KEEP )
    render.SetStencilZFailOperation( STENCIL_KEEP )
    render.ClearStencil()
    render.MaterialOverride( 0 ) 

    render.SetStencilEnable( true )

        
        // Fail to draw the model
        render.SetStencilReferenceValue( 13 ) 
        render.SetStencilCompareFunction( STENCIL_NEVER )
        render.SetStencilFailOperation( STENCIL_REPLACE )
        self:ModelStencilMM("models/hunter/blocks/cube2x2x2.mdl", self:GetPos()+Vector(0,0,-47), self:GetAngles(), "taunt_cheer", 0.3, 1)
       /* cam.Start3D2D( self:GetPos(), self:GetAngles(), 32 )
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			surface.DrawRect( -1,-1,2, 2 ) // a circular hole on the floor
		cam.End3D2D()*/
        
        // If 
        render.SetStencilReferenceValue( 14 ) 
        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilFailOperation( STENCIL_KEEP )
        self:ModelStencilMM("models/monstermash/deer_haunter_final.mdl", self:GetPos()+Vector(0,0,-32), self:GetAngles(), "taunt_cheer", 0.3, 1)
        
    render.SetStencilEnable( false )

end