local version = "Version 2.11 Release" 
local panic_button = false
local wratio = ScrW()/1600
local hratio = ScrH()/900
local LoadoutFlash = 0
local MenuOpen = false

// Stories
local welcomemessage =  "Gain points for killing others with style, or leave them to wander the earth without any arms. If you stay long enough, the mash might be interrupted by something else...\n\nSelect your monster, carefully consider the budget on your weapon loadout (or return the weapon for a full refund), and press the Spawn button to join the graveyard smash."
local story = {
    "After the demise of Bobby Pickett, and the unfortunate cocaine addiction of The Coffin Bangers' main singer, the monsters had nowhere else to go and have chosen to fufill their everlasting need for bloodlust in one final mash.",
    "1 day yuo go to a garage sale and buy a vidoe game named 'Monster MAsh' and decide what the heck I should play it bcause it is almost halloween time but then the game sucked you into the computer becaus it was really haunted and have too fight all of the spooky monsters! The game mode your playing now is realy  your fight for survival dont get killed or you will die!!!!!!",
    "I was working in the lab late one night when my eyes beheld an eerie sight, for my monsters from their slabs began to rise, and suddenly to my surprise, they did the mash! They did the monster mash! It was a graveyard smash! It caught on in a flash! They did the monster mash!",
    "It's that time of the year again. When the leaves crumple and fall amidst the chilly autumn air, the days get shorter and the nights get longer, and the monsters are out to do their monster mash! With Halloween approaching fast, all of the monsters have resorted to a battle royale to fight for the title of Crypt Keeper and to become the lord of the the Samhain Season!",
    "Little Timmy down the street's parents are letting him host the ultimate Halloween party and you're invited! Timmy spent all of his allowance on nerf guns and spooky costumes for all his friends and the whole neighborhood is in on it! Put your costume on, bring your imagination, fill up on some sugary treats, and get ready to mash!",
    "Following up on your invitation for your audition to the next big Halloween movie 'Monster Mash', you arrive at the set and are given quite the task. Take down the other actors in the most spectacular fashions you can think of to become the star!",
    "You were hibernating in your coffin when one day you heard some commotion coming from the ground above and disturbing your beauty sleep. Agitated, you climb out of your grave to see what the fuss is about. It's time to dust off the old guns, shut this party down, and get back to resting in peace!",
    "The doctor was working in his lab late one night when you decided it was time to for a change in sight. From your slab you began to rise and suddenly, and to his surprise, you did the mash! Well it seems like from the laboratory in the castle east, to the master bedroom where vampires feast, all the other monsters were doing the mash as well, but who will be the life of the party?",
}

// Controls
local controls = {
    {"Controls"},
    {""},
    {"F1", "Open this menu"},
    {"Q", "Heal"},
    {"C", "Activate trick"},
    {"Shift+A/D", "Dodge roll"},
    {"F", "Candlestick"},
    {"Z", "Taunt"},
}

// Updates
local updates = {
    "What's new this update?",
    "",
    "Team support",
    "",
    ""
}

// Map credits
local mapcredits = {
    ["mm_harvest_v1"] = "Demo",
    ["mm_harvest_v2"] = "Demo",
    ["mm_harvest_night"] = "Demo",
    ["mm_rot"] = "Demo",
    ["mm_swamp"] = "Mushroom Guy, finished by Demo",
    ["mm_village"] = "Billion",
}

// Credits
local mmcredits = {
    {"Credits:", ""},
    {"Main Programmer", "- Buu342"},
    {"Modeler/Director", "- Demo"},
    {"Playtesters", "- Blargh"},
    {"", "- Maximus0451"},
    {"", "- Mr. Serious"},
    {"", "- Dr. Hammer"},
    {"", "- Rex the Impaler"},
    {"", "- Billion SL"},
    {"", "- Der Vampir"},
    {"", "- Tazer Man"},
    {"Current map:", game.GetMap()},
    {"", ""} // Blank for the map's creator
}

// Options checkboxes
local optionslist = {
    { text = "Dodge first person rotation",   command = "mm_rollrotatescreen" },
    { text = "Disable Haunted Urn Screamers", command = "mm_pussymode" },
    { text = "Blur Menu Background",          command = "mm_blurmenu" },
    { text = "Electrocution screen shake",    command = "mm_deanimatorshake" },
    { text = "Show tips in deathcam",         command = "mm_deathtips" },
    { text = "Auto reload when empty",        command = "mm_autoreload" },
    { text = "Screen blood",                  command = "mm_screenblood" },
    { text = "End Round Scoreboard",          command = "mm_endroundboard" },
    { text = "Aim Assist",                    command = "mm_aimassist" },
    { text = "Ye Olde Mode (experimental)",   command = "mm_oldtimeymode" },
    { text = "Confetti blood",                command = "mm_confetti" },
}

local musicbuttons = {
    { text = "Start",     command = "mm_musicplayerstart" },
    { text = "Stop",      command = "mm_musicplayerstop" },
    { text = "Auto" },
    { text = "Loop" },
    { text = "Shuffle" }
}

local adminoptions = {
    [01] = { text = "Buy Time",                    command = "mm_buytime" },
    [02] = { text = "Round Time",                  command = "mm_roundtime" },
    [03] = { text = "Round Ending Time",           command = "mm_endtime" },
    [04] = { text = "Round End Slowmo Duration",   command = "mm_slomo_duration" },
    [05] = { text = "End Scoreboard Display Time", command = "mm_endroundboard_time" },
    [06] = { text = "Point Limit",                 command = "mm_point_limit" },
    [07] = { text = "Rounds to Map Swap",          command = "mm_maxrounds" },
    [08] = { text = "Wacky Round Frequency",       command = "mm_wackyfrequency" },
    [09] = " ",
    [10] = { text = "Gold Limit",                  command = "mm_budget" },
    [11] = { text = "Cleanup Time",                command = "mm_cleanup_time" },
    [12] = { text = "Health Regen Time",           command = "mm_healthregen_time" },
    [13] = { text = "Health Regen Amount",         command = "mm_healthregen_amount" },
    [14] = " ",                                     
    [15] = { text = "Spawn Protection",            command = "mm_spawnprotect", checkbox = true },
    [16] = { text = "Death Cam",                   command = "mm_deathcam", checkbox = true },
    [17] = { text = "Ludicrous Gibs Mode",         command = "mm_ludicrousgibs", checkbox = true },
    [18] = { text = "Orgasmic Death Sounds",       command = "mm_orgasmicdeathsounds", checkbox = true },
    [19] = { text = "Tazerman Mode",               command = "mm_tasermanmode", checkbox = true },
    [20] = { text = "Wacky Taunts",                command = "mm_wackytaunts", checkbox = true },
    [21] = { text = "End of Monster Mash",         command = "mm_endofmonstermash", checkbox = true },
    [21] = { text = "Throwable Cooldown on Spawn", command = "mm_throwablespawncool", checkbox = true },
    [21] = { text = "Enable team mode",            command = "mm_teammode", checkbox = true },
}

