if SERVER then return end

local version = "Version 1.0 Release" 
local panic_button = false

function SimpleButtonPaint(self, w, h)
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
    draw.RoundedBox( 0, 0, 0, 2, h, Color(0,0,0,255) )
    draw.RoundedBox( 0, w-2, 0, 2, h, Color(0,0,0,255) )
    draw.RoundedBox( 0, 0, 0, w, 2, Color(0,0,0,255) )
    draw.RoundedBox( 0, 0, h-2, w, 2, Color(0,0,0,255) )
end

function SimpleButtonPaintCheck(self, w, h, check)
    local col = Color(0,0,0,255)
    if check then
        col = Color(0,0,255,255)
    end
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
    draw.RoundedBox( 0, 0, 0, 2, h, col )
    draw.RoundedBox( 0, w-2, 0, 2, h, col )
    draw.RoundedBox( 0, 0, 0, w, 2, col )
    draw.RoundedBox( 0, 0, h-2, w, 2, col)
end

function Class_Menu()
    local ply = LocalPlayer()
	local menuw = 640
	local menuh = 480
    local padding = 4
    local buttons = 5
    local tabheight = 32
    local flash = 0
    
    surface.PlaySound("ui/vending_shoot.wav")
    
    if LocalPlayer():GetNWString("Category") == "" then
        LocalPlayer():SetNWString("Category", "melee")
    end
    
    /*-------------------------------------------------
                       Initial Setup
    -------------------------------------------------*/
    
    //{
    local modeltable = {
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
        "models/monstermash/bloody_mary_final.mdl",
    }
    local SelectedModel = ""	
    
    local stories = math.random(1,8)
    local welcomemessage =  "Gain points for killing others with style, or leave them to wander the earth without any arms. If you stay long enough, the mash might be interrupted by something else...\n\nSelect your monster, carefully consider the budget on your weapon loadout (or return the weapon or a full refund), and press the Spawn button to join the graveyard smash."
                            
    local story1 =  "After the demise of Bobby Pickett, and the unfortunate cocaine addiction of The Coffin Bangers' main singer, the monsters had nowhere else to go and have chosen to fufill their everlasting need for bloodlust in one final mash."
    local story2 =  "1 day yuo go to a garage sale and buy a vidoe game named 'Monster MAsh' and decide what the heck I should play it bcause it is almost halloween time but then the game sucked you into the computer becaus it was really haunted and have too fight all of the spooky monsters! The game mode your playing now is realy  your fight for survival dont get killed or you will die!!!!!!"
    local story3 =  "I was working in the lab late one night when my eyes beheld an eerie sight, for my monsters from their slabs began to rise, and suddenly to my surprise, they did the mash! They did the monster mash! It was a graveyard smash! It caught on in a flash! They did the monster mash!"
    local story4 =  "It's that time of the year again. When the leaves crumple and fall amidst the chilly autumn air, the days get shorter and the nights get longer, and the monsters are out to do their monster mash! With Halloween approaching fast, all of the monsters have resorted to a battle royale to fight for the title of Crypt Keeper and to become the lord of the the Samhain Season!"
    local story5 =  "Little Timmy down the street's parents are letting him host the ultimate Halloween party and you're invited! Timmy spent all of his allowance on nerf guns and spooky costumes for all his friends and the whole neighborhood is in on it! Put your costume on, bring your imagination, fill up on some sugary treats, and get ready to mash!"
    local story6 =  "Following up on your invitation for your audition to the next big Halloween movie 'Monster Mash', you arrive at the set and are given quite the task. Take down the other actors in the most spectacular fashions you can think of to become the star!"
    local story7 =  "You were hibernating in your coffin when one day you heard some commotion coming from the ground above and disturbing your beauty sleep. Aggitated, you climb out of your grave to see what the fuss is about. It's time to dust off the old guns, shut this party down, and get back to resting in peace!"
    local story8 =  "The doctor was working in his lab late one night when you decided it was time to for a change in sight. From your slab you began to rise and suddenly, and to his surprise, you did the mash! Well it seems like from the laboratory in the castle east, to the master bedroom where vampires feast, all the other monsters were doing the mash as well, but who will be the life of the party?"

    if table.HasValue(admins, LocalPlayer():SteamID()) then
        buttons = 6
    end
    
    //}
    
    
    /*-------------------------------------------------
                        Main Frame
    -------------------------------------------------*/

    //{    
    // Fade background
    local Frame3 = vgui.Create( "DFrame" )
    local width2 = 1
    local height2 = 1
    Frame3:SetPos( 0,0	)
    Frame3:SetSize( 1,1 )
    Frame3:SetDraggable(false)
    Frame3:ShowCloseButton( false )
    Frame3:SetParent(Frame)
    if GetConVar("mm_blurmenu"):GetInt() == 1 then
        Frame3:SetBackgroundBlur( true )
    else
        Frame3:SetBackgroundBlur( false )
    end
    
    // Title and other info
    local Frame2 = vgui.Create( "DFrame" )
    local width2 = 1
    local height2 = 1
    Frame2:SetPos( 0,0	)
    Frame2:SetTitle( "" )
    Frame2:SetSize( ScrW(),ScrH() )
    Frame2:SetDraggable(false)
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
        local text = version
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
        surface.DrawText( "Modeler/Director - Demo" )
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
        if game.GetMap() == "mm_harvest_v1" then
            surface.DrawText( "Current map: "..game.GetMap().." created by Demo" )
        elseif game.GetMap() == "mm_village" then
            surface.DrawText( "Current map: "..game.GetMap().." created by Billion" )
        else
            surface.DrawText( "Current map: "..game.GetMap() )
        end
    end
    
    // The actual frame
    local Frame = vgui.Create("DFrame")
	Frame:SetSize(menuw, menuh)
	Frame:SetPos( (ScrW()/2) - (menuw/2), (ScrH()/2) - (menuh/2) )
	Frame:SetTitle("")
    Frame:SetDraggable(false)
	Frame:ShowCloseButton(false)
	Frame:MakePopup()
	Frame.Paint = function()
	end
    Frame.OnClose = function()
        Frame2:Close()
        Frame3:Close()
    end
    
    // Panic Button
    if panic_button then
        local ClipSize = vgui.Create( "DButton" )
        ClipSize:SetPos( 16, 16 )
        ClipSize:SetParent( Frame2 )	
        ClipSize:SetText( "PANIC" )
        ClipSize:SetSize( 72, 64 )
        ClipSize.DoClick = function()
            Frame:Close()
        end
    end
    
    // Tabs
	local ps = vgui.Create( "DPropertySheet", Frame)
	ps:SetPos( 0, 0 )
	ps:SetSize( menuw, menuh )
    ps.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 0, 150 ) )
        draw.RoundedBox( 0, 0, h-2, w, 2, Color( 0, 0, 0, 255 ) )
        draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
        draw.RoundedBox( 0, 0, 0, 2, h, Color( 0, 0, 0, 255 ) )
        draw.RoundedBox( 0, w-2, 0, 2, h, Color( 0, 0, 0, 255 ) )
    end
    //}
	
    
    /*-------------------------------------------------
                        Welcome Tab
    -------------------------------------------------*/
    
    //{
	local welcome = vgui.Create( "DPanel", ps )
	welcome:SetPos( 0, 0 )
	welcome:SetSize( menuw, menuh )
    welcome.Paint = function( self, w, h )  end
    
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(153,16)
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("TheDefaultSettings")
    text:SetText("WELCOME TO THE MASH")   
    text:SizeToContents()
    
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(0,64)
    text:SetSize( menuw-10, menuh )
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("TheDefaultSettings4")
    if      stories == 1 then text:SetText(story1.."\n\n"..welcomemessage)
    elseif  stories == 2 then text:SetText(story2.."\n\n"..welcomemessage)
    elseif  stories == 3 then text:SetText(story3.."\n\n"..welcomemessage)
    elseif  stories == 4 then text:SetText(story4.."\n\n"..welcomemessage)
    elseif  stories == 5 then text:SetText(story5.."\n\n"..welcomemessage)
    elseif  stories == 6 then text:SetText(story6.."\n\n"..welcomemessage)
    elseif  stories == 7 then text:SetText(story7.."\n\n"..welcomemessage)
    elseif  stories == 8 then text:SetText(story8.."\n\n"..welcomemessage)
    end
    text:SetAutoStretchVertical(true)
    text:SetWrap( true )
    
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(0,322)
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("Trebuchet18")
    text:SetText("Controls\n\nF1\nQ\nShift + A/D\nF\nZ\n")
    text:SizeToContents()
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(72,322)
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("Trebuchet18")
    text:SetText("\n\nOpen this menu\nHeal\nDodge Roll\nCandlestick\nTaunt")
    text:SizeToContents()
    
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(484,358)
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("Trebuchet18")
    text:SetText("What's new this update?")
    text:SizeToContents()
    local text = vgui.Create("DLabel", welcome)
    text:SetPos(484,358)
    text:SetColor( Color( 0, 0, 0, 255 ) )
    text:SetFont("Trebuchet18")
    text:SetText("\n\n     Added medal system\n Brand new HUD + Menu    \nTHE SKULL RECHARGES!!")
    text:SizeToContents()
    //}

    
    /*-------------------------------------------------
                       Character Tab
    -------------------------------------------------*/
    
    //{
    local character = vgui.Create( "DPanel", ps )
	character:SetPos( 0, 0 )
    character:SetSize( menuw, menuh )
    character.Paint = function( self, w, h )  end
    
    local mdl = vgui.Create( "DModelPanel", character )
    local mdl_size = 400
    local mdl_disp = 108
    mdl:SetPos(mdl_disp,16)
    mdl:SetSize(mdl_size, menuh-100 )
    mdl:SetAnimated( false )
    mdl:SetAnimSpeed( 0 )
    mdl:SetModel( ply:GetNWString("plymdl") )
    mdl.Entity:SetSkin(ply:GetNWString("plyskn"))
    function mdl:LayoutEntity( Entity ) return end
    local function UpdateSkin()
        mdl.Entity:SetSkin( ply:GetNWString("plyskn") )
    end
    
    local CharacterName = vgui.Create("DLabel", character)
    CharacterName:SetPos(448,24)
    CharacterName:SetColor( Color( 0, 0, 0, 255 ) )
    CharacterName:SetFont("Friday13-big")
    CharacterName:SetText("nil")
    CharacterName:SizeToContents()

    local CharacterDesc = vgui.Create("DLabel", character)
    CharacterDesc:SetPos(448,64)
    CharacterDesc:SetColor( Color( 0, 0, 0, 255 ) )
    CharacterDesc:SetFont("Default")
    CharacterDesc:SetText("nil")
    CharacterDesc:SizeToContents()
        
    local function UpdateFromConvars()
        mdl:SetModel( ply:GetNWString("plymdl") )
        if ply:GetNWString("plymdl") == "models/monstermash/random_character.mdl" then
            mdl:SetCamPos( Vector( 100, -30, 30 ) )
        else
            mdl:SetCamPos( Vector( 50,-30, 60 ) )
        end
        mdl.Entity:SetSkin( ply:GetNWString("plyskn") )
    end
    
        /*-------------------------------------------------
                        Skin Buttons
        -------------------------------------------------*/
        
        //{ 
        local SkinButton = vgui.Create( "DButton", character )
        local SkinButton2 = vgui.Create( "DButton", character )
        local SkinButton3 = vgui.Create( "DButton", character )
        local SkinButton4 = vgui.Create( "DButton", character )
        local SkinButton5 = vgui.Create( "DButton", character )
        local SkinButton6 = vgui.Create( "DButton", character )
        
        for i=1, 6 do
            local ent = SkinButton
            if      i == 2 then ent = SkinButton2
            elseif  i == 3 then ent = SkinButton3
            elseif  i == 4 then ent = SkinButton4
            elseif  i == 5 then ent = SkinButton5
            elseif  i == 6 then ent = SkinButton6
            end
            ent:SetText( tostring(i) )
            ent:SetTextColor(  Color( 255, 150, 0, 255 ) )
            ent:SetPos( 0, 0 )
            ent:SetSize( 30, 30 )
            function ent:DoClick()
                surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                ply:SetNWInt("plyskn",i-1)
                net.Start("MMSkin")
                net.WriteInt(i-1,5)
                net.SendToServer()
                timer.Simple( 0, function() UpdateSkin() end )
            end
        end
        //}
        
        
        /*-------------------------------------------------
                     Character Descriptions
        -------------------------------------------------*/
        
        //{
        local function ResetDeerHaunterStuffButton()
            local desc =    [[                   First seen in
]]..                        [[Tazer Man's mind


]]..                        [[                         Trivia
]]..                        [[Timothy D. Manning was once your
]]..                        [[average deer-headed, hook-handed
]]..                        [[child. He did well in school, was
]]..                        [[polite, and always ate his 
]]..                        [[vegetables. Now he is a horrific
]]..                        [[being that stalks the day and
]]..                        [[night. He is so menacing that he
]]..                        [[makes even the most dreaded
]]..                        [[beings like Cthulhu say 'Yeah, that
]]..                        [[guy's alright.'


]]..                        [[Loves: Grass
]]..                        [[Hates: Cars
]]

            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            CharacterName:SetText("  Deer Haunter\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetRandomStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[                   First seen in
]]..                        [[Unknown


]]..                        [[                         Trivia
]]..                        [[Not much is known about Random.
]]..                        [[It is believed that it was created
]]..                        [[by lazy players who are unsure of
]]..                        [[who they want to be. Random can
]]..                        [[take many forms, which it has no
]]..                        [[control over.


]]..                        [[Loves: Dittos
]]..                        [[Hates: Existing
]]

            CharacterName:SetText("       Random\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
                
        local function ResetNosferatuStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[                   First seen in
]]..                        [[Nosferatu, eine Symphonie des
]]..                        [[Grauens (1922)


]]..                        [[                         Trivia
]]..                        [[Definitely not a rip off of Dracula.
]]..                        [[Not to be confused with Incognito,
]]..                        [[the main villain in the 2001 anime
]]..                        [[Hellsing.


]]..                        [[Loves: Flickering light switches
]]..                        [[Hates: Daylight
]]

            CharacterName:SetText("    Nosferatu\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
         
        local function ResetScarecrowStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[                   First seen in
]]..                        [[Your grandma's backyard


]]..                        [[                         Trivia
]]..                        [[Scarecrow's biggest desire in life
]]..                        [[is to obtain a brain, so he has
]]..                        [[joined the mash to bash it out of 
]]..                        [[whoever stands in the way of him 
]]..                        [[and his scythe.


]]..                        [[Loves: Corn
]]..                        [[Hates: Crows
]]

            CharacterName:SetText("   Scarecrow\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetBloodyMaryStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[                   First seen in
]]..                        [[20th century folklore


]]..                        [[                         Trivia
]]..                        [[It is believed that if you utter her
]]..                        [[name while holding a candle in a 
]]..                        [[dark bathroom, you will catch a 
]]..                        [[glimpse of your future loved ones,
]]..                        [[or you might end up at the jaws of
]]..                        [[this demon.


]]..                        [[Loves: Children
]]..                        [[Hates: Fire
]]

            CharacterName:SetText("  Bloody Mary\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetHeadlessHorsemanStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[

           

]]..                        [[                   First seen in
]]..                        [[The Legend of Sleepy Hollow 
]]..                        [[(1820)


]]..                        [[                         Trivia
]]..                        [[The Horseman was a Hessian 
]]..                        [[artilleryman who was killed during
]]..                        [[the Battle of White Plains in 1776.
]]..                        [[He was decapitated by an
]]..                        [[American cannonball, and the
]]..                        [[shattered remains of his head were
]]..                        [[left on the battlefield while his
]]..                        [[comrades hastily carried his body
]]..                        [[away. Eventually they buried him
]]..                        [[in the cemetery of the Old Dutch
]]..                        [[Church of Sleepy Hollow, from
]]..                        [[which each Halloween night he
]]..                        [[rises as a malevolent ghost,
]]..                        [[furiously seeking his lost head.


]]..                        [[Loves: Heads
]]..                        [[Hates: Heads
]]
            CharacterName:SetText("   The Headless\n     Horseman")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end

        local function ResetSteinStuffButton()
            SkinButton:SetPos( 1000000, 1000000 )
            SkinButton2:SetPos( 1000000, 1000000 )
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            local desc =    [[
            

]]..                        [[                   First seen in
]]..                        [[Frankenstein (1818)


]]..                        [[                         Trivia
]]..                        [[Not to be confused with his
]]..                        [[creator, Victor Frankenstein, this
]]..                        [[unnamed creature just wants to 
]]..                        [[listen to violin music, but is
]]..                        [[constantly shunned for his develish
]]..                        [[appearance.


]]..                        [[Loves: Violins
]]..                        [[Hates: Sparks
]]

            CharacterName:SetText("Frankenstein's\n     Monster")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetVampireStuffButton()
            local x = (mdl_size/2-(30*3)/2+mdl_disp)
            local desc =    [[                   First seen in
]]..                        [[Dracula (1897)


]]..                        [[                         Trivia
]]..                        [[Possible descendants of Vlad 
]]..                        [[Tepes, vampires are feared due to
]]..                        [[their constant thirst for human
]]..                        [[blood and dangerously good looking
]]..                        [[attire. 


]]..                        [[Loves: Blood
]]..                        [[Hates: Wet socks
]]

            SkinButton:SetPos( x, 400 )
            SkinButton.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 30, 30, 30, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 200, 200, 200, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall()/2 )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton2:SetPos( x+35, 400 )
            SkinButton2.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 150, 150, 150, 255 )
                surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
                surface.SetDrawColor( 30, 30, 30, 255 )
                surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall()/2 )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            
            SkinButton3:SetPos( x+70, 400 )
            SkinButton3.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 30, 30, 30, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 57, 19, 18, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall()/2 )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            CharacterName:SetText("       Vampire\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetGuestStuffButton()
            local x = (mdl_size/2-(30*6)/2+mdl_disp)
            local desc =    [[                   First seen in
]]..                        [[Like, any graveyard


]]..                        [[                         Trivia
]]..                        [[Despite wearing the fanciest 
]]..                        [[clothes, Guest walks the earth
]]..                        [[with a big hole in his heart. Due to
]]..                        [[his appearance, he has no body to
]]..                        [[go with to the prom. 


]]..                        [[Loves: Looking nice
]]..                        [[Hates: Formal attire
]]

            SkinButton:SetPos( x, 400 )
            SkinButton.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 26, 26, 26, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton2:SetPos( x+35, 400 )
            SkinButton2.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 62, 64, 62, 255 )
                surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            
            SkinButton3:SetPos( x+70, 400 )
            SkinButton3.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 86, 72, 54, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton4:SetPos( x+105, 400 )
            SkinButton4.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 16, 24, 33, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton5:SetPos( x+140, 400 )
            SkinButton5.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 47, 25, 19, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton6:SetPos( x+175, 400 )
            SkinButton6.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 143, 148, 135, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            CharacterName:SetText("        Guest\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetSkeletonStuffButton()
            local x = (mdl_size/2-(30*4)/2+mdl_disp)
            local desc =    [[                   First seen in
]]..                        [[Roughly 2.1 - 1.5 million years ago


]]..                        [[                         Trivia
]]..                        [[Why should I bother writing trivia?
]]..                        [[Skeletons aren't real. 


]]..                        [[Loves: Milk
]]..                        [[Hates: Dogs
]]

            SkinButton:SetPos( x, 400 )
            SkinButton.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 219, 215, 195, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton2:SetPos( x+35, 400 )
            SkinButton2.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 205, 199, 165, 255 )
                surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            
            SkinButton3:SetPos( x+70, 400 )
            SkinButton3.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 112, 107, 85, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton4:SetPos( x+105, 400 )
            SkinButton4.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 103, 60, 45, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton5:SetPos( 1000000,1000000 )
            SkinButton6:SetPos( 1000000,1000000 )
            CharacterName:SetText("     Skeleton\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end
        
        local function ResetWitchStuffButton()
            local x = (mdl_size/2-(30*4)/2+mdl_disp)
            local desc =    [[                   First seen in
]]..                        [[2000 B.C.


]]..                        [[                         Trivia
]]..                        [[An old lady who once sent an army
]]..                        [[of evil after a little girl after being
]]..                        [[bitten by her dog.


]]..                        [[Loves: Calculators
]]..                        [[Hates: Water
]]

            SkinButton:SetPos( x, 400 )
            SkinButton.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 152, 60, 16, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton2:SetPos( x+35, 400 )
            SkinButton2.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 92, 139, 35, 255 )
                surface.DrawRect( 0, 0, SkinButton2:GetWide(), SkinButton2:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            
            SkinButton3:SetPos( x+70, 400 )
            SkinButton3.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 122, 48, 160, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton4:SetPos( x+105, 400 )
            SkinButton4.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 143, 16, 16, 255 )
                surface.DrawRect( 0, 0, SkinButton3:GetWide(), SkinButton3:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton5:SetPos( 1000000,1000000 )
            SkinButton6:SetPos( 1000000,1000000 )
            CharacterName:SetText("         Witch\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
        end

        local function ResetMummyStuffButton()
            local x = (mdl_size/2-(30*2)/2+mdl_disp)
            local desc =    [[                   First seen in
]]..                        [[450 - 250 BC


]]..                        [[                         Trivia
]]..                        [[The wrapped remains of once 
]]..                        [[powerful rulers of acient egypt.


]]..                        [[Loves: Yu-Gi-Oh!
]]..                        [[Hates: Air
]]

            SkinButton:SetPos( x, 400 )
            SkinButton.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 187, 188, 175, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton2:SetPos( x+35, 400 )
            SkinButton2.Paint = function()
                if LocalPlayer().LastTab != 2 then return end
                surface.SetDrawColor( 73, 65, 51, 255 )
                surface.DrawRect( 0, 0, SkinButton:GetWide(), SkinButton:GetTall() )
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            SkinButton3:SetPos( 1000000, 1000000 )
            SkinButton4:SetPos( 1000000, 1000000 )
            SkinButton5:SetPos( 1000000, 1000000 )
            SkinButton6:SetPos( 1000000, 1000000 )
            CharacterName:SetText("         Mummy\n")
            CharacterName:SizeToContents()
            CharacterDesc:SetText(desc)
            CharacterDesc:SizeToContents()
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
        elseif ply:GetNWString("plymdl") == "models/monstermash/stein_final.mdl" then
            ResetSteinStuffButton()
        elseif ply:GetNWString("plymdl") == "models/monstermash/random_character.mdl" then
            ResetRandomStuffButton()
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
        local function CallButton(i)
            if      i == 0  then ResetDeerHaunterStuffButton()
            elseif  i == 1  then ResetVampireStuffButton()
            elseif  i == 2  then ResetNosferatuStuffButton()
            elseif  i == 3  then ResetGuestStuffButton()
            elseif  i == 4  then ResetScarecrowStuffButton()
            elseif  i == 5  then ResetSkeletonStuffButton()
            elseif  i == 6  then ResetWitchStuffButton()
            elseif  i == 7  then ResetHeadlessHorsemanStuffButton()
            elseif  i == 8  then ResetSteinStuffButton()
            elseif  i == 9  then ResetMummyStuffButton()
            elseif  i == 10  then ResetBloodyMaryStuffButton()
            end        
        end
        
        local i = 1
        local j = 0
        for i=0, 17 do
            if      i >= 6  && i <= 11 then j = 1 
            elseif  i >= 12 && i <= 17 then j = 2 
            end
            local model = modeltable[i+1]
            if i == #modeltable then
                model = "models/monstermash/random_character.mdl"
            end
            BGPanel = vgui.Create( "DPanel", character )
            BGPanel:SetPos( 4+72*(j), 16+72*(i%6) )
            BGPanel:SetSize( 64, 64 )
            if i <= #modeltable then
                local mdl = vgui.Create( "SpawnIcon", BGPanel )
                mdl:SetSize( BGPanel:GetSize() )
                mdl:SetModel( model )
                mdl:SetSkin(ply:GetNWInt("plyskn"))
                
                if i == #modeltable then
                    function mdl:DoClick()
                        modelchosen = "models/monstermash/random_character.mdl"
                        SelectedModel = "models/monstermash/random_character.mdl"
                        ResetRandomStuffButton()
                        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                        timer.Simple( 0, function() UpdateSkin() ResetRandomStuffButton() end )
                        ply:SetNWString("plymdl",modelchosen)
                        net.Start("MMPlyModel")
                        net.WriteString(modelchosen)
                        net.SendToServer()
                        
                        ply:SetNWInt("plyskn",math.random(0,5))
                        net.Start("MMSkin")
                        net.WriteInt(1,5)
                        net.SendToServer()
                        UpdateSkin()
                        
                        timer.Simple( 0, function() UpdateFromConvars() end )
                    end
                else
                    function mdl:DoClick()
                        CallButton(i)
                        SelectedModel = model
                        ply:SetNWString("plymdl",model)
                        net.Start("MMPlyModel")
                        net.WriteString(model)
                        net.SendToServer()
                        timer.Simple( 0, function() UpdateFromConvars() CallButton(i) end )
                        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                    end
                end
            end
            BGPanel.Paint = function(self, w, h)
                draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
            end
        end
        
        //}

        UpdateFromConvars()
    
    //}
    
    
    /*-------------------------------------------------
                          Loadout
    -------------------------------------------------*/
    
    //{
    local loadout = vgui.Create( "DPanel", ps )
	loadout:SetPos( 0, 0 )
	loadout:SetSize( menuw, menuh )
    loadout.Paint = function( self, w, h )  end
    
    local GoldIcon = vgui.Create( "DImageButton", loadout )
    GoldIcon:SetFont("TheDefaultSettings4")
    GoldIcon:SetTextColor(  Color( 0, 0, 0, 255 ) )
    GoldIcon:SetSize(48, 48)
    GoldIcon:SetImage("vgui/hud/goldstack")
    GoldIcon:SetContentAlignment(5)
    
    local GoldText = vgui.Create("DLabel", loadout)
    GoldText:SetColor( Color( 0, 0, 0, 255 ) )
    GoldText:SetFont("CloseCaption_Bold")
    GoldText:SetText(LocalPlayer():GetNWInt("gold"))
    GoldText:SizeToContents()
    
    local TextName = vgui.Create("DLabel", loadout)
    TextName:SetColor( Color( 0, 0, 0, 255 ) )
    TextName:SetSize(240, 439)
    TextName:SetPos(menuw-240,16)
    TextName:SetFont("Friday13-big")
    TextName:SetText(" ")
    TextName:SizeToContents()
    
    local TextDesc = vgui.Create("DLabel", loadout)
    TextDesc:SetColor( Color( 0, 0, 0, 255 ) )
    TextDesc:SetSize(220, 439)
    TextDesc:SetPos(menuw-240,64)
    TextDesc:SetFont("Trebuchet18")
    TextDesc:SetText(" ")
    TextDesc:SetAutoStretchVertical(true)
    TextDesc:SetWrap(true)
    
    if LocalPlayer():GetNWInt("gold") >= 100 then
        GoldIcon:SetPos(150+90, menuh-80)
        GoldText:SetPos(190+90, menuh-70)
    elseif LocalPlayer():GetNWInt("gold") < 10 then
        GoldIcon:SetPos(150+100, menuh-80)
        GoldText:SetPos(190+100, menuh-70)
    else
        GoldIcon:SetPos(150+94, menuh-80)
        GoldText:SetPos(190+94, menuh-70)
    end

    local weapontypes = {
        "melee", 
        "handgun", 
        "primary", 
        "throwable", 
        "buff", 
        "random"
    }

    local weapontypes_name = {
        "Melee", 
        "Handgun", 
        "Primary", 
        "Throwable", 
        "Coming Soon", 
        "Randomize"
    }

        /*-------------------------------------------------
                         Current Loadout
        -------------------------------------------------*/
        //{
        local category = LocalPlayer():GetNWString("Category")
        local total = 4
        local PanicText = vgui.Create("DLabel", loadout)
        PanicText:SetColor( Color( 0, 0, 0, 255 ) )
        PanicText:SetFont("CloseCaption_Bold")
        PanicText:SetText("WEAPON LIST NEEDS REBUILDING!")
        PanicText:SizeToContents()
        PanicText:Center()
        for i=1, total do
            local tp = weapontypes_name[i]
            local Current = vgui.Create( "DImageButton", loadout )
            Current:SetPos( menuw-66-56*(total-1-(i-1)), menuh-86 )
            Current:SetFont("TheDefaultSettings4")
            Current:SetTextColor(  Color( 0, 0, 0, 255 ) )
            Current:SetSize( 48, 48 )
            Current:SetContentAlignment(5)
            Current.Paint = function(self, w, h)
                if LocalPlayer().LastTab != 3 then return end
                if LocalPlayer():GetNWString("Category") != "random" then
                    local index = 1
                    for j=1, #MonsterMash_Weapons[weapontypes[i]] do
                        if MonsterMash_Weapons[weapontypes[i]][j].entity == LocalPlayer():GetNWString(tp) then index = j break end
                    end
                    if MonsterMash_Weapons[weapontypes[i]][index] == nil then
                        PanicText:SetText("WEAPON LIST NEEDS REBUILDING!")
                        return
                    end
                    PanicText:SetText("")
                    Current:SetImage( MonsterMash_Weapons[weapontypes[i]][index].icon )
                    Current:SetText("")
                else
                    if MonsterMash_Weapons[weapontypes[1]][1] == nil then
                        PanicText:SetText("WEAPON LIST NEEDS REBUILDING!")
                        return
                    end
                    PanicText:SetText("")
                    Current:SetImage( "nothing" )
                    Current:SetText("?")
                end
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
                draw.RoundedBox( 0, 0, 0, 2, h, Color( 0, 0, 0, 255 ) )
                draw.RoundedBox( 0, w-2, 0, 2, h, Color( 0, 0, 0, 255 ) )
                draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
                draw.RoundedBox( 0, 0, h-2, w, 2, Color( 0, 0, 0, 255 ) )
            end
            Current.DoClick = function()
                if category == "random" then return end
                if !(i <= #MonsterMash_Weapons[category]) then return end
                if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == LocalPlayer() then return end
                local ent = MonsterMash_Weapons[category][1].entity
                local tp = weapontypes_name[i]
                local lastcost = "lastcost_"..tp
                local start = "MM_Wep_"..tp
                if LocalPlayer():GetNWString(tp) == "" then return end
                if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt(lastcost) >= MonsterMash_Weapons[category][1].cost then
                    net.Start(start)
                    net.WriteString(ent)
                    net.WriteFloat(MonsterMash_Weapons[category][1].cost)
                    net.SendToServer()
                    LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-MonsterMash_Weapons[category][1].cost+LocalPlayer():GetNWInt(lastcost))
                    LocalPlayer():SetNWInt(lastcost,MonsterMash_Weapons[category][1].cost)
                    LocalPlayer():SetNWString(tp,ent)
                    GoldText:SetText(LocalPlayer():GetNWInt("gold"))
                    GoldText:SizeToContents()
                    surface.PlaySound("ui/keys_pickup-0"..math.random(1,4)..".wav")
                    if LocalPlayer():GetNWInt("gold") == GetConVar("mm_budget"):GetInt() then
                        GoldIcon:SetPos(150+90, menuh-80)
                        GoldText:SetPos(190+90, menuh-70)
                    elseif LocalPlayer():GetNWInt("gold") < 10 then
                        GoldIcon:SetPos(150+100, menuh-80)
                        GoldText:SetPos(190+100, menuh-70)
                    else
                        GoldIcon:SetPos(150+94, menuh-80)
                        GoldText:SetPos(190+94, menuh-70)
                    end
                end
            end
        end
        //}
        
        
        /*-------------------------------------------------
                         Category Buttons
        -------------------------------------------------*/
        //{
        local k = 1
        for k=1, #weapontypes do
            local TypeTab = vgui.Create( "DButton", loadout )
            TypeTab:SetPos( 16, 64*k-24 )
            TypeTab:SetFont("TheDefaultSettings3")
            TypeTab:SetTextColor(  Color( 0, 0, 0, 255 ) )
            TypeTab:SetText( weapontypes_name[k] )
            TypeTab:SetSize( 128, 48 )
            TypeTab.DoClick = function()
                if k == 5 then return end
                LocalPlayer():SetNWString("Category", weapontypes[k])
                category = LocalPlayer():GetNWString("Category")
                surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                if k == 6 then
                    for z = 1, 5 do
                        local tp = weapontypes_name[z]
                        if tp == "Coming Soon" then
                            tp = "Buff"
                        end
                        net.Start("MM_Wep_"..tp)
                        net.WriteString("")
                        net.WriteFloat(0)
                        net.SendToServer()
                        LocalPlayer():SetNWInt("lastcost_"..tp, 0)
                        LocalPlayer():SetNWString(tp,ent)
                    end
                    LocalPlayer():SetNWInt("gold", GetConVar("mm_budget"):GetInt())
                    GoldText:SetText(LocalPlayer():GetNWInt("gold"))
                    GoldText:SizeToContents()
                    TextName:SetText("")
                    TextDesc:SetText("")
                end
            end
            TypeTab.Paint = function( self, w, h )
                if LocalPlayer().LastTab != 3 then return end
                local col = Color(0,0,0,255)
                if LocalPlayer():GetNWString("Category") == weapontypes[k] then
                    col = Color( 0, 0, 255, 255 )
                end
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
                draw.RoundedBox( 0, 0, 0, 2, h, col )
                draw.RoundedBox( 0, w-2, 0, 2, h, col )
                draw.RoundedBox( 0, 0, 0, w, 2, col )
                draw.RoundedBox( 0, 0, h-2, w, 2, col )
            end
        end 
        //}
        
        
        /*-------------------------------------------------
                          Weapon Buttons
        -------------------------------------------------*/
        //{
        if table.HasValue(weapontypes, LocalPlayer():GetNWString("Category")) then
            local j = 0
            
            for i=1, 15 do
                if      i-1 >= 5  && i-1 <= 9   then j = 1 
                elseif  i-1 >= 10               then j = 2
                end

                local button = vgui.Create( "DImageButton", loadout )
                button:SetPos( 180+72*(j), 72*((i-1)%5)+48)
                button:SetFont("TheDefaultSettings4")
                button:SetTextColor(  Color( 0, 0, 0, 255 ) )
                button:SetSize( 64, 64 )
                button:SetContentAlignment(5)
                button.DoClick = function()
                    if category == "random" then return end
                    if !(i <= #MonsterMash_Weapons[category]) then return end
                    if GetGlobalVariable("WackyRound_Event") == 0 && GetGlobalVariable("WackyRound_COOPOther") == LocalPlayer() then return end
                    local ent = MonsterMash_Weapons[category][i].entity
                    local tp = LocalPlayer():GetNWString("Category")
                    local lastcost = "lastcost_"..tp
                    local start = "MM_Wep_"..tp
                    if LocalPlayer():GetNWInt("gold")+LocalPlayer():GetNWInt(lastcost) >= MonsterMash_Weapons[category][i].cost then
                        net.Start(start)
                        net.WriteString(ent)
                        net.WriteFloat(MonsterMash_Weapons[category][i].cost)
                        net.SendToServer()
                        LocalPlayer():SetNWInt("gold",LocalPlayer():GetNWInt("gold")-MonsterMash_Weapons[category][i].cost+LocalPlayer():GetNWInt(lastcost))
                        LocalPlayer():SetNWInt(lastcost,MonsterMash_Weapons[category][i].cost)
                        LocalPlayer():SetNWString(tp,ent)
                        GoldText:SetText(LocalPlayer():GetNWInt("gold"))
                        GoldText:SizeToContents()
                        surface.PlaySound("ui/keys_pickup-0"..math.random(1,4)..".wav")
                        if LocalPlayer():GetNWInt("gold") == GetConVar("mm_budget"):GetInt() then
                            GoldIcon:SetPos(150+90, menuh-80)
                            GoldText:SetPos(190+90, menuh-70)
                        elseif LocalPlayer():GetNWInt("gold") < 10 then
                            GoldIcon:SetPos(150+100, menuh-80)
                            GoldText:SetPos(190+100, menuh-70)
                        else
                            GoldIcon:SetPos(150+94, menuh-80)
                            GoldText:SetPos(190+94, menuh-70)
                        end
                    end
                end
                button.Paint = function( self, w, h )
                    if LocalPlayer().LastTab != 3 then return end
                    if category == "random" || !(i <= #MonsterMash_Weapons[category]) then button:SetText("") button:SetImage( "nothing" ) return end
                    
                    if button:IsHovered() == true then
                        timer.Create("AA", 0, 2, function()
                            if !IsValid(TextName) then return end
                            local text = MonsterMash_Weapons[category][i].name
                            
                            TextName:SetText(text)
                            TextName:Center()
                            local x, y = TextName:GetPos()
                            TextName:SetPos(x+202, 16)
                            TextName:SizeToContents()
                            
                            if category == "melee" then
                                local a = MonsterMash_Weapons[category][i]
                                local range = "     "
                                local count = math.Round((a.range/128)*5)
                                for z=1, count do
                                    range = string.SetChar( range, z, "+" )
                                end
                                
                                TextDesc:SetText(a.description.."\n\nTier: "..a.classification.."\nDamage: "..a.damage.."\nRange: "..range.."\n\nConcuss chance: "..a.concusschance.."%\nBleed chance: "..a.bleedchance.."%\nDismember chance: "..a.dismemberchance.."%")
                                TextDesc:SetAutoStretchVertical(true)
                                TextDesc:SetWrap(true)
                            elseif category == "throwable" then
                                local a = MonsterMash_Weapons[category][i]
                                
                                TextDesc:SetText(a.description.."\n\nTier: "..a.classification.."\nDamage: "..a.damage.."\nChargeup: "..tostring(a.chargeup))
                                TextDesc:SetAutoStretchVertical(true)
                                TextDesc:SetWrap(true)                        
                            else
                                local a = MonsterMash_Weapons[category][i]
                                local range = "     "
                                local count = 5
                                local damage = a.damage
                                if a.entity == "mm_pumpshotgun" || a.entity == "mm_sawedoff" || a.entity == "mm_coachgun" then
                                    damage = damage*(weapons.Get(a.entity).Primary.NumberofShots)
                                end
                                if a.range != -1 then
                                    count = math.Round((a.range/2000)*5)
                                end
                                for z=1, count do
                                    range = string.SetChar( range, z, "+" )
                                end
                                
                                TextDesc:SetText(a.description.."\n\nTier: "..a.classification.."\nDamage: "..damage.."\nRange: "..range.."\n\nFiremode: "..a.firemode.."\nClip size: "..a.clipsize)
                                TextDesc:SetAutoStretchVertical(true)
                                TextDesc:SetWrap(true)
                            end
                            
                            if i == 1 then
                                TextName:SetText("")
                                TextDesc:SetText("")
                            end
                        end)
                    end
                    
                    local ent = MonsterMash_Weapons[category][i].entity
                    local col = Color(0,0,0,255)
                    if LocalPlayer():GetNWString(LocalPlayer():GetNWString("Category")) == ent then
                        col = Color( 0, 0, 255, 255 )
                    end
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
                    draw.RoundedBox( 0, 0, 0, 2, h, col )
                    draw.RoundedBox( 0, w-2, 0, 2, h, col )
                    draw.RoundedBox( 0, 0, 0, w, 2, col )
                    draw.RoundedBox( 0, 0, h-2, w, 2, col )
                    if button:IsHovered() == true then
                        button:SetText( MonsterMash_Weapons[category][i].cost.." Gold" )
                        button:SetImage( "nothing" )
                        //LocalPlayer():SetNWString("Category", "Melee")
                    else
                        if i == 1 then
                            button:SetText( "Nothing" )
                        else
                            button:SetText( "" )
                        end
                        button:SetImage( MonsterMash_Weapons[category][i].icon )
                    end
                end
            end
        end 
        //}
    //}
    
    
    /*-------------------------------------------------
                          Options
    -------------------------------------------------*/
    
    //{
    local options = vgui.Create( "DPanel", ps )
	options:SetPos( 0, 0 )
	options:SetSize( menuw, menuh )
    options.Paint = function( self, w, h )  end
    
    local x = 0
    local y = 16
    local text
    local command
    
    for i=1, 5 do
        if i == 1 then
            text = "Aim Assist"
            command = "mm_aimenable"
        elseif i == 2 then
            text = "Dodge firstperson rotation"
            command = "mm_rollrotatescreen"
        elseif i == 3 then
            text = "Disable Haunted Urn Screamers"
            command = "mm_pussymode"
        elseif i == 4 then
            text = "Blur Menu Background"
            command = "mm_blurmenu"
        elseif i == 5 then
            text = "Deanimator shake"
            command = "mm_deanimatorshake"
        end
        local Checkbox = vgui.Create( "DCheckBox", options )
        Checkbox.command = command
        Checkbox:SetPos( x, y )
        Checkbox:SetValue( GetConVar(command):GetInt() )
        function Checkbox:OnChange( value )
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            if value == false then
                booltoint = 0
            else
                booltoint = 1
            end
            LocalPlayer():ConCommand(Checkbox.command.." "..booltoint)
        end
        local Text = vgui.Create("DLabel", options)
        Text:SetPos(x+18,y+1)
        Text:SetColor( Color( 0, 0, 0, 255 ) )
        Text:SetFont("Default")
        Text:SetText(text)
        Text:SizeToContents()

        y = y + 18
    end
    
    local Slide = vgui.Create( "DNumSlider", options )
    Slide:SetPos( x-128, y )
    Slide:SetSize( 300, 32 )
    Slide:SetText( "" )
    Slide:SetMin( 0 )
    Slide:SetMax( 1000 )
    Slide:SetValue(GetConVar("mm_cleardecals"):GetInt())
    Slide:SetDecimals( 0 )
    function Slide:OnValueChanged(num)
        LocalPlayer():ConCommand("mm_cleardecals "..math.Round(num))
    end
    local Text = vgui.Create("DLabel", options)
    Text:SetPos(x+160,y+11)
    Text:SetColor( Color( 0, 0, 0, 255 ) )
    Text:SetFont("Default")
    Text:SetText("Clear decals (seconds)")
    Text:SizeToContents()
    
    y = y + 32
    local OptionsButton = vgui.Create( "DButton", options )
    OptionsButton:SetPos( x, y )
    OptionsButton:SetFont("TheDefaultSettings4")
    OptionsButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
    OptionsButton:SetText( "Stop sound" )
    OptionsButton:SetSize( 90, 32 )
    OptionsButton.DoClick = function()
        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
        LocalPlayer():ConCommand("stopsound")
        LocalPlayer():ConCommand("mm_musicplayerstop")
        LocalPlayer():ChatPrint("Stopping music")
    end
    OptionsButton.Paint = function(self, w, h) SimpleButtonPaint(self, w, h) end
    local Text = vgui.Create("DLabel", options)
    Text:SetPos(x+100,y+4)
    Text:SetColor( Color( 0, 0, 0, 255 ) )
    Text:SetFont("Default")
    Text:SetText("Press this if you hear a sound\nthat won't stop.")
    Text:SizeToContents()
    
    // Music Player
    local x = menuw-350
    local y = 16
    local f = vgui.Create( "DPanel", options )
    f:SetSize( 330, 108 )
    f:SetPos(x,y)
    local MusicSelection = vgui.Create( "DListView", f )
    MusicSelection:Dock( FILL )
    MusicSelection:SetMultiSelect( false )
    MusicSelection:AddColumn( "Song" )
    MusicSelection:AddColumn( "Artist" )
    MusicSelection.musicselected = 0
    for i=1, #MusicList do
        MusicSelection:AddLine( MusicList[i].name, MusicList[i].author )
        if LocalPlayer().Music && ply.MusicIndex == i then
            MusicSelection:SelectItem( MusicSelection:GetLine(i) )
        end
    end
    MusicSelection.OnRowSelected = function( lst, index, pnl )
        MusicSelection.musicselected = index
    end
    
    y = 128
    for i=1, 5 do
        if i == 1 then
            text = "Start"
            command = "mm_musicplayerstart"
        elseif i == 2 then
            text = "Stop"
            command = "mm_musicplayerstop"
        elseif i == 4 then
            text = "Auto Next"
            command = "Check1"
        elseif i == 3 then
            text = "Loop"
            command = "Check2"
        elseif i == 5 then
            text = "Shuffle"
            command = "Check3"
        end
        local MusicButton = vgui.Create( "DButton", options )
        MusicButton:SetPos( x,y )
        MusicButton:SetFont("DermaDefault")
        MusicButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
        MusicButton:SetText( text )
        MusicButton.command = command
        if i == 1 then
            MusicButton.Arg = -1
        else
            MusicButton.Arg = " "
        end
        MusicButton:SetSize( 62, 16 )
        function MusicButton:DoClick()
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            if MusicButton.command == "Check1" then
                LocalPlayer().MusicAutoNext = !LocalPlayer().MusicAutoNext
                LocalPlayer().MusicLoop = false
                LocalPlayer().MusicShuffle = false
            elseif MusicButton.command == "Check2" then
                LocalPlayer().MusicAutoNext = false
                LocalPlayer().MusicLoop = !LocalPlayer().MusicLoop
                LocalPlayer().MusicShuffle = false
            elseif MusicButton.command == "Check3" then
                LocalPlayer().MusicAutoNext = false
                LocalPlayer().MusicShuffle = !LocalPlayer().MusicShuffle
                LocalPlayer().MusicLoop = false
            else
                if MusicButton.Arg != " " then
                    MusicButton.Arg = " "..tostring(MusicSelection.musicselected)
                end
                if MusicButton.command == "mm_musicplayerstart" then
                    LocalPlayer().MusicListening = true
                elseif MusicButton.command == "mm_musicplayerstop" then
                    LocalPlayer().MusicListening = false
                end
                LocalPlayer():ConCommand(MusicButton.command..MusicButton.Arg)
                timer.Simple(0.1, function()
                    if MusicButton == nil || MusicList[LocalPlayer().MusicIndex] != nil then return end
                    if MusicButton.command == "mm_musicplayerstart" && LocalPlayer().MusicIndex != 0 then
                        LocalPlayer():ChatPrint("Now playing "..MusicList[LocalPlayer().MusicIndex].name.." by "..MusicList[LocalPlayer().MusicIndex].author)
                    elseif MusicButton.command == "mm_musicplayerstop" then
                        LocalPlayer():ChatPrint("Stopping music")
                    end
                end)
            end
        end
        MusicButton.Paint = function(self, w, h)
            local arg
            if MusicButton.command == "Check1" then
                arg = LocalPlayer().MusicAutoNext
                SimpleButtonPaintCheck(self, w, h, arg)
            elseif MusicButton.command == "Check2" then
                arg = LocalPlayer().MusicLoop
                SimpleButtonPaintCheck(self, w, h, arg)
            elseif MusicButton.command == "Check3" then
                arg = LocalPlayer().MusicShuffle
                SimpleButtonPaintCheck(self, w, h, arg)
            elseif MusicButton.command == "mm_musicplayerstart" then
                if IsValid(LocalPlayer().Music) then
                    arg = true
                else
                    arg = false
                end
                SimpleButtonPaintCheck(self, w, h, arg)
            else
                SimpleButtonPaint(self, w, h)
            end            
        end
        x = x + 67
    end
    
    if !ply.MusicVolume then
        ply.MusicVolume = 1
    end
    x = menuw-350
    y = y + 16
    local Slide = vgui.Create( "DNumSlider", options )
    Slide:SetPos( x, y )
    Slide:SetSize( 350, 32 )
    Slide:SetText( "" )
    Slide:SetMin( 0.01 )
    Slide:SetMax( 1 )
    Slide:SetValue(ply.MusicVolume)
    Slide:SetDecimals( 2 )
    function Slide:OnValueChanged(num)
        LocalPlayer():ConCommand("mm_musicplayervolume "..tostring(num))
    end
    local Text = vgui.Create("DLabel", options)
    Text:SetPos(x,y+11)
    Text:SetColor( Color( 0, 0, 0, 255 ) )
    Text:SetFont("Default")
    Text:SetText("Music Volume")
    Text:SizeToContents()
    //}
  

    /*-------------------------------------------------
                        Admin Options
    -------------------------------------------------*/
  
    //{
    local admin = vgui.Create( "DPanel", ps )
    admin:SetPos( 0, 0 )
    admin:SetSize( menuw, menuh )
    admin.Paint = function( self, w, h )  end
        
    if table.HasValue(admins, LocalPlayer():SteamID()) then
        /*-------------------------------------------------
                           Left Column
        -------------------------------------------------*/
        //{
        local command
        local text
        local x = 0
        local y = 12
        for i=1, 9 do
            if i == 1 then
                text = "Point Limit"
                command = "mm_kill_limit"
            elseif i == 2 then
                text = "Gold Limit"
                command = "mm_budget"
            elseif i == 3 then
                text = "Buy Time"
                command = "mm_buy_time"
            elseif i == 4 then
                text = "Health Regen Time"
                command = "mm_healthregentime"
            elseif i == 5 then
                text = "Wacky Round frequency"
                command = "mm_wackyfrequency"
            elseif i == 6 then
                text = "Cleanup Time"
                command = "mm_cleanup_time"
            elseif i == 7 then
                text = "Aim Size"
                command = "mm_aimsize"
            elseif i == 8 then
                text = "Aim Range"
                command = "mm_aimrange"
            elseif i == 9 then
                text = "Aim Speed"
                command = "mm_aimspeed"
            end
            if GetConVar(command) == nil then continue end 
            local Text = vgui.Create("DLabel", admin)
            Text:SetPos(x,y+4)
            Text:SetColor( Color( 0, 0, 0, 255 ) )
            Text:SetFont("Default")
            Text:SetText(text)
            Text:SizeToContents()
            local TextEntry = vgui.Create( "DTextEntry", admin )
            TextEntry:SetPos( x+108, y )
            TextEntry:SetSize( 75, 20 )
            TextEntry.Different = false
            TextEntry.command = command
            TextEntry:SetText( tostring(GetConVar(command):GetInt()) )
            function TextEntry:Think()
                if self.Different && !self:IsEditing() then
                    self.Different = false
                    surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                    RunConsoleCommand(self.command, tostring(self:GetValue()))
                end
            end
            TextEntry.OnChange = function( self )
                self.Different = true
            end
            
            y = y + 20
            if i == 6 then
                y = y + 20
            end
        end

        y = y + 20
        for i=1, 4 do
            if i == 1 then
                text = "Tazerman Mode"
                command = "mm_tasermanmode"
            elseif i == 2 then
                text = "Ludicrous Gibs Mode"
                command = "mm_ludicrousgibs"
            elseif i == 3 then
                text = "Orgasmic Death Sounds"
                command = "mm_OrgasmicDeathSounds"
            elseif i == 4 then
                text = "Medals"
                command = "mm_medals"
            end
            if GetConVar(command) == nil then continue end 
            local Checkbox = vgui.Create( "DCheckBox", admin )
            Checkbox.command = command
            Checkbox:SetPos( x, y )
            Checkbox:SetValue( GetConVar(command):GetInt() )
            function Checkbox:OnChange( value )
                surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                if value == false then
                    booltoint = 0
                else
                    booltoint = 1
                end
                RunConsoleCommand(Checkbox.command, booltoint)
            end
            local Text = vgui.Create("DLabel", admin)
            Text:SetPos(x+18,y+1)
            Text:SetColor( Color( 0, 0, 0, 255 ) )
            Text:SetFont("Default")
            Text:SetText(text)
            Text:SizeToContents()

            y = y + 18
        end
        //}
        
        
        /*-------------------------------------------------
                          Bottom Buttons
        -------------------------------------------------*/
        //{
        local AdminButton = vgui.Create( "DButton", admin )
        AdminButton:SetPos( 0, menuh-84 )
        AdminButton:SetFont("TheDefaultSettings3")
        AdminButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
        AdminButton:SetText( "Rebuild Weapons" )
        AdminButton:SetSize( 150, 48 )
        AdminButton.DoClick = function()
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            RunConsoleCommand("mm_rebuildweapons", "") 
        end
        AdminButton.Paint = function(self, w, h) SimpleButtonPaint(self, w, h) end
        
        local AdminButton = vgui.Create( "DButton", admin )
        AdminButton:SetPos( 156, menuh-84 )
        AdminButton:SetFont("TheDefaultSettings3")
        AdminButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
        AdminButton:SetText( "End Round" )
        AdminButton:SetSize( 150, 48 )
        AdminButton.DoClick = function()
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            GAMEMODEGLOBAL_ForceGame_Over = true
            net.Start("GAMEMODEGLOBAL_ForceGame_Over")
            net.WriteBool(true)
            net.SendToServer()
        end
        AdminButton.Paint = function(self, w, h) SimpleButtonPaint(self, w, h) end
        //}
    
    
        /*-------------------------------------------------
                         Kick/Ban Button
        -------------------------------------------------*/
        //{
        local selectedplayer = nil
        local time = 60
        local reason = "Reason"
        
        x = menuw - 300
        y = 12
        y = y + 12
        x = x + 128
        local AdminButton = vgui.Create( "DButton", admin )
        AdminButton:SetPos( x,y )
        AdminButton:SetFont("DermaDefault")
        AdminButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
        AdminButton:SetText( "Kick" )
        AdminButton:SetSize( 64, 16 )
        function AdminButton:DoClick()
            if selectedplayer == nil then return end
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            LocalPlayer():ConCommand("say !kick "..selectedplayer.." "..reason)
        end
        
        x = x + 72
        local AdminButton = vgui.Create( "DButton", admin )
        AdminButton:SetPos( x,y )
        AdminButton:SetFont("DermaDefault")
        AdminButton:SetTextColor(  Color( 0, 0, 0, 255 ) )
        AdminButton:SetText( "Ban" )
        AdminButton:SetSize( 64, 16 )
        function AdminButton:DoClick()
            if selectedplayer == nil then return end
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            LocalPlayer():ConCommand("say !ban "..selectedplayer.." "..time)
        end
        
        x = x - 72
        y = y + 32
                        
        local TextEntry = vgui.Create( "DTextEntry", admin )
        TextEntry:SetPos( x, y )
        TextEntry:SetSize( 134, 20 )
        TextEntry:SetText( reason )
        TextEntry.Different = false
        function TextEntry:Think()
            if self.Different && !self:IsEditing() then
                self.Different = false
                surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                reason = tostring(self:GetValue())
            end
        end
        TextEntry.OnChange = function( self )
            self.Different = true
        end
        y = y + 24
        local Slide = vgui.Create( "DNumSlider", admin )
        Slide:SetPos( x-128, y )
        Slide:SetSize( 300, 32 )
        Slide:SetText( "" )
        Slide:SetMin( 0 )
        Slide:SetMax( 1000 )
        Slide:SetValue(time)
        Slide:SetDecimals( 0 )
        function Slide:OnValueChanged(num)
            time = math.Round(num)
        end
        x = menuw - 300
        y = 12
        local f = vgui.Create( "DPanel", admin )
        f:SetSize( 100, 100 )
        f:SetPos(x,y)
        local List = vgui.Create( "DListView", f )
        List:Dock( FILL )
        List:SetMultiSelect( false )
        List:AddColumn( "Players" )
        for k, v in pairs( ents.FindByClass("player") ) do
            List:AddLine( v:Nick() )
        end
        List.OnRowSelected = function( lst, index, pnl )
            selectedplayer = pnl:GetColumnText( 1 )
        end
        //}
 
 
        /*-------------------------------------------------
                            Map Change
        -------------------------------------------------*/
        //{
        /*
        x = menuw - 300
        y = 12
        local test = GetMapList()
        local f = vgui.Create( "DPanel", admin )
        f:SetSize( 100, 100 )
        f:SetPos(x,y)
        local List = vgui.Create( "DListView", f )
        List:Dock( FILL )
        List:SetMultiSelect( false )
        List:AddColumn( "Players" )
        for i=1, 3 do
            List:AddLine( "Hello" )
        end
        List.OnRowSelected = function( lst, index, pnl )
            selectedplayer = pnl:GetColumnText( 1 )
        end
        */
        //}
    end
    //}
    
    local spawn = vgui.Create( "DPanel", ps )
	spawn:SetPos( 0, 0 )
	spawn:SetSize( menuw, menuh )
    spawn.Paint = function( self, w, h )  end
    
    
    /*-------------------------------------------------
                        Tab Setup
    -------------------------------------------------*/
    
    //{
    local tabstext = {"Welcome", "Character", "Loadout", "Options", "Spawn"}
    if table.HasValue(admins, LocalPlayer():SteamID()) then table.insert(tabstext, 5, "Admin Panel") end
    for i=1, buttons do
        local Tab = vgui.Create( "DButton" )
        Tab:SetPos( (menuw/buttons)*(i-1), 0 )
        Tab:SetParent( ps )	
        Tab:SetFont("TheDefaultSettings3")
        Tab:SetTextColor(  Color( 0, 0, 0, 255 ) )
        if tabstext[i] == "Spawn" && LocalPlayer():Team() != 2 then
            Tab:SetText( "Close" )
        else
            Tab:SetText( tabstext[i] )
        end
        Tab:SetSize( math.ceil(menuw/buttons), tabheight )
        Tab.DoClick = function()
            for k, v in pairs(ps.Items) do
                if k == i then
                    if tabstext[i] == "Spawn" then
                        if LocalPlayer():GetNWString("Category") != "random" && ply:GetNWString("Melee") == "" && ply:GetNWString("Handgun") == "" && ply:GetNWString("Primary") == "" && ply:GetNWString("Throwable") == "" then
                            surface.PlaySound("buttons/button10.wav")
                            flash = 1;
                        else
                            net.Start("MMTeam")
                            net.SendToServer()
                            Frame:Close()
                            surface.PlaySound("ui/shock_reveal.wav")
                        end
                    else
                        ps:SetActiveTab(v.Tab)
                        LocalPlayer().LastTab = i
                        surface.PlaySound("ui/door_unlock.wav")
                    end
                end
            end
        end
        Tab.Paint = function( self, w, h )
            if flash != 0 && i == 3 then
                flash = flash + 1
                Tab:SetTextColor( Color( 255*(math.floor(flash/3)%2), 0, 0, 255 ) )
                if flash > 30 then
                    flash = 0
                end
            end
            if ps:GetActiveTab() == ps.Items[i].Tab then
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) )
            else
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 50 ) )
                draw.RoundedBox( 0, 0, h-2, w, 2, Color( 0, 0, 0, 255 ) )
            end
            draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
            draw.RoundedBox( 0, 0, 0, 1, h, Color( 0, 0, 0, 255 ) )
            draw.RoundedBox( 0, w-1, 0, 1, h, Color( 0, 0, 0, 255 ) )
        end
    end
    
	ps:AddSheet( tabstext[1], welcome, nil, false, false, "Basic gamemode information" )
	ps:AddSheet( tabstext[2], character, nil, false, false, "Select your playermodel" )
	ps:AddSheet( tabstext[3], loadout, nil, false, false, "Select your weapon" )
	ps:AddSheet( tabstext[4], options, nil, false, false, "Customize your experience" )
    if table.HasValue(admins, LocalPlayer():SteamID()) then
        ps:AddSheet( tabstext[5], admin, nil, false, false, "Admin options" )
        ps:AddSheet( tabstext[6], spawn, nil, false, false, "Join the mash" )
    else
        ps:AddSheet( tabstext[5], spawn, nil, false, false, "Join the mash" )
    end
    
    if LocalPlayer().LastTab == nil then
        LocalPlayer().LastTab = 1
    end
    ps:SetActiveTab(ps.Items[LocalPlayer().LastTab].Tab)

    for k, v in pairs(ps.Items) do
        if (!v.Tab) then 
            continue 
        end
        v.Tab:SetVisible(false)
    end
    //}
end

concommand.Add( "mm_menu", Class_Menu )
usermessage.Hook( "mm_menu", Class_Menu )