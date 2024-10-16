/**************************************************************
                    Fancy Material Overlays
**************************************************************/

local BloodMat = Material("models/player/monstermash/gibs/bloody") 
local AcidMat = Material("models/player/monstermash/gibs/acid_skin") 
local FireMat = Material("animated/burn")
local ElectricMat = Material("animated/zap")
local SpawnProtectTex = "models/props_combine/tprings_globe"
local SpawnProtectMat = Material(SpawnProtectTex)

hook.Add("RenderScreenspaceEffects", "MM_MaterialsOnPlayers", function()
	cam.Start3D(EyePos(), EyeAngles()) 
        for k, v in pairs(player.GetAll()) do 
            if v.lastTextureBlendTime == nil then
                v.lastTextureBlendTime = 0
            end
            if v:Alive() then
                if v:HasStatusEffect(STATUS_GOREJARED) then
                    if v:GetStatusEffectTime(STATUS_GOREJARED) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = BloodMat
                    end
                end
                
                if v:HasStatusEffect(STATUS_ACID) then
                    if v:GetStatusEffectTime(STATUS_ACID) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = AcidMat
                    end
                end
                
                if v:HasStatusEffect(STATUS_SUPERACID) then
                    if v:GetStatusEffectTime(STATUS_SUPERACID) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = AcidMat
                    end
                end
                
                if v:HasStatusEffect(STATUS_MELTER) then
                    if v:GetStatusEffectTime(STATUS_MELTER) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = AcidMat
                    end
                end
                
                if v:HasStatusEffect(STATUS_ONFIRE) then
                    if v:GetStatusEffectTime(STATUS_ONFIRE) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = FireMat
                    end
                end
                
                if v:HasStatusEffect(STATUS_ELECTROCUTED) then
                    if v:GetStatusEffectTime(STATUS_ELECTROCUTED) > 0 then
                        v.lastTextureBlendTime = 1
                        v.lastTextureBlend = ElectricMat
                    end
                end

                if v:HasStatusEffect(STATUS_SPAWNPROTECTED) then
                    v.lastTextureBlendTime = 0.01
                    v.lastTextureBlend = SpawnProtectMat
                end
                
                if v.lastTextureBlendTime > 0 then
                    render.SetBlend(v.lastTextureBlendTime)
                    render.MaterialOverride(v.lastTextureBlend)
                    v:DrawModel() 
                    render.SetBlend(1) 
                    render.MaterialOverride(0) 
                end
            end
            if v.lastTextureBlendTime > 0 then
                v.lastTextureBlendTime = v.lastTextureBlendTime - FrameTime()
            end
        end
        /*
        for k, v in pairs(ents.GetAll()) do 
            if (v.IsBloodyGibs) then
                render.SetBlend(1)
                render.MaterialOverride(BloodMat)
                v:DrawModel() 
                render.SetBlend(1) 
                render.MaterialOverride(0) 
            end
        end
        */
	cam.End3D() 
end)


/**************************************************************
                         Dynamic Lights
**************************************************************/

hook.Add("Think", "MM_DynamicLightsOnPlayers", function()
    for k, ply in pairs(player.GetAll()) do 
        if ply:HasStatusEffect(STATUS_ONFIRE) then
            local dlight = DynamicLight(ply:EntIndex())
            if (dlight) then
                dlight.Pos = ply:GetPos()+Vector(0,0,50)
                dlight.r = 255
                dlight.g = 100
                dlight.b = 0
                dlight.brightness = 2
                dlight.Decay = 512
                dlight.Size = 512
                dlight.DieTime = CurTime() + 0.1
            end  
        end
        if IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "weapon_mm_flamethrower" then
            if ply:GetActiveWeapon():GetMMBase_Charge() != 0 then
                local dlight = DynamicLight(ply:EntIndex())
                if (dlight) then
                    local r, g, b, a = ply:GetColor()
                    dlight.Pos = ply:GetPos()+Vector(0,0,50)
                    dlight.r = 255
                    dlight.g = 105
                    dlight.b = 0
                    dlight.brightness = 5
                    dlight.Decay = 1000
                    dlight.Size = (ply:GetActiveWeapon():GetMMBase_Charge()/100) * 128
                    dlight.DieTime = CurTime() + 1
                end
            end
		end
        if IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "weapon_mm_deanimator" && ply:GetActiveWeapon():GetMMBase_Charge() != 0 then
			local dlight = DynamicLight(ply:EntIndex())
			if (dlight) then
				local r, g, b, a = ply:GetColor()
				dlight.Pos = ply:GetPos()+Vector(0,0,50)
				dlight.r = 33
				dlight.g = 144
				dlight.b = 255
				dlight.brightness = 5
				dlight.Decay = 1000
				dlight.Size = (ply:GetActiveWeapon():GetMMBase_Charge()/100) * 128
				dlight.DieTime = CurTime() + 1
			end
		end
        if IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "weapon_mm_candlestick" then
			local dlight = DynamicLight(ply:EntIndex())
			if (dlight) then
				local r, g, b, a = ply:GetColor()
				dlight.Pos = ply:GetPos()+Vector(0,0,50)
				dlight.r = 240
				dlight.g = 104
				dlight.b = 0
				dlight.brightness = 1
				dlight.Decay = 10000
				dlight.Size = 384
				dlight.DieTime = CurTime() + 0.2
			end
		end
    end
end)


