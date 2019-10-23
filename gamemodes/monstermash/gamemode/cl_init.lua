include( 'shared.lua' )
include( 'Admin/adminlist.lua' )
include( 'Menu/cl_menu.lua' )
include( 'Music/cl_music.lua' )
include( 'HUD/cl_hud.lua' )
include( 'HUD/cl_scoreboard.lua' )
include( 'HUD/cl_deathnotices.lua' )
include( 'Flinch/cl_flinch.lua' )
// Clientside only stuff goes here

function GM:PlayerBindPress(ply, bind, pressed)
	if string.find(bind, "impulse 100") then 
        ply:ConCommand("mm_givelight")
    end
end

function GM:OnSpawnMenuOpen()
    RunConsoleCommand("mm_healplayer")
end

net.Receive("EmitConcussEffect", function() 
    local victim = net.ReadEntity()
    local effectdata = EffectData()
    effectdata:SetEntity( victim )
    util.Effect( "concuss", effectdata )
end)

local haydecalmat = Material("models/player/monstermash/gibs/hay_splat")
net.Receive("DoHayDecal", function()
    local data = net.ReadTable()
    //PrintTable(data)
    util.DecalEx(haydecalmat, game.GetWorld(), data.HitPos, data.HitNormal, Color(255,255,255,255), 0.2, 0.2)
end)

CreateClientConVar( "mm_aimenable", "0", true, false )
CreateClientConVar( "mm_meleeaim", "0", true, false )
CreateClientConVar( "mm_pussymode", "0", true, true )
CreateClientConVar( "mm_blurmenu", "1", true, true )
CreateClientConVar( "mm_rollrotatescreen", "1", true, false )
CreateClientConVar( "mm_cleardecals", "60", true, false )
CreateClientConVar( "mm_deanimatorshake", "1", true, false )
CreateClientConVar( "mm_deathtips", "1", true, false )
CreateClientConVar( "mm_autoreload", "1", true, false )
CreateClientConVar( "mm_screenblood", "0", true, false )

function GM:OnContextMenuOpen()
    if LocalPlayer():GetNWString("buff_ready") == "" || LocalPlayer():GetNWString("buff") != "" then return end
    if LocalPlayer():GetNWInt("buffcost") == LocalPlayer():GetNWInt("MM_MedalsEarned") then 
        LocalPlayer():ConCommand("play ui/lunatic_distant2.wav")
        LocalPlayer():SetNWString("buff", LocalPlayer():GetNWString("buff_ready"))
        net.Start("MM_Apply_Buff")
        net.SendToServer()
        LocalPlayer():SetNWInt("MM_MedalsEarned", 0)
    end
end

