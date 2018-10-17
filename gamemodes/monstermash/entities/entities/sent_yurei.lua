AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Yurei"
ENT.Name = "Yurei"
ENT.Author = "Buu342"
ENT.Information = "A slender, stalking figure."
ENT.Category = "Ghouls"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HitAbleTransparency = 200

ENT.HP = 300

function ENT:SetupDataTables()

	self:NetworkVar("Float", 0, "HP")
	self:NetworkVar("Float", 1, "Distance")
	self:NetworkVar("Float", 2, "JumpTime")
	self:NetworkVar("Float", 3, "CoolDown")
	self:NetworkVar("Float", 4, "JumpAngle")
	self:NetworkVar("Int", 0, "Transparency")
	self:NetworkVar("String", 0, "State")

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
	self.countframe = 1
	self:SetState("Idle")
	self:SetHP(self.HP)
	
	if ( CLIENT ) then return end

	self:SetModel( "models/hunter/misc/sphere175x175.mdl" )
	self:RebuildPhysics()
	self:SetJumpTime(2)
	self:SetJumpAngle(math.Rand(0,2*3.14159))
	self:SetCoolDown(CurTime()+self:GetJumpTime())
	self:DrawShadow( false )

end

function ENT:Think()

	self:NextThink( CurTime() + 0.01 )
	local ply = FindNearestPlayer(self:GetPos(), 32767)
	
	if GetConVar("ai_disabled"):GetInt() == 1 || (ply == nil && self:GetState() != "Dying") then 
		self:SetState("Idle")
	end
	
	if SERVER then
		local physobj = self:GetPhysicsObject()
		if self:GetTransparency() < self.HitAbleTransparency then
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			physobj:SetVelocity(Vector(0,0,0))
			physobj:Sleep()
			self:SetNotSolid(true)
		else
			self:SetNotSolid(false)
			physobj:Wake()
			physobj:SetVelocity(Vector(0,0,-128))
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
		if self:GetState() == "Idle" then
			self:SetTransparency(0)
			if IsValid(ply) && self:GetJumpTime() < 0.2 then
				ply:Kill()
				ply:EmitSound("ghouls/yurei/SUPERC4.wav", 75, 100, 1, CHAN_VOICE)
				ply:SetNWFloat("YureiSpook", CurTime()+1.75)
				self:SetJumpTime(2)
				self:SetCoolDown(CurTime()+self:GetJumpTime())
			end
			if IsValid(ply) && self:GetCoolDown() < CurTime() then
				self:SetState("Jump1")
			end
			return
		end
		if self:GetState() == "Jump1" then
			if IsValid(ply) then
				self:SetPos(ply:GetPos() + Vector((384*self:GetJumpTime())*math.sin(self:GetJumpAngle()), (384*self:GetJumpTime())*math.cos(self:GetJumpAngle()), 32))
				ply:EmitSound("ghouls/yurei/HEART.wav", 40)
				self:SetState("Jump2")
			else
				self:SetState("Idle")
			end
			return
		end
		if self:GetState() == "Jump2" then
			self:SetTransparency(self:GetTransparency()+math.Clamp((2-self:GetJumpTime())*64, 75, 128))
			if self:GetTransparency() >= 255 then
				self:SetTransparency(255)
				self:SetState("Jump3")
			end
			return
		end
		if self:GetState() == "Jump3" then
			self:SetTransparency(self:GetTransparency()-math.Clamp((2-self:GetJumpTime())*64, 75, 128))
			if self:GetTransparency() <= 0 then
				self:SetTransparency(0)
				self:SetJumpTime(self:GetJumpTime()*0.9)
				self:SetJumpAngle(self:GetJumpAngle() + math.Rand(3.14159/3,3.14159/1.5))
				self:SetCoolDown(CurTime()+self:GetJumpTime())
				self:SetState("Idle")
			end
			return
		end
		
		if self:GetState() == "Pain" then
			self:SetTransparency(0)
			if self:GetCoolDown() < CurTime() then
				self:SetState("Dying")
				self:EmitSound("ghouls/yurei/SAMARADI.wav", 75, 100, 1, CHAN_VOICE)
				timer.Simple(4, function() if IsValid(self) then self:Remove() end end)
			end
			return
		end
		
		if self:GetState() == "Dying" then
			self:SetTransparency(self.HitAbleTransparency)
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
			return
		end
	end
end


