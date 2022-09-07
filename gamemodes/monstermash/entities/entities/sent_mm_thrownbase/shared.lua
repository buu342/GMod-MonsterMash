ENT.Type = "anim"
ENT.Name = "Thrown Entity Base"

ENT.FireLight = false
ENT.LightSize = 0
ENT.LightColor = Color(0, 0, 0)
ENT.LightBrightness = 0
ENT.LightDecay = 0
ENT.LightTime = 0

function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:Draw()
    self:DrawModel()
    if self.LightSize != 0 && (!self.FireLight || self:IsOnFire()) then
        local dlight = DynamicLight(self:EntIndex())
        if (dlight) then
            local r, g, b, a = self:GetColor()
            dlight.Pos = self:GetPos()
            dlight.r = self.LightColor.r
            dlight.g = self.LightColor.g
            dlight.b = self.LightColor.b
            dlight.brightness = self.LightBrightness
            dlight.Decay = self.LightDecay
            dlight.Size = self.LightSize
            dlight.DieTime = CurTime() + self.LightTime
        end  
    end
    
    if self.ContinuousEffect != nil then
        local effectdata2 = EffectData()
		effectdata2:SetOrigin(self:GetPos())
		util.Effect(self.ContinuousEffect, effectdata2)
    end
end

hook.Add("HUDPaint", "MM_EntityHUDPaint", function()
    local tr = LocalPlayer():GetEyeTrace()
    if (tr.Entity.Base == "sent_mm_thrownbase" && tr.Entity.Retrievable && LocalPlayer():GetPos():Distance(tr.Entity:GetPos()) < 128) then
        draw.SimpleTextOutlined("Press E to pick up "..tr.Entity.PrintName, "MMDefaultFont", ScrW()/2, ScrH()/2, Color(255, 105, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
    end
end)   

hook.Add("PreDrawHalos", "MM_AddHaloEntity", function()
    local tr = LocalPlayer():GetEyeTrace()
    if (tr.Entity.Base == "sent_mm_thrownbase"&& tr.Entity.Retrievable && LocalPlayer():GetPos():Distance(tr.Entity:GetPos()) < 128) then
        halo.Add({tr.Entity}, Color(255, 105, 0), 5, 5, 1, true, true)
    end
end)        