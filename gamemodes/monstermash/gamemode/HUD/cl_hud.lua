surface.CreateFont( "TheDefaultSettings", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings2", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 96,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings3", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings4", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13-big", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13-small", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 7,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )


local Tex_white = surface.GetTextureID( "vgui/white" )
local medaly = {0,0,0}
local function DrawPercentageCircle( x, y, radius, seg, progression )
	local cir = { [1] = { x = x, y = y } }
	local cir2 = { [1] = { x = x, y = y } }

	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		cir[#cir+1] = { x = x - math.sin( a ) * radius, y = y - math.cos( a ) * radius }
	end

	for i = 0, progression do
		table.insert( cir2, cir[next(cir)+1] )
		table.remove( cir, next(cir)+1 )
	end

	surface.SetTexture( Tex_white )
	surface.SetDrawColor( 255, 0, 0, 100 )
	surface.DrawPoly( cir )
	//surface.SetDrawColor( 0, 0, 0, 255 )
	//surface.DrawPoly( cir2 )
end

local function IsSlotEmpty( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then return false end 
	end

	return true

end

local function SelectWep( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			net.Start("MM_SelectWeapon")
			net.WriteString(v:GetClass())
			net.SendToServer()
		end
	end

end

local function CheckWep( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			return v
		end
	end
	
end

local function SelectWepIcon( ply, slot )
	slot = slot - 1 
	if not ply:Alive() then return end
	local weptbl = ply:GetWeapons()
	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			ply:SetNWString("lastselecticon",v.SelectIcon)
		end
	end
end

local function SelectWeapon1()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),1))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 1 )
	SelectWepIcon(LocalPlayer(), 1)
end

local function SelectWeapon2()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),2))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 2 )
	SelectWepIcon(LocalPlayer(), 2)
end

local function SelectWeapon3()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),3))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 3 )
	SelectWepIcon(LocalPlayer(), 3)
end

local function SelectWeapon4()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),4))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 4 )
	SelectWepIcon(LocalPlayer(), 4)
end

if CLIENT then // Not my code. Thank you gmod wiki
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
end

local MirrorRT = GetRenderTarget( "MirrorTexture", ScrW(), ScrH(), false )

local view = {} 

hook.Add("RenderScene", "Mirror.RenderScene", function( Origin, Angles )

	if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
		view.x = 0
		view.y = 0
		view.w = ScrW()
		view.h = ScrH()
		view.origin = Origin
		view.angles = Angles
		view.drawhud = true
		
		local MirroredMaterial = CreateMaterial(
			"MirroredMaterial",
			"UnlitGeneric",
			{
				[ '$basetexture' ] = MirrorRT,
				[ '$basetexturetransform' ] = "center .5 .5 scale -1 1 rotate 0 translate 0 0",
			}
		)
	 
		// get the old rendertarget
		local oldrt = render.GetRenderTarget()
	 
		// set the rendertarget
		render.SetRenderTarget( MirrorRT )
		 
			// clear
			render.Clear( 0, 0, 0, 255, true )
			render.ClearDepth()
			render.ClearStencil()
			render.RenderView( view )
			
	 
		// restore
		render.SetRenderTarget( oldrt )
		MirroredMaterial:SetTexture( "$basetexture", MirrorRT )
		render.SetMaterial( MirroredMaterial )
		render.DrawScreenQuad()
		
		
		if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
			local alpha
			alpha = ((LocalPlayer():GetNWFloat("MM_Concussion") - CurTime())/8)*270
			surface.SetDrawColor(0,0,0,alpha)
			surface.DrawRect( -1, -1, 2, 2 )
		end
		
		DrawMotionBlur( 0.2, 0.8, 0.01 )
		render.RenderHUD( 0,0,ScrW(), ScrH() )
		return true
	end
end )

