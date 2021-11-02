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

ENT.Master = nil

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "CoolDown")
	self:NetworkVar( "Float", 1, "ChaseSoundCoolDown" )
	self:NetworkVar( "Float", 2, "HP")
	self:NetworkVar( "Float", 3, "Lifetime")
	self:NetworkVar( "String", 0, "State")
	self:NetworkVar( "Int", 0, "CountFrame")
	self:NetworkVar( "Entity", 0, "Master")

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
    
    
    if (self:GetMaster() == TEAM_COOPMONST) then
        // Search for TEAM_COOPOTHER or other skellingtons
    else
        for i, ply in pairs( player.GetAll()) do
            if ply:Team() == TEAM_SPECT || ply:Team() == TEAM_INVALID || ply == self:GetMaster() || 
                (IsValid(self:GetMaster()) && ply != self:GetMaster() && ply:Team() == self:GetMaster():Team() && GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().mode != MODE_DEATHMATCH && GAMEMODE:WackyRoundData().mode != MODE_LMS) then 
            else
                local distance = pos:Distance( ply:GetPos() )
                if( distance <= range ) && ply:Alive() then

                    nearestply = ply
                    range = distance
                    
                end
            end
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
    
    timer.Simple(0, function()
        self:SetMaster(self.Master)
        if self:GetMaster() != nil then
            self:SetOwner(self.Master)
            self.Owner = self.Master
            self:SetLifetime(CurTime()+60)
        end
    end)
	
end

function ENT:Think()

	self:NextThink( CurTime() + 0.001 )
    
    if self:GetMaster() != nil && self:GetLifetime() < CurTime() && SERVER then
        self:Remove()
        return
    end
    
	local ply = self:FindNearestPlayer(self:GetPos(), 4096)
	if GetConVar("ai_disabled"):GetInt() == 1 || (ply == nil && self:GetState() == "Chase") then 
		self:SetState("Idle")
	end
	
	if SERVER then
		local physobj = self:GetPhysicsObject()
		if self:GetState() == "Dying" || GAMEMODE:GetRoundState() == GMSTATE_ENDING then
			self:EmitSound("death/clickityclack2.wav", 75, 100, 1, CHAN_VOICE)

            // Spawn gibs here

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
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size+32 ) )

	self:PhysWake()
	
end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:GetClass() == "player" && data.HitEntity != self:GetMaster() && self:GetState() == "Chase" then
		physobj:SetVelocity(Vector(0,0,0))
		self:SetState("Attack1")
        if (data.HitEntity:IsPlayer()) then
            timer.Simple(0, function() if IsValid(data.HitEntity) then data.HitEntity:SetKillFlag(KILL_SKELLINGTON) end end)
            data.HitEntity:SetKillFlag(KILL_GIB)
        end
		data.HitEntity:TakeDamage(140, self, self)
		data.HitEntity:EmitSound("death/clickityclack1.wav", 75, 100, 1, CHAN_VOICE2)
	end
end

if CLIENT then
    local spookcount = 0
    local nextspookcount = 0
    local spooktime = 0
    local dospook = false
    local finishedspook = false
    local skellmatspop = {
        Material( "animated/skeletonpop_1.png" ),
        Material( "animated/skeletonpop_2.png" ),
        Material( "animated/skeletonpop_3.png" ),
        Material( "animated/skeletonpop_4.png" ),
        Material( "animated/skeletonpop_5.png" ),
        Material( "animated/skeletonpop_6.png" )
    }
    local skellmatsloop = {
        Material( "animated/skeletonpoploop_1.png" ),
        Material( "animated/skeletonpoploop_2.png" ),
        Material( "animated/skeletonpoploop_3.png" ),
        Material( "animated/skeletonpoploop_4.png" ),
        Material( "animated/skeletonpoploop_5.png" )
    }
    
    hook.Add("HUDPaint", "MM_SkellingtonSpookHUD", function()
        if ((LocalPlayer():HasKillFlag(KILL_SKELLINGTON) || (IsValid(LocalPlayer():GetNWEntity("MM_Killer")) && LocalPlayer():GetNWEntity("MM_Killer"):GetClass() == "sent_mm_skellington") || dospook) && !LocalPlayer():Alive()) then
            if (!dospook) then
                dospook = true
                spooktime = CurTime() + 1.25
                finishedspook = false
            end
            if (!finishedspook) then
                surface.SetDrawColor( 255, 255, 255, 255 )
                if (spookcount > 5) then
                    surface.SetMaterial(skellmatsloop[(spookcount%5)+1])
                else
                    surface.SetMaterial(skellmatspop[spookcount+1])
                end
                surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
            end
        end
        if (dospook) then
            if (nextspookcount < CurTime()) then
                spookcount = spookcount + 1
                nextspookcount = CurTime() + 1/15
            end
        end
        if (spooktime < CurTime()) then
            if (!LocalPlayer():Alive()) then
                finishedspook = true
            elseif (LocalPlayer():Alive() && dospook) then
                spookcount = 0
                nextspookcount = 0
                dospook = false
                spooktime = 0
                finishedspook = false
            end
        end
    end)
end

function ENT:OnTakeDamage( dmginfo )
	if self:GetState() != "Dying" then
		self:SetState("Pain")
		self:SetCoolDown(CurTime()+0.5)
		self:SetHP(self:GetHP() - dmginfo:GetDamage())
		self:SetCountFrame(1)
		if self:GetHP() <= 0 then
			self:SetCountFrame(1)
            local dethtbl = {
                color = Color(255, 105, 0),
                time = CurTime()+10,
                text = dmginfo:GetAttacker():Name().." fought off a skellington"
            }
			net.Start("MMNPCKilled")
				net.WriteTable(dethtbl)
			net.Broadcast()
			self:SetState("Dying")
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
    
    if LocalPlayer() == self:GetMaster() then
        lcolor.x = 0
        lcolor.z = 0
    end
	
	local width = mat:Width()/3
	local height = mat:Height()/3
	local offset = 8
	render.DrawSprite( pos+Vector(0,0,offset), width, height, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	//self:DrawModel()
end