/**************************************************************
                            Gorejar
**************************************************************/

hook.Add("RenderScreenspaceEffects", "MM_BloodiedScreen", function()
    if LocalPlayer():HasStatusEffect(STATUS_GOREJARED) then
        local timemax = LocalPlayer():GetStatusEffectMaxTime(STATUS_GOREJARED)
        local timeleft = LocalPlayer():GetStatusEffectTime(STATUS_GOREJARED)
        local tab = {
            [ "$pp_colour_addr" ] = 0.3,
            [ "$pp_colour_addg" ] = 0,
            [ "$pp_colour_addb" ] = 0,
            [ "$pp_colour_brightness" ] = 0,
            [ "$pp_colour_contrast" ] = 0.7,
            [ "$pp_colour_colour" ] = 0.7,
            [ "$pp_colour_mulr" ] = 0.4,
            [ "$pp_colour_mulg" ] = 0,
            [ "$pp_colour_mulb" ] = 0
        }
        
        DrawColorModify(tab)
        DrawMaterialOverlay("models/shadertest/shader4", 0.2*(timeleft/timemax))
    end
end)

hook.Add("PostPlayerDraw", "MM_BloodDripsGorejar", function(ply)
    if ply:HasStatusEffect(STATUS_GOREJARED) then
        if ply.BloodNextDrip == nil then
            ply.BloodNextDrip = 0
        end
        if (ply.BloodNextDrip > CurTime()) then return end
        ply.BloodNextDrip = CurTime() + math.Rand(0.01, 0.05)
        
        local Spawnpos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
        local LightColor = render.GetLightColor(Spawnpos)*255
        LightColor.r = math.Clamp(LightColor.r, 70, 255)
        
        local RandVel = VectorRand()*16
        RandVel.z = 0

        local emitter = ParticleEmitter(Spawnpos)
        local particle = emitter:Add("effects/blooddrop", Spawnpos + RandVel)
        if (particle) then
            particle:SetVelocity(Vector(0, 0, math.Rand(-150, -50)))
            particle:SetDieTime(1)
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(255)
            particle:SetStartSize(3)
            particle:SetEndSize(0)
            particle:SetColor(LightColor.r*0.5, 0, 0)
        end
        emitter:Finish()
    end
end)


/**************************************************************
                          Concussion
**************************************************************/

local NormalRT = GetRenderTarget("NormalMaterial", ScrW(), ScrH(), false)
local MirrorRT = GetRenderTarget("MirrorTexture", ScrW(), ScrH(), false)
local view = {} 
local NormalMaterial = CreateMaterial(
    "NormalMaterial",
    "UnlitGeneric",
    {
        [ '$basetexture' ] = NormalRT,
        [ '$basetexturetransform' ] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
    }
)

local MirroredMaterial = CreateMaterial(
    "MirroredMaterial",
    "UnlitGeneric",
    {
        [ '$basetexture' ] = MirrorRT,
        [ '$REFRACTTINT'] = "250 230 200",
        [ '$basetexturetransform' ] = "center .5 .5 scale -1 1 rotate 0 translate 0 0",
    }
)

