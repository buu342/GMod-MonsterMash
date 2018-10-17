AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false

local function simplifyangle(angle)
	while (angle >= 180) do
		angle = angle - 360;
	end

	while (angle <= -180) do
		angle = angle + 360;
	end

	return angle;
end


local COLLISION_RADIUS = 3

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/cannonball.mdl")
	self:DrawShadow(false)
	-- Initiate cheap physics
	self:PhysicsInitSphere( COLLISION_RADIUS )
	self:SetCollisionBounds( Vector( -COLLISION_RADIUS, -COLLISION_RADIUS, -COLLISION_RADIUS ), Vector( COLLISION_RADIUS, COLLISION_RADIUS, COLLISION_RADIUS ) )
	
	self:SetNotSolid( true )
	if SERVER then self:SetTrigger( true ) end -- This allows it to call Touch() on entities it does not collide with

	self:SetMoveType( MOVETYPE_FLY )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	
	timer.Simple(1,function() if IsValid(self) and SERVER then self:Remove() end end)
	self.MyScale = CurTime()
end

/*---------------------------------------------------------
Explode
---------------------------------------------------------*/
function ENT:OnRemove()
end
	
/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage()
end


function ENT:Think()
	if self.Dead and SERVER then
		local startp = self:GetPos()
       	local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
       	local trace = util.TraceLine(traceinfo)
       	local todecal1 = trace.HitPos + trace.HitNormal
       	local todecal2 = trace.HitPos - trace.HitNormal
        util.Decal("FadingScorch", todecal1, todecal2)
		self:Remove()
	end
	local col = COLLISION_RADIUS + (CurTime()-self.MyScale)*2
	self:SetCollisionBounds( Vector( -col, -col, -col ), Vector( col, col, col ) )
end

function ENT:PhysicsCollide()
    if SERVER then
		self:Explode()
    end
end

function ENT:Touch( entity )
    if SERVER then
		self:Explode(entity)
    end
end

function ENT:Explode( entity )
    if SERVER then
		local col = COLLISION_RADIUS + (CurTime()-self.MyScale)*2
		if entity != self.Owner then
			entity:TakeDamage((1-(col-3)/1.5)/3, self.Owner, self:GetNWEntity("FlamethrowerDamageInflictor"))
			entity:Ignite(5) 
			entity:SetNWFloat("MM_FireDuration", CurTime() + 5)

			entity:SetNWInt("MM_FireDamage", 3)
			entity:SetNWEntity("MM_FireOwner", self.Owner)
			entity:SetNWEntity("MM_FireInflictor", self:GetNWEntity("FlamethrowerDamageInflictor"))
		end
        self.Dead = true
    end
end


// TEST DRAW


if SERVER then return end
function ENT:RenderOverride()
	/*
	local phys = self:GetPhysicsObject()
	local col = COLLISION_RADIUS + (CurTime()-self.MyScale)*38
	local mins = Vector( -col, -col, -col )
	local maxs = Vector( col, col, col )
	local pos = self:GetPos()
	local angle = self:GetAngles()
	render.SetMaterial(Material("models/debug/debugwhite"))
	render.DrawWireframeBox( pos,angle,mins,maxs,Color(255,255,255,255),true)
	*/
end