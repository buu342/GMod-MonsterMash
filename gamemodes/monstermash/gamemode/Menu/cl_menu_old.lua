if CLIENT then
	local tab = 0
    function Class_Menu2(ply)
        if true then
            return
        end
		//{				-- Setup
		local modeltable={
			"models/monstermash/deer_haunter_final.mdl",
			"models/monstermash/vampire_final.mdl",
			"models/monstermash/nosferatu_final.mdl",
			"models/monstermash/guest_final.mdl",
			"models/monstermash/scarecrow_final.mdl",
			"models/monstermash/skeleton_final.mdl",
			"models/monstermash/witch_final.mdl",
			"models/monstermash/headless_horseman_final.mdl",
			"models/monstermash/stein_final.mdl",
			"models/monstermash/mummy_final.mdl",
			"models/monstermash/bloody_mary_final.mdl"
			}
		local SelectedModel = ""	
		
		
		local Frame3 = vgui.Create( "DFrame" )
        local width2 = 1
        local height2 = 1
        Frame3:SetPos( 0,0	)
        Frame3:SetSize( 1,1 )
		Frame3:ShowCloseButton( false )
        Frame3:SetParent(Frame)
        Frame3:SetBackgroundBlur( true )
		
		local Frame2 = vgui.Create( "DFrame" )
        local width2 = 1
        local height2 = 1
        Frame2:SetPos( 0,0	)
		Frame2:SetTitle( "" )
        Frame2:SetSize( ScrW(),ScrH() )
        Frame2:SetParent(Frame)
		Frame2:ShowCloseButton( false )
		Frame2.Paint = function(self,width,height)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material("vgui/Logo") )
			surface.DrawTexturedRect( (ScrW()/2)-256,0,512,256 )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material("vgui/Mash") )
			surface.DrawTexturedRect( (ScrW()/2)-256,(ScrH())-256,512,256 )
			surface.SetFont( "DebugFixed" )
			surface.SetTextColor( 255, 255, 255, 255 )
			local text = "Version 0.9 Beta"
			local w, h = surface.GetTextSize( text )
			surface.SetTextPos( ScrW()/2 - ( w / 2 ), 120 - ( h / 2 )+48 )
			surface.DrawText( text )
			w = 8
			surface.SetFont( "Trebuchet18" )
			surface.SetTextPos( w,ScrH()-8-216 )
			surface.DrawText( "Credits:" )
			surface.SetTextPos( w,ScrH()-8-198 )
			surface.DrawText( "Main Programmer - Buu342" )
			surface.SetTextPos( w,ScrH()-8-180 )
			surface.DrawText( "Modeler/Director - CougarMagnum" )
			surface.SetTextPos( w,ScrH()-8-162 )
			surface.DrawText( "Playtesters - Blargh" )
			surface.SetTextPos( w+67,ScrH()-8-144 )
			surface.DrawText( "- Maximus0451" )
			surface.SetTextPos( w+67,ScrH()-8-126 )
			surface.DrawText( "- Mr. Serious" )
			surface.SetTextPos( w+67,ScrH()-8-108 )
			surface.DrawText( "- DrHammer" )
			surface.SetTextPos( w+67,ScrH()-8-90 )
			surface.DrawText( "- Rex" )
			surface.SetTextPos( w+67,ScrH()-8-72 )
			surface.DrawText( "- Billion SL" )
			surface.SetTextPos( w+67,ScrH()-8-54 )
			surface.DrawText( "- Der Vampir" )
			surface.SetTextPos( w+67,ScrH()-8-36 )
			surface.DrawText( "- Tazer Man" )
			surface.SetTextPos( w,ScrH()-8-18 )
			if game.GetMap() == "gm_construct" then
			surface.DrawText( "Current map: "..game.GetMap().." created by gayrry" )
			else
			surface.DrawText( "Current map: "..game.GetMap() )
			end
		end
		

		local width = 350
        local Frame = vgui.Create( "DFrame" )
		if tab == 0 then
			width = 350
		else
			width = 620
		end
        local height = 600
		if tab == 0 then
			height = 500
		else
			height = 600
		end
        Frame:SetPos( (ScrW()/2)-width/2, (ScrH()/2)-height/2 )
        Frame:SetSize( width, height )
        Frame:SetTitle( "" )
        Frame:SetVisible( true )
        Frame:SetDraggable( false )
        Frame:ShowCloseButton( false )
        Frame:MakePopup()
        Frame.Paint = function( self, width, height )
            draw.RoundedBox( 0, 0, 0, width, height, Color( 255, 150, 0, 150 ) )
        end
        Frame.OnClose = function()
            Frame2:Close()
			Frame3:Close()
			LocalPlayer():SetNWString("LastClick","")
        end
		//}
		
		if tab == 0 then	-- Characters
		
			/*-------------------------------------------------
								Setup
			-------------------------------------------------*/
		
			//{
			
			local ply = LocalPlayer()
			BGPanel2 = vgui.Create( "DPanel",Frame )
			BGPanel2:SetPos( 0,16 )
			BGPanel2:SetSize( 200, 400 )		
			BGPanel2.Paint = function( self, width, height )
				draw.RoundedBox( 0, 0, 0, width, height, Color( 0, 0, 0, 0 ) )
			end
			
			local Button = vgui.Create( "DButton", Frame )
			Button:SetText( "Loadout" )
			Button:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button:SetPos( 52, 16 )
			Button:SetSize( 100, 30 )
			Button.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			function Button:DoClick()
				tab = 1
				Frame:Close()
				LocalPlayer():SetNWString("LastClick","")
				LocalPlayer():ConCommand("mm_menu2")
			end
			
			local mdl = vgui.Create( "DModelPanel", BGPanel2 )
			mdl:SetSize( BGPanel2:GetSize() )
			mdl:SetCamPos( Vector( 40,0, 50 ) )
			mdl:SetAnimated( false )
			mdl:SetAnimSpeed( 0 )
			mdl:SetModel( ply:GetNWString("plymdl") )
			mdl.Entity:SetSkin(ply:GetNWString("plyskn"))
			function mdl:LayoutEntity( Entity ) return end
			local function UpdateSkin()
			mdl.Entity:SetSkin( ply:GetNWString("plyskn") )
			end
			
			local function UpdateFromConvars()
				mdl:SetModel( ply:GetNWString("plymdl") )
				mdl.Entity:SetSkin( ply:GetNWString("plyskn") )
			end
			
			//}
			
			/*-------------------------------------------------
							Skin Buttons
			-------------------------------------------------*/
			
			//{ 
			local SkinButton = vgui.Create( "DButton", Frame )
			SkinButton:SetText( "1" )
			SkinButton:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton:SetPos( 52, 454-32 )
			SkinButton:SetSize( 30, 30 )
			function SkinButton:DoClick()
				ply:SetNWInt("plyskn",0)
				net.Start("MMSkin")
				net.WriteInt(0,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			local SkinButton2 = vgui.Create( "DButton", Frame )
			SkinButton2:SetText( "2" )
			SkinButton2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton2:SetPos( 52+35, 454-32 )
			SkinButton2:SetSize( 30, 30 )
			function SkinButton2:DoClick()
				ply:SetNWInt("plyskn",1)
				net.Start("MMSkin")
				net.WriteInt(1,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			local SkinButton3 = vgui.Create( "DButton", Frame )
			SkinButton3:SetText( "3" )
			SkinButton3:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton3:SetPos( 52+70, 454-32 )
			SkinButton3:SetSize( 30, 30 )
			function SkinButton3:DoClick()
				ply:SetNWInt("plyskn",2)
				net.Start("MMSkin")
				net.WriteInt(2,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			local SkinButton4 = vgui.Create( "DButton", Frame )
			SkinButton4:SetText( "4" )
			SkinButton4:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton4:SetPos( 52, 454-64 )
			SkinButton4:SetSize( 30, 30 )
			function SkinButton4:DoClick()
				ply:SetNWInt("plyskn",3)
				net.Start("MMSkin")
				net.WriteInt(3,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			local SkinButton5 = vgui.Create( "DButton", Frame )
			SkinButton5:SetText( "5" )
			SkinButton5:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton5:SetPos( 52+35, 454-64 )
			SkinButton5:SetSize( 30, 30 )
			function SkinButton5:DoClick()
				ply:SetNWInt("plyskn",4)
				net.Start("MMSkin")
				net.WriteInt(4,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			local SkinButton6 = vgui.Create( "DButton", Frame )
			SkinButton6:SetText( "6" )
			SkinButton6:SetTextColor(  Color( 255, 150, 0, 255 ) )
			SkinButton6:SetPos( 52+70, 454-64 )
			SkinButton6:SetSize( 30, 30 )
			function SkinButton6:DoClick()
				ply:SetNWInt("plyskn",5)
				net.Start("MMSkin")
				net.WriteInt(5,5)
				net.SendToServer()
				UpdateSkin() 
				timer.Simple( 0.1, function() UpdateSkin() end )
			end
			
			
			local function ResetDeerHaunterStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			local function ResetVampireStuffButton()
				SkinButton:SetPos( 52, 454-32 )
				SkinButton.Paint = function()
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 200, 200, 200, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall()/2 )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton2:SetPos( 52+35, 454-32 )
				SkinButton2.Paint = function()
					surface.SetDrawColor( 150, 150, 150, 255 )
					surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall()/2 )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				SkinButton3:SetPos( 52+70, 454-32 )
				SkinButton3.Paint = function()
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 57, 19, 18, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall()/2 )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			local function ResetNosferatuStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			local function ResetGuestStuffButton()
				SkinButton:SetPos( 52, 454-64 )
				SkinButton.Paint = function()
					surface.SetDrawColor( 26, 26, 26, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton2:SetPos( 52+35, 454-64 )
				SkinButton2.Paint = function()
					surface.SetDrawColor( 62, 64, 62, 255 )
					surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				SkinButton3:SetPos( 52+70, 454-64 )
				SkinButton3.Paint = function()
					surface.SetDrawColor( 86, 72, 54, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton4:SetPos( 52, 454-32 )
				SkinButton4.Paint = function()
					surface.SetDrawColor( 16, 24, 33, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton5:SetPos( 52+35, 454-32 )
				SkinButton5.Paint = function()
					surface.SetDrawColor( 47, 25, 19, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton6:SetPos( 52+70, 454-32 )
				SkinButton6.Paint = function()
					surface.SetDrawColor( 143, 148, 135, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
			end
			
			local function ResetScarecrowStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			local function ResetSkeletonStuffButton()
				SkinButton:SetPos( 52+17, 454-64 )
				SkinButton.Paint = function()
					surface.SetDrawColor( 219, 215, 195, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton2:SetPos( 52+35+18, 454-64 )
				SkinButton2.Paint = function()
					surface.SetDrawColor( 205, 199, 165, 255 )
					surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				SkinButton3:SetPos( 52+17, 454-32 )
				SkinButton3.Paint = function()
					surface.SetDrawColor( 112, 107, 85, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton4:SetPos( 52+35+18, 454-32 )
				SkinButton4.Paint = function()
					surface.SetDrawColor( 103, 60, 45, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton5:SetPos( 10000,10000 )
				SkinButton6:SetPos( 10000,10000 )
			end
			
			local function ResetWitchStuffButton()
				SkinButton:SetPos( 52+17, 454-64 )
				SkinButton.Paint = function()
					surface.SetDrawColor( 152, 60, 16, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton2:SetPos( 52+35+18, 454-64 )
				SkinButton2.Paint = function()
					surface.SetDrawColor( 92, 139, 35, 255 )
					surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				SkinButton3:SetPos( 52+17, 454-32 )
				SkinButton3.Paint = function()
					surface.SetDrawColor( 122, 48, 160, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton4:SetPos( 52+35+18, 454-32 )
				SkinButton4.Paint = function()
					surface.SetDrawColor( 143, 16, 16, 255 )
					surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton5:SetPos( 10000,10000 )
				SkinButton6:SetPos( 10000,10000 )
			end
			
			local function ResetHeadlessHorsemanStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end

			local function ResetSteinStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end

			local function ResetMummyStuffButton()
				SkinButton:SetPos( 52+17, 454-32 )
				SkinButton.Paint = function()
					surface.SetDrawColor( 187, 188, 175, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton2:SetPos( 52+35+18, 454-32 )
				SkinButton2.Paint = function()
					surface.SetDrawColor( 73, 65, 51, 255 )
					surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			local function ResetBloodyMaryStuffButton()
				SkinButton:SetPos( 1000, 10000 )
				SkinButton2:SetPos( 1000, 10000 )
				SkinButton3:SetPos( 1000, 10000 )
				SkinButton4:SetPos( 1000, 10000 )
				SkinButton5:SetPos( 1000, 10000 )
				SkinButton6:SetPos( 1000, 10000 )
			end
			
			if ply:GetNWString("plymdl") == "models/monstermash/deer_haunter_final.mdl" then
			ResetDeerHaunterStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/vampire_final.mdl" then
			ResetVampireStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/nosferatu_final.mdl" then
			ResetNosferatuStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/guest_final.mdl" then
			ResetGuestStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/scarecrow_final.mdl" then
			ResetScarecrowStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/skeleton_final.mdl" then
			ResetSkeletonStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/witch_final.mdl" then
			ResetWitchStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/headless_horseman_final.mdl" then
			ResetHeadlessHorsemanStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/stein_final.mdl" || ply:GetNWString("plymdl") == "models/monstermash/random_character.mdl" then
			ResetSteinStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/mummy_final.mdl" then
			ResetMummyStuffButton()
			elseif ply:GetNWString("plymdl") == "models/monstermash/bloody_mary_final.mdl" then
			ResetBloodyMaryStuffButton()
			end
			
			local function ModelRandomizer()
				modelchosen = table.Random( modeltable ) 
				timer.Simple(0.1,function() ModelRandomizer() end)
			end
			//}
			
			/*-------------------------------------------------
							Model Buttons
			-------------------------------------------------*/

			//{
			
			local model = "models/monstermash/deer_haunter_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80, 16+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			mdl:SetSkin(ply:GetNWInt("plyskn"))
			function mdl:DoClick()
				
				ResetDeerHaunterStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/vampire_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80,83+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetVampireStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/nosferatu_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80,150+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetNosferatuStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/guest_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80,217+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetGuestStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/scarecrow_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80,284+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetScarecrowStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/skeleton_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-80,351+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetSkeletonStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/witch_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,284+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetWitchStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/headless_horseman_final.mdl" 
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,16+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetHeadlessHorsemanStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/stein_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,83+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetSteinStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/mummy_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,150+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetMummyStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/bloody_mary_final.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,217+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				ResetBloodyMaryStuffButton()
				SelectedModel = model
				ply:SetNWString("plymdl",model)
				net.Start("MMPlyModel")
				net.WriteString(model)
				net.SendToServer()
				timer.Simple( 0.1, function() UpdateFromConvars() end )
			end
			
			local model = "models/monstermash/random_character.mdl"
			BGPanel = vgui.Create( "DPanel",Frame )
			BGPanel:SetPos( width-148,351+32 )
			BGPanel:SetSize( 64, 64 )		
			local mdl = vgui.Create( "SpawnIcon", BGPanel )
			mdl:SetSize( BGPanel:GetSize() )
			mdl:SetModel( model )
			function mdl:DoClick()
				
				modelchosen = "models/monstermash/random_character.mdl"
				SelectedModel = "models/monstermash/random_character.mdl"
				ResetSteinStuffButton()
				
				timer.Simple( 0.1, function() UpdateSkin() end )
				ply:SetNWString("plymdl",modelchosen)
				net.Start("MMPlyModel")
				net.WriteString(modelchosen)
				net.SendToServer()
				
				ply:SetNWInt("plyskn",math.random(0,5))
				net.Start("MMSkin")
				net.WriteInt(1,5)
				net.SendToServer()
				UpdateSkin()
				
				timer.Simple( 0.01, function() UpdateFromConvars() end )
			end
			
			// }
			
			UpdateFromConvars()
			
			/*-------------------------------------------------
							Spawn Button
			-------------------------------------------------*/
			
		    // {
			
			local Button = vgui.Create( "DButton", Frame )
			Button:SetText( "Spawn" )
			Button:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button:SetPos( 52, 454 )
			Button:SetSize( 100, 30 )
			Button.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			function Button:DoClick()
				if ply:GetNWString("Melee") == "" && ply:GetNWString("Handgun") == "" && ply:GetNWString("Primary") == "" && ply:GetNWString("Throwable") == "" then
				LocalPlayer():ConCommand("Play buttons/button10.wav")
				else
				net.Start("MMTeam")
				net.SendToServer()
				Frame:Close()
				LocalPlayer():SetNWString("LastClick","")
				end
			end
			if ply:GetNWString("Melee") == "" && ply:GetNWString("Handgun") == "" && ply:GetNWString("Primary") == "" && ply:GetNWString("Throwable") == "" then
				local text = vgui.Create("DLabel", Frame)
				text:SetPos(154,457)
				text:SetColor( Color( 0, 0, 0, 255 ) )
				text:SetFont("default")
				text:SetText("You may only spawn once you have\n selected your loadout")
				text:SizeToContents()
			end
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(width-104, 32)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Monsters")
			text:SizeToContents()
			//}
		
		end
	
		if tab == 1 then	-- Loadout
		
			/* ------------------------------------------------
								Setup
			-------------------------------------------------*/	

			//{ 
			local ply = LocalPlayer()
			BGPanel2 = vgui.Create( "DPanel",Frame )
			BGPanel2:SetPos( 0,16 )
			BGPanel2:SetSize( 200, 400 )
			BGPanel2.Paint = function( self, width, height )
				draw.RoundedBox( 0, 0, 0, width, height, Color( 0, 0, 0, 0 ) )
			end
			
			local Button = vgui.Create( "DButton", Frame )
			Button:SetText( "Character" )
			Button:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button:SetPos( 52, 16 )
			Button:SetSize( 100, 30 )
			Button.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			function Button:DoClick()
				tab = 0
				LocalPlayer():ConCommand("mm_menu2")
				Frame:Close()
				LocalPlayer():SetNWString("LastClick","")
			end
			
			local Button = vgui.Create( "DButton", Frame )
			Button:SetText( "Spawn" )
			Button:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button:SetPos( 470, 16 )
			Button:SetSize( 100, 30 )
			Button.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			function Button:DoClick()
				if ply:GetNWString("Melee") == "" && ply:GetNWString("Handgun") == "" && ply:GetNWString("Primary") == "" && ply:GetNWString("Throwable") == "" then
				LocalPlayer():ConCommand("Play buttons/button10.wav")
				else
				net.Start("MMTeam")
				net.SendToServer()
				Frame:Close()
				LocalPlayer():SetNWString("LastClick","")
				end
			end
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(50,80)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Melee:")
			text:SizeToContents()
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(165,80)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Side Arms:")
			text:SizeToContents()
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(285,80)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Primary:")
			text:SizeToContents()
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(400,80)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Throwables:")
			text:SizeToContents()
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(532,80)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Buffs:")
			text:SizeToContents()
			
			local text = vgui.Create("DLabel", Frame)
			local texty = vgui.Create("DLabel", Frame)
			local function RefreshMenu()
				
				text:SetPos(225,24)
				text:SetColor( Color( 0, 0, 0, 255 ) )
				text:SetFont("default")
				text:SetText("Gold: "..LocalPlayer():GetNWInt("gold"))
				text:SizeToContents()
				text:CenterHorizontal()

				
				texty:SetPos(8,height-16)
				texty:SetColor( Color( 0, 0, 0, 255 ) )
				texty:SetFont("default")
				if LocalPlayer():GetNWString("LastClick") == "mm_knife" then
				texty:SetText("Tip: With this weapon you lunge at and instant kill players with a backstab.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_boner" then
				texty:SetText("Tip: Killing players with this weapon drops medkits.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_scythe" then
				texty:SetText("Tip: This weapon has long reach.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_battleaxe" then
				texty:SetText("Tip: This weapon instant kills.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_shield" then
				texty:SetText("Tip: Right click to shield yourself.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_sawedoff" || LocalPlayer():GetNWString("LastClick") == "mm_pumpshotgun" then
				texty:SetText("Tip: This weapon has limited range.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_coachgun" then
				texty:SetText("Tip: This weapon is very powerful but has limited range.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_musketpistol" then
				texty:SetText("Tip: Hold left click to charge up your shot for maximum damage.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_battlerifle" then
				texty:SetText("Tip: You can only reload once the clip is empty.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_huntingrifle" then
				texty:SetText("Tip: You can only shoot while scoped. Headshots deal 2x damage.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_urn" then
				texty:SetText("Tip: Stuns enemies caught within explosion. Hold left click to throw further.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_skull" then
				texty:SetText("Tip: Hold left click to throw further.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_pumpkinnade" then
				texty:SetText("Tip: Hold left click to throw further. Explodes on impact.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_gorejar" then
				texty:SetText("Tip: Hold left click to throw further. slows enemies and jams their guns.")
				elseif LocalPlayer():GetNWString("LastClick") == "mm_cannon" then
				texty:SetText("Tip: Hold left click to shoot further. Explodes on impact.")
				elseif LocalPlayer():GetNWString("LastClick") == "armor" then
				texty:SetText("Tip: Decreases damage by 25% at the cost of speed.")
				else
				texty:SetText("")
				end
				texty:SizeToContents()
				
			end
			
			
			RefreshMenu()
			
			local checkbox = vgui.Create( "DCheckBoxLabel", Frame )
			checkbox:SetPos( 590, height-17 )
			checkbox:SetText("")
			checkbox:SizeToContents()
			checkbox:SetConVar( "mm_aimenable" )
			
			local text = vgui.Create("DLabel", Frame)
			text:SetPos(530,height-16)
			text:SetColor( Color( 0, 0, 0, 255 ) )
			text:SetFont("default")
			text:SetText("Aim assist:")
			text:SizeToContents()
			
			//}
			
			/* ------------------------------------------------
								MELEE
			-------------------------------------------------*/	

			//{
			
			local w = 20
			local h = 100
			local space = 35
			local cost,wep
			
			//{ 		--None--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetMouseInputEnabled( true )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				Button2:SetText( "None" )
				if LocalPlayer():GetNWString("Melee") == "" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 0
				wep = ""
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			
			h = h+space
			//}
			
			//{ 		--Boner--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetMouseInputEnabled( true )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 5 Gold" )
				else
					Button2:SetText( "Boner" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_boner" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 5
				wep = "mm_boner"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			
			h = h+space
			//}

			//{  		--Knife--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 10 Gold" )
				else
					Button2:SetText( "Knife" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_knife" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 10
				wep = "mm_knife"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
		
			//{  		--Shovel--	
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetText( "Shovel" )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 15 Gold" )
				else
					Button2:SetText( "Shovel" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_shovel" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 15
				wep = "mm_shovel"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
		
			//{  		--Hook--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 15 Gold" )
				else
					Button2:SetText( "Hook" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_hook" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 15
				wep = "mm_hook"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{  		--Fencepost--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 20 Gold" )
				else
					Button2:SetText( "Fencepost" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_fencepost" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				local cost = 20
				local wep = "mm_fencepost"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{  		--Saw--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 20 Gold" )
				else
					Button2:SetText( "Saw" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_hacksaw" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 20
				wep = "mm_hacksaw"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Pitchfork--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 25 Gold" )
				else
					Button2:SetText( "Pitchfork" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_pitchfork" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 25
				wep = "mm_pitchfork"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Axe--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 25 Gold" )
				else
					Button2:SetText( "Axe" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_axe" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 25
				wep = "mm_axe"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Mace--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 30 Gold" )
				else
					Button2:SetText( "Mace" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_mace" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 30
				wep = "mm_mace"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Sword--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 30 Gold" )
				else
					Button2:SetText( "Sword" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_sword" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 30
				wep = "mm_sword"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{  		--Stake--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 35 Gold" )
				else
					Button2:SetText( "Stake" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_stake" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 35
				wep = "mm_stake"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Scythe--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 40 Gold" )
				else
					Button2:SetText( "Scythe" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_scythe" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 40
				wep = "mm_scythe"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{  		--Battleaxe--
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 50 Gold" )
				else
					Button2:SetText( "Battle Axe" )
				end
				if LocalPlayer():GetNWString("Melee") == "mm_battleaxe" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				local cost = 50
				local wep = "mm_battleaxe"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Melee") >= cost then
					net.Start("MM_Wep_Melee")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Melee"))
					LocalPlayer():SetNWInt("lastcost_Melee",cost)
					LocalPlayer():SetNWString("Melee",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//}
			
			/* ------------------------------------------------
								HANDGUNS
			-------------------------------------------------*/	

			//{
			
			local w = 140
			local h = 100
			local space = 35
			local cost,wep
	
			//{ 		--None--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				Button2:SetText( "None" )
				if LocalPlayer():GetNWString("Handgun") == "" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 0
				wep = ""
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Revolver--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 15 Gold" )
				else
					Button2:SetText( "Revolver" )
				end
				if LocalPlayer():GetNWString("Handgun") == "mm_revolver" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 15
				wep = "mm_revolver"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Pistol--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 20 Gold" )
				else
					Button2:SetText( "Pistol" )
				end
				if LocalPlayer():GetNWString("Handgun") == "mm_colt" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 20
				wep = "mm_colt"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--Shield--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 25 Gold" )
				else
					Button2:SetText( "Shield + Revolver" )
				end
				if LocalPlayer():GetNWString("Handgun") == "mm_shield" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 25
				wep = "mm_shield"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Sawed Off--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 30 Gold" )
				else
					Button2:SetText( "Sawed Off" )
				end
				if LocalPlayer():GetNWString("Handgun") == "mm_sawedoff" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 30
				wep = "mm_sawedoff"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Dueling Pistol--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 40 Gold" )
				else
					Button2:SetText( "Dueling Pistol" )
				end
				if LocalPlayer():GetNWString("Handgun") == "mm_musketpistol" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 40
				wep = "mm_musketpistol"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Handgun") >= cost then
					net.Start("MM_Wep_Handgun")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Handgun"))
					LocalPlayer():SetNWInt("lastcost_Handgun",cost)
					LocalPlayer():SetNWString("Handgun",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//}
			
			/* ------------------------------------------------
								PRIMARY
			-------------------------------------------------*/	

			//{
			local w = 260
			local h = 100
			local space = 35
			local cost,wep

			//{ 		--None--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				Button2:SetText( "None" )
				if LocalPlayer():GetNWString("Primary") == "" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 0
				wep = ""
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}			

			//{ 		--Crossbow--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 25 Gold" )
				else
					Button2:SetText( "Crossbow" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_crossbow" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 25
				wep = "mm_crossbow"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--Pump Shotgun--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 30 Gold" )
				else
					Button2:SetText( "Pump Shotgun" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_pumpshotgun" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 30
				wep = "mm_pumpshotgun"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Undertaker--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 35 Gold" )
				else
					Button2:SetText( "Undertaker" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_undertaker" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 35
				wep = "mm_undertaker"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
            
            //{ 		--Repeater--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 40 Gold" )
				else
					Button2:SetText( "Repeater" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_repeater" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 40
				wep = "mm_repeater"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--Battle Rifle--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 50 Gold" )
				else
					Button2:SetText( "Battle Rifle" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_battlerifle" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 50
				wep = "mm_battlerifle"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--Flamethrower--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 55 Gold" )
				else
					Button2:SetText( "Flamethrower" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_flamethrower" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 55
				wep = "mm_flamethrower"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
            
            //{ 		--Sawblade Launcher--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 60 Gold" )
				else
					Button2:SetText( "Saw Launcher" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_sawblade" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 60
				wep = "mm_sawblade"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Coach Gun--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 60 Gold" )
				else
					Button2:SetText( "Coach Gun" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_coachgun" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 60
				wep = "mm_coachgun"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--Cannon--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 70 Gold" )
				else
					Button2:SetText( "Cannon" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_cannon" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 70
				wep = "mm_cannon"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
			//{ 		--De-Animator--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 75 Gold" )
				else
					Button2:SetText( "De-Animator" )
				end
				if LocalPlayer():GetNWString("Primary") == "mm_deanimator" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 75
				wep = "mm_deanimator"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Primary") >= cost then
					net.Start("MM_Wep_Primary")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Primary"))
					LocalPlayer():SetNWInt("lastcost_Primary",cost)
					LocalPlayer():SetNWString("Primary",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//}
			
			/* ------------------------------------------------
								THROWABLE
			-------------------------------------------------*/	

			//{
			
			local w = 380
			local h = 100
			local space = 35
			local cost,wep

			//{ 		--None--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				Button2:SetText( "None" )
				if LocalPlayer():GetNWString("Throwable") == "" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 0
				wep = ""
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}			
			
			//{ 		--Skull--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 10 Gold" )
				else
					Button2:SetText( "Skull" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_skull" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 10
				wep = "mm_skull"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}			
			
			//{ 		--Meat Cleaver--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 10 Gold" )
				else
					Button2:SetText( "Meat Cleaver" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_cleaver" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 10
				wep = "mm_cleaver"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
            
            //{ 		--Spider 'Nade--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 15 Gold" )
				else
					Button2:SetText( "Spider 'Nade" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_spidernade" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 15
				wep = "mm_spidernade"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}
			
            //{ 		--Gore Jar--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 20 Gold" )
				else
					Button2:SetText( "Gore Jar" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_gorejar" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 20
				wep = "mm_gorejar"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}	
            
            //{ 		--Haunted Urn--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 25 Gold" )
				else
					Button2:SetText( "Haunted Urn" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_urn" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 25
				wep = "mm_urn"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}			
			
			//{ 		--Acid Flask--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 30 Gold" )
				else
					Button2:SetText( "Acid Flask" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_acidflask" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 30
				wep = "mm_acidflask"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}

			//{ 		--Pumpkin 'Nade--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 35 Gold" )
				else
					Button2:SetText( "Pumpkin 'Nade" )
				end
				if LocalPlayer():GetNWString("Throwable") == "mm_pumpkinnade" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 35
				wep = "mm_pumpkinnade"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Throwable") >= cost then
					net.Start("MM_Wep_Throwable")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Throwable"))
					LocalPlayer():SetNWInt("lastcost_Throwable",cost)
					LocalPlayer():SetNWString("Throwable",wep)
					RefreshMenu()
				end
			end
			h = h+space
			//}	
		
			//}

			/* ------------------------------------------------
								  BUFFS
			-------------------------------------------------*/	

			//{
			
			local w = 500
			local h = 100
			local space = 35
			local cost,wep
			
			//{ 		--None--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetMouseInputEnabled( true )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				Button2:SetText( "None" )
				if LocalPlayer():GetNWString("Buff") == "" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 0
				wep = ""
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Buff") >= cost then
					net.Start("MM_Wep_Buff")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Buff"))
					LocalPlayer():SetNWInt("lastcost_Buff",cost)
					LocalPlayer():SetNWString("Buff",wep)
					RefreshMenu()
				end
			end
			
			h = h+space
			//}
			
			//{ 		--Armor--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetMouseInputEnabled( true )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 5 Gold" )
				else
					Button2:SetText( "Armor" )
				end
				if LocalPlayer():GetNWString("Buff") == "armor" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 5
				wep = "armor"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Buff") >= cost then
					net.Start("MM_Wep_Buff")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Buff"))
					LocalPlayer():SetNWInt("lastcost_Buff",cost)
					LocalPlayer():SetNWString("Buff",wep)
					RefreshMenu()
				end
			end
			
			h = h+space
			//}
	
			//{ 		--Double Jump--		
			local Button2 = vgui.Create( "DButton", Frame )
			Button2:SetMouseInputEnabled( true )
			Button2:SetTextColor(  Color( 255, 150, 0, 255 ) )
			Button2:SetPos( w, h )
			Button2:SetSize( 100, 30 )
			Button2.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall() )
				surface.SetDrawColor( 20, 20, 20, 255 )
				surface.DrawRect( 0, 0, Button:GetWide(), Button:GetTall()/2 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				if Button2:IsHovered() == true then
					Button2:SetText( "Cost: 5 Gold" )
				else
					Button2:SetText( "Double Jump" )
				end
				if LocalPlayer():GetNWString("Buff") == "double_jump" then
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawOutlinedRect( 0, 0, Button:GetWide(), Button:GetTall() )
					surface.DrawOutlinedRect( 1, 1, Button:GetWide()-2, Button:GetTall()-2 )
				end
			end
			function Button2:DoClick()
				cost = 5
				wep = "double_jump"
				LocalPlayer():SetNWString("LastClick",wep)
				if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt("lastcost_Buff") >= cost then
					net.Start("MM_Wep_Buff")
					net.WriteString(wep)
					net.WriteFloat(cost)
					net.SendToServer()
					LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-cost+LocalPlayer():GetNWInt("lastcost_Buff"))
					LocalPlayer():SetNWInt("lastcost_Buff",cost)
					LocalPlayer():SetNWString("Buff",wep)
					RefreshMenu()
				end
			end
			
			h = h+space
			//}	
			//}
			
		end

	end
end
concommand.Add( "mm_menu2", Class_Menu2 )
usermessage.Hook( "mm_menu2", Class_Menu2 )