AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Sjas"
ENT.Name = "Sjas"
ENT.Author = "Buu342"
ENT.Information = "A fast, hardly visible screecher."
ENT.Category = "Ghouls"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HP = 120

local sequence_idle = "A"
local sequence_chase = "B"
local sequence_attack = "CCDDCCDDCCDDCCDDCCDD"
local sequence_die = "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFGFGFGFGFGFGFGFGFGFGFGFGFGFGFGFGFGFGFGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHGHFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"


function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "CoolDown")
	self:NetworkVar( "Float", 1, "ChaseSoundCoolDown" )
	self:NetworkVar( "Float", 2, "HP")
	self:NetworkVar( "String", 0, "State")
	self:NetworkVar( "Int", 0, "CountFrame")
	self:NetworkVar( "Bool", 0, "FireEffect")
	self:NetworkVar( "Bool", 1, "DeathFrameResetMulti") // Required to fix multiplayer prediction

end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 32 )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:FindNearestPlayer( pos, range )
	
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

	self:SetNWInt("lastframe",1 )
	self:SetCountFrame(1)
	self:SetState("Idle")
	self:SetHP(self.HP)

	self:SetGravity(0)
	
	if ( CLIENT ) then return end

	self:SetModel( "models/hunter/misc/sphere175x175.mdl" )
	self:RebuildPhysics()
	self:DrawShadow( false )
	
end

function ENT:DoFireDeath()
	self:EmitSound("ghouls/DSFLAME.wav")
	local total = 20
	for i=1, total do
		local ang = ((2*(3.14159))/total)*i
		local ang2 = Vector(math.sin(ang), math.cos(ang), 0)
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		effectdata:SetNormal( ang2 )
		util.Effect( "ghoul_fire2", effectdata )
	end
end

function ENT:Think()

	self:NextThink( CurTime() + 0.001 )
	local ply = self:FindNearestPlayer(self:GetPos(), 8138)
	
	if GetConVar("ai_disabled"):GetInt() == 1 || (ply == nil && self:GetState() == "Chase") then 
		self:SetState("Idle")
	end
	
	if CLIENT && self:GetState() == "Chase" then
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "sjas_trail", effectdata )
	end
	
	if CLIENT then
		local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*30)	
		
		if self:GetNWInt("lastframe") != doomframe then
			self:SetCountFrame(self:GetCountFrame()+1)
			self:SetNWInt("lastframe", doomframe)
			if self:GetState() == "Dying" then
				if self:GetDeathFrameResetMulti() == false then
					self:SetDeathFrameResetMulti(true)
					self:SetCountFrame(1)
					self:SetNWInt("lastframe", 1)
				end
				local soundframe = string.sub(sequence_die, (self:GetCountFrame()%string.len(sequence_die))+1, (self:GetCountFrame()%string.len(sequence_die))+1)
				local soundframenext = string.sub(sequence_die, (self:GetCountFrame()%string.len(sequence_die))+2, (self:GetCountFrame()%string.len(sequence_die))+2)
				if (soundframe == "F" || soundframe == "H") && soundframenext != "F" && self:GetCountFrame() < string.len(sequence_die)-1 then
					self:EmitSound("ghouls/sjas/SJASPAIN.wav", 75, 100, 1, CHAN_VOICE)
				end
			end
		end
	end
	
	if SERVER then
		local physobj = self:GetPhysicsObject()
		
		if self:GetState() == "Dying" then
			if !self:IsOnGround() then
				self:SetGravity(physenv.GetGravity().z)
			else
				self:SetGravity(0)
				physobj:SetVelocity(Vector(0,0,0))
				physobj:Sleep()
			end
			if self:GetFireEffect() == false then
				self:SetFireEffect(true)
				timer.Simple(6.5, function() 
					if IsValid(self) then 
						physobj:SetVelocity(Vector(0,0,0))
						self:EmitSound("ghouls/sjas/SJASDEAT.wav")
						self:DoFireDeath()
						timer.Simple(0.75, function() if IsValid(self) then self:DoFireDeath() end end)
						timer.Simple(1.50, function() if IsValid(self) then self:DoFireDeath() self:Remove() end end)
					end 
				end)
			end
			return
		end
		
		if self:GetState() == "Idle" then
			physobj:SetVelocity(Vector(0,0,0))
			if self:GetCoolDown() < CurTime() && IsValid(ply) then
				self:SetState("Chase")
			end
			return
		end
		
		if self:GetState() == "Chase" then
			physobj:SetVelocity(Vector(0,0,0))
			local dir = ((ply:GetPos()+Vector(0,0,32))-self:GetPos())
			dir:Normalize()
			dir = dir + Vector(math.Rand(-0.9,0.9),math.Rand(-0.9,0.9),0)
			dir:Normalize()
			physobj:SetVelocity(dir*500)
			if self:GetChaseSoundCoolDown() < CurTime() then
				self:SetChaseSoundCoolDown(CurTime()+0.3)
				self:EmitSound("ghouls/sjas/SJASACT.wav", 60, 100, 1, CHAN_VOICE)
			end
			return
		end
		
		if self:GetState() == "Pain" then
			physobj:SetVelocity(Vector(0,0,0))
			local possiblejumps = {}
			for k, v in pairs(navmesh.GetAllNavAreas()) do
				if IsValid(ply) && ply:GetPos():Distance(v:GetCenter()) < 8138 then
					table.insert(possiblejumps, v:GetCenter())
				else
					table.insert(possiblejumps, v:GetCenter())
				end
			end
			
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "sjas_vanish", effectdata )
			
			if table.Count(possiblejumps) == 0 && IsValid(ply) then
				local dir = (ply:GetPos()-self:GetPos())
				dir:Normalize()
				dir = dir + Vector(math.Rand(-0.9,0.9),math.Rand(-0.9,0.9))
				dir:Normalize()
				physobj:SetVelocity(dir*9999999999999 + Vector(0,0,10))
			else
				self:SetPos(table.Random(possiblejumps)+Vector(0,0,32))
			end
			self:SetState("Idle")
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
	//self:PhysicsInitBox(self:GetPos()-Vector(32,0,0), self:GetPos()+Vector(32,0,96))
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size+32 ) )

	self:PhysWake()

