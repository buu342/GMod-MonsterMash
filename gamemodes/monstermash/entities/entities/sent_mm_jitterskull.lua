AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Jitterskull"
ENT.Name = ENT.PrintName
ENT.Author = "Buu342"
ENT.Information = "A huge skull with a strange movement pattern and a charge attack."
ENT.Category = "Ghouls"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HP = 200
ENT.IsMMNPC = true

function ENT:SetupDataTables()

	self:NetworkVar("Float", 0, "CoolDown")
	self:NetworkVar("Float", 1, "ChaseSoundCoolDown")
	self:NetworkVar("Float", 2, "ChaseCoolDown")
	self:NetworkVar("Float", 3, "HP")
	self:NetworkVar("String", 0, "State")

end

function ENT:SpawnFunction(ply, tr, ClassName)

	if (!tr.Hit) then return end

	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal * 32)
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:FindNearestPlayer(pos, range)
	
	local nearestply = nil
    
    for k, ply in pairs(player.GetAll()) do
        if (ply:Team() == TEAM_SPECT || ply:Team() == TEAM_COOPDEAD || ply:Team() == TEAM_INVALID) then 
            // Don't chase this player
        else
            local distance = pos:Distance(ply:GetPos())
            if (distance <= range) && ply:Alive() then
                
                nearestply = ply
                range = distance
                
            end
        end
	end
	
	return nearestply
    
end

function ENT:Initialize()

	self.lastframe = 1
	self.countframe = 1
	self:SetState("Idle")
	self:SetHP(self.HP)
	
	self.Name = self.PrintName

	if (CLIENT) then return end

	self:SetModel("models/hunter/misc/shell2x2.mdl")
	self:RebuildPhysics()
	self:DrawShadow(false)
	self:SetName(self.PrintName)
	
end

function ENT:Think()

	self:NextThink(CurTime() + 0.01)
	local ply = self:FindNearestPlayer(self:GetPos(), 4096)
	
	if GetConVar("ai_disabled"):GetInt() == 1 || (ply == nil && self:GetState() != "Dying") then 
		self:SetState("Idle")
	end
	
	if SERVER then
		local physobj = self:GetPhysicsObject()
		
		if self:GetState() == "Dying" || GAMEMODE:GetRoundState() == GMSTATE_ENDING then
			physobj:SetVelocity(Vector(0,0,0))
			local i=0
			for i=1, 5 do
				local vPoint = self:GetPos()
				local effectdata = EffectData()
				effectdata:SetOrigin(vPoint)
				util.Effect("mm_ghoul_fire1", effectdata)
			end
			self:EmitSound("ghouls/DSFLAME.wav")
            if (!self.Dead) then
                timer.Simple(3, function() if IsValid(self) then self:Remove() end end)
            end
            self.Dead = true
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
			if self:GetChaseCoolDown() < CurTime() then
				if self:GetPos():Distance(ply:GetPos()) < 356 then
					self:SetState("Attack1")
				else
					local dir = (ply:GetPos()-self:GetPos())
					dir:Normalize()
					dir = dir + Vector(math.Rand(-0.9,0.9),math.Rand(-0.9,0.9),0)
					dir:Normalize()
					physobj:SetVelocity(dir*10000000)
					timer.Simple(0.04, function() if IsValid(physobj) then physobj:SetVelocity(Vector(0,0,0)) end end)
					self:SetChaseCoolDown(CurTime()+0.7)
					self:EmitSound("ghouls/jitterskull/chase"..math.random(1,4)..".wav", 65)
				end
			end
			return
		end
		
		if self:GetState() == "Attack1" then 
			local dir = (ply:GetPos()-self:GetPos())
			dir:Normalize()
			physobj:SetVelocity(dir*1300)
			self:SetState("Attack2")
			self:EmitSound("ghouls/jitterskull/attack.wav")
			return
		end
		
		if self:GetState("Attack2") then
			physobj:SetVelocity(physobj:GetVelocity()*0.6)
			if physobj:GetVelocity():Length() < 75 then
				self:SetState("Idle")
			end
			if self:GetCoolDown() < CurTime() then
				self:SetCoolDown(CurTime()+0.5)
			end
			return
		end
	end
