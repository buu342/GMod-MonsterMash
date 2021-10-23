AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "SpawnDirt"
ENT.Spawnable = false

ENT.Animation1 = 0.5
ENT.Animation2 = 2
ENT.Animation3 = 2.75
ENT.TombModel = nil

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 6
	
	local ent = ents.Create("sent_spawndirt")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end


/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()	
	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:EmitSound("death/player_spawn.wav")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.Animation1 = self.Animation1 + CurTime()
	self.Animation2 = self.Animation2 + CurTime()
	self.Animation3 = self.Animation3 + CurTime()
	self:SetModelScale(0)
	if CLIENT then
		self:SetRenderBounds( Vector(-32,-32,-32), Vector(32,32,32) )
		self.TombModel = ClientsideModel( "models/props_c17/gravestone002a.mdl" )
		self.TombModel:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.TombModel:SetPos( self:GetPos()+Vector(0,0,30)+self:GetAngles():Forward()*50 )
		self.TombModel:SetAngles( self:GetAngles() )
		self.TombModel:DrawModel()
	end
end

function ENT:Think()
	if self.Animation1 > CurTime() then
		if CLIENT then
			self.TombModel:SetColor( Color( 255, 255, 255, 255*(1-(self.Animation1-CurTime())/0.5)) )
            local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
            util.Effect( "mm_dirtgib", effectdata )
		end
	elseif self.Animation2 > CurTime() then
		if CLIENT then
			self.TombModel:SetColor( Color( 255, 255, 255, 255) )
            local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
            util.Effect( "mm_dirtgib", effectdata )
		end
	elseif self.Animation3 > CurTime() then
		if CLIENT then
			self.TombModel:SetColor( Color( 255, 255, 255, 255*((self.Animation3-CurTime())/0.5)) )
		end
	else
		if SERVER then
			self:Remove()
		end
	end
end

function ENT:OnRemove()
	if CLIENT then
		self.TombModel:Remove()
	end	
end

function ENT:PhysicsCollide()
end


/*-----------------------------------------------------
				Custom render.Model func
-----------------------------------------------------*/
if SERVER then return end
function render.ModelCustom( mdl, pos, ang, animation, animationspeed, scale,mat,skin )

	local ent = ClientsideModel( mdl, RENDERGROUP_OTHER )

	if ( !IsValid( ent ) ) then return end

	ent:SetModel( mdl )
	ent:SetNoDraw( true )

	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:ResetSequence( ent:LookupSequence( animation ) )
	ent:SetModelScale(scale)
	ent:SetCycle( animationspeed )
	ent:SetMaterial(mat or "")
	ent:SetSkin(skin or 0)
	ent:DrawModel()
	
	
	ent:Remove()


end

function ENT:RenderOverride()
	local angle = Angle(0, 0, 0)
	local scale = 64
	local pos = self:GetPos()//self:GetNWVector("DoSpawnPos")-Vector(32,-scale/2,0)-Vector(0,0,1.8)
    
    if !self:GetOwner():IsLineOfSightClear(LocalPlayer()) then return end
    
	render.SetStencilEnable( true )
	
		local dirtscale
		if self.Animation1 > CurTime() then
			dirtscale = 0.75-(self.Animation1-CurTime())*0.5
			scale = 64*(0.75-(self.Animation1-CurTime()))
		elseif self.Animation2 > CurTime() then
			scale = 64
			dirtscale = 0.75
		elseif self.Animation3 > CurTime() then
			scale = 64*((self.Animation3-CurTime()))
			dirtscale = self.Animation3-CurTime()
		else
			scale = 0
			dirtscale = 0
		end
	
		render.SetStencilWriteMask( 255 )
		render.SetStencilTestMask( 255 )
		
		
		/*-----------------------------------------------------
							Make the hole
		-----------------------------------------------------*/

		render.SetStencilReferenceValue( 13 )
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_REPLACE )
		render.SetStencilFailOperation( STENCIL_DECR )
		render.SetStencilZFailOperation( STENCIL_DECR )
		
		pos = pos - Vector(scale/2,-scale/2,0)

		cam.Start3D2D( pos, angle, scale )
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			surface.DrawRect( 0, 0, 1, 1 ) -- a 1 x 1 square
		cam.End3D2D()
		
		/*-----------------------------------------------------
							Draw Hell
		-----------------------------------------------------*/
		
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		cam.IgnoreZ( true )
			render.SetMaterial(Material("models/misc/cube_left.png"))
			render.DrawBox( pos,angle,Vector(0,-64,-64),Vector(0,0,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_right.png"))
			render.DrawBox( pos,angle,Vector(64,-64,-64),Vector(64,0,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_center.png"))
			render.DrawBox( pos,angle,Vector(0,0,-64),Vector(64,0,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_back.png"))
			render.DrawBox( pos,angle,Vector(0,-64,-64),Vector(64,-64,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_bot.png"))
			render.DrawBox( pos,angle,Vector(0,-64,-64),Vector(64,0,-64),Color(255,255,255,255),true)
		cam.IgnoreZ( false )
		
		/*-----------------------------------------------------
				Draw player crawling out of hell
		-----------------------------------------------------*/		
		
		render.SetStencilCompareFunction( STENCIL_GREATEREQUAL )
		render.SetStencilPassOperation( STENCIL_REPLACE )
		render.SetStencilFailOperation( STENCIL_DECR )
		render.SetStencilZFailOperation( STENCIL_DECR )
		cam.IgnoreZ( true )
			if self.Animation2-CurTime() > 0.5 && GetViewEntity() != self.Owner then
				render.ModelCustom(self:GetNWString("PlayerModel"),pos+Vector(scale/2,-scale/2,50*(2-(self.Animation2-CurTime()))-70),Angle(0,self.Owner:GetAngles().y,0),"zombie_climb_end",(2-(self.Animation2-CurTime()))/1.5, 1,mat,self:GetSkin())
			end
		cam.IgnoreZ( false )
		
		/*-----------------------------------------------------
							Draw Dirt
		-----------------------------------------------------*/	
		
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_REPLACE )
		render.SetStencilFailOperation( STENCIL_REPLACE )
		render.SetStencilZFailOperation( STENCIL_DECR )

		render.ModelCustom("models/props_debris/concrete_debris128pile001a.mdl",pos-Vector(-scale/2,scale/2,0),Angle(0,self:GetAngles().y,0),"idle",1, dirtscale,"models/misc/dirtfloor001a")
		render.ModelCustom("models/props_debris/concrete_debris128pile001a.mdl",pos-Vector(-scale/2,scale/2,0),Angle(0,self:GetAngles().y+240,0),"idle",1, dirtscale,"models/misc/dirtfloor001a")
		
	render.SetStencilEnable( false )
end