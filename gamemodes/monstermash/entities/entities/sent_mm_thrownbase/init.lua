AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.Owner = nil
ENT.Inflictor = nil
ENT.Pickup = false
ENT.Mdl = "models/weapons/monstermash/w_skull.mdl"
ENT.ExplodeOnImpact = false
ENT.ExplodeRadius = 128
ENT.Damage = 10
ENT.CreateEntOnRemove = nil
ENT.Arrow = false
ENT.ExplodeSound = nil
ENT.Retrievable = false
ENT.ApplyEffectAlways = false
ENT.ApplyEffectDistance = 0
ENT.ApplyEffectType = 0
ENT.ApplyEffectDuration = 0
ENT.ApplyEffectDistance2 = 0
ENT.ApplyEffectType2 = 0
ENT.ApplyEffectDuration2 = 0
ENT.ThrowAngle = Angle(0,0,0)
ENT.SwooshSound = nil
ENT.CanAffectOwner = false
ENT.Trail = nil
ENT.LightSize = 0
ENT.LightColor = Color(0,0,0)
ENT.LightBrightness = 0
ENT.LightDecay = 0
ENT.OnFire = false
ENT.Gravity = 1
ENT.ContinuousEffect = nil
ENT.LoopSound = nil
ENT.LifeTime = -1
ENT.ActivateTime = 0
ENT.Flare = false
ENT.DamageType = 0
ENT.GibOnContact = true
ENT.NoGravity = false
ENT.DoCollideThing = false
ENT.FireTrail = false
ENT.RemoveOnDamage = false
ENT.Material = ""
ENT.NumBounces = 1
ENT.RemoveBounces = false
ENT.Seeker = false

ENT.BleedChance     = 0
ENT.BurnChance      = 0
ENT.ConcussChance   = 0
ENT.DismemberChance = 0

ENT.StoppedMoving = false
ENT.HitEnt = nil
ENT.HitPosAng = nil
ENT.Exploded = false
ENT.DoDamage = true
ENT.RemoveEnt = 0
ENT.Parented = false
ENT.Force = 0
ENT.LoopSoundEnt = nil
ENT.SpawnTime = 0
ENT.MMSent = true
ENT.Target = nil
ENT.NextTargetTime = 0
ENT.RetargetLerp = 0

local BoneTargets = {
    "ValveBiped.Bip01_Spine4",
    "ValveBiped.Bip01_Head1",
    "ValveBiped.Bip01_Neck1",
    "ValveBiped.Bip01_Spine2",
    "ValveBiped.Bip01_Spine1",
    "ValveBiped.Bip01_Spine",
    "ValveBiped.Bip01_Pelvis",
    "ValveBiped.Bip01",
}

function ENT:SetupDataTables()
end

function ENT:Initialize()
    self:SetModel(self.Mdl)
    self:SetAngles(self:GetAngles()+self.ThrowAngle)
    self:PhysicsInit(SOLID_VPHYSICS)
    if self.Arrow then
        local size = 0.25
        self:SetVelocity(self:GetForward()*self.Force)
		self:SetGravity(self.Gravity)
        self:SetMoveType(MOVETYPE_FLYGRAVITY)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionBounds(Vector(-size, -size, -size), Vector(size, size, size))
    else
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
    self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)
    
    if !self.CanAffectOwner then
        self:SetOwner(self.Owner)
    end
    
    if self.Material != "" then
        self:SetMaterial(self.Material)
    end
    
    if self.FireTrail then
        if SERVER then
            local zfire = ents.Create("env_fire_trail")
            zfire:SetPos(self:GetPos())
            zfire:SetParent(self)
            zfire:Spawn()
            zfire:Activate()
        end
    end
    
    if self.Flare then
        if SERVER then
            local ent = ents.Create("env_flare")
            ent:SetPos(self:GetPos())
            ent:SetParent(self)
            ent:Spawn()
            ent:SetKeyValue("Start", "10")
            ent:SetKeyValue("Scale", "5")
            ent:Activate()
        end
    end
    
    if self.OnFire then
        self:Ignite(6, 0)
    end

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        if self.NoGravity then
            phys:EnableGravity(false) 
        end
        if (self.Seeker) then
            phys:SetVelocity(self.Dir*self.Force)
        end
    end

    if self.LifeTime == -1 then
        self.RemoveEnt = CurTime() + GetConVar("mm_cleanup_time"):GetInt()
    else
        self.RemoveEnt = CurTime() + self.LifeTime
    end
    
    if self.Trail != nil then
        local trail = util.SpriteTrail(self, 0, Color(255, 255, 255), true, 5, 0, 1, 1 / (5 + 0) * 0.5, self.Trail)
    end
    
    if (self.LoopSound != nil) then
        self.LoopSoundEnt = CreateSound(self, self.LoopSound) 
        if self.LoopSoundEnt then
            self.LoopSoundEnt:SetSoundLevel(65) 
            self.LoopSoundEnt:Play()
        end
    end
    self.SpawnTime = CurTime()
    
    timer.Simple(0, function() if !IsValid(self) then return end self:SetOwner(nil) end)
