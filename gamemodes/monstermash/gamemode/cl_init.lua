include( 'shared.lua' )
include( 'Admin/adminlist.lua' )
include( 'Menu/cl_menu.lua' )
include( 'Menu/cl_menu_old.lua' )
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

CreateClientConVar( "mm_aimenable", "0", true, false )
CreateClientConVar( "mm_pussymode", "0", true, true )
CreateClientConVar( "mm_blurmenu", "1", true, true )
CreateClientConVar( "mm_rollrotatescreen", "1", true, false )
CreateClientConVar( "mm_cleardecals", "60", true, false )
CreateClientConVar( "mm_deanimatorshake", "1", true, false )

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
		if IsValid(v) && v:GetNWFloat("MM_Deanimatorstun") > CurTime() then
			v:SetNWInt("LightingFrame", (v:GetNWInt("LightingFrame") + 1) % 5)
		end
    end
    for k, v in pairs( ents.FindByClass("ent_pumpkin_nade") ) do
        if IsValid(v) && CLIENT then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 240
                dlight.g = 104
                dlight.b = 0
                dlight.brightness = 3
                dlight.Decay = 2048
                dlight.Size = 512
                dlight.DieTime = CurTime() + 0.25
            end  
        end
    end
    for k, v in pairs( ents.FindByClass("ent_fireball") ) do
        if IsValid(v) && CLIENT then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 240
                dlight.g = 104
                dlight.b = 0
                dlight.brightness = 2
                dlight.Decay = 1000
                dlight.Size = 160
                dlight.DieTime = CurTime() + 1
            end  
        end
    end
    for k, v in pairs( ents.FindByClass("ent_acidflask") ) do
        if IsValid(v) && CLIENT then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 181
                dlight.g = 230
                dlight.b = 29
                dlight.brightness = 2
                dlight.Decay = 512
                dlight.Size = 160
                dlight.DieTime = CurTime() + 1
            end  
        end
    end
    for k, v in pairs( ents.FindByClass("ent_acid") ) do
        if IsValid(v) && CLIENT then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 181
                dlight.g = 230
                dlight.b = 29
                dlight.brightness = 2
                dlight.Decay = 512
                dlight.Size = 160
                dlight.DieTime = CurTime() + 1
            end  
        end
    end
    
    for k, v in pairs( ents.FindByClass("ent_smokenade") ) do
        if IsValid(v) && CLIENT then
            local dlight = DynamicLight( v:EntIndex() )
            if ( dlight ) then
                local r, g, b, a = v:GetColor()
                dlight.Pos = v:GetPos()
                dlight.r = 163
                dlight.g = 73
                dlight.b = 164
                dlight.brightness = 3
                dlight.Decay = 2048
                dlight.Size = 512
                dlight.DieTime = CurTime() + 0.25
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
		DrawMaterialOverlay( "models/electric/electric_hud", 0.2 )
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