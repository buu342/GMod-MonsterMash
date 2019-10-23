AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Sound = ""

function ENT:Initialize()   

	self.Entity:SetModel( "models/props_phx/misc/smallcannonball.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Sound = CreateSound( self, Sound("ambient/fire/fire_small_loop1.wav") )
	self.Sound:Play()
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false) 
	end
	
	self.Entity:SetMaterial("models/effects/comball_tape")   
	
	if SERVER then
		local zfire = ents.Create( "env_fire_trail" )
		zfire:SetPos( self.Entity:GetPos() )
		zfire:SetParent( self.Entity )
		zfire:Spawn()
		zfire:Activate()
	end

end   

function ENT:PhysicsCollide()
	self:Explode()
end

function ENT:Explode()
	util.BlastDamage(self:GetNWEntity("FlamethrowerDamageInflictor"), self.Owner, self.Entity:GetPos(), 256, 35)
	for k, v in pairs( ents.GetAll() ) do
		if v:GetPos():Distance(self:GetPos()) < 128 then
			v:Ignite(5) 
			v:SetNWFloat("MM_FireDuration", CurTime() + 5)

			v:SetNWInt("MM_FireDamage", 3)
			v:SetNWEntity("MM_FireOwner", self.Owner)
			v:SetNWEntity("MM_FireInflictor", self:GetNWEntity("FlamethrowerDamageInflictor"))
		end
	end
	self:EmitSound("ambient/explosions/explode_9.wav",350)
	local effectdata = EffectData()
	effectdata:SetOrigin( self.Entity:GetPos() )
    util.Effect( "Fireball_Explosion", effectdata )
	local effectdata = EffectData()
	effectdata:SetOrigin( self.Entity:GetPos() )
	util.Effect( "HelicopterMegaBomb", effectdata )
	local effectdata = EffectData()
	effectdata:SetOrigin( self.Entity:GetPos() )
	util.Effect( "ManhackSparks", effectdata )
	//if IsValid(self.Sound) then
		self.Sound:Stop()
	//end
	timer.Simple(0,function() if !IsValid(self) then return end self:Remove() end)
end