// Render the world flipped
hook.Add("RenderScene", "MM_Concussion", function(Origin, Angles)
	if LocalPlayer():HasStatusEffect(STATUS_CONCUSS) then
        local timemax = LocalPlayer():GetStatusEffectMaxTime(STATUS_CONCUSS)
        local timeleft = LocalPlayer():GetStatusEffectTime(STATUS_CONCUSS)
		view.x = 0
		view.y = 0
		view.w = ScrW()
		view.h = ScrH()
		view.origin = Origin
		view.angles = Angles
		view.drawhud = true
	 
		// get the old rendertarget
		local oldrt = render.GetRenderTarget()
	 
		// set the rendertarget
		render.SetRenderTarget(MirrorRT)
		 
			// clear
			render.Clear(0, 0, 0, 255, true)
			render.ClearDepth()
			render.ClearStencil()
			render.RenderView(view)
			
	 
		// restore
		render.SetRenderTarget(oldrt)
		MirroredMaterial:SetTexture("$basetexture", MirrorRT)
		render.SetMaterial(MirroredMaterial)
		render.DrawScreenQuad()
        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawRect(-1, -1, 2, 2)
		
		DrawMotionBlur(0.2, 0.8, 0.01)
		render.RenderHUD(0, 0, ScrW(), ScrH())
		return true
    end
end)

// Flip the mouse
hook.Add("InputMouseApply", "MM_ConcussionFlipMouse", function(cmd, x, y, angle)
	if LocalPlayer():HasStatusEffect(STATUS_CONCUSS) then
		local pitchchange = y * GetConVar("m_pitch"):GetFloat()
		local yawchange = x * -GetConVar("m_yaw"):GetFloat()
		 
		angle.p = angle.p + pitchchange * (1)
		angle.y = angle.y + yawchange * (-1)
		 
		cmd:SetViewAngles(angle)
		 
		return true
	end
end)

// Blinking after concuss
local blinking = 0
local blinkTime = 0
hook.Add("HUDPaint", "MM_HUD_Concuss", function()
    
    local concusstime = 5
    if LocalPlayer():HasStatusEffect(STATUS_CONCUSS) then
        local time = LocalPlayer():GetStatusEffectTime(STATUS_CONCUSS)
        if time < 0.5 then
            blinking = 1-time*2
        elseif time < (concusstime-1) then
            blinking = 0
        else
            blinking = (time-(concusstime-1))
        end
    else
        if blinking > 0 then
            if blinkTime == 0 then
                blinkTime = CurTime() + 0.5
            end
            blinking = (blinkTime-CurTime())*2
        elseif blinking < 0 then
            blinking = 0
            blinkTime = 0
        end
    end
    if blinking != 0 then
        surface.SetDrawColor(0,0,0,255*blinking)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end

end)

hook.Add("PostPlayerDraw" , "MM_ConcussSwirl" , function(ply)
    if ply.ConcussionTime == nil then
        ply.ConcussionTime = 0
    end
    
    if (ply:HasStatusEffect(STATUS_CONCUSS)) && ply.ConcussionTime < CurTime() then
        local effectdata = EffectData()
        effectdata:SetEntity(ply)
        util.Effect("mm_concuss", effectdata)
        ply.ConcussionTime = CurTime() + ply:GetStatusEffectTime(STATUS_CONCUSS)
    end
end)

/**************************************************************
                          Haunted Urn
**************************************************************/

local mat_screamies = {
    Material("vgui/hud/screamy3"),
    Material("vgui/hud/screamy2"),
    Material("vgui/hud/screamy"),
    Material("vgui/hud/spooky_fella.png"),
    Material("vgui/hud/spooky_madam.png")
}
local snd_screamies = {
    "gameplay/halloween_boo1.mp3",
    "death/creeper.wav",
    "npc/stalker/go_alert2a.wav"
}
local playSpookSound = true
local spookTexture
hook.Add("HUDPaint", "MM_HUD_Spooked", function()

    if LocalPlayer():HasStatusEffect(STATUS_SPOOKED) && LocalPlayer():GetStatusEffectTime(STATUS_SPOOKED) > 0 then
        if (playSpookSound) then
            spookTexture = math.random(2, 5)
            if LocalPlayer():GetInfoNum("mm_pussymode", 0) == 1 then
                spookTexture = 1
            end
            playSpookSound = false
            surface.PlaySound(snd_screamies[math.min(spookTexture, 3)])
        end
        surface.SetDrawColor(255, 255, 255, LocalPlayer():GetStatusEffectTime(STATUS_SPOOKED)*255)
        surface.SetMaterial(mat_screamies[spookTexture])
		
		local size = ScrH()
		local moveup = math.min(ScrH(),(2.5 - (LocalPlayer():GetStatusEffectTime(STATUS_SPOOKED)))*ScrH()*4)
		surface.DrawTexturedRect((ScrW()/2)-(size/2), ScrH()-moveup, size, size)
    elseif !playSpookSound then
        playSpookSound = true
    end

end)