end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:GetClass() == "player" && self:GetState() == "Chase" then
		physobj:SetVelocity(Vector(0,0,0))
		self:SetState("Attack1")
		data.HitEntity:TakeDamage(100, self, self)
		self:EmitSound("ghouls/sjas/SJASATTA.wav", 75, 100, 1, CHAN_VOICE)
	end
end

function ENT:OnTakeDamage( dmginfo )
	if self:GetState() != "Dying" then
		self:SetCountFrame(1)
		self:SetState("Pain")
		self:SetCoolDown(CurTime()+0.5)
		self:SetHP(self:GetHP() - dmginfo:GetDamage())
		self:EmitSound("ghouls/sjas/SJASPAIN.wav", 75, 100, 1, CHAN_VOICE)
		self:SetCountFrame(1)
		if self:GetHP() <= 0 then
			self:SetNWInt("lastframe",1)
			self:SetCountFrame(1)
			self:SetState("Dying")
            net.Start("PlayerKilledNPC")
				net.WriteString(self:GetClass())
				net.WriteString(dmginfo:GetInflictor():GetClass())
				net.WriteEntity(dmginfo:GetAttacker())
			net.Broadcast()
		end
	end
end


if ( SERVER ) then return end

function ENT:Draw()
	
	local target_sequence
	if self:GetState() == "Attack1" then
		target_sequence = sequence_attack
	elseif self:GetState() == "Chase" then
		target_sequence = sequence_chase
	elseif self:GetState() == "Dying" then
		target_sequence = sequence_die
	else
		target_sequence = sequence_idle
	end
	local target_frame = string.sub(target_sequence, (self:GetCountFrame()%string.len(target_sequence))+1, (self:GetCountFrame()%string.len(target_sequence))+1)
	local mat = Material( "ghouls/SJAS"..target_frame.."0.png" )
	
	if self:GetState() == "Dying" && self:GetCountFrame() > 205 then return end
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
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 128 ) )

end