
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0.25
ENT.Parenty = 0
ENT.OrgAngle = Angle(0,0,0)
soundfx = 0
util.PrecacheSound("Weapon_Arrow.ImpactFlesh")
util.PrecacheSound("Weapon_Arrow.ImpactMetal")
util.PrecacheSound("Weapon_Arrow.ImpactWood")
util.PrecacheSound("Weapon_Arrow.ImpactConcrete")

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.OrgAngle = self.Entity:GetAngles()
	//util.SpriteTrail(self, 0, Color(255,190,190,200), false, 0, 0.7, 0.8, 0/(0.7+0)*0.5, "Effects/arrowtrail_red.vmt")
	self:SetModel("models/weapons/monstermash/arrow.mdl")
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	self.NotStuck = true

	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetNetworkedString("Owner", "World")
	self.RemoveArrow = CurTime() + GetConVar( "mm_cleanup_time" ):GetInt()
	if self.ArrowType == 1 then
		self.Entity:Ignite(100, 20)
	end
end

local exp

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
	
	soundfx = CreateSound( self, Sound("weapons/fx/nearmiss/bulletltor04.wav") )
	if self.NotStuck == true then
		for k, v in pairs( player.GetAll() ) do
			if v:GetPos():Distance(self:GetPos()) < 128 then
				soundfx:Play()
			end
		end
	end
	
	if self.Parenty == 1 then
		if IsValid(self:GetParent()) && self:GetParent():IsPlayer() && !self:GetParent():Alive() then
		self:GetParent():Extinguish()
		self.Entity:Remove()
		end
	end
	
	if self.RemoveArrow and CurTime()>self.RemoveArrow then self:Remove() end
	if self.NotStuck then self:SetAngles(self:GetVelocity():Angle()) end
	self:NextThink(CurTime()) return true
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )
    if ent:GetClass() == "trigger_soundscape" then return end
	local speed = self:GetVelocity():Length( )
	
	if ent:IsNPC() or ent:IsPlayer() then
		if (SERVER) then
			ParticleEffect( "blood_impact_red_01", self:GetPos() - self:GetForward()*4, (self:GetAngles() + Angle(0,0,0)), nil)
		end
	end
	
	if ent:IsNPC() or ent:IsPlayer() or ent:IsWorld() or ent:IsVehicle() or ent:IsValid() then

		if speed < 150 then

			local damage = speed * 0

			if speed >= 150 then
				self.NotStuck = false
				self:SetMoveType( MOVETYPE_NONE )
				self:PhysicsInit( SOLID_NONE )
				self:SetParent(ent)
				local damage = speed * 0.03
				ent:TakeDamage(damage , self.Owner, self.Inflictor)
				ent:EmitSound("weapons/fx/rics/arrow_impact_flesh"..math.random(2,4)..".wav")
				if self.ArrowType == 1 then
					ent:Ignite( math.Rand( 5, 6 ), 0 )
					ent:Fire( "IgniteLifeTime", math.Rand( 10, 12 ), 0 )
				elseif self.ArrowType == 2 then
					local effectdata = EffectData()
					effectdata:SetOrigin(self.Entity:GetPos())
					util.Effect( "Explosion", effectdata )
					util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 125, 125)
					self:Remove()
				end
				self:Remove()
			end
			return false 
        end
        if ent:IsWorld() then
            self.NotStuck = false
            self:SetMoveType( MOVETYPE_NONE )
            self:PhysicsInit( SOLID_NONE )
            self:EmitSound("weapons/crossbow/hitbod"..tostring(math.random(1,2))..".wav")
            self:SetPos(self:GetPos() + self:GetForward()*0)
        else
            if ent:IsValid() && ent:GetNWFloat("DivingRight") < CurTime() && ent:GetNWFloat("DivingLeft") < CurTime() then
                self.NotStuck = false
                self:SetMoveType( MOVETYPE_NONE )
                self:PhysicsInit( SOLID_NONE )
                self:SetParent(ent)
                local damageprop = speed * 0.015
                ent:TakeDamage(damageprop , self.Owner, self.Inflictor)
                local physforce = speed * 8
                local phy = ent:GetPhysicsObject()
                self.RemoveArrow = CurTime() + 20
                self:EmitSound("weapons/crossbow/hitbod"..tostring(math.random(1,2))..".wav")
					
				self:SetPos(self:GetPos() + self:GetForward()*2)
			end
		end
	end
	if ent:IsPlayer() then
		self.Parenty = 1
	elseif ent:IsNPC() then
		self.Parenty = 2
	end
end

function ENT:PhysicsCollide( data, phys )
	if data.HitEntity:IsWorld() then
		phys:Wake()  
		phys:EnableGravity(false) 
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
	end
end