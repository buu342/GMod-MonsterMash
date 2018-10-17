AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Creeper"
ENT.Name = "Creeper"
ENT.Author = "Buu342"
ENT.Information = "A a shadowy figure which pops up in your face up close."
ENT.Category = "Ghouls"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HP = 100

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
			local dir = Vector(math.Rand(-0.9,0.9),math.Rand(-0.9,0.9),0)
			dir:Normalize()
			physobj:SetVelocity(dir*300)
			for i=1, 2 do
				local vPoint = self:GetPos()
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "ghoul_fire3", effectdata )
			end
			self:EmitSound("ghouls/DSFLAME.wav")
			if self:GetFireEffect() == false then
				self:SetFireEffect(true)
				self:EmitSound("ghouls/creeper/CREEP4.wav", 75, 100, 1, CHAN_VOICE)
				timer.Simple(4, function() if IsValid(self) then self:Remove() end end)
			end
			return
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
			dir = dir + Vector(math.Rand(-0.9,0.9),math.Rand(-0.9,0.9),-0.75)
			dir:Normalize()
			physobj:SetVelocity(dir*300)
			if self:GetChaseSoundCoolDown() < CurTime() then
				self:SetChaseSoundCoolDown(CurTime()+2)
				self:EmitSound("ghouls/creeper/CREEP1.wav", 65, 100, 1, CHAN_VOICE)
			end
			return
		end
		
		if self:GetState() == "Pain" then
			if IsValid(ply) then
				local dir = (ply:GetPos()-self:GetPos())
				dir:Normalize()
				dir = Vector(-dir.x + math.Rand(-0.9,0.9), -dir.y + math.Rand(-0.9,0.9), 0)
				dir:Normalize()
				physobj:SetVelocity(dir*500000)
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

	local size = 16
	self:PhysicsInitSphere( size, "default_silent" )
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size-48 ) )

	self:PhysWake()

end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:GetClass() == "player" && self:GetState() == "Chase" then
		physobj:SetVelocity(Vector(0,0,0))
		self:SetState("Attack1")
		data.HitEntity:TakeDamage(100, self, self)
		data.HitEntity:SetNWFloat("CreeperSpook", CurTime()+2.5)
		data.HitEntity:EmitSound("ghouls/creeper/CREEP2.wav", 75, 100, 1, CHAN_VOICE2)
	end
end

hook.Add("HUDPaint", "CreeperSpookHUD", function()
	if LocalPlayer():GetNWFloat("CreeperSpook") > CurTime() then
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("CreeperSpook") - CurTime())*255 )
		surface.SetMaterial( Material( "ghouls/CREEC0.png" ) )
		
		size = ScrH()
		local moveup = math.min(ScrH(),(2.5 - (LocalPlayer():GetNWFloat("CreeperSpook")-CurTime()))*ScrH()*4)
		surface.DrawTexturedRect( (ScrW()/2)-(size/2), ScrH()-moveup, size, size )
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
			self:SetState("Dying")
            net.Start("PlayerKilledNPC")
				net.WriteString(self:GetClass())
				net.WriteString(dmginfo:GetInflictor():GetClass())
				net.WriteEntity(dmginfo:GetAttacker())
			net.Broadcast()
		else
			self:EmitSound("ghouls/creeper/CREEP3.wav")
		end
	end
end


if ( SERVER ) then return end

local sequence_idle = "A"
local sequence_chase = "AABB"
local sequence_pain = "AB"
local sequence_die = "D"

function ENT:Draw()
	local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*10)	
	
	if self.lastframe != doomframe then
		self:SetCountFrame(self:GetCountFrame()+1)
		self.lastframe = doomframe
		local soundframe = string.sub(sequence_die, (self:GetCountFrame()%string.len(sequence_die))+1, (self:GetCountFrame()%string.len(sequence_die))+1)
		local soundframenext = string.sub(sequence_die, (self:GetCountFrame()%string.len(sequence_die))+2, (self:GetCountFrame()%string.len(sequence_die))+2)
	end
	
	local target_sequence
	if self:GetState() == "Chase" then
		target_sequence = sequence_chase
	elseif self:GetState() == "Dying" then
		target_sequence = sequence_die
	else
		target_sequence = sequence_idle
	end
	local target_frame = string.sub(target_sequence, (self:GetCountFrame()%string.len(target_sequence))+1, (self:GetCountFrame()%string.len(target_sequence))+1)
	local mat = Material( "ghouls/CREE"..target_frame.."0.png" )
	
	render.SetMaterial( mat )

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector(1,1,1)

	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.2 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.2 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.2 ) * 255
	
	local width = mat:Width()/1.2
	local height = 10
	local offset = -26+16
	if target_frame == "D" then
		offset = 20+16
		height = mat:Height()/10
		width = mat:Width()/20
	end
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 200 ) )
end