end

function ENT:OnRemove()
    self:DoRemoveStuff()
    if self.LoopSound != nil then
        self.LoopSoundEnt:Stop() 
    end
end

function ENT:DoRemoveStuff()
end
	
function ENT:Think()
    if (self.SwooshSound != nil) then
        if (type(self.SwooshSound) == "table") then
            soundfx = CreateSound(self, table.Random(self.SwooshSound))
        else
            soundfx = CreateSound(self, self.SwooshSound)
        end
        if (self.DoDamage == true) then
            for k, v in pairs(player.GetAll()) do
                if (v:GetPos():Distance(self:GetPos()) < 128) then
                    soundfx:SetSoundLevel(60)
                    soundfx:Play()
                end
            end
        end
    end
    
    if (self.Seeker) then
        local phys = self:GetPhysicsObject()
        
        if (self.Target != nil && IsValid(self.Target) && (self.Target:IsNPC() || (self.Target:IsPlayer() && self.Target:Alive() && self.Target:CanBeDamagedBy(self.Owner)))) then
            local targetpos = self.Target:GetPos()+Vector(0,0,10)
            local found = false

            for k, v in pairs(BoneTargets) do
                if (self.Target:LookupBone(v) != nil) then
                    targetpos = self.Target:GetBonePosition(self.Target:LookupBone(v))
                    found = true
                    break
                end
            end            
    
            local dir = targetpos-self:GetPos()
            dir:Normalize()
            phys:SetVelocity(LerpVector(1-math.max(0, self.RetargetLerp-CurTime()), self.Dir, dir)*self.Force)
        else
            phys:SetVelocity(self.Dir*self.Force)
            if (self.NextTargetTime < CurTime()) then
                if (self.Target == nil || !(self.Target:IsPlayer() || self.Target:IsNPC())) then
                    for k, v in pairs(ents.FindInSphere(self:GetPos(), 192)) do
                        if ((v:IsPlayer() || v:IsNPC()) && v != self.Owner) then
                            self.Target = v
                            break
                        end
                    end
                end
                self.NextTargetTime = CurTime() + 0.7
                self.RetargetLerp = CurTime() + 1
            end
        end
    end
    
    if self.StoppedMoving && !self.Parented then
        if self.HitEnt != nil && !self.HitEnt:IsWorld() then
            self:SetParent(self.HitEnt)
        else
            self:SetPos(self.HitPosAng[1])
            self:SetAngles(self.HitPosAng[2])
            self.RemoveEnt = CurTime() + self.LifeTime
        end
        self.Parented = true
    end
    
    if self.ApplyEffectAlways then
        self:ApplyStatusRadius()
    end
    
    if self.Exploded || (self.RemoveEnt != 0 && self.RemoveEnt < CurTime()) then
        self:Remove()
    end
    
    self:NextThink(CurTime()) return true
end

if (SERVER) then
	function ENT:Use(_, pCaller)
		if (self.Retrievable && pCaller:IsPlayer() && pCaller:GetWeaponCooldown(self.Inflictor) > 0) then
			pCaller:SetWeaponCooldown(self.Inflictor, 0)
			self.Entity:Remove()
		end
	end
end

function ENT:Touch(ent)
    if self.StoppedMoving then return end
    if ent:GetClass() == "trigger_soundscape" then return end
    if ent:GetClass() == "prop_ragdoll" then return end
    if ent:IsWeapon() then return end
    
    local data = {HitEntity = ent}
    if ent == self.Owner && !self.CanAffectOwner then return end
    self:PhysicsCollide(data, self:GetPhysicsObject())
end

