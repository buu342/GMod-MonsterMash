AddCSLuaFile( "shared.lua" )
include("shared.lua")

ENT.Type = "anim"
ENT.Name = "Spidernade"
ENT.PrintName = "Spidernade"

ENT.ChangeNumb			= true
ENT.BeforeExplode = 0
/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/monstermash/w_webgrenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	if (SERVER) then
		self:SetUseType(SIMPLE_USE)
	end
	self.Entity:DrawShadow( false )
	local phys = self.Entity:GetPhysicsObject()
	self.exploded = false
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.MyOwner = self.Owner
	self:SetNWBool("HitAlready",false)
	
	self.RemoveEnt = CurTime() + GetConVar( "mm_cleanup_time" ):GetInt()
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
if (SERVER) then
	function ENT:Use(_, pCaller)
		if (pCaller:IsPlayer() && pCaller:HasWeapon("mm_spidernade") == false) then
			pCaller:Give("mm_spidernade")
			self.Entity:Remove()
		end
	end
end

function ENT:Think()
	if self:IsValid() then
		self.Owner = nil
		self:SetOwner(nil)
	end
	if self.RemoveEnt and CurTime()>self.RemoveEnt then self:Remove() end
	self:NextThink(CurTime()) return true
end

function ENT:PhysicsCollide(data)
    if SERVER && self.RemoveEnt != 1 then
        if data.HitEntity:IsWorld() then
            local ent = ents.Create("ent_web")
            ent:SetPos(data.HitPos)
            ent:SetAngles(data.HitNormal:Angle())
            ent.Owner = self.Owner
            ent:Spawn()
            ent:SetNWEntity("Sticky_Attacker", self:GetNWEntity("Sticky_Attacker" ))
            ent:SetNWEntity("Sticky_Inflictor", self:GetNWEntity("Sticky_Inflictor" ) )
        end
        
        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "spidernade_explosion", effectdata4 )
        
        for k, v in pairs(player.GetAll()) do
			if v:GetPos():Distance(self:GetPos()) < 128 && self:Visible(v)  then
				if !v:HasGodMode() then
                    if v:IsValid() && v:IsPlayer() && self:GetNWBool("HitAlready") == false && v:GetNWFloat("DivingRight") < CurTime() && v:GetNWFloat("DivingLeft") < CurTime()  then
                        local damage = 35
                        v:SetNWFloat("Sticky",CurTime()+4)
                        v:SetNWEntity("Sticky_Attacker", self:GetNWEntity("Sticky_Attacker" ))
                        v:SetNWEntity("Sticky_Inflictor", self:GetNWEntity("Sticky_Inflictor" ) )
                    end
				end
			end
		end
        self:EmitSound("weapons/webgrenade/agrub_squish1.wav")
        self.RemoveEnt = 1
    end
end


util.AddNetworkString("MMGiveSNade")
function MMGiveSNade(len,client)
	if IsValid(client) then
		local ent = net.ReadEntity()
        ent:Give("mm_spidernade",false)
		ent:GiveAmmo(1,"strider",false)
	end
end
net.Receive("MMGiveSNade", MMGiveSNade)