hook.Add("CalcMainActivity", "MM_Animations_Spooked", function(ply, velocity)
    if IsValid(ply) && ply:HasStatusEffect(STATUS_SPOOKED) then
       	ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
        if !ply:MissingBothLegs() then
            ply.CalcSeqOverride = ply:LookupSequence("idle_all_cower")
        end
		return ply.CalcIdeal, ply.CalcSeqOverride
    end
end)


/**************************************************************
                             Bats
**************************************************************/

local bats = {}
local batstex = Material("animated/bat")
hook.Add("HUDPaint", "MM_HUD_Bats", function()

    if LocalPlayer():HasStatusEffect(STATUS_BATS) && LocalPlayer():GetStatusEffectTime(STATUS_BATS) > 0 then
        local numbats = 6
        local size = 1024
        local size2 = size/2
        local actvel = 2
        local framespeed = 0.1
        
        if table.Count(bats) != numbats then
            table.Empty(bats)
            for i=1, numbats do
                local batty = {
                    x = math.random(0, ScrW()),
                    y = math.random(0, ScrH()),
                    vel = Vector(math.Rand(-7, 7), math.Rand(-7, 7), 0),
                    col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                }
                table.insert(bats, batty)
            end
        end
        
        for i=1, numbats do            
            bats[i].x = bats[i].x + bats[i].vel.x*actvel
            bats[i].y = bats[i].y + bats[i].vel.y*actvel
            
            surface.SetDrawColor(bats[i].col.r, bats[i].col.g, bats[i].col.b, math.min(1, LocalPlayer():GetStatusEffectTime(STATUS_BATS))*255)
            surface.SetMaterial(batstex)
            surface.DrawTexturedRect(bats[i].x-size2, bats[i].y-size2, size, size)
            
            if bats[i].x-size2/4 < 0 then
                bats[i].x = size2/4
                bats[i].vel.x = -bats[i].vel.x
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].x+size2/4 > ScrW() then
                bats[i].x = ScrW()-size2/4
                bats[i].vel.x = -bats[i].vel.x
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].y-size2/4 < 0 then
                bats[i].y = size2/4
                bats[i].vel.y = -bats[i].vel.y
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].y+size2/4 > ScrH() then
                bats[i].y = ScrH()-size2/4
                bats[i].vel.y = -bats[i].vel.y
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
        end
    elseif table.Count(bats) > 0 then
        table.Empty(bats)
    end

end)

hook.Add("CalcMainActivity", "MM_Animations_Bats", function(ply, velocity)
    if IsValid(ply) && ply:HasStatusEffect(STATUS_BATS) then
       	ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
        if !ply:MissingBothLegs() then
            ply.CalcSeqOverride = ply:LookupSequence("bats_attacked")
        end
		return ply.CalcIdeal, ply.CalcSeqOverride
    end
end)


/**************************************************************
                           Spider Web
**************************************************************/

hook.Add("Think" , "MM_DrawSpiderWeb" , function()
    for k, ply in pairs(player.GetAll()) do
        if ply:HasStatusEffect(STATUS_SPIDERWEBBED) && ply:GetStatusEffectTime(STATUS_SPIDERWEBBED) > 0 then
            local web = ClientsideModel("models/monstermash/player_web_mask.mdl")
            web:SetPos(ply:GetPos() + Vector(-15,0,0))
            web:SetParent(ply)
            web:AddEffects(EF_BONEMERGE)
            //if ply:GetStatusEffectTime(STATUS_SPIDERWEBBED) < 1 then
            //    web:SetRenderMode(RENDERMODE_TRANSALPHA)
            //    web:SetColor(Color(255,255,255,255*(ply:GetStatusEffectTime(STATUS_SPIDERWEBBED))))
            //end
            web:DrawModel()
            web:Remove()
        end
    end
end)

