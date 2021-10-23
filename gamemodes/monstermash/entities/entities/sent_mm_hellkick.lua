AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "HellKick"
ENT.Spawnable = false
ENT.SndTime = 4.4
ENT.AnimTime = 7

local sound1 = {
    "vo/npc/male01/no01.wav",
    "vo/npc/male01/ohno.wav",
    "vo/npc/male01/runforyourlife03.wav",
    "vo/npc/male01/uhoh.wav",
}

local sound2 = {
    "vo/npc/male01/no02.wav",
    "vo/npc/male01/help01.wav",
}

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 6
	
	local ent = ents.Create("sent_hellkick")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()	
    self.Entity:SetModel("models/props_phx/construct/metal_plate1.mdl")
	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
    if self:GetNWString("Model") == "" then
        self:SetNWString("Model", "")
    end
    self:SetNWFloat("CryHelp", CurTime()+self.SndTime)
    self:SetNWFloat("AnimationLimit", CurTime()+self.AnimTime)
    self:SetNWBool("Closing", false)
    self:EmitSound("kick/hellopen.wav")
    self:EmitSound(table.Random(sound1), 75, 100, 1, CHAN_AUTO+1)
    if SERVER then
        local shake = ents.Create("env_shake")
        shake:SetOwner(self.Owner)
        shake:SetPos(self.Entity:GetPos())
        shake:SetKeyValue("amplitude", "200")	// Power of the shake
        shake:SetKeyValue("radius", "512")		// Radius of the shake
        shake:SetKeyValue("duration", "2.5")	// Time of shake
        shake:SetKeyValue("frequency", "255")	// How hard should the screenshake be
        shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
        shake:Spawn()
        shake:Activate()
        shake:Fire("StartShake", "", 0)
    end
    
    self.Snd = CreateSound(self, "kick/hell.mp3")
    if self.Snd then
        self.Snd:SetSoundLevel( 65 )
        self.Snd:Play()
    end
end

function ENT:Think()

    if self:GetNWFloat("AnimationLimit") < CurTime() && SERVER then
        if self:GetNWBool("KickPlayer") == true then
            local ent = self:GetNWEntity("KickPlayerEntity")
            local reason = self:GetNWString("KickPlayerReason")
            if IsValid(ent) then
                ent:Kick(reason)
            end
        end
        if self:GetNWBool("BanPlayer") == true then
            local ent = self:GetNWEntity("BanPlayerEntity")
            local time = self:GetNWInt("BanPlayerTime")
            if IsValid(ent) then
                ent:Ban(time, true)
            end
        end
        self:Remove()
    end
    
    if self:GetNWFloat("CryHelp") < CurTime() && self:GetNWFloat("CryHelp") != 0 then
        self:EmitSound(table.Random(sound2), 75, 100, 1, CHAN_AUTO+1)
        self:SetNWFloat("CryHelp", 0)
    end
    
    if self:GetNWFloat("AnimationLimit")-2 < CurTime() && self:GetNWBool("Closing") == false then
        self:SetNWBool("Closing", true)
        self:EmitSound("kick/hellclose.wav")
        self.Snd:FadeOut(2)
        if SERVER then
            local shake = ents.Create("env_shake")
            shake:SetOwner(self.Owner)
            shake:SetPos(self.Entity:GetPos())
            shake:SetKeyValue("amplitude", "200")	// Power of the shake
            shake:SetKeyValue("radius", "512")		// Radius of the shake
            shake:SetKeyValue("duration", "2.5")	// Time of shake
            shake:SetKeyValue("frequency", "255")	// How hard should the screenshake be
            shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
            shake:Spawn()
            shake:Activate()
            shake:Fire("StartShake", "", 0)
        end
    end
    
    self:NextThink(CurTime()) return true
end

function ENT:OnRemove()
    if self.Snd then
        self.Snd:Stop()
    end
end

function ENT:PhysicsCollide()
end


/*-----------------------------------------------------
				Custom render.Model func
-----------------------------------------------------*/
if SERVER then return end
function render.ModelPlayer( self, mdl, pos, ang, animation, animationspeed, scale )
    
	local ent = ClientsideModel( mdl, RENDERGROUP_OTHER )

	if ( !IsValid( ent ) ) then return end

	ent:SetModel( mdl )
	ent:SetNoDraw( true )

	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:ResetSequence( ent:LookupSequence( animation ) )
	ent:SetModelScale(scale)
	ent:SetCycle( animationspeed )
	ent:SetMaterial(self:GetNWString("KickPlayerMat") or "")
	ent:SetSkin(self:GetNWInt("KickPlayerSkin") or 0)
    ent:SetBodygroup(1, self:GetNWInt("KickPlayerBG1"))
    ent:SetBodygroup(2, self:GetNWInt("KickPlayerBG2"))
    ent:SetBodygroup(3, self:GetNWInt("KickPlayerBG3"))
    ent:SetBodygroup(4, self:GetNWInt("KickPlayerBG4"))
	ent:DrawModel()
	local returnpos, returnang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_R_Hand"))
	
	ent:Remove()
    return returnpos, returnang
