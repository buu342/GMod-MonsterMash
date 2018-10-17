AddCSLuaFile( "shared.lua" )
include("shared.lua")

ENT.Type = "anim"
ENT.Name = "Skull"
ENT.PrintName = "Skull"

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

    self.Entity:SetModel("models/props_junk/metal_paintcan001a.mdl")
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	self.Entity:DrawShadow( false )
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
    self.CanDamage = CurTime()+1
	self.MyOwner = self.Owner
	self.Entity:SetModel("models/Items/Flare.mdl")
	self.RemoveEnt = CurTime() + 20
    self.LoopSound = CreateSound( self, "weapons/flaregun/burn.wav" ) 
    if self.LoopSound then
        self.LoopSound:SetSoundLevel( 65 ) 
        self.LoopSound:Play()
    end
end

/*---------------------------------------------------------
Explode
---------------------------------------------------------*/
function ENT:OnRemove()
    if self.LoopSound then self.LoopSound:Stop() end
end
	
/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage()
end


/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )
end

function ENT:Think()
    local phys = self:GetPhysicsObject()
	//if IsValid(phys) && phys:GetVelocity():Length() < 10 then
        local effectdata2 = EffectData()
		effectdata2:SetOrigin( self:GetPos() )
		util.Effect( "smoke_single", effectdata2 )
    //end
    if self.CanDamage < CurTime() then
        for k, v in pairs(player.GetAll()) do
            if v:GetPos():Distance(self:GetPos()) < 128 && self:Visible(v) && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime() then
                if !v:HasGodMode() then
                    v:SetNWFloat("MM_FireDuration", CurTime() + 1)

                    v:SetNWInt("MM_FireDamage", 3)
                    v:SetNWEntity("MM_FireOwner", self.Owner)
                    v:SetNWEntity("MM_FireInflictor", self:GetNWEntity("FlamethrowerDamageInflictor"))
                end
            end
        end
    end
    if self.RemoveEnt and CurTime()>self.RemoveEnt then if self.LoopSound then self.LoopSound:Stop() end self:Remove() end
	self:NextThink(CurTime()) return true
end