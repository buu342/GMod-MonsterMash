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

	self.Entity:SetModel("models/weapons/monstermash/w_gorejar.mdl")
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

function ENT:PhysicsCollide()
    if SERVER then
    self:Explode()
    end
end

function ENT:Explode()
    if SERVER then

        self:EmitSound(Sound("physics/glass/glass_largesheet_break3.wav"))
            
		for i=0,10 do
			local vPoint = self:GetPos()+Vector(0,0,60)
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect("bloodstream",effectdata)
		end
		local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "gorejar_explosion", effectdata4 )
		
		local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "gibs", effectdata4 )
            
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
			if v:GetPos():Distance(self:GetPos()) < 256 then
				if v != self.Owner && !v:HasGodMode() && v:Alive() && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() then
					v:SetNWFloat("Bloodied",CurTime()+7.5)
					timer.Create("BloodTrail",0.1,75,function()
						local start = v:GetPos()
						local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
						util.Decal("Blood", btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal,v)
					end)
				end
			end
		end
		
        timer.Simple(0,function() self:Remove() end)
    end
end