local spiders = {}
local spiderstex = Material("animated/spider_crawling")
local mat_webbing = Material("vgui/hud/webbing")
hook.Add("HUDPaint", "MM_HUD_Spiders", function()

    if LocalPlayer():HasStatusEffect(STATUS_SPIDERWEBBED) && LocalPlayer():GetStatusEffectTime(STATUS_SPIDERWEBBED) > 0 then
        local ymax = 6*6*8
        local y = (LocalPlayer():GetStatusEffectTime(STATUS_SPIDERWEBBED))*8*6
        if (LocalPlayer():GetNWFloat("Sticky") - CurTime() > 1) then
            surface.SetDrawColor(255, 255, 255, 20)
        else
            surface.SetDrawColor(255, 255, 255, 20*(LocalPlayer():GetStatusEffectTime(STATUS_SPIDERWEBBED)))
        end
		surface.SetMaterial(mat_webbing)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH()+(ymax-y))

        local numspiders = 10
        local size = 256
        local size2 = size/2
        local actvel = 4
        
        if table.Count(spiders) != numspiders then
            table.Empty(spiders)
            for i=1, numspiders do
                local spidery = {
                    x = math.random(0+size, ScrW()-size),
                    y = math.random(0+size, ScrH()-size),
                    vel = Vector(math.Rand(-7, 7), math.Rand(-7, 7), 0):GetNormalized(),
                    ang = 0,
                }
                table.insert(spiders, spidery)
                if (spiders[i].vel.x == 0) then
                    spiders[i].vel.x = 0.01
                end
                spiders[i].ang = (math.deg(math.atan2(spiders[i].vel.y,spiders[i].vel.x))+360)%360
            end
        end
        
        for i=1, numspiders do            
            spiders[i].x = spiders[i].x + spiders[i].vel.x*actvel
            spiders[i].y = spiders[i].y + spiders[i].vel.y*actvel
            
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(spiderstex)
            surface.DrawTexturedRectRotated(spiders[i].x-size2, spiders[i].y-size2, size, size/1.5, -spiders[i].ang)
            surface.SetTextPos(spiders[i].x, spiders[i].y) 
        end
    elseif table.Count(spiders) > 0 then
        table.Empty(spiders)
    end
end)


/**************************************************************
                             Fire
**************************************************************/

hook.Add("RenderScreenspaceEffects", "MM_FireHUD", function()
    if LocalPlayer():HasStatusEffect(STATUS_ONFIRE) then
        render.SetBlend(1) 
        render.MaterialOverride(0) 
		DrawMaterialOverlay("animated/burnie", 1)
	end
end)


/**************************************************************
                          Eletrocution
**************************************************************/

hook.Add("RenderScreenspaceEffects", "MM_EletrocutedHUD", function()
	if LocalPlayer():HasStatusEffect(STATUS_ELECTROCUTED) || LocalPlayer():HasStatusEffect(STATUS_SELFELECTROCUTED) then
        render.SetBlend(1) 
        render.MaterialOverride(0) 
		DrawMaterialOverlay("animated/zappy", 0.2)
	end
end)

local curangle = nil
local lastangle = Angle(0,0,0)
local nextanglechange = 0
hook.Add("CalcView", "MM_ElectrocutionView", function(ply, pos, angles, fov)
    if (GetConVar("mm_deanimatorshake"):GetBool()) then
        if LocalPlayer():HasStatusEffect(STATUS_ELECTROCUTED) || LocalPlayer():HasStatusEffect(STATUS_SELFELECTROCUTED) then
            if (curangle == nil) then
                curangle = angles
            end
            if (nextanglechange < CurTime()) then
                lastangle = Angle(math.random(-5, 5), math.random(-5, 5), 0)
                nextanglechange = CurTime()+0.03
            end
            curangle = LerpAngle(FrameTime()*10, curangle, angles+lastangle)
            local view = {}
            view.origin = pos
            view.angles = curangle
            view.fov = fov
            return view
            //self.Owner:ViewPunch(Angle(self:RandomRange(-2, 2), self:RandomRange(-2, 2), 0))
        elseif (curangle != nil) then
            curangle = nil
        end
    end
end)



/**************************************************************
                          Hallucination
**************************************************************/

