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

	self.Entity:SetModel("models/weapons/monstermash/w_urn.mdl")
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
            
		local effectdata2 = EffectData()
		effectdata2:SetOrigin( self:GetPos() )
		util.Effect( "urn_explosion", effectdata2 )
            
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
				if v != self.Owner && !v:HasGodMode() && v:Alive() && v:Visible() && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() then
					if v:GetInfoNum( "mm_pussymode", 0 ) == 1 then
						v:ConCommand("play gameplay/halloween_boo1.mp3")
					else
						local chance = math.random(1,4)
						v:SetNWInt("SpookType",chance)
						if chance == 1 then
							v:ConCommand("play death/creeper.wav")
						else
							v:ConCommand("play npc/stalker/go_alert2a.wav")
						end
					end
					v:SetNWFloat("Spooked",CurTime()+2.5)
                    v:SetNWFloat("MM_Assister", self.Owner)
                    v:SetNWEntity("MM_AssisterInflictor", self:GetNWEntity("MM_HauntedUrnInflictor"))
                    timer.Simple(2.5, function() if !IsValid(v) then return end v:SetNWEntity("MM_Assister", NULL) v:SetNWString("MM_AssisterInflictor", "suicide") end)
				end
			end
		end
		
        timer.Simple(0,function() self:Remove() end)
    end
end