end


function ENT:RebuildPhysics()

	// This is necessary so that the vphysics.dll will not crash when attaching constraints to the new PhysObj after old one was destroyed
	// Garry pls fix
	self.ConstraintSystem = nil

	local size = 40
	self:PhysicsInitSphere(size, "default_silent")
	//self:PhysicsInitBox(self:GetPos()-Vector(32,0,0), self:GetPos()+Vector(32,0,96))
	self:SetCollisionBounds(Vector(-size, -size, -size), Vector(size, size, size+32))

	self:PhysWake()

end

function ENT:PhysicsCollide(data, physobj)
	if data.HitEntity:GetClass() == "player" && self:GetState() == "Attack2" then
		physobj:SetVelocity(Vector(0,0,0))
		self:SetState("Attack2")
        if (data.HitEntity:IsPlayer()) then
            timer.Simple(0, function() if IsValid(data.HitEntity) then data.HitEntity:SetKillFlag(KILL_SKELLINGTON) end end)
            data.HitEntity:SetKillFlag(KILL_GIB)
        end
		data.HitEntity:TakeDamage(100, self, self)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetState() != "Dying" then
		if self:GetState() == "Attack2" then
			self:SetState("Idle")
			self:SetCoolDown(CurTime()+0.5)
		end
		self:SetHP(self:GetHP() - dmginfo:GetDamage())
		if self:GetHP() <= 0 then
			self:SetState("Dying")
            if (dmginfo:GetAttacker() != nil && dmginfo:GetAttacker():IsPlayer()) then
                dmginfo:GetAttacker():AddScore(5)
                local dethtbl = {
                    color = Color(255, 105, 0),
                    time = CurTime()+10,
                    text = dmginfo:GetAttacker():Name().." overpowered the Jitterskull"
                }
                net.Start("MMNPCKilled")
                    net.WriteTable(dethtbl)
                net.Broadcast()
            end
            self:EmitSound("ghouls/jitterskull/die.wav", 75, 100, 1, CHAN_VOICE)
		end
	end
end

if (SERVER) then return end

local sequence_idle = "A"
local sequence_chase = "ABCBABCBCBABABCBCBABABCBCBA"
local sequence_attack = "D"

function ENT:Draw()
	local doomframe = math.ceil(((CurTime())-math.floor(CurTime()))*15)	
	
	if self.lastframe != doomframe then
		self.countframe = self.countframe+1
		self.lastframe = doomframe
	end
	
	local target_sequence
	if self:GetState() == "Attack2" || self:GetState() == "Dying" then
		target_sequence = sequence_attack
	elseif self:GetState() == "Chase" then
		target_sequence = sequence_chase
	else
		target_sequence = sequence_idle
	end
	local target_frame = string.sub(target_sequence, (self.countframe%string.len(target_sequence))+1, (self.countframe%string.len(target_sequence))+1)
	local mat = Material("ghouls/JSKL"..target_frame.."0.png")
	render.SetMaterial(mat)

	local pos = self:GetPos()
	local lcolor = render.ComputeLighting(pos, Vector(0, 0, 1))
	local c = Vector(1,1,1)

	lcolor.x = c.r * (math.Clamp(lcolor.x, 0, 1) + 0.20) * 255
	lcolor.y = c.g * (math.Clamp(lcolor.y, 0, 1) + 0.20) * 255
	lcolor.z = c.b * (math.Clamp(lcolor.z, 0, 1) + 0.20) * 255
	
	local height = 96	
	local offset = 17
	if target_frame == "D" then
		height = 128
		offset = 32
	end
	render.DrawSprite(pos+Vector(0,0,offset), 64, height, Color(lcolor.x, lcolor.y, lcolor.z, 255))
end