function ENT:PhysicsCollide(data, phys)
    if data.HitEntity:GetClass() == "trigger_soundscape" then return end
    if data.HitEntity:GetClass() == "prop_ragdoll" then return end
    if data.HitEntity:IsWeapon() then return end

    if self.ExplodeOnImpact && !self.Exploded then
        self.Exploded = true
        
        if (self.ExplodeSound != nil) then
            if type(self.ExplodeSound) == "table" then 
                local snd = table.Random(self.ExplodeSound)
                self:EmitSound(snd, 140)
            else
                self:EmitSound(self.ExplodeSound, 140)
            end
        end
        
        self:ExplodeEffect()
        
        if self.ApplyEffectType != 0 && !self.ApplyEffectAlways then
            self:ApplyStatusRadius()
        end
        
        if self.Damage != 0 then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(self.Damage)
            dmginfo:SetAttacker(self.Owner)
            if self.Inflictor != nil then
                dmginfo:SetInflictor(self.Inflictor)
            end
            if self.DamageType != 0 then
                dmginfo:SetDamageType(self.DamageType)
            end
            if data.HitEntity:IsPlayer() && self.GibOnContact && data.HitEntity:Health()-self.Damage <= 0 then
                data.HitEntity:SetKillFlag(KILL_GIB)
            end
            if data.HitEntity:IsPlayer() && data.HitEntity:IsDodgeRolling() && SERVER then
                data.HitEntity:GiveTreat("dodged_explosion")
            end
            util.BlastDamageInfo(dmginfo, self:GetPos(), self.ExplodeRadius)
            if (self.RemoveOnDamage) then
                self.Exploded = true
            end
        end
        
        if self.CreateEntOnRemove != nil then
            local d = data
            if data.HitEntity:IsPlayer() then
                if data.HitEntity:IsOnGround() then
                    d = util.TraceLine({
                        start = data.HitEntity:GetPos(),
                        endpos = data.HitEntity:GetPos() - Vector(0,0,100),
                        filter = function(ent) 
                            if (ent:IsPlayer()) then 
                                return true 
                            end 
                        end
                    })
                else
                    d = nil
                end
            end
            
            if d != nil && d.HitNormal != nil && math.floor(d.HitNormal:Angle().p) != 0 then
                local ent = ents.Create(self.CreateEntOnRemove)
                ent:SetPos(d.HitPos+Vector(0,0,1))
                ent:SetAngles(d.HitNormal:Angle())
                ent:Spawn()
                ent.Owner = self.Owner
                ent.Inflictor = self.Inflictor
            end
        end
    elseif self.DoSomethingCollide && self.DoDamage then
        self:DoCollideThing(data, phys)
        self.DoDamage = false
    elseif self.DoDamage then
        
        self:ExplodeExtra(data, phys)
        
        if ((data.HitEntity:IsPlayer() && data.HitEntity:CanBeDamagedBy(self.Owner)) || data.HitEntity.IsMMNPC) then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(self.Damage)
            dmginfo:SetAttacker(self.Owner)
            dmginfo:SetInflictor(self.Inflictor)
            if (self.DismemberChance >= math.random(1, 100)) then
                dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_MISSINGLIMB))
            end
            if (self.ConcussChance >= math.random(1, 100)) then
                dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_CONCUSS))
            end
            if (self.BleedChance >= math.random(1, 100)) then
                dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_BLEED))
            end
            if self.BurnChance >= math.random(1, 100) then
                data.HitEntity:SetStatusEffect(STATUS_ONFIRE, dmginfo, 6)
            end
            if self.DamageType != 0 then
                dmginfo:SetDamageType(self.DamageType)
            else
                dmginfo:SetDamageType(DMG_BLAST)
            end
            if (!data.HitEntity:IsPlayer() || data.HitEntity:CanBeDamagedBy(self.Owner)) then
                data.HitEntity:TakeDamageInfo(dmginfo)
            end
            if (self.RemoveOnDamage) then
                self.Exploded = true
            end
            self.DoDamage = false
        end
        
        if self.Arrow then
            self.StoppedMoving = true
            phys:Wake()  
            phys:EnableGravity(false) 
            self:SetMoveType(MOVETYPE_NONE)
            self:PhysicsInit(SOLID_NONE)
            self.HitEnt = data.HitEntity
            self.HitPosAng = {self:GetPos(), self:GetAngles()}
        end
        
        if (self.ExplodeSound != nil) then
            if type(self.ExplodeSound) == "table" then 
                local snd = table.Random(self.ExplodeSound)
                self:EmitSound(snd, 140)
            else
                self:EmitSound(self.ExplodeSound, 140)
            end
        end
        
        if (!self.RemoveBounces) then
            self.DoDamage = false
        end
    end
    
    if (self.RemoveBounces) then
        self.NumBounces = self.NumBounces - 1
        if (self.NumBounces == 0) then
            self.Exploded = true
            self:ExplodeEffect()
        end
    end
end

function ENT:ApplyStatusRadius()
    if self.ActivateTime+self.SpawnTime > CurTime() then return end
    for k, v in pairs(player.GetAll()) do
        if v:Alive() then
            local damagable = ((self.CanAffectOwner || (!self.CanAffectOwner && v != self.Owner)) && self:VisibleVec(v:GetPos()+Vector(0,0,50)) && v:CanBeDamagedBy(self.Owner))
            if v:GetPos():Distance(self:GetPos()) <= self.ApplyEffectDistance && damagable then 
                local dmginfo = DamageInfo()
                if self.Owner != nil && IsValid(self.Owner) then
                    dmginfo:SetAttacker(self.Owner)
                end
                if self.Inflictor != nil && IsValid(self.Inflictor) then
                    dmginfo:SetInflictor(self.Inflictor)
                end
                v:SetStatusEffect(self.ApplyEffectType, dmginfo, self.ApplyEffectDuration)
            elseif v:GetPos():Distance(self:GetPos()) <= self.ApplyEffectDistance2 && damagable then
                local dmginfo = DamageInfo()
                if self.Owner != nil && IsValid(self.Owner) then
                    dmginfo:SetAttacker(self.Owner)
                end
                if self.Inflictor != nil && IsValid(self.Inflictor) then
                    dmginfo:SetInflictor(self.Inflictor)
                end
                v:SetStatusEffect(self.ApplyEffectType2, dmginfo, self.ApplyEffectDuration2)
            end
        end
    end
end

function ENT:ExplodeEffect()

end

function ENT:DoCollideThing(data, phys)

end

function ENT:ExplodeExtra(data, phys)

end