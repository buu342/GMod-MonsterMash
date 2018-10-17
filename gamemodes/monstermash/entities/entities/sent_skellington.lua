AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Skellington"
ENT.Name = "Skellington"
ENT.Author = "Buu342"
ENT.Information = "3spooky5me"
ENT.Category = "Monster Mash"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HP = 60

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "CoolDown")
	self:NetworkVar( "Float", 1, "ChaseSoundCoolDown" )
	self:NetworkVar( "Float", 2, "HP")
	self:NetworkVar( "String", 0, "State")
	self:NetworkVar( "Int", 0, "CountFrame")
	self:NetworkVar( "Bool", 0, "FireEffect")

end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 32 )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function FindNearestPlayer( pos, range )
	
	local nearestply = nil
    
    for i, ply in pairs( player.GetAll()) do
        if ply:Team() != 3 then continue end
		local distance = pos:Distance( ply:GetPos() )
        if( distance <= range ) && ply:Alive() then

            nearestply = ply
            range = distance
            
        end
	end
	
	return nearestply
    
end

function ENT:Initialize()

	self.lastframe = 1
	self:SetCountFrame(1)
	self:SetState("Idle")
	self:SetHP(self.HP)

	if ( CLIENT ) then return end

	self:SetModel( "models/hunter/misc/sphere175x175.mdl" )
	self:RebuildPhysics()
	self:DrawShadow( false )
	
end

function ENT:Think()

	self:NextThink( CurTime() + 0.001 )
	local ply = FindNearestPlayer(self:GetPos(), 4096)
	
	if GetConVar("ai_disabled"):GetInt() == 1 || (ply == nil && self:GetState() == "Chase") then 
		self:SetState("Idle")
	end
	
	if SERVER then
		local physobj = self:GetPhysicsObject()
		if self:GetState() == "Dying" then
			self:EmitSound("death/clickityclack2.wav", 75, 100, 1, CHAN_VOICE)
			local giblist = {
			"models/monstermash/gibs/head_skull.mdl",
			"models/monstermash/gibs/sk_gib_1.mdl",
			"models/monstermash/gibs/sk_gib_2.mdl",
			"models/monstermash/gibs/sk_gib_3.mdl",
			"models/monstermash/gibs/sk_gib_4.mdl",
			"models/monstermash/gibs/sk_gib_5.mdl",
			"models/monstermash/gibs/sk_gib_6.mdl",
			"models/monstermash/gibs/sk_gib_8.mdl",
			"models/monstermash/gibs/sk_gib_9.mdl",
			"models/monstermash/gibs/sk_gib_10.mdl",
			"models/monstermash/gibs/sk_gib_11.mdl",
			"models/monstermash/gibs/sk_gib_12.mdl",
			}
			for i=1, 11 do
				local ent2 = ents.Create("prop_physics")
				ent2:SetPos(self:GetPos())
				ent2:SetModel(giblist[i])
				ent2:SetAngles(self:GetAngles())
				ent2:Spawn()
				local phys = ent2:GetPhysicsObject()
				if ( !IsValid( phys ) ) then ent2:Remove() return end
				phys:ApplyForceCenter( Vector( math.random(-200,200), math.random(-200,200), math.random(0,100) )*10 )
				ent2:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
				timer.Simple(GetConVar( "mm_cleanup_time" ):GetInt(),function() if !IsValid(ent2) then return end ent2:Remove() end)
			end
			self:Remove()
		end
		
		if self:GetState() == "Idle" then
			if !self:IsOnGround() then
				physobj:SetVelocity(Vector(0,0,-200))
			end
			if self:GetChaseSoundCoolDown() < CurTime() then
				self:SetChaseSoundCoolDown(CurTime()+2)
				self:EmitSound("ghouls/creeper/CREEP1.wav", 60, 100, 1, CHAN_VOICE)
			end
			if self:GetCoolDown() < CurTime() && IsValid(ply) then
				self:SetState("Chase")
			end
			return
		end
		
		if self:GetState() == "Chase" then
			if !self:IsOnGround() then
				physobj:SetVelocity(Vector(0,0,-200))
			end
			local dir = (ply:GetPos()-self:GetPos())
			dir:Normalize()
			dir = dir + Vector(math.Rand(-0.4,0.4),math.Rand(-0.4,0.4),-0.75)
			dir:Normalize()
			physobj:SetVelocity(dir*200)
			return
		end
		
		if self:GetState() == "Pain" then
			if IsValid(ply) then
				local dir = (ply:GetPos()-self:GetPos())
				dir:Normalize()
				dir = Vector(-dir.x + math.Rand(-0.9,0.9), -dir.y + math.Rand(-0.9,0.9), 0)
				dir:Normalize()
				physobj:SetVelocity(dir*750)
			end
			self:SetState("Chase")
			return
		end
		
		if self:GetState() == "Attack1" then
			physobj:SetVelocity(Vector(0,0,0))
			timer.Simple(0.7, function() if IsValid(self) then self:SetState("Idle") end end)
			return
		end
	end
