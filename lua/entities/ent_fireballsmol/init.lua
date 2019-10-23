AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.MySound = ""

function ENT:Initialize()   

	self.Entity:SetModel("models/props_junk/watermelon01.mdl") 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
    self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	
	self.MySound = CreateSound( self, Sound("ambient/fire/fire_small_loop1.wav") )
	self.MySound:Play()
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false) 
	end
	
	self.Entity:SetMaterial("models/effects/vol_light001")   
	
	if SERVER then
		local zfire = ents.Create( "env_fire_trail" )
		zfire:SetPos( self.Entity:GetPos() )
		zfire:SetParent( self.Entity )
		zfire:Spawn()
		zfire:Activate()
	end

    timer.Simple(0.3, function() if !IsValid(self) then return end self.MySound:Stop() self:Remove() end)
end   

function ENT:PhysicsCollide(data, phys)
	self:Explode(data)
end

function ENT:Explode(data)
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(3)
    dmginfo:SetAttacker(self.Own)
    dmginfo:SetInflictor(self:GetNWEntity("FlamethrowerDamageInflictor"))
    data.HitEntity:TakeDamageInfo(dmginfo)
    
    data.HitEntity:Ignite(5) 
    data.HitEntity:SetNWFloat("MM_FireDuration", CurTime() + 5)

    data.HitEntity:SetNWInt("MM_FireDamage", 2)
    data.HitEntity:SetNWEntity("MM_FireOwner", self.Owner)
    data.HitEntity:SetNWEntity("MM_FireInflictor", self:GetNWEntity("FlamethrowerDamageInflictor"))
    
    self:SetVelocity(Vector(0,0,0))
    print(data.HitEntity:GetVelocity())
    
	//self:EmitSound("ambient/explosions/explode_9.wav",350)
	timer.Simple(0,function() if !IsValid(self) then return end self.MySound:Stop() self:Remove() end)
end