hook.Add("CalcView", "MM_HallucinationView", function(ply, pos, angles, fov)
    if LocalPlayer():HasStatusEffect(STATUS_HALLUCINATING) then
        local view = {}
        local totalang = 120
        view.origin = pos+Vector(0,0,0)
        view.angles = angles+Angle(0,0,totalang/2-math.abs(math.sin(-CurTime()/4)*totalang))
        ply:GetViewModel():SetRenderOrigin(view.origin)
        ply:GetViewModel():SetRenderAngles(Angle(view.angles.p, view.angles.y, -view.angles.r))
        view.fov = fov
        return view
    end
end)

local skeletonfly = {
    Material("animated/skeleton1.png"),
    Material("animated/skeleton2.png"),
    Material("animated/skeleton3.png"),
    Material("animated/skeleton4.png"),
    Material("animated/skeleton5.png"),
    Material("animated/skeleton6.png"),
    Material("animated/skeleton7.png"),
    Material("animated/skeleton8.png")
}
local skellies = {}
hook.Add("HUDPaint", "MM_HUD_HallucinateSkellies", function()
    if LocalPlayer():HasStatusEffect(STATUS_HALLUCINATING) then 
        local numskels = 10
        local size = 256
        local size2 = size/2
        local actvel = 2
        local framespeed = 0.1
        
        if table.Count(skellies) != numskels then
            table.Empty(skellies)
            for i=1, numskels do
                local skelly = {
                    x = math.random(0, ScrW()),
                    y = math.random(0, ScrH()),
                    vel = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0),
                    frame = 1,
                    col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                }
                table.insert(skellies, skelly)
            end
        end
        
        for i=1, numskels do            
            skellies[i].x = skellies[i].x + skellies[i].vel.x*actvel
            skellies[i].y = skellies[i].y + skellies[i].vel.y*actvel
            
            surface.SetDrawColor(skellies[i].col.r, skellies[i].col.g, skellies[i].col.b, math.abs(math.sin(CurTime()+(skellies[i].col.a/255)*6.28318))*255)
            surface.SetMaterial(skeletonfly[1+math.floor(skellies[i].frame)])
            surface.DrawTexturedRect(skellies[i].x-size2, skellies[i].y-size2, size, size)
            
            skellies[i].frame = (skellies[i].frame + framespeed)%8
            
            if skellies[i].x-size2 < 0 then
                skellies[i].x = size2
                skellies[i].vel.x = -skellies[i].vel.x
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].x+size2 > ScrW() then
                skellies[i].x = ScrW()-size2
                skellies[i].vel.x = -skellies[i].vel.x
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].y-size2 < 0 then
                skellies[i].y = size2
                skellies[i].vel.y = -skellies[i].vel.y
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].y+size2 > ScrH() then
                skellies[i].y = ScrH()-size2
                skellies[i].vel.y = -skellies[i].vel.y
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
        end
    end
end)

local SwirlyTexture = surface.GetTextureID("animated/tripping_swirly");
hook.Add("PostPlayerDraw" , "MM_DrawHallucinateSwirl" , function(ply)
    local tr = util.GetPlayerTrace(LocalPlayer())
    local trace = util.TraceLine(tr)
    local showhallucinate = true
    local hallucinatepos = 0
    
    if trace.Hit && trace.HitNonWorld && ply == trace.Entity then 
        if false then // TODO: Add invisibility
            showhallucinate = false
        end
        hallucinatepos = -64
    end
    
    if ply:HasStatusEffect(STATUS_HALLUCINATING) && showhallucinate then
        local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
        pos.z = pos.z + 30
        local ang = ply:EyeAngles()
        local dist = LocalPlayer():GetPos():Distance(ply:GetPos())
        cam.Start3D2D(pos, EyeAngles():Right():Angle() + Angle(0,0,90), 0.25);
            surface.SetDrawColor(255, 255, 255, 255);
            surface.SetTexture(SwirlyTexture);
            surface.DrawTexturedRect(-32, hallucinatepos, 64, 64);
        cam.End3D2D()
    end
end)