end

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

function ENT:RenderGrab(animation)

	local ent = ClientsideModel( "models/monstermash/skeletonhand.mdl", RENDERGROUP_OTHER )
	if ( !IsValid( ent ) ) then return end

	ent:SetNoDraw( true )

    local pos = self:GetPos()
    pos = pos + self:GetForward()*-20
    pos = pos + self:GetRight()*0
    pos = pos + self:GetUp()*30
    
	ent:SetPos( pos )
	ent:SetAngles( self:GetAngles() )
	ent:ResetSequence( ent:LookupSequence( "idle" ) )
	ent:SetModelScale(10)
	ent:SetCycle( animation )
	ent:DrawModel()
	local returnpos, returnang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_R_Hand"))
	
	ent:Remove()
    
    if returnpos != nil then
        returnpos = returnpos + self:GetForward()*45
        returnpos = returnpos + self:GetRight()*15
        returnpos = returnpos + self:GetUp()*-30
        
        returnang:RotateAroundAxis(returnang:Right(), 40)
        returnang:RotateAroundAxis(returnang:Up(), 0)
        returnang:RotateAroundAxis(returnang:Forward(), -10)
        
        if animation > 0.6 then
            render.ModelPlayer(self, self:GetNWString("Model"),returnpos,returnang,"drive_pd",1, 1) 
        else
            render.ModelPlayer(self, self:GetNWString("Model"),self:GetPos(),self:GetAngles(),"menu_combine",animation, 1)
        end 
    end
end

function ENT:RenderOverride()
	local angle = Angle(0, 0, 0)
	local scale = 128
    local scale2 = 128
	local pos = self:GetPos()
    local animation = 1-(self:GetNWFloat("AnimationLimit") - CurTime())/self.AnimTime
    
    if animation < 0.3 then
        scale2 = 128*(animation)*10/3
    elseif animation > 0.7 then
        scale2 = 128*(1-animation)*10/3
    end
    
    if !IsValid(self) then return end
	
    render.SetStencilEnable( true )
    
        // Garry's halos are mean to us so we need to reset some values 
		render.SetStencilWriteMask( 255 )
		render.SetStencilTestMask( 255 )
		render.MaterialOverride( 0 ) 
		
		/*-----------------------------------------------------
							Make the hole
		-----------------------------------------------------*/

		render.SetStencilReferenceValue( 13 )
		render.SetStencilCompareFunction( STENCIL_ALWAYS ) // Always draw the circle
		render.SetStencilPassOperation( STENCIL_REPLACE ) // If the hole is visible normally, overwrite the current pixels
        render.SetStencilZFailOperation( STENCIL_ZERO ) // If something obscures the hole, decrease it's pixel value
		render.SetStencilZFailOperation( STENCIL_DECR ) // If something obscures the hole, decrease it's pixel value
		
		pos = pos - Vector(scale/2,-scale/2,0)

		cam.Start3D2D( pos, angle, scale )
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			surface.DrawCirc( 0.5, 0.5, scale2/256, 32 ) // a circular hole on the floor
		cam.End3D2D()
        

		/*-----------------------------------------------------
							Draw Hell
		-----------------------------------------------------*/
		
		render.SetStencilCompareFunction( STENCIL_EQUAL ) // If our pixel value is the same as the hole, draw hell
		cam.IgnoreZ( true )
            local size = 128
			render.SetMaterial(Material("models/misc/cube_left.png"))
			render.DrawBox( pos,angle,Vector(-128,-size*3+128,-size*3),Vector(-128,128,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_right.png"))
			render.DrawBox( pos,angle,Vector(size*3-128,-size*3+128,-size*3),Vector(size*3-128,128,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_center.png"))
			render.DrawBox( pos,angle,Vector(-128,128,-size*3),Vector(size*3-128,128,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_back.png"))
			render.DrawBox( pos,angle,Vector(-128,-size*3+128,-size*3),Vector(size*3-128,-size*3+128,0),Color(255,255,255,255),true)
			render.SetMaterial(Material("models/misc/cube_bot.png"))
			render.DrawBox( pos,angle,Vector(-128,-size*3+128,-size*3),Vector(size*3-128,128,-size*3),Color(255,255,255,255),true)
		cam.IgnoreZ( false )
        
        render.SetStencilReferenceValue(12)
		render.SetStencilCompareFunction(STENCIL_EQUAL)

		render.ClearBuffersObeyStencil(0, 0, 0, 255, true)
        
		
		/*-----------------------------------------------------
                        Draw player and hand
		-----------------------------------------------------*/		
        
		render.SetStencilCompareFunction( STENCIL_GREATEREQUAL )
		render.SetStencilPassOperation( STENCIL_REPLACE )
		render.SetStencilFailOperation( STENCIL_DECR )
		render.SetStencilZFailOperation( STENCIL_DECR )
		cam.IgnoreZ( true )
            self:RenderGrab(animation)
		cam.IgnoreZ( false )
		
	render.SetStencilEnable( false )
    
    self:RenderGrab(animation)
end