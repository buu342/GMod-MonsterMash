if ( SERVER ) then return end

MM_Scoreboard = MM_Scoreboard or {}

local wratio = ScrW()/1600
local hratio = ScrH()/900

local width = 900*wratio

local MMLogo = Material("vgui/Logo")

local MutedIcon = {
	texture = surface.GetTextureID( 'vgui/hud/muted' ),
	color	= Color( 255, 255, 255, 255 ),
	x 	= width*0.91,
	y 	= 6*hratio,
	w 	= 32*wratio,
	h 	= 32*hratio
}
local UnMutedIcon = {
	texture = surface.GetTextureID( 'vgui/hud/unmuted' ),
	color	= Color( 255, 255, 255, 255 ),
	x 	= width*0.91,
	y 	= 6*hratio,
	w 	= 32*wratio,
	h 	= 32*hratio
}

local developers = {
    "STEAM_0:0:31739525", // Buu342
    "STEAM_0:0:56188280", // Demo
    "STEAM_0:1:30535198", // Cougar Magnum
}

local admins = {
    "STEAM_0:0:31739525", // Buu342
    "STEAM_0:0:56188280", // Demo
    "STEAM_0:1:30535198", // Cougar Magnum
}

local aborter = {
    "STEAM_0:1:43032837", // Taserman
}

local edgelord = {
    "STEAM_0:0:28144880", // Rex Impaler
}

local BoxColor

