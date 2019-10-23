AddCSLuaFile( "shared.lua" )
include("shared.lua")

local function simplifyangle(angle)
	while (angle >= 180) do
		angle = angle - 360;
	end

	while (angle <= -180) do
		angle = angle + 360;
	end

	return angle;
end

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/w_pumpkin_nade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	-- Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.MyOwner = self.Owner
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

/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use()
end

function ENT:PhysicsCollide()
    if SERVER then
    self:Explode()
    end
end

function ENT:Explode()
    if SERVER then
        local var = math.random(1,3)
        if var == 1 then
        self:EmitSound(Sound("weapons/pumpkin/pumpkin_explode1.wav"),140)
        elseif var == 2 then
        self:EmitSound(Sound("weapons/pumpkin/pumpkin_explode2.wav"),140)
        elseif var == 3 then
        self:EmitSound(Sound("weapons/pumpkin/pumpkin_explode3.wav"),140)
        end
        local explo = ents.Create("env_explosion")
        explo:SetOwner(self.Owner)
        explo:SetPos(self.Entity:GetPos())
        explo:SetKeyValue("iMagnitude", "100")
        explo:Spawn()
        explo:Activate()
        util.BlastDamage(self.Inflictor, self.Owner, self:GetPos(), 200,175)

        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "HelicopterMegaBomb", effectdata4 )
		
        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "pumpkin_explosion", effectdata4 )
            
        local shake = ents.Create("env_shake")
        shake:SetOwner(self.Owner)
        shake:SetPos(self.Entity:GetPos())
        shake:SetKeyValue("amplitude", "2000")	// Power of the shake
        shake:SetKeyValue("radius", "500")		// Radius of the shake
        shake:SetKeyValue("duration", "2.5")	// Time of shake
        shake:SetKeyValue("frequency", "255")	// How hard should the screenshake be
        shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
        shake:Spawn()
        shake:Activate()
        shake:Fire("StartShake", "", 0)
		
		local startp = self:GetPos()
       	local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = self, mask = MASK_SOLID_BRUSHONLY}
       	local trace = util.TraceLine(traceinfo)
       	local todecal1 = trace.HitPos + trace.HitNormal
       	local todecal2 = trace.HitPos - trace.HitNormal
        util.Decal("Antlion.Splat", todecal1, todecal2)
		
        timer.Simple(0,function() self:Remove() end)
    end
end