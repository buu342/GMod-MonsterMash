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

	self.Entity:SetModel("models/weapons/monstermash/w_acid_flask.mdl")
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

function ENT:PhysicsCollide(data)
    if SERVER then
		self:Explode(data)
    end
end

function ENT:Explode(data)
    if SERVER then

        self:EmitSound(Sound("physics/glass/glass_largesheet_break3.wav"))
        self:EmitSound(Sound("ambient/levels/canals/toxic_slime_sizzle4.wav"))
        
        if math.floor(data.HitNormal:Angle().p) != 0 then
            local ent = ents.Create("ent_acid")
            ent:SetPos(data.HitPos)
            ent:SetAngles(data.HitNormal:Angle())
            ent.Owner = self.Owner
            ent:Spawn()
            ent:SetNWEntity("Acid_Inflictor",self:GetNWEntity("Acid_Inflictor"))
            ent:SetNWEntity("Acid_Attacker",self:GetNWEntity("Acid_Attacker"))
        end
        
		local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "acidflask_explosion", effectdata4 )
            
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
		
		for k, v in pairs(player.GetAll()) do
			if v:GetPos():Distance(self:GetPos()) < 256 && self:Visible(v)  then
				if !v:HasGodMode() then
					v:SetNWFloat("Acidied",CurTime()+7.5)
                    if v:GetPos():Distance(self:GetPos()) <= 48  then
                        v:SetNWInt("MM_AcidDamage", 9)
                    else
                        v:SetNWInt("MM_AcidDamage", 5)
                    end
					v:SetNWEntity("MM_AcidOwner", self:GetNWEntity("Acid_Attacker"))
					v:SetNWEntity("MM_AcidInflictor", self:GetNWEntity("Acid_Inflictor"))
				end
			end
		end
		
        timer.Simple(0,function() self:Remove() end)
    end
end