// Add the map's creator to the credits
if (mapcredits[game.GetMap()] == nil) then
    mmcredits[#mmcredits] = nil
else
    mmcredits[#mmcredits][2] = "Created by "..mapcredits[game.GetMap()]
end

local function GetTableOrder(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[v.index] = k
    end
    return ret
end

function SimpleButtonPaint(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 105))
    draw.RoundedBox(0, 0, 0, 2, h, Color(0,0,0,255))
    draw.RoundedBox(0, w-2, 0, 2, h, Color(0,0,0,255))
    draw.RoundedBox(0, 0, 0, w, 2, Color(0,0,0,255))
    draw.RoundedBox(0, 0, h-2, w, 2, Color(0,0,0,255))
end

function SimpleButtonPaintCheck(self, w, h, check)
    local col = Color(0, 0, 0, 255)
    if check then
        col = Color(0, 0, 255, 255)
    end
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 105))
    draw.RoundedBox(0, 0, 0, 2, h, col)
    draw.RoundedBox(0, w-2, 0, 2, h, col)
    draw.RoundedBox(0, 0, 0, w, 2, col)
    draw.RoundedBox(0, 0, h-2, w, 2, col)
end

function TabPaint(self, w, h, ps, i)
    if ps:GetActiveTab() != nil && ps.Items[i] != nil && ps:GetActiveTab() == ps.Items[i].Tab then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
    else
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
        draw.RoundedBox(0, 0, h-2, w, 2, Color(0, 0, 0, 255))
    end
    draw.RoundedBox(0, 0, 0, w, 2, Color(0, 0, 0, 255))
    draw.RoundedBox(0, 0, 0, 1, h, Color(0, 0, 0, 255))
    draw.RoundedBox(0, w-1, 0, 1, h, Color(0, 0, 0, 255))
end

function TabClick(ps, i)
    for k, v in pairs(ps.Items) do
        if k == i then
            ps:SetActiveTab(v.Tab)
            LocalPlayer().LastTab = i
            surface.PlaySound("ui/tab_scroll.wav")
        end
    end
end