function ENT:RebuildPhysics()

	// This is necessary so that the vphysics.dll will not crash when attaching constraints to the new PhysObj after old one was destroyed
	// Garry pls fix
	self.ConstraintSystem = nil

	local size = 32
	self:PhysicsInitSphere( size, "default_silent" )
	//self:PhysicsInitBox(self:GetPos()-Vector(32,0,0), self:GetPos()+Vector(32,0,96))
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size+32 ) )

	self:PhysWake()

end

local spookytextures =
{
	"creepy/gman.png",
	"creepy/chestire.png",
	"creepy/creepydoll.png",
	"creepy/funhouse.png",
	"creepy/illusion.png",
	"creepy/jason.png",
	"creepy/jeff.png",
	"creepy/russiansleep.png",
	"creepy/wdzombie1.png",
	"creepy/wdzombie2.png",
	"creepy/wdzombie3.png",
	"creepy/SCARY13.png",
	"creepy/SCARY17.png"
}

hook.Add("HUDPaint", "Yurei	SpookHUD", function()
	local finalstaytime = 0.5
	if LocalPlayer():GetNWFloat("YureiSpook") > CurTime() then
		if LocalPlayer():GetNWInt("SpookyTextureNext") < CurTime() && LocalPlayer():GetNWFloat("YureiSpook")-finalstaytime > CurTime() then
			LocalPlayer():SetNWInt("SpookyTexture", math.random(1,table.Count(spookytextures)))
			LocalPlayer():SetNWInt("SpookyTextureNext", CurTime()+0.1)
		end
	
		local mat = Material( spookytextures[LocalPlayer():GetNWInt("SpookyTexture")] )
		if LocalPlayer():GetNWFloat("YureiSpook")-finalstaytime < CurTime() then
			surface.SetDrawColor( 255, 255, 255, 255*((LocalPlayer():GetNWFloat("YureiSpook") - CurTime())/finalstaytime) )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end
end)


function ENT:OnBallSizeChanged( varname, oldvalue, newvalue )

	-- Do not rebuild if the size wasn't changed
	if ( oldvalue == newvalue ) then return end

	self:RebuildPhysics( newvalue )

end


function ENT:PhysicsCollide( data, physobj )
end

function ENT:OnTakeDamage( dmginfo )
	if self:GetTransparency() > 128 then
        self:SetHP(self:GetHP() - dmginfo:GetDamage())
		if self:GetHP() <= 0 && self:GetState() != "Dying" && self:GetState() != "Pain" then
            self:SetCoolDown(CurTime()+0.5)
            self:SetState("Pain")
            self:EmitSound("ghouls/yurei/SAMARAHI.wav")
            net.Start("PlayerKilledNPC")
                net.WriteString(self:GetClass())
                net.WriteString(dmginfo:GetInflictor():GetClass())
                net.WriteEntity(dmginfo:GetAttacker())
            net.Broadcast()
            for i=1, 5 do
                local vPoint = self:GetPos() 
                local effectdata = EffectData()
                local scale = i
                effectdata:SetOrigin( vPoint )
                effectdata:SetNormal( self:GetAngles():Up() * math.max( 3, scale ) / 3 )
                effectdata:SetMagnitude( 1 )
                effectdata:SetScale( scale + 9 )
                effectdata:SetColor( 0 )
                effectdata:SetFlags( 3 )
                util.Effect( "bloodspray", effectdata )
            end
        end
	end
end


if ( SERVER ) then return end

local sequence_idle = "ABCDEFGHI"
local sequence_die = "JK"

function ENT:Draw()
	local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*7)	
	
	if self.lastframe != doomframe then
		self.countframe = self.countframe+1
		self.lastframe = doomframe
	end
	
	local target_sequence
	if self:GetState() == "Dying" then
		target_sequence = sequence_die
	else
		target_sequence = sequence_idle
	end
	local target_frame = string.sub(target_sequence, (self.countframe%string.len(target_sequence))+1, (self.countframe%string.len(target_sequence))+1)
	local mat = Material( "ghouls/SAMA"..target_frame.."0.png" )
	
	if self:GetState() == "Pain" then return end
	render.SetMaterial( mat )

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
	local c = Vector(1,1,1)

	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255
	
	local width = 20
	local height = 80
	local offset = 4
	if target_frame == "J" || target_frame == "K" then
		width = 64
		height = 64
		offset = 32
	end
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, self:GetTransparency() ) )
end