function MM_Scoreboard:show()
	gui.EnableScreenClicker( true )

	local Players = player.GetAll()

	table.sort( Players, function( a, b )
		return a:GetScore() > b:GetScore()
	end )

	local Logo = vgui.Create( "DPanel" )
	Logo:SetSize( 700*wratio, 256*hratio )
	Logo:SetPos( ScrW()/2-(350*wratio), 10*hratio )
	function Logo:Paint( w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( MMLogo )
		surface.DrawTexturedRect( 100*wratio, -48*hratio, 512*wratio, 256*hratio )
	end
	
	local Back = vgui.Create( "DPanel" )
	local height = (100+(44*(table.Count(Players)-1)))*hratio
	Back:SetSize( width, height ) 
	Back:SetPos( (ScrW()/2)-width/2,(ScrH()/2)-height/2)
	function Back:Paint( w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 145, 0, 105 ) )
		
		draw.SimpleTextOutlined	( "Name:", "DermaDefault", width*0.08*wratio, 10*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Rank:", "DermaDefault", width*0.6, 10*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Score:", "DermaDefault", width*0.72, 10*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Deaths:", "DermaDefault", width*0.8, 10*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Ping:", "DermaDefault", width*0.89, 10*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleTextOutlined	( "Point Limit: "..tostring(GetConVar("mm_point_limit"):GetInt()), "DermaDefault", width*0.02*wratio, height-22*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Map: "..tostring(game.GetMap()), "DermaDefault", width/2, height-22*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined	( "Player Count: "..tostring(table.Count(player.GetAll())).."/"..tostring(game.MaxPlayers()), "DermaDefault", width*0.98, height-22*hratio, Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
	end
	local Back2 = vgui.Create( "DPanel" )
    Back2:SetSize( 200*wratio, 16*hratio ) 
	Back2:SetPos( (ScrW()/2)-100*wratio, (ScrH()/2)+height/2)
	function Back2:Paint( w, h )
        if (GetConVar("mm_maxrounds"):GetInt()-GAMEMODE:GetRoundNum() == 0) then
            draw.SimpleTextOutlined	( "Map change on round end", "DermaDefault", w/2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        elseif (GetConVar("mm_maxrounds"):GetInt()-GAMEMODE:GetRoundNum() == 1) then
            draw.SimpleTextOutlined	( "Map change next round", "DermaDefault", w/2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        else
            draw.SimpleTextOutlined	( "Map change in "..tostring(GetConVar("mm_maxrounds"):GetInt()-GAMEMODE:GetRoundNum()).." round(s)", "DermaDefault", w/2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        end
    end
	local Main = vgui.Create( "DPanel" )
	Main:SetSize( width*0.96, ScrH()-394*hratio ) // 372
	Main:SetPos( ScrW()/2-width/2+width*0.02, math.max((ScrH()/2)-(22*table.Count(Players))*hratio,208*hratio)	)

	function Main:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 0 ) )
	end

	local Scroll = vgui.Create( "DScrollPanel", Main )
	Scroll:Dock( FILL )
	local Rows = vgui.Create( "DListLayout", Scroll )
	Rows:Dock( FILL )
	for k, v in pairs( Players ) do
		local PlayerBox = Rows:Add( "DPanel" )
		PlayerBox:SetSize( Rows:GetWide()+4*wratio, 44*hratio )
		PlayerBox:Dock( TOP )
		
		function PlayerBox:Paint( w, h )
		
			local UserRank = v:GetUserGroup()
			
			if v == LocalPlayer() then
				BoxColor = Color( 255, 0, 0 )
			else
				BoxColor = Color( 255, 145, 30 )
			end

			
			draw.RoundedBox( 4, 0, 0, w, 44*hratio, Color(0,0,0,255))
			draw.RoundedBox( 4, 2, 2, w-4*wratio, 40*hratio, BoxColor)
			
			if IsValid(v) then
                if table.HasValue(developers, v:SteamID()) then
                    NameColor = Color( 0, 38, 255 )
                elseif table.HasValue(admins, v:SteamID()) then
                    NameColor = Color( 0, 255, 255 )
                elseif table.HasValue(aborter, v:SteamID()) then
                    NameColor = Color( 0, 255, 0 )                
                elseif table.HasValue(edgelord, v:SteamID()) then
                    NameColor = Color( 255, 0, 255 )
                else
                    NameColor = Color( 0, 0, 0 )
                end 
                
                local extra = " "
                if v:Team() == TEAM_SPECT then
                    extra = "(Spectating)"
                elseif v:Team() == TEAM_COOPDEAD then
                    extra = "(Dead)"
                end
                
				draw.DrawText( v:Nick()..extra, "MMScoreboardFont", 52*wratio, 7*hratio, NameColor, TEXT_ALIGN_LEFT )

				if table.HasValue(developers, v:SteamID()) then
					draw.DrawText( "Developer", "MMScoreboardFont", width*0.6, 7*hratio, NameColor, TEXT_ALIGN_CENTER )
				elseif table.HasValue(admins, v:SteamID()) then
                    draw.DrawText( "Administrator", "MMScoreboardFont", width*0.6, 7*hratio, NameColor, TEXT_ALIGN_CENTER )
				elseif table.HasValue(aborter, v:SteamID()) then
					draw.DrawText( "Professional Aborter", "MMScoreboardFont", width*0.6, 7*hratio, Color( 0, 255, 0 ), TEXT_ALIGN_CENTER )				
                elseif table.HasValue(edgelord, v:SteamID()) then
					draw.DrawText( "Friendly Neighborhood Edgelord", "MMScoreboardFont", width*0.6, 7*hratio, Color( 255, 0, 255 ), TEXT_ALIGN_CENTER )
				else
					draw.DrawText( "User", "MMScoreboardFont", width*0.6, 7*hratio, NameColor, TEXT_ALIGN_CENTER )			
				end
				draw.DrawText( tostring( v:GetScore() ), "MMScoreboardFont", width*0.72, 7*hratio, NameColor, TEXT_ALIGN_CENTER )
				draw.DrawText( tostring( v:Deaths() ), "MMScoreboardFont", width*0.8, 7*hratio, NameColor, TEXT_ALIGN_CENTER )
				draw.DrawText( tostring( v:Ping() ), "MMScoreboardFont", width*0.87, 7*hratio, NameColor, TEXT_ALIGN_CENTER )

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
		AvatarButton:SetPos( 4*wratio, 4*hratio )
		AvatarButton:SetSize( 36*wratio, 36*hratio )
		function AvatarButton:DoClick()
			v:ShowProfile()
		end
		if v != LocalPlayer() then
			MuteButton = Rows:Add( "DImageButton" )
			MuteButton:SetParent( PlayerBox )
			MuteButton:Dock( NODOCK )
			MuteButton:SetPos( 662*wratio, 6*hratio )
			MuteButton:SetSize( 32*wratio, 32*hratio )
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
		Back2:Remove()
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