local controlheight = ScrH()
function DrawWelcome(frame, w, h)
    surface.PlaySound("ui/vending_shoot.wav")
    
    // Title
    local welcometitle = "WELCOME TO THE MASH"
    local text = vgui.Create("DLabel", frame)
    surface.SetFont("MMDefaultFont")
    text:SetFont("MMDefaultFont")
    text:SetPos(w/2-surface.GetTextSize(welcometitle)/2, h/30)
    text:SetColor(Color(0, 0, 0, 255))
    text:SetText(welcometitle)
    text:SizeToContents()
    
    // Story and welcome message
    local text = vgui.Create("DLabel", frame)
    local wpad = w/100
    text:SetPos(wpad, h/8)
    text:SetSize(w-wpad*4, h)
    text:SetColor(Color(0, 0, 0, 255))
    text:SetFont("MMMenuStory")
    text:SetText(story[math.random(1, #story)].."\n\n"..welcomemessage)
    text:SetAutoStretchVertical(true)
    text:SetWrap(true)
    local garb, finaly = surface.GetTextSize(story[math.random(1, #story)].."\n\n"..welcomemessage)
    finaly = finaly + h/7

    // Controls
    surface.SetFont("MMMenuControls")
    local longest = {}
    local extraspacing = surface.GetTextSize("--")
    for i=1, #controls do
        for j=1, #controls[i] do
            local w = surface.GetTextSize(controls[i][j])
            if (longest[j] == nil || w > longest[j]) then
                longest[j] = w
            end
        end
    end
    for i=1, #controls do
        for j=1, #controls[i] do
            surface.SetFont("MMMenuControls")
            local fw, fh = surface.GetTextSize(controls[i][j])
            local tw = wpad+extraspacing*(j-1)
            local th = finaly+(i-1)*fh
            local text = vgui.Create("DLabel", frame)
            local long = 0
            if (th < controlheight) then controlheight = th end
            if (j-1 > 0) then long = longest[j-1] end
            text:SetFont("MMMenuControls")
            text:SetColor(Color(81, 47, 112, 255))
            text:SetText(controls[i][j])
            text:SetPos(tw+long, th)
            text:SizeToContents()
        end
    end
    
    // Updates
    for i=1, #updates do
        local tw, th = surface.GetTextSize(updates[i])
        local text = vgui.Create("DLabel", frame)
        text:SetPos(w-wpad*3-tw, controlheight+th*(i-1))
        text:SetColor(Color(81, 47, 112, 255))
        text:SetFont("MMMenuControls")
        text:SetText(updates[i])
        text:SizeToContents()
    end
end

function UpdateCharacterText(character, nameframe1, nameframe2, textframe, w, h)    
    if character == nil then
        nameframe1:SetText("")
        nameframe1:SetSize(0, 0)
        nameframe2:SetText("")
        nameframe2:SetSize(0, 0)
        textframe:SetText("")
        textframe:SetSize(0, 0)
        return
    end
    local startx = 0
    local starty = h/16*(1-900/ScrH())
    local endy = 0
    
    surface.SetFont("MMFriday13")
    local fw, fh = surface.GetTextSize(character)
    
    nameframe1:SetPos(394*wratio+(240*wratio-fw)/2, starty+h/25)
    nameframe1:SetSize(230*wratio, fh)
    if (fw < 230*wratio) then
        nameframe1:SetText(character)
        nameframe2:SetText("")
        endy = fh
    else
        local str = string.Split(character, " ")
        local fw, fh = surface.GetTextSize(str[1])
        nameframe1:SetText(str[1])
        nameframe1:SetPos(394*wratio+(240*wratio-fw)/2, starty+h/25)
        
        local fw, fh = surface.GetTextSize(str[2])
        nameframe2:SetPos(394*wratio+(240*wratio-fw)/2, starty+h/25+fh)
        nameframe2:SetSize(230*wratio, fh)
        nameframe2:SetText(str[2])
        endy = fh*2
    end
    local intro = "First seen in:\n"
    if (character == "Invisible Man") then
        intro = "Not first seen in:\n"
    end
    textframe:SetPos(394*wratio, starty+h/25+endy)
    textframe:SetText(intro..GAMEMODE.Characters[character].origin.."\n\nTrivia\n"..GAMEMODE.Characters[character].trivia.."\n\nLoves: "..GAMEMODE.Characters[character].loves.."\nHates: "..GAMEMODE.Characters[character].hates)
    textframe:SetContentAlignment(7)
    textframe:SetSize(230*wratio, 640*hratio)
    textframe:SetWrap(true)
end

function UpdateSkinButtons(selectedchar, w, h, mdl_disp, mdl_size, starty, SkinButton)
    for i=1, #SkinButton do
        local char = GAMEMODE.Characters[selectedchar]
        if (char.skins != nil && char.skins[i] != nil) then
            SkinButton[i]:SetPos(mdl_disp+mdl_size/2+(30*wratio)*(i-1)-((30*wratio)*(#char.skins))/2, starty+mdl_size)
            if (char.skins[i].r == nil) then
                SkinButton[i].Col1 = char.skins[i][1]
                SkinButton[i].Col2 = char.skins[i][2]
            else
                SkinButton[i].Col1 = char.skins[i]
                SkinButton[i].Col2 = nil
            end
        else
            SkinButton[i]:SetPos(w+10000, h+10000)
        end
    end
end

function DrawCharacter(frame, w, h)
    local startx = 0
    local starty = h/16*(1-900/ScrH())
    
    local CharacterName1 = vgui.Create("DLabel", frame)
    CharacterName1:SetPos(394*wratio, starty+h/25)
    CharacterName1:SetColor(Color(0, 0, 0, 255))
    CharacterName1:SetFont("MMFriday13")
    
    local CharacterName2 = vgui.Create("DLabel", frame)
    CharacterName2:SetPos(394*wratio, starty+h/25)
    CharacterName2:SetColor(Color(0, 0, 0, 255))
    CharacterName2:SetFont("MMFriday13")

    local CharacterDesc = vgui.Create("DLabel", frame)
    CharacterDesc:SetPos(448, 64)
    CharacterDesc:SetColor(Color(0, 0, 0, 255))
    CharacterDesc:SetFont("MMCharacterDesc")
    CharacterDesc:SetText("")
    
    UpdateCharacterText(LocalPlayer():GetCharacterTemp(), CharacterName1, CharacterName2, CharacterDesc, w, h)
    
    local CharModel = vgui.Create("DModelPanel", frame)
    local mdl_size = 400*hratio
    local mdl_disp = 108*wratio
    CharModel:SetPos(mdl_disp,  starty+h/25)
    CharModel:SetSize(mdl_size, mdl_size)
    CharModel:SetAnimated(false)
    CharModel:SetAnimSpeed(0)
    if (LocalPlayer():GetCharacterTemp() != nil) then
        CharModel:SetModel(GAMEMODE.Characters[LocalPlayer():GetCharacterTemp()].model)
        CharModel.Entity:SetSkin(LocalPlayer():GetSkinTemp())
    else
        CharModel:SetModel("")
    end
    if (LocalPlayer():GetCharacterTemp() == "Random") then
        CharModel:SetCamPos(Vector(100, -30, 10))
    else
        CharModel:SetCamPos(Vector(50,-30, 60))
    end
    function CharModel:LayoutEntity(Entity) return end
    
    local SkinButton = {
        vgui.Create("DButton", frame),
        vgui.Create("DButton", frame),
        vgui.Create("DButton", frame),
        vgui.Create("DButton", frame),
        vgui.Create("DButton", frame),
        vgui.Create("DButton", frame)
    }
    for i=1, #SkinButton do
        SkinButton[i]:SetText(tostring(i))
        SkinButton[i]:SetTextColor( Color(255, 150, 0, 255))
        SkinButton[i]:SetPos(w+10000, h+10000)
        SkinButton[i]:SetSize(30*wratio, 30*wratio)
        SkinButton[i].Col1 = Color(255, 255, 255, 255)
        SkinButton[i].Col2 = Color(255, 255, 255, 255)
        SkinButton[i].DoClick = function()
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            CharModel.Entity:SetSkin(i-1)
            LocalPlayer():RequestSkinChange(i-1)
        end
        SkinButton[i].Paint = function()
            if (SkinButton[i].Col2 == nil) then
                surface.SetDrawColor(SkinButton[i].Col1.r, SkinButton[i].Col1.g, SkinButton[i].Col1.b, 255)
                surface.DrawRect(0, 0, SkinButton[i]:GetWide(), SkinButton[i]:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
            else
                surface.SetDrawColor(SkinButton[i].Col1.r, SkinButton[i].Col1.g, SkinButton[i].Col1.b, 255)
                surface.DrawRect(0, 0, SkinButton[i]:GetWide(), SkinButton[i]:GetTall())
                surface.SetDrawColor(SkinButton[i].Col2.r, SkinButton[i].Col2.g, SkinButton[i].Col2.b, 255)
                surface.DrawRect(0, 0, SkinButton[i]:GetWide(), SkinButton[i]:GetTall()/2)
                surface.SetDrawColor(255, 255, 255, 255)
            end
        end
    end
    if (LocalPlayer():GetCharacterTemp() != nil) then
        UpdateSkinButtons(LocalPlayer():GetCharacterTemp(), w, h, mdl_disp, mdl_size, starty, SkinButton)
    end

    local pad = h/80
    local realxstart = startx + w/60
    local realystart = starty + h/25
    local butx = realxstart
    local buty = realystart
    local buttonsize = h/7.5
    for k, _ in pairs(GetTableOrder(GAMEMODE.Characters)) do
        local v = GAMEMODE.Characters[_]
        if !v.unlisted && LocalPlayer():CanUseCharacter(_) then
            local BGPanel = vgui.Create("DPanel", frame)
            BGPanel:SetPos(butx, buty)
            BGPanel:SetSize(buttonsize, buttonsize)
            local mdl = vgui.Create("SpawnIcon", BGPanel)
            mdl:SetSize(BGPanel:GetSize())
            mdl:SetModel(v.model)
            mdl.Char = _
            BGPanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 105))
            end
            function mdl:DoClick()
                surface.PlaySound("ui/door_unlock.wav")
                UpdateCharacterText(self.Char, CharacterName1, CharacterName2, CharacterDesc, w, h)
                LocalPlayer():RequestSkinChange(0)
                LocalPlayer():RequestCharacterChange(self.Char)
                CharModel:SetModel(GAMEMODE.Characters[self.Char].model)
                if (self.Char == "Random") then
                    CharModel:SetCamPos(Vector(100, -30, 10))
                else
                    CharModel:SetCamPos(Vector(50,-30, 60))
                end
                UpdateSkinButtons(self.Char, w, h, mdl_disp, mdl_size, starty, SkinButton)
            end
            buty = buty + buttonsize + pad
            if (buty+buttonsize > (h-h/16)) then
                buty = realystart
                butx = butx + buttonsize + pad
            end
        end
    end
end

function UpdateLoadoutText(frame, info, w, h)
    if (info == nil) then
        frame.Text1:SetText("")
        frame.Text2:SetText("")
        frame.Desc:SetText("")
        return
    end
    local start_y = 20*hratio
    local end_y = 0
    local finaldesc = info.Weptable.description
    surface.SetFont("MMFriday13")
    local finalfirst = info.PrintName
    if (info.PrintName == "Shield + Revolver") then
        finalfirst = "Shield +"
        info.PrintName2 = "Revolver"
    elseif (info.PrintName == "Sawblade Launcher") then
        finalfirst = "Sawblade"
        info.PrintName2 = "Launcher"
    else
        if (info.PrintName == "?") then
            finalfirst = "Random"
        end
        info.PrintName2 = ""
    end
    local fw, fh = surface.GetTextSize(finalfirst)
    frame.Text1:SetPos(394*wratio+(240*wratio-fw)/2, h/30)
    frame.Text1:SetText(finalfirst)
    end_y = end_y + fh*1.2
    if (info.PrintName2 != "") then
        local fw, fh = surface.GetTextSize(info.PrintName2)
        frame.Text2:SetPos(394*wratio+(240*wratio-fw)/2, 40+h/20)
        frame.Text2:SetText(info.PrintName2)
        end_y = end_y + fh
    else
        frame.Text2:SetText("")
    end
    
    if (finaldesc != "") then
        finaldesc = finaldesc.."\n"
        if (info.Weptable.firemode != nil) then
            finaldesc = finaldesc.."\nFiremode: "..info.Weptable.firemode
        end
        if (info.Weptable.damage != nil) then
            finaldesc = finaldesc.."\nDamage: "..info.Weptable.damage
        end
        if (info.Weptable.range != nil) then
            finaldesc = finaldesc.."\nRange: "..info.Weptable.range.." units"
        end
        if (info.Weptable.clipsize != nil) then
            finaldesc = finaldesc.."\nClip Size: "..info.Weptable.clipsize
        end
        if (info.Weptable.concusschance != nil) then
            finaldesc = finaldesc.."\n\nConcuss chance: "..info.Weptable.concusschance.."%"
        end
        if (info.Weptable.bleedchance != nil) then
            finaldesc = finaldesc.."\nBleed chance: "..info.Weptable.bleedchance.."%"
        end
        if (info.Weptable.dismemberchance != nil) then
            finaldesc = finaldesc.."\nDismember chance: "..info.Weptable.dismemberchance.."%"
        end
        if (info.Weptable.points != nil && info.Weptable.points > 0) then
            finaldesc = finaldesc.."\n\nBase Points: "..info.Weptable.points
        end
    end
    frame.Desc:SetPos(w-230*wratio, start_y+end_y)
    frame.Desc:SetText(finaldesc)
end

function DrawLoadout(frame, w, h)
    local i=0
    local correcty = 30*hratio-28
    local framehtabs = (h-30*hratio - 48*hratio*(#GAMEMODE.WeaponOrder))/(#GAMEMODE.WeaponOrder+1)
    local framehweps = (h-30*hratio - 64*hratio*6)/(6+1)
    local Weapons = {}
    local WeaponListInOrder = {}
    local MaxWeapons = 23
    local GoldText
    local WeaponText = {}
    local CurGold = LocalPlayer():GetGold()
    local CurTab = nil
    
    WeaponText.Text1 = vgui.Create("DLabel", frame)
    WeaponText.Text1:SetTextColor(Color(0, 0, 0, 255))
    WeaponText.Text1:SetPos(w-160*wratio, 0)
    WeaponText.Text1:SetFont("MMFriday13")
    WeaponText.Text1:SetSize(320*wratio, 64*wratio)
    WeaponText.Text1:SetText("")
    WeaponText.Text1:SetContentAlignment(7)
    WeaponText.Text2 = vgui.Create("DLabel", frame)
    WeaponText.Text2:SetTextColor(Color(0, 0, 0, 255))
    WeaponText.Text2:SetPos(w-160*wratio, 0)
    WeaponText.Text2:SetFont("MMFriday13")
    WeaponText.Text2:SetSize(320*wratio, 64*wratio)
    WeaponText.Text2:SetText("")
    WeaponText.Text2:SetContentAlignment(7)
    WeaponText.Desc = vgui.Create("DLabel", frame)
    WeaponText.Desc:SetTextColor(Color(0, 0, 0, 255))
    WeaponText.Desc:SetPos(w-160*wratio, 0)
    WeaponText.Desc:SetFont("MMCharacterDesc")
    WeaponText.Desc:SetSize(200*wratio, 300*wratio)
    WeaponText.Desc:SetText("")
    WeaponText.Desc:SetContentAlignment(7)
    WeaponText.Desc:SetWrap(true)
    
    // Draw tabs
    for k, v in pairs(GAMEMODE.WeaponOrder) do
        if (v != "Random") then
            WeaponListInOrder[(i+1)] = GetTableOrder(GAMEMODE.Weapons[v])
        end
        local TypeTab = vgui.Create("DButton", frame)
        TypeTab:SetPos(16*wratio-10*wratio, correcty+(i+1)*framehtabs+48*hratio*i)
        TypeTab:SetFont("MMTabs")
        TypeTab:SetTextColor( Color(0, 0, 0, 255))
        TypeTab:SetText(v)
        TypeTab:SetSize(100*wratio, 48*hratio)
        TypeTab.index = i+1
        TypeTab.v = v
        TypeTab.Paint = function(self, w, h)
            local col = Color(0,0,0,255)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 105))
            draw.RoundedBox(0, 0, 0, 2, h, col)
            draw.RoundedBox(0, w-2, 0, 2, h, col)
            draw.RoundedBox(0, 0, 0, w, 2, col)
            draw.RoundedBox(0, 0, h-2, w, 2, col)
            if (CurTab == self) then
                surface.SetDrawColor(Color(81, 47, 112, 255))
                surface.DrawOutlinedRect(0, 0, w, h, 5)
            end
        end
        function TypeTab:DoClick()
            if (CurTab == self) then
                return
            end
            surface.PlaySound("ui/door_unlock.wav")
            CurTab = self
            if (v != "Random" && LocalPlayer():GetWeaponTable() != nil) then
                local weptemp
                if (v == "Trick") then
                    weptemp = {
                        PrintName = GAMEMODE.Weapons[v][LocalPlayer():GetWeaponTable()["Trick_NextLife"]].name,
                        Weptable = GAMEMODE.Weapons[v][LocalPlayer():GetWeaponTable()["Trick_NextLife"]]
                    }
                else
                    weptemp = {
                        PrintName = GAMEMODE.Weapons[v][LocalPlayer():GetWeaponTable()[v]].name,
                        Weptable = GAMEMODE.Weapons[v][LocalPlayer():GetWeaponTable()[v]]
                    }
                end
                UpdateLoadoutText(WeaponText, weptemp, w, h)
            else
                UpdateLoadoutText(WeaponText, nil, w, h)
            end
            for j=0, MaxWeapons-1 do
                if (v != "Random" && j <= #WeaponListInOrder[self.index]) then
                    local class = WeaponListInOrder[self.index][j]
                    local weapontable = GAMEMODE.Weapons[v][class]
                    Weapons[j+1].Panel:SetPos(120*wratio+72*math.floor(j/6)*wratio, correcty+(j%6+1)*framehweps+64*hratio*(j%6))
                    if (weapontable.icon != -1) then
                        Weapons[j+1].Image = weapontable.icon:GetName()
                        Weapons[j+1].Text = ""
                        Weapons[j+1].PrintName = weapontable.name
                    else
                        Weapons[j+1].Image = "nothing"
                        Weapons[j+1].Text = weapontable.name
                        Weapons[j+1].PrintName = weapontable.name
                    end
                    Weapons[j+1].Category = v
                    Weapons[j+1].Class = class
                    Weapons[j+1].Cost = weapontable.cost
                    Weapons[j+1].Weptable = weapontable
                else
                    Weapons[j+1].Panel:SetPos(ScrW(), ScrH())
                end
            end
            if (v == "Random") then
                for i=1, 5 do
                    net.Start("MM_RequestWeaponChange", true) 
                        net.WriteString("Random")
                        net.WriteString(GAMEMODE.WeaponOrder[i])
                    net.SendToServer()
                    LocalPlayer():BuyWeapon("Random", GAMEMODE.WeaponOrder[i])
                    CurGold = 100
                    GoldText:SetText(tostring(100))
                end
            end
        end
        i = i+1
    end
    
    // Draw weapons
    for i=1, MaxWeapons do
        if (Weapons[i] == nil) then
            Weapons[i] = {}
        end
        Weapons[i].Panel = vgui.Create("DImageButton", frame)
        Weapons[i].Panel:SetPos(ScrW(), ScrH())
        Weapons[i].Panel:SetTextColor(Color(0, 0, 0, 255))
        Weapons[i].Panel:SetSize(64*wratio, 64*hratio)
        Weapons[i].Panel:SetContentAlignment(5)
        Weapons[i].Panel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 105))
            draw.RoundedBox(0, 0, 0, 2, h, Color(0, 0, 0, 255))
            draw.RoundedBox(0, w-2, 0, 2, h, Color(0, 0, 0, 255))
            draw.RoundedBox(0, 0, 0, w, 2, Color(0, 0, 0, 255))
            draw.RoundedBox(0, 0, h-2, w, 2, Color(0, 0, 0, 255))
            if Weapons[i].Panel:IsHovered() == true then
                Weapons[i].Panel:SetFont("MMCostFont")
                Weapons[i].Panel:SetImage("nothing")
                if Weapons[i].Category != "Trick" then
                    local category = Weapons[i].Category
                    
                    if (LocalPlayer():GetWeaponTable() != nil && CurGold+GAMEMODE.Weapons[category][LocalPlayer():GetWeaponTable()[category]].cost-Weapons[i].Cost < 0) then
                        Weapons[i].Panel:SetTextColor(Color(255, 0, 0, 255))
                    else
                        Weapons[i].Panel:SetTextColor(Color(0, 0, 0, 255))
                    end
                    Weapons[i].Panel:SetText(Weapons[i].Cost.." Gold")
                else
                    Weapons[i].Panel:SetText(Weapons[i].Cost.." Treats")
                end
            else
                Weapons[i].Panel:SetTextColor(Color(0, 0, 0, 255))
                Weapons[i].Panel:SetFont("MMTabs")
                if (Weapons[i].Image != nil) then
                    Weapons[i].Panel:SetImage(Weapons[i].Image)
                end
                if (Weapons[i].Text != nil) then
                    Weapons[i].Panel:SetText(Weapons[i].Text)
                end
            end
            if (LocalPlayer():GetWeaponTable() != nil && ((Weapons[i].Category != "Trick" && LocalPlayer():GetWeaponTable()[Weapons[i].Category] == Weapons[i].Class) || (Weapons[i].Category == "Trick" && LocalPlayer():GetWeaponTable()["Trick_NextLife"] == Weapons[i].Class))) then
                surface.SetDrawColor(Color(81, 47, 112, 255))
                surface.DrawOutlinedRect(0, 0, w, h, 5)
            end
        end
        Weapons[i].Panel.DoClick = function()
            local retval
            net.Start("MM_RequestWeaponChange", true) 
                net.WriteString(Weapons[i].Class)
                net.WriteString(Weapons[i].Category)
            net.SendToServer()
            retval = LocalPlayer():BuyWeapon(Weapons[i].Class, Weapons[i].Category)
            if (retval != -1) then
                CurGold = retval
                GoldText:SetText(tostring(CurGold))
                surface.PlaySound("ui/keys_pickup-0"..math.random(1,4)..".wav")
            end
            UpdateLoadoutText(WeaponText, Weapons[i], w, h)
        end
    end
    
    // Draw loadout
    local Loadout = {}
    for i=1, 5 do
        Loadout[i] = vgui.Create("DImageButton", frame)
        Loadout[i]:SetPos(w-66*wratio-56*(5-1-(i-1))*wratio, h-86*hratio)
        Loadout[i]:SetFont("MMDefaultFont")
        Loadout[i]:SetText("")
        Loadout[i]:SetTextColor( Color(0, 0, 0, 255))
        Loadout[i]:SetSize(48*wratio, 48*wratio)
        Loadout[i]:SetContentAlignment(5)
        Loadout[i].Panel.Paint = function(self, w, h)
            local class
            local category = GAMEMODE.WeaponOrder[i]
            if (LocalPlayer():GetWeaponTable() != nil) then
                if (i != 5) then
                    class = LocalPlayer():GetWeaponTable()[category]
                else
                    class = LocalPlayer():GetWeaponTable()["Trick_NextLife"]
                end
            end
            local weapontable = GAMEMODE.Weapons[category][class]
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 105))
            draw.RoundedBox(0, 0, 0, 2, h, Color(0, 0, 0, 255))
            draw.RoundedBox(0, w-2, 0, 2, h, Color(0, 0, 0, 255))
            draw.RoundedBox(0, 0, 0, w, 2, Color(0, 0, 0, 255))
            draw.RoundedBox(0, 0, h-2, w, 2, Color(0, 0, 0, 255))
            if (class == "Random") then
                Loadout[i]:SetText("?")
                Loadout[i]:SetImage("nothing")
            elseif (class == "None") then
                Loadout[i]:SetText("")
                Loadout[i]:SetImage("nothing")
            elseif (class != nil) then
                Loadout[i]:SetText("")
                Loadout[i]:SetImage(weapontable.icon:GetName())
            end
        end
        Loadout[i].Panel.DoClick = function()
            if (CurTab != nil && CurTab.v == "Random") then return end
            local category = GAMEMODE.WeaponOrder[i]
            local class
            if (LocalPlayer():GetWeaponTable() != nil) then
                class = LocalPlayer():GetWeaponTable()[category]
            end
            if (class != "None") then
                net.Start("MM_RequestWeaponChange", true) 
                    net.WriteString("None")
                    net.WriteString(category)
                net.SendToServer()
                retval = LocalPlayer():BuyWeapon("None", category)
                if (retval != -1) then
                    CurGold = retval
                    GoldText:SetText(tostring(CurGold))
                end
                surface.PlaySound("ui/keys_pickup-0"..math.random(1,4)..".wav")
            end
            if (CurTab != nil && CurTab.v == GAMEMODE.WeaponOrder[i]) then
                UpdateLoadoutText(WeaponText, nil, w, h)
            end
        end
    end
    
    local GoldIcon = vgui.Create("DImageButton", frame)
    GoldIcon:SetPos(w-180*wratio, h-correcty-135*hratio)
    GoldIcon:SetTextColor(Color(0, 0, 0, 255))
    GoldIcon:SetSize(48*hratio, 48*hratio)
    GoldIcon:SetImage("vgui/hud/goldstack")
    GoldIcon:SetContentAlignment(5)
    
    GoldText = vgui.Create("DLabel", frame)
    GoldText:SetTextColor(Color(0, 0, 0, 255))
    GoldText:SetPos(w-130*wratio, h-correcty-135*hratio)
    GoldText:SetFont("MMDefaultFont")
    GoldText:SetSize(64*wratio, 64*wratio)
    GoldText:SetText(tostring(CurGold))
    GoldText:SetContentAlignment(7)
end

function DrawOptions(frame, w, h)

    local optionsy = 0

    // Add the options checkboxes
    for i=1, #optionslist do
        local Checkbox = vgui.Create("DCheckBoxLabel", frame)
        Checkbox.command = optionslist[i].command
        Checkbox:SetPos(16, h/16*(1-900/ScrH())+i*24*hratio)
        Checkbox:SetTextColor(Color(0, 0, 0, 255))
        Checkbox:SetFont("MMCharacterDesc")	
        Checkbox:SetText(optionslist[i].text)	
        Checkbox:SetValue(GetConVar(Checkbox.command):GetBool())		
        function Checkbox:OnChange(value)
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            if value == false then
                booltoint = 0
            else
                booltoint = 1
            end
            LocalPlayer():ConCommand(self.command.." "..booltoint)
        end
        optionsy = optionsy+20
    end
    
    // Load music player settings
    local musicsettings = util.JSONToTable(file.Read("monstermash/music.json", "DATA") or "")
    if (musicsettings == nil) then
        musicsettings = {}
    end
    
    // Music Player
    local x = w-350*wratio
    local y = h/16*(1-900/ScrH()) + 16*hratio
    local f = vgui.Create("DPanel", frame)
    local MusicTimeSlider = vgui.Create("DNumSlider", frame)
    f:SetSize(330*wratio, 300*hratio)
    f:SetPos(x,y)
    local MusicSelection = vgui.Create("DListView", f)
    MusicSelection:Dock(FILL)
    MusicSelection:SetMultiSelect(false)
    MusicSelection:AddColumn("Enabled"):ResizeColumn(-32)
    MusicSelection:AddColumn("Song")
    MusicSelection:AddColumn("Artist")
    MusicSelection.musicselected = 0
    for i=1, #MusicList do
        local value = "Enabled"
        if (musicsettings != nil && musicsettings[MusicList[i].name] != nil && musicsettings[MusicList[i].name] == false) then
            value = "Blacklisted"
        end
        MusicSelection:AddLine(value, MusicList[i].name, MusicList[i].author)
        if MusicGetCurrentSong() == MusicList[i] then
            MusicSelection:SelectItem(MusicSelection:GetLine(i))
            MusicSelection.musicselected = i
        end
    end
    MusicSelection.DoDoubleClick = function(lineID, line)
        local name = MusicSelection:GetLine(line):GetColumnText(2)
        if (musicsettings[name] == nil || musicsettings[name] == true) then
            MusicSelection:GetLine(line):SetColumnText(1, "Blacklisted")
            musicsettings[name] = false
        else
            MusicSelection:GetLine(line):SetColumnText(1, "Enabled")
            musicsettings[name] = true
        end
        file.Write("monstermash/music.json", util.TableToJSON(musicsettings))
    end
    MusicSelection.OnRowSelected = function(lst, index, pnl)
        MusicSelection.musicselected = index
    end
    
    for i=1, 5 do
        local MusicButton = vgui.Create("DButton", frame)
        MusicButton:SetPos(x, y+hratio*8+300*hratio)
        MusicButton:SetFont("MMMenuControls")
        MusicButton:SetTextColor( Color(0, 0, 0, 255))
        MusicButton:SetText(musicbuttons[i].text)
        MusicButton.command = musicbuttons[i].command
        if i == 1 then
            MusicButton.Arg = -1
        else
            MusicButton.Arg = " "
        end
        MusicButton:SetSize(62*wratio, 16*hratio)
        function MusicButton:DoClick()
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            if self:GetText() == "Start" then
                GeneratePlaylist(MusicSelection.musicselected)
                MusicPlay({MusicSelection.musicselected}, true)
            elseif self:GetText() == "Stop" then
                if (MusicGetCurrentSong() != nil) then
                    LocalPlayer():ChatPrint("Stopping music")
                end
                MusicStop()
            elseif self:GetText() == "Auto" then
                MusicSetAutoPlay(!MusicGetAutoPlay())
                MusicSetLooping(false)
                MusicSetShuffle(false)
                GeneratePlaylist(MusicSelection.musicselected)
            elseif self:GetText() == "Loop" then
                MusicSetAutoPlay(false)
                MusicSetLooping(!MusicGetLooping())
                MusicSetShuffle(false)
                GeneratePlaylist(MusicSelection.musicselected)
            elseif self:GetText() == "Shuffle" then
                MusicSetAutoPlay(false)
                MusicSetLooping(false)
                MusicSetShuffle(!MusicGetShuffle())
                GeneratePlaylist(MusicSelection.musicselected)
            end
        end
        MusicButton.Paint = function(self, w, h)
            local arg
            if (self.command == nil) then
                if self:GetText() == "Auto" then
                    arg = MusicGetAutoPlay()
                elseif self:GetText() == "Loop" then
                    arg = MusicGetLooping()
                elseif self:GetText() == "Shuffle" then
                    arg = MusicGetShuffle()
                end
            elseif self.command == "mm_musicplayerstart" then
                arg = MusicGetCurrentSong() != nil
            end        
            SimpleButtonPaintCheck(self, w, h, arg)
        end
        x = x + 67*wratio
    end
    
    MusicTimeSlider:SetPos(w-600*wratio, y+hratio*8+308*hratio+16*hratio)
    MusicTimeSlider:SetSize(580*wratio, 32*hratio)
    MusicTimeSlider:SetMin(0.01)
    MusicTimeSlider:SetMax(MusicGetLength())
    MusicTimeSlider:SetValue(MusicGetTime())
    MusicTimeSlider:SetDecimals(2)
    MusicTimeSlider:SetDark(true)
    MusicTimeSlider.Scratch:SetZoom(0)
    MusicTimeSlider.LastSong = nil
    function MusicTimeSlider:OnValueChanged(num)
        if self:IsEditing() then
            MusicSetTime(num)
        end
    end
    function MusicTimeSlider:Think()
        if (MusicGetCurrentSong() != nil && !self:IsEditing()) then
            self:SetMax(MusicGetLength())
            self:SetValue(MusicGetTime())
        end
        
        // Music changed, update the selected track
        if (self.LastSong != nil && self.LastSong != MusicGetCurrentSong()) then
            for i=1, #MusicList do
                if MusicGetCurrentSong() == MusicList[i] then
                    MusicSelection:ClearSelection()
                    MusicSelection:SelectItem(MusicSelection:GetLine(i))
                    MusicSelection.musicselected = i
                    break
                end
            end
        end
        self.LastSong = MusicGetCurrentSong()
    end
    local SliderText = MusicTimeSlider:GetTextArea()
    SliderText:SetTextColor(Color(0, 0, 0, 255))
    SliderText:SetFont("MMCharacterDesc")
    SliderText:SetEnabled(false)
    SliderText:SetEditable(false)
    SliderText:SetEnterAllowed(false)
    
    y = y+32
    local Slide = vgui.Create("DNumSlider", frame)
    Slide:SetPos(w-350*wratio, y+hratio*8+308*hratio+16*hratio)
    Slide:SetSize(330*wratio, 32*hratio)
    Slide:SetText("Music Volume")
    Slide:SetMin(0.01)
    Slide:SetMax(1)
    Slide:SetValue(MusicGetVolume())
    Slide:SetDecimals(2)
    Slide:SetDark(true)
    Slide.Label:SetFont("MMCharacterDesc")
    function Slide:OnValueChanged(num)
        MusicSetVolume(num)
    end
    local SliderText = Slide:GetTextArea()
    SliderText:SetTextColor(Color(0, 0, 0, 255))
    SliderText:SetFont("MMCharacterDesc")
end

function DrawAdmin(frame, w, h)
    local x = 16*wratio
    local y = h/16*(1-900/ScrH()) + 16*hratio
    for i=1, #adminoptions do
        local v = adminoptions[i]
        if (v != " ") then
            if (v.checkbox) then
                local Checkbox = vgui.Create("DCheckBoxLabel", frame)
                Checkbox:SetPos(x, y)
                Checkbox:SetTextColor(Color(0, 0, 0, 255))
                Checkbox:SetFont("MMCharacterDesc")
                Checkbox:SetText(v.text)
                Checkbox.command = v.command
                Checkbox:SetValue(GetConVar(v.command):GetBool())
                function Checkbox:OnChange(value)
                    surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                    net.Start("MM_RequestAdminCVarChangeBool", true)
                        net.WriteString(self.command)
                        net.WriteBool(value)
                    net.SendToServer()
                end
            else
                local Text = vgui.Create("DLabel", frame)
                Text:SetPos(x, y)
                Text:SetColor(Color(0, 0, 0, 255))
                Text:SetFont("MMCharacterDesc")
                Text:SetText(v.text)
                Text:SizeToContents()
                local TextEntry = vgui.Create("DTextEntry", frame)
                TextEntry:SetPos(x+200*wratio, y)
                TextEntry:SetFont("MMCharacterDesc")
                TextEntry:SetSize(75*wratio, 18*hratio)
                TextEntry.Different = false
                TextEntry.command = v.command
                TextEntry:SetText(tostring(GetConVar(v.command):GetInt()))
                function TextEntry:Think()
                    if self.Different && !self:IsEditing() then
                        self.Different = false
                        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
                        net.Start("MM_RequestAdminCVarChangeVal", true)
                            net.WriteString(self.command)
                            net.WriteInt(self:GetValue(), 32)
                        net.SendToServer()
                    end
                end
                TextEntry.OnChange = function(self)
                    self.Different = true
                end
            end
        end
        y = y+18*hratio
    end
    
    local AdminButton = vgui.Create("DButton", frame)
    AdminButton:SetPos(w-150*wratio-32*wratio, h-100*hratio)
    AdminButton:SetFont("MMTabs")
    AdminButton:SetTextColor( Color(0, 0, 0, 255))
    AdminButton:SetText("End Round")
    AdminButton:SetSize(150*wratio, 48*hratio)
    AdminButton.DoClick = function()
        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
        net.Start("MM_EndCurrentRound", true)
            net.WriteString("The round was forcefully ended")
        net.SendToServer()
    end
    AdminButton.Paint = function(self, w, h) SimpleButtonPaint(self, w, h) end
    
    local selectedplayer = nil
    local selectedround = nil
    local time = 60
    local reason = "Reason"
    
    x = w - 300*wratio
    y = h/16*(1-900/ScrH()) + 12*hratio
    y = y + 12*hratio
    x = x + 128*wratio
    local AdminButton = vgui.Create("DButton", frame)
    AdminButton:SetPos(x,y)
    AdminButton:SetFont("MMCharacterDesc")
    AdminButton:SetTextColor( Color(0, 0, 0, 255))
    AdminButton:SetText("Kick")
    AdminButton:SetSize(64*wratio, 20*hratio)
    function AdminButton:DoClick()
        if selectedplayer == nil then return end
        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
        LocalPlayer():ConCommand("say !kick "..selectedplayer.." "..reason)
    end
    
    x = x + 72*wratio
    local AdminButton = vgui.Create("DButton", frame)
    AdminButton:SetPos(x,y)
    AdminButton:SetFont("MMCharacterDesc")
    AdminButton:SetTextColor( Color(0, 0, 0, 255))
    AdminButton:SetText("Ban")
    AdminButton:SetSize(64*wratio, 20*hratio)
    function AdminButton:DoClick()
        if selectedplayer == nil then return end
        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
        LocalPlayer():ConCommand("say !ban "..selectedplayer.." "..time)
    end
    
    x = x - 72*wratio
    y = y + 32*hratio
                    
    local TextEntry = vgui.Create("DTextEntry", frame)
    TextEntry:SetFont("MMCharacterDesc")
    TextEntry:SetPos(x, y)
    TextEntry:SetSize(134*wratio, 24*hratio)
    TextEntry:SetText(reason)
    TextEntry.Different = false
    function TextEntry:Think()
        if self.Different && !self:IsEditing() then
            self.Different = false
            surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
            reason = tostring(self:GetValue())
        end
    end
    TextEntry.OnChange = function(self)
        self.Different = true
    end
    y = y + 24*hratio
    local Slide = vgui.Create("DNumSlider", frame)
    Slide:SetPos(x-128*wratio, y)
    Slide:SetSize(300*wratio, 32*hratio)
    Slide:SetText("")
    Slide:SetMin(0)
    Slide:SetMax(1000)
    Slide:SetValue(time)
    Slide:SetDecimals(0)
    Slide:SetDark(true)
    Slide.Label:SetFont("MMCharacterDesc")
    function Slide:OnValueChanged(num)
        time = math.Round(num)
    end
    local SliderText = Slide:GetTextArea()
    SliderText:SetTextColor(Color(0, 0, 0, 255))
    SliderText:SetFont("MMCharacterDesc")
    
    x = w - 300*wratio
    y = h/16*(1-900/ScrH()) + 12*hratio
    local f = vgui.Create("DPanel", frame)
    f:SetSize(100*wratio, 100*hratio)
    f:SetPos(x,y)
    local List = vgui.Create("DListView", f)
    List:Dock(FILL)
    List:SetMultiSelect(false)
    List:AddColumn("Players")
    //List:SetFont("MMCharacterDesc")
    for k, v in pairs(player.GetAll()) do
        List:AddLine(v:Nick())
    end
    List.OnRowSelected = function(lst, index, pnl)
        selectedplayer = pnl:GetColumnText(1)
    end
    
    y = y + 110*hratio
    local f = vgui.Create("DPanel", frame)
    f:SetSize(200*wratio, 128*hratio)
    f:SetPos(x,y)
    local List = vgui.Create("DListView", f)
    List:Dock(FILL)
    List:SetMultiSelect(false)
    List:AddColumn("Wacky Rounds")
    //List:SetFont("MMCharacterDesc")
    for k, v in pairs(GAMEMODE.WackyRounds) do
        List:AddLine(k)
    end
    List.OnRowSelected = function(lst, index, pnl)
        selectedround = pnl:GetColumnText(1)
    end
    
    local AdminButton = vgui.Create("DButton", frame)
    AdminButton:SetPos(x+25*wratio, y+144*hratio)
    AdminButton:SetFont("MMTabs")
    AdminButton:SetTextColor( Color(0, 0, 0, 255))
    AdminButton:SetText("Force Wacky")
    AdminButton:SetSize(150*wratio, 48*hratio)
    AdminButton.DoClick = function()
        surface.PlaySound("ui/keycard_collision-0"..math.random(1,5)..".wav")
        if (selectedround != nil) then
            net.Start("MM_ForceWacky", true)
                net.WriteString(selectedround)
            net.SendToServer()
        end
    end
    AdminButton.Paint = function(self, w, h) SimpleButtonPaint(self, w, h) end
end

function DrawSpawn(frame, w, h) end

// Tabs
local welcome, character, loadout, options, admin, spawn
local mmtabs = {
    {"Welcome", "Basic gamemode information", welcome, DrawWelcome}, 
    {"Character", "Select your playermodel", character, DrawCharacter}, 
    {"Loadout", "Select your weapon", loadout, DrawLoadout}, 
    {"Options", "Customize your experience", options, DrawOptions}, 
    {"Admin", "Admin options", admin, DrawAdmin}, 
    {"Spawn", "Join the mash", spawn, DrawSpawn}, 
}

function MM_MenuCharacter()
    MM_Menu(2)
end

function MM_MenuLoadout()
    MM_Menu(3)
end

function MM_MenuOptions()
    MM_Menu(4)
end

// Menu drawing function
local flash = 0
function MM_Menu(tab)
    if MenuOpen then return end
    local menuw = 640*wratio
	local menuh = 480*hratio
    MenuOpen = true
    
    if (isnumber(tab)) then
        LocalPlayer().LastTab = tab
    end
    
    // Fade background
    local Frame3 = vgui.Create("DFrame")
    Frame3:SetPos(0,0)
    Frame3:SetSize(1, 1)
    Frame3:SetDraggable(false)
    Frame3:ShowCloseButton(false)
    Frame3:SetParent(Frame)
    Frame3:SetBackgroundBlur(GetConVar("mm_blurmenu"):GetBool())
    
    // Title and other info
    local Frame2 = vgui.Create("DFrame")
    Frame2:SetPos(0,0)
    Frame2:SetTitle("")
    Frame2:SetSize(ScrW(), ScrH())
    Frame2:SetDraggable(false)
    Frame2:SetParent(Frame)
    Frame2:ShowCloseButton(false)
    Frame2.Paint = function(self, width, height)
        local logoxscale = 512*wratio
        local logoyscale = 256*hratio
    
        // Monster Mash Logo
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("vgui/Logo"))
        surface.DrawTexturedRect((ScrW()/2)-logoxscale/2, -logoyscale/10, logoxscale, logoyscale)
        
        // Monsters mashing at the bottom
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("vgui/Mash"))
        surface.DrawTexturedRect((ScrW()/2)-logoxscale/2,(ScrH())-logoxscale/2, logoxscale, logoyscale)
        
        // Version text
        surface.SetFont("MMVersion")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(ScrW()/2-surface.GetTextSize(version)/2, logoyscale/1.5)
        surface.DrawText(version)
        
        // Credits
        surface.SetFont("MMCredits")
        local longest = {}
        local extraspacing = surface.GetTextSize("--")
        for i=1, #mmcredits do
            for j=1, #mmcredits[i] do
                local w = surface.GetTextSize(mmcredits[i][j])
                if (longest[j] == nil || w > longest[j]) then
                    longest[j] = w
                end
            end
        end
        for i=1, #mmcredits do
            local tx = ScrW()/200
            local ty = ScrH()-ScrH()/200
            for j=1, #mmcredits[i] do
                local long = 0
                local w, h = surface.GetTextSize(mmcredits[i][j])
                if (j-1 > 0) then long = longest[j-1] end
                surface.SetTextPos(tx+long+extraspacing*(j-1), ty-h*(#mmcredits+1-i))
                surface.DrawText(mmcredits[i][j])
            end
        end
    end
    
    // The actual frame
    local Frame = vgui.Create("DFrame")
	Frame:SetSize(menuw, menuh)
	Frame:SetPos((ScrW()/2)-(menuw/2), (ScrH()/2)-(menuh/2))
	Frame:SetTitle("")
    Frame:SetDraggable(false)
	Frame:ShowCloseButton(false)
	Frame:MakePopup()
	Frame.Paint = function()
	end
    Frame.OnClose = function()
        Frame2:Close()
        Frame3:Close()
        MenuOpen = false
    end
    
    // Panic Button (for developers)
    if panic_button then
        local ClipSize = vgui.Create("DButton")
        ClipSize:SetPos(16, 16)
        ClipSize:SetParent(Frame2)	
        ClipSize:SetText("PANIC")
        ClipSize:SetSize(72, 64)
        ClipSize.DoClick = function()
            Frame:Close()
        end
    end
    
    // Tabs
	local ps = vgui.Create("DPropertySheet", Frame)
	ps:SetPos(0, 0)
	ps:SetSize(menuw, menuh)
    ps.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 150, 0, 150))
        draw.RoundedBox(0, 0, h-2, w, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(0, 0, 0, w, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(0, 0, 0, 2, h, Color(0, 0, 0, 255))
        draw.RoundedBox(0, w-2, 0, 2, h, Color(0, 0, 0, 255))
    end
    local panels = #mmtabs
    local j = 1
    if (!LocalPlayer():IsAdmin()) then
        panels = panels-1
    end
    for i=1, #mmtabs do
        if (mmtabs[i][1] != "Admin" || (LocalPlayer():IsAdmin() && mmtabs[i][1] == "Admin")) then
            mmtabs[i][3] = vgui.Create("DPanel", ps)
            mmtabs[i][3]:SetPos(0, 0)
            mmtabs[i][3]:SetSize(menuw, menuh)
            mmtabs[i][3].Paint = function(self, w, h) end
            
            // Set the tab settings
            local Tab = vgui.Create("DButton")
            Tab.Text = mmtabs[i][1]
            Tab:SetPos((menuw/panels)*(j-1), 0)
            Tab:SetParent(ps)	
            Tab:SetFont("MMTabs")
            Tab:SetTextColor(Color(0, 0, 0, 255))
            Tab:SetText(Tab.Text)
            Tab:SetSize(math.ceil(menuw/panels), 30*hratio)
            Tab.DoClick = function()
                if (mmtabs[i][1] == "Spawn") then
                    if (LocalPlayer():GetWeaponTable() == nil || (LocalPlayer():GetWeaponTable().Melee == "None" && LocalPlayer():GetWeaponTable().Handgun == "None" && LocalPlayer():GetWeaponTable().Primary == "None" && LocalPlayer():GetWeaponTable().Throwable == "None")) then
                        surface.PlaySound("buttons/button10.wav")
                        LoadoutFlash = CurTime()+1
                    else
                        surface.PlaySound("ui/shock_reveal.wav")
                        LocalPlayer():DoneLoadout()
                        Frame:Close()
                    end
                else
                    TabClick(ps, i)
                end
            end
            Tab.Paint = function(self, w, h)
                if (Tab.Text == "Loadout" && LoadoutFlash > CurTime()) then
                    if ((CurTime()*20)%4 > 2) then
                        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
                    end
                end
                TabPaint(self, w, h, ps, i)
            end
            
            // Draw this specific tab and add it to our property list
            ps:AddSheet(mmtabs[i][1], mmtabs[i][3], nil, false, false, mmtabs[i][2])
            mmtabs[i][4](mmtabs[i][3], menuw, menuh)
            j = j + 1
        end
    end
    
    // Set the first tab to the welcome
    if LocalPlayer().LastTab == nil then
        LocalPlayer().LastTab = 1
    end
    ps:SetActiveTab(ps.Items[LocalPlayer().LastTab].Tab)

    // Hide all the tabs
    for k, v in pairs(ps.Items) do
        if (v.Tab) then 
            v.Tab:SetVisible(false)
        end
    end
end

concommand.Add("mm_menu", MM_Menu)
usermessage.Hook("mm_menu", MM_Menu)

concommand.Add("mm_character", MM_MenuCharacter)
usermessage.Hook("mm_character", MM_MenuCharacter)

concommand.Add("mm_loadout", MM_MenuLoadout)
usermessage.Hook("mm_loadout", MM_MenuLoadout)

concommand.Add("mm_options", MM_MenuOptions)
usermessage.Hook("mm_options", MM_MenuOptions)