end


function ENT:RebuildPhysics( )

	// This is necessary so that the vphysics.dll will not crash when attaching constraints to the new PhysObj after old one was destroyed
	// Garry pls fix
	self.ConstraintSystem = nil

	local size = 31
	self:PhysicsInitSphere( size, "default_silent" )
	//self:PhysicsInitBox(self:GetPos()-Vector(32,0,0), self:GetPos()+Vector(32,0,96))
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size+32 ) )

	self:PhysWake()
	
end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:GetClass() == "player" && self:GetState() == "Chase" then
		physobj:SetVelocity(Vector(0,0,0))
		self:SetState("Attack1")
		data.HitEntity:TakeDamage(140, self, self)
		data.HitEntity:SetNWFloat("SkeletonSpook", CurTime()+1.33)
		data.HitEntity:SetNWFloat("NextSkeletonSpookCount", CurTime())
		data.HitEntity:SetNWInt("SkeletonSpookCount", 1)
		data.HitEntity:EmitSound("death/clickityclack1.wav", 75, 100, 1, CHAN_VOICE2)
	end
end

hook.Add("HUDPaint", "SkellingtonSpookHUD", function()
	if LocalPlayer():GetNWFloat("SkeletonSpook") > CurTime() then
		surface.SetDrawColor( 255, 255, 255, 255 )
		if LocalPlayer():GetNWInt("SkeletonSpookCount") > 6 then
			surface.SetMaterial( Material( "animated/skeletonpoploop_"..((LocalPlayer():GetNWInt("SkeletonSpookCount")%5)+1)..".png" ) )
		else
			surface.SetMaterial( Material( "animated/skeletonpop_"..LocalPlayer():GetNWInt("SkeletonSpookCount")..".png" ) )
		end
		
		surface.DrawTexturedRect( 0,0, ScrW(), ScrH() )
	end
	if LocalPlayer():GetNWFloat("SkeletonSpook") > CurTime() && LocalPlayer():GetNWFloat("NextSkeletonSpookCount") < CurTime() then
		LocalPlayer():SetNWInt("SkeletonSpookCount", LocalPlayer():GetNWInt("SkeletonSpookCount") + 1)
		LocalPlayer():SetNWFloat("NextSkeletonSpookCount", CurTime() + 1/15)
	end
end)

function ENT:OnTakeDamage( dmginfo )
	if self:GetState() != "Dying" then
		self:SetState("Pain")
		self:SetCoolDown(CurTime()+0.5)
		self:SetHP(self:GetHP() - dmginfo:GetDamage())
		self:SetCountFrame(1)
		if self:GetHP() <= 0 then
			self:SetCountFrame(1)
			net.Start("PlayerKilledNPC")
				net.WriteString(self:GetClass())
				net.WriteString(dmginfo:GetInflictor():GetClass())
				net.WriteEntity(dmginfo:GetAttacker())
			net.Broadcast()
			self:SetState("Dying")
            SetGlobalVariable("WackyRound_Extra", GetGlobalVariable("WackyRound_Extra") - 1)
		else
			self:EmitSound("weapons/bone/boner2.wav")
		end
	end
end


if ( SERVER ) then return end


function ENT:Draw()

	local mat = Material( "animated/skeleton_run" )
	
	render.SetMaterial( mat )

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector(1,1,1)

	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.25 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.25 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.25 ) * 255
	
	local width = mat:Width()/3
	local height = mat:Height()/3
	local offset = 8
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	//self:DrawModel()
end