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

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true) 
	end
	
	self.MyOwner = self.Owner
    self:SetOwner(self.MyOwner)
    self.Hit = false
    self.OldPos = self:GetPos()
    self:NextThink(CurTime())
end

function ENT:Think()
    local times = 4
    for i=0, times do
        local pos = LerpVector(i/times, self.OldPos, self:GetPos())
        local effectdata4 = EffectData()
        effectdata4:SetStart( pos ) 
        effectdata4:SetOrigin( pos )
        effectdata4:SetScale( 1 )
        util.Effect( "magic_staff", effectdata4 )
    end

    if CLIENT then
        local dlight = DynamicLight( self:EntIndex() )
        if ( dlight ) then
            local r, g, b, a = self:GetColor()
            dlight.Pos = self:GetPos()
            dlight.r = 181
            dlight.g = 230
            dlight.b = 29
            dlight.brightness = 2
            dlight.Decay = 512
            dlight.Size = 160
            dlight.DieTime = CurTime() + 1
        end  
    end

    self.OldPos = self:GetPos()
    self:NextThink(CurTime()) return true
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

function ENT:Touch( ent )
    self:Explode(ent)
end

function ENT:PhysicsCollide(data)
    if SERVER  then
        timer.Simple(0,function() self:Remove() end)
    end
end

function ENT:Explode(ent)
    if ent:GetClass() == "trigger_soundscape" then return end
    if self.Hit then return end
    if SERVER then
    
        local dmginfo = DamageInfo()
        dmginfo:SetDamage(60)
        dmginfo:SetAttacker(self.MyOwner)
        dmginfo:SetInflictor(self.Inflictor)
        dmginfo:SetDamageType(DMG_DISSOLVE)
        ent:TakeDamageInfo(dmginfo)
		
        local effectdata4 = EffectData()
        effectdata4:SetStart( self:GetPos() ) 
        effectdata4:SetOrigin( self:GetPos() )
        effectdata4:SetScale( 1 )
        util.Effect( "magic_explosion", effectdata4 )
        
        self.Hit = true
            
        self:Remove()
            
    end
end