hook.Add("Think", "ClientsideThink", function()
    for k, v in pairs( ents.FindByClass("player") ) do

        // Music
        MusicThink(v)
    
        // Decal clearing
        if IsValid(v) && (v.ClearDecalTime == nil || v.ClearDecalTime < CurTime()) then
            v:ConCommand("r_cleardecals")
            v.ClearDecalTime = CurTime() + GetConVar("mm_cleardecals"):GetInt()
        end
        
        // Web model on players
        if CLIENT && IsValid(v) && v:Alive() && v:GetNWFloat("Sticky") > CurTime() then
            local web = ClientsideModel("models/weapons/monstermash/webbing.mdl")
            web:SetPos(v:GetPos() + Vector(-15,0,0))
            if (v:GetNWFloat("Sticky")-CurTime()) < 1 then
                web:SetRenderMode(RENDERMODE_TRANSALPHA)
                web:SetColor(Color(255,255,255,255*((v:GetNWFloat("Sticky")-CurTime()))))
            end
            web:Remove()
        end
        
        // Lights
        if IsValid(v) && CLIENT && IsValid(v:GetActiveWeapon()) && v:GetActiveWeapon():GetClass() == "mm_candlestick" then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 240
                dlight.g = 104
                dlight.b = 0
                dlight.brightness = 1
                dlight.Decay = 10000
                dlight.Size = 384
                dlight.DieTime = CurTime() + 0.2
            end  
        end
		if IsValid(v) && CLIENT && (IsValid(v:GetActiveWeapon()) && v:GetActiveWeapon():GetClass() == "mm_flamethrower") && v:GetActiveWeapon():GetGun_FakeTimer1() > CurTime()  then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
				
				local pos = v:GetShootPos()
					pos = pos + v:GetForward() * 50
					pos = pos + v:GetRight() * 0
					pos = pos + v:GetUp() * 0
					
                dlight.Pos = pos
                dlight.r = 240
                dlight.g = 104
                dlight.b = 0
                dlight.brightness = 3
                dlight.Decay = 2048
                dlight.Size = 512
                dlight.DieTime = CurTime() + 0.25
            end  
        end
		if IsValid(v) && CLIENT && IsValid(v:GetActiveWeapon()) && v:GetActiveWeapon():GetClass() == "mm_deanimator" && v:GetActiveWeapon():GetGun_Charge() != 0  then
			local dlight = DynamicLight( v:EntIndex() )
			if ( dlight ) then
				local r, g, b, a = v:GetColor()
				dlight.Pos = v:GetPos()
				dlight.r = 33
				dlight.g = 144
				dlight.b = 255
				dlight.brightness = 5
				dlight.Decay = 1000
				dlight.Size = (v:GetActiveWeapon():GetGun_Charge()/100) * 128
				dlight.DieTime = CurTime() + 1
			end
		end
		if IsValid(v) && IsValid(v:GetActiveWeapon()) && v:GetNWFloat("MM_Deanimatorstun") > CurTime() && v:GetNWInt("LightingFrame") == 0 then
			local dlight = DynamicLight( v:EntIndex() )
			if ( dlight ) then
				local r, g, b, a = v:GetColor()
				dlight.Pos = v:GetPos()
				dlight.r = 33
				dlight.g = 144
				dlight.b = 255
				dlight.brightness = 5
				dlight.Decay = 1000
				dlight.Size = 128
				dlight.DieTime = CurTime() + 0.05
			end
		end
        if IsValid(v) && v:GetNWFloat("MM_FireTime") > CurTime() then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 240
                dlight.g = 104
                dlight.b = 0
                dlight.brightness = 1
                dlight.Decay = 2048
                dlight.Size = 512
                dlight.DieTime = CurTime() + 0.25
            end  
        end
		if IsValid(v) && v:GetNWFloat("MM_Deanimatorstun") > CurTime() then
			v:SetNWInt("LightingFrame", (v:GetNWInt("LightingFrame") + 1) % 5)
		end
    end

    if CLIENT then
        if GetConVar( "mm_meleeaim" ):GetInt() == 1 && IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon().Base == "mm_melee_base" then
        
            if LocalPlayer():GetNWFloat("MeleeAttackAim") < CurTime() then
                return
            end
            local ply = LocalPlayer()
			local size = 64
        
            local tr = util.TraceHull( {
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 128,
                filter = ply,
                mins = Vector( -size/2, -size/2, -size/2 ),
                maxs = Vector( size/2, size/2, size/2 ),
                mask = MASK_SHOT_HULL
            } )
            
            if tr.HitNonWorld then 
                local target = tr.Entity
                if target:IsPlayer() then 
                    local targetbody = target:LookupBone("ValveBiped.Bip01_Spine4")
                    
                    local targetbodypos,targetbodyang = target:GetBonePosition(targetbody)
                    local aimto = (targetbodypos-ply:GetShootPos()):Angle()
                    local thing = LerpAngle(80*FrameTime(),ply:EyeAngles(),aimto)
                    ply:SetEyeAngles(Angle(thing.p,thing.y,0))
                end
            end
        end
    end
	
	if CLIENT then 
		if GetConVar( "mm_aimenable" ):GetInt() == 1 then
			local ply = LocalPlayer()
			local size = GetConVar( "mm_aimsize" ):GetInt()
			if ply:GetActiveWeapon().Base == "mm_melee_base" then
				size = size + 10
			end

			local tr = util.TraceHull( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * GetConVar( "mm_aimrange" ):GetInt(),
				filter = ply,
				mins = Vector( -size/2, -size/2, -size/2 ),
				maxs = Vector( size/2, size/2, size/2 ),
				mask = MASK_SHOT_HULL
			} )
            
			if tr.HitNonWorld then 
				local target = tr.Entity
				if target:IsPlayer() then 
					local targetbody = target:LookupBone("ValveBiped.Bip01_Spine2")
					if !IsValid(ply:GetActiveWeapon()) then return end
					if ply:GetActiveWeapon():GetClass() == "mm_huntingrifle" then
						targetbody = target:LookupBone("ValveBiped.Bip01_Head1")
					elseif ply:GetActiveWeapon().Base == "mm_melee_base" then
						targetbody = target:LookupBone("ValveBiped.Bip01_Spine4")
					end
					local targetbodypos,targetbodyang = target:GetBonePosition(targetbody)
					local aimto = (targetbodypos-ply:GetShootPos()):Angle()
					if ply:GetActiveWeapon().Base == "mm_melee_base" then
						local thing = LerpAngle(5*FrameTime(),ply:EyeAngles(),aimto)
						ply:SetEyeAngles(Angle(thing.p,thing.y,0))
					else
						local thing = LerpAngle(GetConVar( "mm_aimspeed" ):GetInt()*FrameTime(),ply:EyeAngles(),aimto)
						ply:SetEyeAngles(Angle(thing.p,thing.y,0))
					end
				end
			end
		end
	end		
end)

hook.Add("CreateMove", "Sticky", function(cmd)
    if LocalPlayer():GetNWFloat("Sticky") > CurTime() then
        cmd:SetForwardMove( 0 )
        cmd:SetSideMove( 0 )
	end
end)

hook.Add("RenderScreenspaceEffects", "BloodiedScreen", function()
	v = LocalPlayer()
	local tab = {
		[ "$pp_colour_addr" ] = (v:GetNWFloat("Bloodied")-CurTime())/25,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1-(v:GetNWFloat("Bloodied")-CurTime())/25,
		[ "$pp_colour_colour" ] = 1-(v:GetNWFloat("Bloodied")-CurTime())/25,
		[ "$pp_colour_mulr" ] = (v:GetNWFloat("Bloodied")-CurTime())/18.75,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	if IsValid(v) && v:GetNWFloat("Bloodied") > CurTime() then
		DrawColorModify( tab )
		DrawMaterialOverlay( "models/shadertest/shader4", (v:GetNWFloat("Bloodied")-CurTime())/50 )
	end
	if IsValid(v) && IsValid(v:GetActiveWeapon()) && v:GetNWFloat("MM_Deanimatorstun") > CurTime() then
		DrawMaterialOverlay( "animated/zap", 0.2 )
	end
    if IsValid(v) && IsValid(v:GetActiveWeapon()) && v:IsOnFire() then
		DrawMaterialOverlay( "animated/burn", 0.2 )
	end
end)

/*
function FlamethrowerHot(vm, ply, wep) 
    if !IsValid(wep) || !IsValid(vm) || !IsValid(ply) then return end
	if wep:GetClass() == "mm_flamethrower" then 
		cam.Start3D( EyePos(), EyeAngles() ) 
            render.Model({, vm:GetPos(), vm:GetAngles()})
		cam.End3D() 
		return true 
	end 
end 
hook.Add("PreDrawViewModel","FlamethrowerHot",FlamethrowerHot)