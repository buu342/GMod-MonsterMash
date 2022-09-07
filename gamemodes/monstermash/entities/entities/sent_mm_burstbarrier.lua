AddCSLuaFile()
DEFINE_BASECLASS("sent_mm_thrownbase")

ENT.Type = "anim"
ENT.Base = "sent_mm_thrownbase"
ENT.Mdl = "models/weapons/monstermash/thrown_pumpkin.mdl"

ENT.DamageType = DMG_SONIC

ENT.LightSize = 256
ENT.LightColor = Color(0, 125, 255)
ENT.LightBrightness = 3
ENT.LightDecay = 2048
ENT.LightTime = 0.25

ENT.PushList = {}

function ENT:Initialize() 
	self.Entity:SetModel("models/XQM/Rails/gumball_1.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
    self:SetNoDraw(true)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true) 
	end
	
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("mm_burstball", effectdata4)
    
    if SERVER then
        timer.Simple(0.5, function() if IsValid(self) then self:Remove() end end)
    end
end

function ENT:Think()
    if SERVER then
        for k, v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
            local ent = v
            local entlist = {
                "sent_mm_acidflask",
                "sent_mm_arrow",
                "sent_mm_arrowfire",
                "sent_mm_cannonball",
                "sent_mm_cleaver",
                "sent_mm_fireball",
                "sent_mm_flare",
                "sent_mm_gorejar",
                "sent_mm_pumpkinnade",
                "sent_mm_hallucinationnade",
                "sent_mm_sawblade",
                "sent_mm_skull",
                "sent_mm_spidernade",
                "sent_mm_toiletpaper",
                "sent_mm_seeker",
                "sent_mm_urn",
                "sent_mm_wandball"
            }
            if table.HasValue(entlist, ent:GetClass()) then
                local pos = ent:GetPos()
                local effectdata = EffectData()
                effectdata:SetStart(pos) 
                effectdata:SetOrigin(pos)
                effectdata:SetScale(1)
                util.Effect("ManhackSparks", effectdata)
                ent:Remove()
            end
            
            if v != self.Owner && (v.IsMMNPC || self.Owner:VisibleVec(v:GetPos()+Vector(0, 0, 10))) && !table.HasValue(self.PushList, v) && (!v:IsPlayer() || v:CanBeDamagedBy(self.Owner)) then
                local damage = DamageInfo()
                if (v:GetClass() == "sent_mm_skellington") then
                    damage:SetDamage(1337)
                else
                    damage:SetDamage(25)
                end
                damage:SetAttacker(self.Owner)
                damage:SetInflictor(self.Inflictor)
                if (v:IsPlayer() && v:Health() - 25 <= 0) then
                    v:SetKillFlag(KILL_FURY)
                elseif (!v:IsPlayer()) then
                    damage:SetDamageType(DMG_DISSOLVE)
                end
                v:TakeDamageInfo(damage)
                if (!v:IsPlayer() || (v:IsPlayer() && v != self.Owner)) then
                    if (v:IsPlayer()) then
                        v:SetStatusEffect(STATUS_ONFIRE, damage, 6)
                    end
                end
                local phys = v:GetPhysicsObject()
                if (IsValid(phys)) then
                    local dir = (v:GetPos()-self.Owner:GetPos()):Angle():Forward()
                    dir:Normalize()
                    if v:OnGround() then
                        v:SetVelocity(dir*2500)
                    else
                        v:SetVelocity(dir*2500/4)
                    end
                end
                table.insert(self.PushList, v)
            end
        end
    end
    self:NextThink(CurTime()) return true
end