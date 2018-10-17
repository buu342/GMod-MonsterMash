AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.DoBlood = false
 
function ENT:Initialize()
 
    self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
    self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
    self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
    //print(self:GetNWFloat("Melting"))
    //print(self:GetNWFloat("Time"))
    if self.DoBlood == true then
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
    self:SetPlaybackRate(1)
    self:NextThink(CurTime())
    
    if CurTime() > self:GetNWFloat("Time") && self:GetNWFloat("Time") != 0 && SERVER then
        local ent = ents.Create("prop_ragdoll")
        ent:SetPos(self:GetPos()+Vector(0,0,10))
        ent:SetAngles(self:GetAngles())
        ent:SetModel(self:GetModel())
        ent:SetSkin(self:GetSkin())
        ent:SetMaterial(self:GetMaterial())
        ent:Spawn()
        ent:SetBodygroup(1,self:GetBodygroup( 1 ))
		ent:SetBodygroup(2,self:GetBodygroup( 2 ))
		ent:SetBodygroup(3,self:GetBodygroup( 3 ))
		ent:SetBodygroup(4,self:GetBodygroup( 4 ))
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)
        timer.Simple(10,function() if IsValid(ent) then ent:Remove() end end)
        if not ent:IsValid() then return end
        local plyvel = self:GetVelocity()
       
        for i = 1, ent:GetPhysicsObjectCount() do
            local bone = ent:GetPhysicsObjectNum(i)
            if bone and bone.IsValid and bone:IsValid() then
                local bonepos, boneang = self:GetBonePosition(ent:TranslatePhysBoneToBone(i))
                bone:SetPos(bonepos)
                bone:SetAngles(boneang)
            end
        end
        self:Remove()
    end
    if (self:GetNWFloat("Melting") != 0 && self:GetNWFloat("Melting") < CurTime()) && SERVER then
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