hook.Add("RenderScene", "MM_HallucinateRenderScene", function(Origin, Angles)

   if LocalPlayer():HasStatusEffect(STATUS_HALLUCINATING) then
		view.x = 0
		view.y = 0
		view.w = ScrW()
		view.h = ScrH()
		view.origin = Origin
		view.angles = Angles
		view.drawhud = true

		// get the old rendertarget
		local oldrt = render.GetRenderTarget()
	 
		// set the rendertarget
		render.SetRenderTarget(NormalRT)
		 
			// clear
			render.Clear(0, 0, 0, 255, true)
			render.ClearDepth()
			render.ClearStencil()
			render.RenderView(view)
			
	 
		// restore
		render.SetRenderTarget(oldrt)
		NormalMaterial:SetTexture("$basetexture", NormalRT)
		render.SetMaterial(NormalMaterial)
		render.DrawScreenQuad()

		DrawMotionBlur(0.2, 0.8, 0.01)
		render.RenderHUD(0,0,ScrW(), ScrH())
		return true
    end
    
end)


/**************************************************************
                          Dodgerolling
**************************************************************/

hook.Add("CalcView", "MM_CalcView_DodgeRoll", function(ply, pos, angles, fov)
    if ply:IsDodgeRolling() then
        local view = {}
        local time
        if ply:HasStatusEffect(STATUS_ROLLRIGHT) then
            time = (ply:GetStatusEffectTime(STATUS_ROLLRIGHT))
        else
            time = (ply:GetStatusEffectTime(STATUS_ROLLLEFT))
        end
        local down
        if time > 0.4 then
            down = (1-((time-0.4)/0.1))*40
        elseif time < 0.1 then
            down = (time/0.1)*40
        else
            down = 40
        end
        view.origin = pos+Vector(0,0,-math.max(0, down))
        if (GetConVar("mm_rollrotatescreen"):GetInt() == 1) then
            if ply:HasStatusEffect(STATUS_ROLLRIGHT) then
                view.angles = angles+Angle(0,0,-(time/0.5)*360)
            else
                view.angles = angles+Angle(0,0,(time/0.5)*360)
            end
        end
        view.fov = fov
        return view
    end
end)


/**************************************************************
                          MeleeCharging
**************************************************************/

hook.Add("CalcView", "MM_CalcView_MeleeCharge", function(ply, pos, angles, fov)
    if ply:IsMeleeCharging() then
        local viewang = Angle(10*math.sin((ply:GetStatusEffectTime(STATUS_MELEECHARGE))*math.pi),0,0)
        local view = {}
        view.origin = origin
        view.angles = angles + viewang
        view.fov = fov
        view.drawviewer = false
        ply:GetViewModel():SetRenderOrigin(pos+Vector(math.cos(CurTime()*10),0,math.cos(CurTime()*3)/3.14))
        ply:GetViewModel():SetRenderAngles(angles-(Angle(math.cos(CurTime()*3),math.sin(CurTime()*5),math.cos(CurTime()*5)*4) - Angle(20*math.sin((LocalPlayer():GetStatusEffectTime(STATUS_MELEECHARGE))*math.pi),0,0)))
        return view
    end
end)


/**************************************************************
                           Spawning
**************************************************************/

hook.Add("PreDrawPlayerHands", "MM_InvisibleTrickHands", function(hands, vm, ply, wep)
    if (ply:HasStatusEffect(STATUS_SPAWNPROTECTED)) then 
        hands:SetMaterial(SpawnProtectTex)
    else
        hands:SetMaterial("")
    end
end)

hook.Add("PrePlayerDraw", "MM_InvisibleSpawningPlayer", function(ply)
    if (ply:HasStatusEffect(STATUS_SPAWNING)) then return true end
end)

hook.Add("CreateMove","MM_CreateMoveSpawning", function(cmd)
    if LocalPlayer():HasStatusEffect(STATUS_SPAWNING) then
        cmd:ClearButtons()
        cmd:ClearMovement()
        cmd:SetButtons(IN_DUCK)
    end
end)

hook.Add("CalcView", "MM_CalcViewSpawning", function(ply, pos, angles, fov)
    if ply:HasStatusEffect(STATUS_SPAWNING) then
        local view = {}
        local effecttime = math.Clamp(ply:GetStatusEffectTime(STATUS_SPAWNING)/1.5, 0, 1)
        view.origin = pos-Vector(0,0,30*effecttime)
        ply:GetViewModel():SetRenderOrigin(view.origin-Vector(0,0,-30*effecttime))
        ply:GetViewModel():SetRenderAngles(angles+Angle(90*effecttime,0,0))
        view.angles = angles
        view.fov = fov
        return view
    end
end)