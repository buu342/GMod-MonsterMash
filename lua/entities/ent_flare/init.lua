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
    
    if SERVER then
        local ent = ents.Create("env_flare")
        ent:SetPos(self:GetPos())
        ent:SetParent(self)
        ent:Spawn()
        ent:SetKeyValue("Start", "10")
        ent:SetKeyValue("Scale", "5")
        ent:Activate()
    end
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.MyOwner = self.Owner
    self.Hit = false
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

function ENT:Think()
    if self.Hit then
        self:Remove()
    end
end

function ENT:PhysicsCollide()
    if SERVER && !self.Hit then
        self:Explode()
    end
end

function ENT:Explode()
    if SERVER then
        self:EmitSound("ambient/explosions/explode_9.wav",350)
        local explo = ents.Create("env_explosion")
        explo:SetOwner(self.Owner)
        explo:SetPos(self.Entity:GetPos())
        explo:SetKeyValue("iMagnitude", "100")
        explo:Spawn()
        explo:Activate()
        util.BlastDamage(self.Inflictor, self.Owner, self:GetPos(), 192,35)

        for k, v in pairs(player.GetAll()) do
            if v:GetPos():Distance(self:GetPos()) < 196 && self:Visible(v) && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() then
                if !v:HasGodMode() then
                    v:SetNWFloat("MM_FireDuration", CurTime() + 6)
                    v:Ignite(6)
                    v:SetNWInt("MM_FireDamage", 3)
                    v:SetNWEntity("MM_FireOwner", self.Owner)
                    v:SetNWEntity("MM_FireInflictor", self.Inflictor)
                end
            end
        end

        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "flare_explosion", effectdata4 )        
        
        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "HelicopterMegaBomb", effectdata4 )
            
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
        util.Decal("Scorch", todecal1, todecal2)
        
        self.Hit = true
    end
end