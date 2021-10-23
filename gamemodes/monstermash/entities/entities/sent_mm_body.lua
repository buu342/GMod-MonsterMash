AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Decapitated = false
ENT.RagdollTime = 0
ENT.BloodType = 0
ENT.Electrocuted = false
ENT.Acided = false
ENT.Ignited = false
ENT.Character = nil
ENT.Ply = nil

ENT.ZOrigin = 30
 
function ENT:Initialize()
 
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE ) 
    self:SetSolid( SOLID_VPHYSICS )   

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableGravity( true )
    end
    
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
    if self.Decapitated == true then
        if self.BloodType == BLOODTYPE_NORMAL then
            local attachment = self:LookupBone("ValveBiped.Bip01_Head1")
            local position, angles = self:GetBonePosition( attachment )
            local effectdata = EffectData()
            effectdata:SetOrigin( position )
            effectdata:SetAngles( angles )
            effectdata:SetFlags( 3 )
            effectdata:SetScale( 4 )
            effectdata:SetColor( 0 )
            util.Effect( "bloodspray", effectdata )
        end
        self:SetBodygroup(1, self:GetBodygroup( 1 ))
    end
    
    if self.RagdollTime != 0 then
        self:SetPlaybackRate(1)
        self:NextThink(CurTime())
    end
    
    if SERVER && self.RagdollTime < CurTime() then
        local ent = ents.Create("prop_ragdoll")
        ent:SetPos(self:GetPos()+Vector(0,0,10))
        ent:SetAngles(self:GetAngles())
        if self.Electrocuted || self.Acided then
            ent:SetModel(self.Character.gib_skeleton)
        else
            ent:SetModel(self:GetModel())
        end
        ent:SetSkin(self:GetSkin())
        if !self.Electrocuted then
            ent:SetMaterial(self:GetMaterial())
        end
        ent:Spawn()
		ent:Activate()
        ent:SetBodygroup(GIBGROUP_HEAD, self:GetBodygroup( GIBGROUP_HEAD ))
		ent:SetBodygroup(GIBGROUP_ARMS, self:GetBodygroup( GIBGROUP_ARMS ))
		ent:SetBodygroup(GIBGROUP_LEGS, self:GetBodygroup( GIBGROUP_LEGS ))
		ent:SetBodygroup(GIBGROUP_STAKE, self:GetBodygroup( GIBGROUP_STAKE ))
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
        if self.Electrocuted then
            timer.Create(tostring(ent), 0.1, 40, function()
                if !IsValid(ent) then return end
                local attachment = ent:LookupBone("ValveBiped.Bip01_Spine2")
                local position, angles = ent:GetBonePosition( attachment )
                local effectdata = EffectData()
                effectdata:SetOrigin( position )
                util.Effect( "corpse_smoke", effectdata )
            end)
        end
        if self.Ignited then
            timer.Create("CorpseSmoke"..tostring(ent), 0.1, 120, function()
                if !IsValid(ent) then return end
                local attachment = ent:LookupBone("ValveBiped.Bip01_Spine2")
                local position, angles = ent:GetBonePosition( attachment )
                local effectdata = EffectData()
                effectdata:SetOrigin( position )
                util.Effect( "mm_corpse_smoke", effectdata )
            end)
        end
        timer.Simple(10,function() if IsValid(ent) then ent:Remove() end end)
        if not ent:IsValid() then return end
        local plyvel = self:GetVelocity()
       
        if self.Ply != nil && !self.Ply:Alive() then
            self.Ply:SpectateEntity(ent)
            self.Ply:Spectate(OBS_MODE_CHASE)
        end
       
        for i = 0, ent:GetPhysicsObjectCount()-1 do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = self:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
            end
        end
        
        self:Remove()
    end
    return true;
end

function ENT:Draw()
    if self:GetNWFloat("Melting")-1 > CurTime() then
        local scale = Vector(1+(1-(self:GetNWFloat("Melting")-1-CurTime())/2),1+(1-(self:GetNWFloat("Melting")-1-CurTime())/2),(self:GetNWFloat("Melting")-1-CurTime())/2)
        local matrix = Matrix()
        matrix:Scale(scale)
        self:EnableMatrix("RenderMultiply",matrix)
        self:DrawModel()
    elseif (self:GetNWFloat("Melting") != 0) then
        local scale = Vector(((self:GetNWFloat("Melting")-CurTime()))*2,((self:GetNWFloat("Melting")-CurTime()))*2,0)
        local matrix = Matrix()
        matrix:Scale(scale)
        self:EnableMatrix("RenderMultiply",matrix)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:DrawModel()
    elseif (self:GetNWFloat("Melting") == 0) then
        self:DrawModel()
    end
end