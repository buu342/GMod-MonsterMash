if ( SERVER ) then return end

MM_Scoreboard = MM_Scoreboard or {}

surface.CreateFont("Chiller", {
	font = "Chiller",
	size = 24,
	weight = 600,
})

local MutedIcon = {
	texture = surface.GetTextureID( 'vgui/hud/muted' ),
	color	= Color( 255, 255, 255, 255 ),
	x 	= 700-48,
	y 	= 6,
	w 	= 32,
	h 	= 32
}
local UnMutedIcon = {
	texture = surface.GetTextureID( 'vgui/hud/unmuted' ),
	color	= Color( 255, 255, 255, 255 ),
	x 	= 700-48,
	y 	= 6,
	w 	= 32,
	h 	= 32
}

local BoxColor

function MM_Scoreboard:show()
	gui.EnableScreenClicker( true )

	local Players = player.GetAll()

	table.sort( Players, function( a, b )
		return a:GetNWInt("killcounter") > b:GetNWInt("killcounter")
	end )

	local Logo = vgui.Create( "DPanel" )
	Logo:SetSize( 700, 256 )
	Logo:SetPos( ScrW()/2-(700/2), 10 )
	function Logo:Paint( w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material("vgui/Logo") )
		surface.DrawTexturedRect( 100, -48,512,256 )
	end
	
	local Back = vgui.Create( "DPanel" )
	local height = 100+(44*(table.Count(Players)-1))
	Back:SetSize( 720, height ) 
	Back:SetPos( ScrW()/2-(700/2)-10,(ScrH()/2)-height/2)
	function Back:Paint( w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 145, 0, 105 ) )
		
		draw.SimpleTextOutlined	( "Name:", "DermaDefault", 64, 10, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Rank:", "DermaDefault", 486-32, 10, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Score:", "DermaDefault", 570-54, 10, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Deaths:", "DermaDefault", 612-48, 10, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Ping:", "DermaDefault", 670-48, 10, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleTextOutlined	( "Kill Limit: "..tostring(GetConVar("mm_kill_limit"):GetInt()), "DermaDefault", 16, height-22, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Map: "..tostring(game.GetMap()), "DermaDefault", 360, height-22, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Player Count: "..tostring(table.Count(player.GetAll())).."/"..tostring(game.MaxPlayers()), "DermaDefault", 720-16, height-22, Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
	end

	--[[-------------------------------------------------------------------------
	Scoreboard Main
	---------------------------------------------------------------------------]]
	local Main = vgui.Create( "DPanel" )
	Main:SetSize( 700, ScrH()-394 ) // 372
	Main:SetPos( ScrW()/2-(700/2), math.max((ScrH()/2)-(22*table.Count(Players)),208)	)

	function Main:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 0 ) )
	end

	local Scroll = vgui.Create( "DScrollPanel", Main )
	Scroll:Dock( FILL )
	local Rows = vgui.Create( "DListLayout", Scroll )
	Rows:Dock( FILL )
	for k, v in pairs( Players ) do
		local PlayerBox = Rows:Add( "DPanel" )
		PlayerBox:SetSize( Rows:GetWide()+4, 44 )
		PlayerBox:Dock( TOP )
		
		function PlayerBox:Paint( w, h )
		
			local UserRank = v:GetUserGroup()
			
			if v == LocalPlayer() then
				BoxColor = Color( 255, 0, 0 )
			else
				BoxColor = Color( 255, 145, 30 )
			end

			
			draw.RoundedBox( 4, 0, 0, w, 44, Color(0,0,0,255))
			draw.RoundedBox( 4, 2, 2, w-4, 40, BoxColor)
			
			if IsValid(v) then
                if table.HasValue(developers, v:SteamID()) then
                    NameColor = Color( 0, 38, 255 )
                elseif table.HasValue(admins, v:SteamID()) then
                    NameColor = Color( 0, 255, 255 )
                elseif table.HasValue(aborter, v:SteamID()) then
                    NameColor = Color( 0, 255, 0 )
                else
                    NameColor = Color( 0, 0, 0 )
                end 
                
				draw.DrawText( v:Nick(), "Chiller", 50+2, 8+2, NameColor, TEXT_ALIGN_LEFT )

				if table.HasValue(developers, v:SteamID()) then
					draw.DrawText( "Developer", "Chiller", 536-48, 8+2, NameColor, TEXT_ALIGN_RIGHT )
				elseif table.HasValue(admins, v:SteamID()) then
                    draw.DrawText( "Administrator", "Chiller", 536-48, 8+2, NameColor, TEXT_ALIGN_RIGHT )
				elseif table.HasValue(aborter, v:SteamID()) then
					draw.DrawText( "Professional Aborter", "Chiller", 536-48, 8+2, Color( 0, 255, 0 ), TEXT_ALIGN_RIGHT )
				else
					draw.DrawText( "User", "Chiller", 536-48, 8+2, NameColor, TEXT_ALIGN_RIGHT )			
				end
				draw.DrawText( tostring( v:GetNWInt("killcounter") ), "Chiller", 570-48, 8+2, NameColor, TEXT_ALIGN_CENTER )
				draw.DrawText( tostring( v:Deaths() ), "Chiller", 620-48, 8+2, NameColor, TEXT_ALIGN_CENTER )
				draw.DrawText( tostring( v:Ping() ), "Chiller", 670-48, 8+2, NameColor, TEXT_ALIGN_CENTER )

				if v != LocalPlayer() then
					if v:IsMuted() then
						draw.TexturedQuad( MutedIcon )
					else
						draw.TexturedQuad( UnMutedIcon )
					end
				end
			end
		end

		AvatarButton = Rows:Add( "DButton" )
		AvatarButton:SetParent( PlayerBox )
		AvatarButton:Dock( NODOCK )
		AvatarButton:SetPos( 2+2, 2+2 )
		AvatarButton:SetSize( 36, 36 )
		function AvatarButton:DoClick()
			v:ShowProfile()
		end
		if v != LocalPlayer() then
			MuteButton = Rows:Add( "DImageButton" )
			MuteButton:SetParent( PlayerBox )
			MuteButton:Dock( NODOCK )
			MuteButton:SetPos( 700-38, 6 )
			MuteButton:SetSize( 32, 32 )
			function MuteButton:DoClick()
				v:SetMuted( !v:IsMuted() )
			end
		end

		Avatar = vgui.Create( "AvatarImage", AvatarButton )
		Avatar:Dock( FILL )
		Avatar:SetMouseInputEnabled( false )
		Avatar:SetPlayer( v )
		
	end

	function MM_Scoreboard:hide()
		gui.EnableScreenClicker( false )
		Back:Remove()
		Main:Remove()
		Logo:Remove()
	end
end

hook.Add("ScoreboardShow", "MM_ScoreboardShow", function()
    MM_Scoreboard:show()
    return false
end )

hook.Add("ScoreboardHide", "MM_ScoreboardHide", function()
    MM_Scoreboard:hide()
    return false
end )