hook.Add( "InputMouseApply", "flipmouse", function( cmd, x, y, angle )
 
	if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
		local pitchchange = y * GetConVar( "m_pitch" ):GetFloat()
		local yawchange = x * -GetConVar( "m_yaw" ):GetFloat()
		 
		angle.p = angle.p + pitchchange * ( 1 )
		angle.y = angle.y + yawchange * ( -1 )
		 
		cmd:SetViewAngles( angle )
		 
		return true
	end
end )

function bool_to_number(value)
    if value == true then
        return 2
    else
        return 0
    end
end

function hud()
    local scale_width 	= 1600
	local scale_height 	= 900
	local MultW 		= ScrW() / scale_width
	local MultH 		= ScrH() / scale_height

	/*--------------------------------------------
					Crosshairs
	--------------------------------------------*/
	//{
	
	if IsValid(LocalPlayer()) && ( LocalPlayer():Alive()) && IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():GetClass() != nil then
		if LocalPlayer():GetNWFloat("MM_Concussion") < CurTime() then
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_battlerifle" then
				local charge = (LocalPlayer():GetNWFloat("Battlerifle_alt")-CurTime())
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-16, (ScrH()/2)-(size/2)-16, 33+size,33+size )
				end
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_BAR" ) ) local size = 34*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_cannon" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetDrawColor( 255, 0, 0, 100 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon_fill" ) )
				local charge = (LocalPlayer():GetActiveWeapon():GetGun_Charge())/5000
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )

			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_coachgun" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 88
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_colt" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end

				surface.SetMaterial( Material( "vgui/hud/crosshair_revolver" ) ) local size = 40*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_crossbow" || LocalPlayer():GetActiveWeapon():GetClass() == "mm_sawblade" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) local size = 48
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2)+20, size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_musketpistol" then
			
				local charge = LocalPlayer():GetNWFloat("mm_musketpistol_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				DrawPercentageCircle((ScrW()/2), (ScrH()/2),9,115,115-LocalPlayer():GetActiveWeapon():GetDuelGun_Charge())
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_deanimator" then
				
				local charge = LocalPlayer():GetActiveWeapon():GetGun_Cooldown2()-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 128*((charge)/3)*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-18, (ScrH()/2)-(size/2)-18, 36+size,36+size )
				end
				DrawPercentageCircle((ScrW()/2), (ScrH()/2),18,100,100-LocalPlayer():GetActiveWeapon():GetGun_Charge())
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 36
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_pumpkinnade" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon_fill" ) )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_pumpkinnade_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_cleaver" then
			
				local charge = LocalPlayer():GetNWFloat("mm_cleaver_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_spidernade" then
			
				local charge = LocalPlayer():GetNWFloat("mm_web_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_skull" then
			
				local charge = LocalPlayer():GetNWFloat("mm_skull_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_pumpshotgun" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
				local x = LocalPlayer():GetActiveWeapon().Primary.Spread
				local size = ((330*(x + 0.1)^2)*0.5)
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_repeater" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_garand" ) ) local size = 46*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_revolver" || LocalPlayer():GetActiveWeapon():GetClass() == "mm_shield" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_revolver" ) ) local size = 40*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_sawedoff" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 128
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_flamethrower" then
            
				DrawPercentageCircle((ScrW()/2), (ScrH()/2),45,100,100-LocalPlayer():GetActiveWeapon():GetGun_Charge())
                
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 88
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )

			end

			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_undertaker" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( Material( "vgui/hud/crosshair_thompson" ) ) local size = 80*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_urn" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon_fill" ) )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_urn_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_acidflask" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon_fill" ) )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_acid_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_gorejar" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon_fill" ) )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_gorejar_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( "vgui/hud/crosshair_cannon" ) ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_stake" then
			
				local charge = LocalPlayer():GetNWFloat("mm_stake_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
			
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().Reach  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_stick" then
			
				local charge = LocalPlayer():GetActiveWeapon():GetFaketimer3() - CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
			
				
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington") && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().Reach  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( Material( "vgui/hud/crosshair_carbine" ) ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
		end
	end
	//}
	
	/*--------------------------------------------
                Screen Text and HUD
	--------------------------------------------*/
    
	//{
	if LocalPlayer():Team() != 2 && LocalPlayer():Team() != 5 then 
    
        local tr = util.TraceHull( {
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + ( LocalPlayer():GetAimVector() * 100 ),
        filter = LocalPlayer(),
        mins = Vector( -10, -10, -10 ),
        maxs = Vector( 10, 10, 10 ),
        mask = MASK_SHOT_HULL
        } )
        
        if IsValid(LocalPlayer()) && ( LocalPlayer():Alive() && tr.Hit && tr.Entity:IsWeapon() && !LocalPlayer():HasWeapon(tr.Entity:GetClass())) || (LocalPlayer():Alive() && tr.Hit && tr.Entity:GetClass() == "ent_skull" && tr.Entity:GetNetworkedBool("HitAlready") == true) then
            halo.Add( {tr.Entity}, Color(255,105,0,255), 2, 2, 1, true, false )
            draw.SimpleTextOutlined( "Press E to Pickup "..tr.Entity.PrintName, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
            
        if LocalPlayer():Alive() then
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( Material( "vgui/hud/hud_back.png" ) )
            surface.DrawTexturedRect( 23+16, ScrH()-131-16+4, 229, 128 )
            
            if LocalPlayer():GetNWInt("LegMissing") != 3 then
                surface.SetDrawColor( 255, 105, 0, 255 )
                surface.DrawRect( 32+14, ScrH()-131+86, 220*(5-math.Clamp(LocalPlayer():GetNWFloat("DiveCooldown")-CurTime(),0,5))/5, 21 )
            end
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            
            surface.SetMaterial( Material( "vgui/hud/heart_dark.png" ) )
            surface.DrawTexturedRect( 32+12+16, ScrH()-131-16+10, 53, 80 )
            surface.SetMaterial( Material( "vgui/hud/heart_light.png" ) )
            local hp = LocalPlayer():Health()/LocalPlayer():GetMaxHealth()
            surface.DrawTexturedRectUV( 32+12+16, math.floor(ScrH()-136+80*(1-hp)), 53, math.ceil(80*hp), 0, 1-hp, 1, 1 )
            draw.SimpleTextOutlined( LocalPlayer():Health(), "TheDefaultSettings", 68+16, ScrH()-88, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            
            if LocalPlayer():GetNWInt("LegMissing") != 3 then
                if LocalPlayer():GetNWInt("LegMissing") != 1 then
                    surface.SetMaterial( Material( "vgui/hud/leg_left.png" ) )
                    surface.DrawTexturedRect( 32+12+64+16+16, ScrH()-131+31, 17/1.4, 62/1.4 )
                end
                
                if LocalPlayer():GetNWInt("LegMissing") != 2 then
                    surface.SetMaterial( Material( "vgui/hud/leg_right.png" ) )
                    surface.DrawTexturedRect( 32+12+64+36+16, ScrH()-131+31, 31/1.4, 65/1.4 )
                end
            end
            
            if LocalPlayer():GetNWInt("ArmMissing") != 3 then
                if LocalPlayer():GetNWInt("ArmMissing") != 1 then
                    surface.SetMaterial( Material( "vgui/hud/arm_left.png" ) )
                    surface.DrawTexturedRect( 32+12+60+16, ScrH()-126, 33/1.4, 29/1.4 )
                end
                
                if LocalPlayer():GetNWInt("ArmMissing") != 2 then
                    surface.SetMaterial( Material( "vgui/hud/arm_right.png" ) )
                    surface.DrawTexturedRect( 32+12+96+16, ScrH()-131-6, 31/1.4, 27/1.4 )
                end
            end
            
            surface.SetMaterial( Material( "vgui/hud/base.png" ) )
            surface.DrawTexturedRect( 32+12+64+16+16, ScrH()-131-16+10, 34/1.4, 61/1.4 )
            
            surface.SetMaterial( Material( "vgui/hud/candy_corn_empty2.png" ) )
            surface.DrawTexturedRect( 32+140+6+16, ScrH()-136, 58, 80 )
            if LocalPlayer():GetNWInt("ArmMissing") != 3 then
                surface.SetMaterial( Material( "vgui/hud/candy_corn_full.png" ) )
                local time = 1-math.Clamp((LocalPlayer():GetNWFloat("HealTime")-CurTime())/20,0,20)
                surface.DrawTexturedRectUV( 32+140+6+16, math.floor(ScrH()-136+80*(1-time)), 58, math.ceil(80*time), 0, 1-time, 1, 1 )
                if LocalPlayer():GetNWFloat("HealTime") > CurTime() then
                    draw.SimpleTextOutlined( math.ceil(LocalPlayer():GetNWFloat("HealTime")-CurTime()), "TheDefaultSettings", 32+140+6+30+16, ScrH()-131+42, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( Material( "vgui/hud/hud_front.png" ) )
            surface.DrawTexturedRect( 0, ScrH()-131-53, 311, 182 )
            
            // Right side
            
            if LocalPlayer():GetNWInt("NumberShowingMedals") > 0 then
                for i=3, 1, -1 do
                    if LocalPlayer():GetNWFloat("ShowMedal"..i) > CurTime() && i <= LocalPlayer():GetNWInt("NumberShowingMedals") then
                        local ymax = 72*(LocalPlayer():GetNWInt("NumberShowingMedals")+1-i)
                        medaly[i] = math.ceil(medaly[i]*0.9 + ymax*0.1)
                        
                        if LocalPlayer():GetNWFloat("ShowMedal"..i) < CurTime()+0.5 then
                            surface.SetDrawColor( 255, 255, 255, 255*(LocalPlayer():GetNWFloat("ShowMedal"..i)-CurTime())/0.5)
                        else
                            surface.SetDrawColor( 255, 255, 255, 255)
                        end
                        local type = v:GetNWString("ShowMedalType"..i)
                        local mat = "vgui/hud/medals/"..type..".png"
                        surface.SetMaterial( Material( mat ) )
                        surface.DrawTexturedRect( ScrW()-120+24, ScrH()-131-48-medaly[i]+24, 72, 72 )
                    else
                        if LocalPlayer():GetNWInt("NumberShowingMedals") == 2 && medaly[3] != 0 then
                            medaly[1] = medaly[2]
                            medaly[2] = medaly[3]
                            medaly[3] = 0
                        elseif LocalPlayer():GetNWInt("NumberShowingMedals") == 1 && medaly[2] != 0 then
                            medaly[1] = medaly[2]
                            medaly[2] = 0
                            medaly[3] = 0
                        end
                    end
                end
            else
                medaly[1] = 0
                medaly[2] = 0
                medaly[3] = 0
            end
                    
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( Material( "vgui/hud/gravestone.png" ) )
            surface.DrawTexturedRect( ScrW()-100, ScrH()-131-16, 85, 131 )
            draw.SimpleTextOutlined( LocalPlayer():GetNWInt("killcounter"), "TheDefaultSettings", ScrW()-16-40, ScrH()-72, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            
            if IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():Clip1() != -1 then
                local wep = LocalPlayer():GetActiveWeapon():GetClass()
                draw.SimpleTextOutlined( LocalPlayer():GetActiveWeapon():Clip1(), "TheDefaultSettings2", ScrW()-150, ScrH()-60, Color(255,105,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            
            if LocalPlayer():GetNWFloat("LastScoreTime") > CurTime() then
                local time = LocalPlayer():GetNWFloat("LastScoreTime") - CurTime()
                draw.SimpleTextOutlined( "+"..LocalPlayer():GetNWInt("LastScore"), "TheDefaultSettings", ScrW()-16-40, ScrH()-72-(1-time)*100, Color(255,255,255,255*time), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255*time))
            end
        end
    end
	
	//}
    
	/*--------------------------------------------
				 Round Start/Stop
	--------------------------------------------*/
	
	//{
	
    if GetGlobalVariable("Game_Over") == true then
        draw.SimpleTextOutlined( "Round Over", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		if GetGlobalVariable("Winner") == "MonsterTeam" then
            draw.SimpleTextOutlined( "Monsters Win!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("Winner") == "OtherTeam" then
            draw.SimpleTextOutlined( "Skeletons win!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("Winner") && GetGlobalVariable("Winner") == LocalPlayer():GetName() then
            draw.SimpleTextOutlined( "You're Winner!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		elseif GetGlobalVariable("Winner") then
            draw.SimpleTextOutlined( GetGlobalVariable("Winner").." is the Gravekeeper!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		end
	end
	if GetGlobalVariable("RoundStartTimer") > CurTime() then
        if GetGlobalVariable("RoundsToWacky") == 0 then
            draw.SimpleTextOutlined( "Wacky round is here", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("RoundsToWacky") == 1 then
            draw.SimpleTextOutlined( "Wacky round next round", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		else
            draw.SimpleTextOutlined( "Wacky round in "..GetGlobalVariable("RoundsToWacky").." rounds", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
        draw.SimpleTextOutlined( "Round Starting in: "..(math.ceil(GetGlobalVariable("RoundStartTimer")-CurTime(),0)).." seconds", "TheDefaultSettings", ScrW()/2, 64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        if GetGlobalVariable("RoundsToWacky") == 0 then
            if GetGlobalVariable("WackyRound_Event") == 0 then
                if GetGlobalVariable("WackyRound_COOPOther") == LocalPlayer() then
                    draw.SimpleTextOutlined( "Show everyone the cool stick you found at the park (Leave no survivors)", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    draw.SimpleTextOutlined( "Primary Attack to clang, Secondary Attack to dash", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                else
                    draw.SimpleTextOutlined( "Kirito from the Chinese TV show Goblin Slayer is on the loose!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    draw.SimpleTextOutlined( "Work together to put a stop to him!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
            if GetGlobalVariable("WackyRound_Event") == 1 then
                draw.SimpleTextOutlined( "Crappy skeleton sprites are invading!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Work together to fight the horde!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        end
    end
	
    if GetGlobalVariable("Game_Over") == false && GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 1 && GetGlobalVariable("RoundStartTimer") < CurTime() then
        local skeleton_count = 0
        for k, v in pairs( ents.FindByClass("sent_skellington")) do
            skeleton_count = skeleton_count + 1
        end
        draw.SimpleTextOutlined( "Total Skeletons left: "..GetGlobalVariable("WackyRound_Extra"), "TheDefaultSettings", ScrW()/2, 32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        draw.SimpleTextOutlined( "Skeletons roaming: "..skeleton_count, "TheDefaultSettings", ScrW()/2, 72, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
	end
	//}
	
	/*--------------------------------------------
					 Screamer
	--------------------------------------------*/
	
	//{
	
	if LocalPlayer():GetNWFloat("Spooked") > CurTime() then
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("Spooked") - CurTime())*255 )
		if GetConVar("mm_pussymode"):GetInt() == 1 then
			surface.SetMaterial( Material( "vgui/hud/screamy3" ) )
		elseif LocalPlayer():GetNWInt("SpookType") == 1 then
			surface.SetMaterial( Material( "vgui/hud/screamy" ) )
		elseif LocalPlayer():GetNWInt("SpookType") == 2 then
			surface.SetMaterial( Material( "vgui/hud/screamy2" ) )
		elseif LocalPlayer():GetNWInt("SpookType") == 3 then
			surface.SetMaterial( Material( "vgui/hud/spooky_fella.png" ) )
		elseif LocalPlayer():GetNWInt("SpookType") == 4 then
			surface.SetMaterial( Material( "vgui/hud/spooky_madam.png" ) )
		end
		
		size = ScrH()
		local moveup = math.min(ScrH(),(2.5 - (LocalPlayer():GetNWFloat("Spooked")-CurTime()))*ScrH()*4)
		surface.DrawTexturedRect( (ScrW()/2)-(size/2), ScrH()-moveup, size, size )
	end
	
	//}
	
	/*--------------------------------------------
				Screen Blood / Death
	--------------------------------------------*/
	
	//{
	
	if LocalPlayer():GetNWFloat("RecentlyTookDamage") > CurTime() then
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("RecentlyTookDamage") - CurTime())*255 )
		surface.SetMaterial( Material( "vgui/hud/bleedout" ) )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end
	if !LocalPlayer():Alive() && LocalPlayer():GetNWBool("DisplayKilla") == true && ((LocalPlayer():GetNWBool("killa"):IsPlayer() && IsValid(LocalPlayer():GetNWBool("killa")) && LocalPlayer():GetNWBool("killa"):Alive()) || IsValid(LocalPlayer():GetNWBool("killa"))) then
		if LocalPlayer():GetNWBool("killa") == LocalPlayer() then
			draw.SimpleTextOutlined( "You killed yourself to death.", "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		else
			if LocalPlayer():GetNWBool("killa"):GetClass() == "sent_skellington" then 
				draw.SimpleTextOutlined( "Clickity clack, get into my sack."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_creeper" then 
				draw.SimpleTextOutlined( "You were creeped up on by the Creeper."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_jitterskull" then 
				draw.SimpleTextOutlined( "You were eaten by the Jitterskull."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_sjas" then 
				draw.SimpleTextOutlined( "You were screamed at by Sjas."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_yurei" then 
				draw.SimpleTextOutlined( "You stood in awe of the Yurei."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif IsValid(LocalPlayer():GetNWBool("killa")) && LocalPlayer():GetNWBool("killa"):GetName() != nil then
				draw.SimpleTextOutlined( LocalPlayer():GetNWBool("killa"):GetName().." sent you back to the grave."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			end
		end
	end
    
	if LocalPlayer():GetNWFloat("Sticky") > CurTime() then
        local ymax = 6*6*8
        local y = (LocalPlayer():GetNWFloat("Sticky") - CurTime())*8*6
        if (LocalPlayer():GetNWFloat("Sticky") - CurTime() > 1) then
            surface.SetDrawColor( 255, 255, 255, 20 )
        else
            surface.SetDrawColor( 255, 255, 255, 20*((LocalPlayer():GetNWFloat("Sticky")-CurTime())) )
        end
		surface.SetMaterial( Material( "vgui/hud/webbing" ) )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH()+(ymax-y) )
	end
	
	//}

	/*--------------------------------------------
				   Weapon Selection 
	--------------------------------------------*/
	
	//{
	
	if !LocalPlayer():Alive() then return end

	if input.IsKeyDown( KEY_1 ) then 
		if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
			SelectWeapon1()
		end
	elseif input.IsKeyDown( KEY_2 ) then
		if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
			SelectWeapon2()
		end
	elseif input.IsKeyDown( KEY_3 ) then
		if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
			SelectWeapon3()
		end
	elseif input.IsKeyDown( KEY_4 ) then
		if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
			SelectWeapon4()
		end
	end
	
	if input.IsKeyDown( KEY_Z ) && !(LocalPlayer():IsPlayingTaunt() || LocalPlayer():GetNWBool("DoingTauntCamera")) then
		if LocalPlayer():GetModel() == "models/monstermash/deer_haunter_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/mummy_final.mdl"  then
			LocalPlayer():ConCommand("act zombie")
		elseif LocalPlayer():GetModel() == "models/monstermash/stein_final.mdl" then
			LocalPlayer():ConCommand("act robot")
		elseif LocalPlayer():GetModel() == "models/monstermash/headless_horseman_final.mdl" then
			LocalPlayer():ConCommand("act salute")
		elseif LocalPlayer():GetModel() == "models/monstermash/skeleton_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/bloody_mary_final.mdl"  then
			LocalPlayer():ConCommand("act laugh")
		elseif LocalPlayer():GetModel() == "models/monstermash/vampire_final.mdl" then
			LocalPlayer():ConCommand("act bow")
		elseif LocalPlayer():GetModel() == "models/monstermash/witch_final.mdl" then
			LocalPlayer():ConCommand("act disagree")
		elseif LocalPlayer():GetModel() == "models/monstermash/scarecrow_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/nosferatu_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/guest_final.mdl"  then
			LocalPlayer():SetCycle(0)
			LocalPlayer():SetNWBool("DoingTauntCamera", true)
			net.Start("ServerDoingTauntCamera")
			net.SendToServer()
		end
	end
	
	local width = 128
	local height = 128
	local startx = ScrW()/2 - width*2
	local starty = ScrH()-height
	if LocalPlayer():GetNWFloat("LastKeyDown1") > CurTime() then
		local x = startx + width*0
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Melee", "TheDefaultSettings", x+width/2-2, y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown2") > CurTime() then
		local x = startx + width
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Side Arm", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown3") > CurTime() then
		local x = startx + width*2
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Primary", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown4") > CurTime() then
		local x = startx + width*3
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255 )
		surface.SetMaterial( Material( LocalPlayer():GetNWString("lastselecticon") ) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Throwable", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255))
	end
	
	//}

end
hook.Add("HUDPaint", "MyHudName", hud)

hook.Add("StartCommand","DetectMouseWheelWeapon",function( ply, cmd )
	if !ply:Alive() then return end
	if cmd:GetMouseWheel() > 0 then
		if ply:GetActiveWeapon().Slot == 0 || (ply:HasWeapon("mm_candlestick") && ply:GetActiveWeapon():GetClass() == "mm_candlestick")  then
			if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			end
		elseif ply:GetActiveWeapon().Slot == 1 then
			if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			end
		elseif ply:GetActiveWeapon().Slot == 2 then
			if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			end
		elseif ply:GetActiveWeapon().Slot == 3 then
			if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			end
		end
	end
	if cmd:GetMouseWheel() < 0 then
		if ply:GetActiveWeapon().Slot == 0 || (ply:HasWeapon("mm_candlestick") && ply:GetActiveWeapon():GetClass() == "mm_candlestick") then
			if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			end
		elseif ply:GetActiveWeapon().Slot == 1 then
			if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			end
		elseif ply:GetActiveWeapon().Slot == 2 then
			if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			end
		elseif ply:GetActiveWeapon().Slot == 3 then
			if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			end
		end
	end
	
end)

function hidehud(name)
	if ( name == "CHudHealth" ) then return false end
    if ( name == "CHudAmmo" ) then return false end
    if ( name == "CHudSecondaryAmmo" ) then return false end
	if ( name == "CHudDamageIndicator" ) then return false end
	if ( name == "CHudWeaponSelection" ) then return false end
    return true;
end
hook.Add("HUDShouldDraw", "HideMyHud", hidehud)

function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	
	if ( trace.Entity:IsPlayer() ) then
		text = trace.Entity:Nick()
	else
		return
		--text = trace.Entity:GetClass()
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleTextOutlined( text, "TheDefaultSettings", ScrW()/2, 0, self:GetTeamColor( trace.Entity ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
	
	y = y + h + 5
	
	local text = "Health: "..trace.Entity:Health()
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x = MouseX - w / 2
	
	draw.SimpleTextOutlined( text, "TheDefaultSettings", ScrW()/2, 48, self:GetTeamColor( trace.Entity ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))

end