local wratio = ScrW()/1600
local hratio = ScrH()/900
local hScrW = ScrW()/2
local hScrH = ScrH()/2
local width = 1000*wratio
local height = 800*hratio

local boardshown = false
local showboardtime = 0
MM_EndRoundboard = MM_EndRoundboard or {}

local medaldescriptions = {
    ["airborne"] = "You killed an airborne opponent.",
    ["assisted_suicide"] = "You pressed an opponent into suicide (even if it was an accident).",
    ["backstab"] = "You killed an opponent with a melee weapon from behind.",
    ["behead"] = "You decapitated an opponent.",
    ["bleed"] = "You bled an opponent to death.",
    ["concuss"] = "You concussed an opponent.",
    ["damage_sources"] = "You took 3+ different sources of damage in a single life. Congrats?",
    ["dash"] = "You killed an opponent with your melee dash.",
    ["dash_kill"] = "You killed an opponent in the middle of their melee dash.",
    ["dismember"] = "You removed an opponent's limb.",
    ["dodged_explosion"] = "You rolled out of the way of an explosion before it could damage you.",  
    ["eat_candy_corn"] = "You ate candy corn three times in the span of one life and somehow didn't vomit.",  
    ["finish_with_melee"] = "You softened up an opponent and finished them off with a melee attack.",  
    ["fire"] = "You killed an opponent with fire.",  
    ["firstblood"] = "You scored the first kill of the round.",  
    ["gib"] = "You blew an opponent to bits.",  
    ["immobilized"] = "You killed an opponent who was stuck in place.",  
    ["kill_healing"] = "You killed an opponent who was trying to eat their candy corn.",  
    ["kill_upon_spawning"] = "You killed an opponent immediately upon spawning.",  
    ["killed_jammed"] = "You killed an opponent whose gun was jammed.",
    ["killed_reloading"] = "You killed an opponent whom was reloading.",    
    ["killstreak"] = "You killed 3+ opponents in one life.",  
    ["killwhilebleeding"] = "You scored a kill while you were bleeding.",
    ["killwhileconcussed"] = "You scored a kill while you were concussed.",
    ["killwhilegorejar"] = "You scored a kill while you were covered in gory muck.", 
    ["killwhilelimbless"] = "You scored a kill while missing a limb.",
    ["longrange"] = "You killed an opponent from a considerable distance.",
    ["melee_duel"] = "You killed a melee-wielding opponent with your own melee weapon.",           
    ["melee_guns"] = "You killed a gun-wielding opponent with your melee weapon.",  
    ["neardeath"] = "You scored a kill at 20 health or lower.",  
    ["post_mortem"] = "You killed an opponent while you were dead.",  
    ["random"] = "You scored a kill with a weapon from your randomized loadout.",
    ["revenge"] = "You killed the opponent who killed you previously.",    
    ["spree_ender"] = "You killed an opponent, ending their killing spree.",  
    ["tp"] = "You threw toilet paper at an opponent. It didn't do anything, but it was rather silly.",  
    ["two_attackers"] = "You killed two different opponents who had dealt damage to you in the past 10 seconds.",
    ["while_immobilized"] = "You scored a kill while you could not move.",
    ["while_tripping"] = "You scored a kill while you were hallucinating.",
    ["youtried"] = "You attempted to kill an opponent, but mostly ended up killing yourself in the process."
}

local wackyachievements = {
    "You highfived %d penguins",
    "You made %d important life decisions",
    "You brightened %d people's day ",
    "You drank %doz of soup",
    "You blinked %d times",
    "You broke %d chairs",
    "You attended %d weddings",
    "You ate %d vegetables",
    "You wet yourself %d times",
    "You found %d secrets",
    "You dethroned %d monarchs",
    "You founded %d countries",
    "You bought $%d worth of DLC",
    "You prevented %d forest fires",
    "You explored %d decommissioned coal mines",
    "You experienced Cornelius %d times",
    "You witnessed %d vehicular collisions",
    "You delayed %d trolleys",
    "You ordered %d pizzas",
    "You pet %d cats",
    "You invented %d mathematical formulas",
    "You read %d books",
    "You overslept by %d hours",
    "You baked %d loaves of bread",
    "You impersonated Tom Hanks %d times",
    "You threw %d midgets",
    "You said %d inspiring quotes",
    "You ran for president %d times",
    "You saw %d UFOs",
    "You listened to %d radio plays",
    "You saw Phantom of the Opera %d times",
    "You built %d sentry guns",
    "You made %d pancakes",
    "You went to Law School %d times",
    "You had %d raindrops land on you",
    "You hijacked %d school buses",
    "You eased political tensions in Ohio %d times",
    "You escaped from the basement %d times",
    "You avoided being bitten by a squirrel %d times",
    "You slipped on %d banana peels",
    "You read %d tarrot cards",
    "You defused %d bombs",
    "You denied the existence of women %d times",
    "You fought %d sharks",
    "You improperly self-diagnosed %d medical ailments",
    "You pranked %d people",
    "You evaded taxes for %d years",
    "You went to prison %d times",
    "You clogged the toilet %d times",
    "You closed %d doors",
    "You read %d Monster Mash erotic fan fictions",
    "You quoted Evil Dead %d times",
    "You witnessed %d solar eclipses",
    "You wrote %d books about Thermodynamics",
    "You played %d games of Chess",
    "You did %d cartwheels",
    "You ranked %d in the Yoga World Tournament",
    "You paintstakingly built %d castles with your bare hands",
    "You denounced Scientology %d times",
    "You were almost sued by Disney %d times",
    "You uncovered %d conspiracies pertaining to garden gnomes",
    "You changed %d station wagon tires",
    "You stole %d jars of Mayonnaise",
    "You recited the alphabet backwards %d times",
    "You got %d employees of a local furniture store fired",
    "You tamed %d dinosaurs",
    "You prepared for %d unforeseen consequences",
    "You laundered $%d for the Transylvanian Coffin Cartel",
    "You contracted Syphilis %d times",
    "You injected %d whole marijuanas",
    "You devoured %d bicycles",
    "You picked your nose %d times",
    "You left your wallet at home %d times",
    "You divorced %d spouses",
    "You stared at %d crows",
    "You were banned from %d Bosnian courtrooms",
    "You dislocated your pancreas %d times",
    "You caused %d wheat famines in Bowling Green, Ohio",
    "You explored %d shipwrecks south of the Indian Ocean",
    "You pirated %d movies",
    "You swallowed %d Toyota 7 Series 6,000 lb. lift capacity forklifts",
    "You graduated with %d PhD's you're not using",
    "You snuck past %d sentry turrets",
    "You smuggled %d diamonds across the Denmark border",
    "You raked the leaves off your front lawn %d times",
    "You infiltrated %d Chinese submarines",
    "You visited a Siamese chiropractor %d times",
    "You did the Trannsylvania Twist %d times",
    "You crafted %d improvised explosive devices in your basement",
    "You were charged with treason %d times",
    "You were indicted for horse theft %d times",
    "You were chased by %d mall cops",
    "You walked %d kilometers",
    "You carved %d Jack-o-lanterns",
    "You streamed all %d of the Pirates of the Carribean movies",
    "You started %d projects that you should probably finish",
    "You swallowed %d Toyota 7 Series 6,000 lb. lift capacity forklifts",
    "You attended %d wedding rehearsals",
    "You successfully removed %d Jenga blocks before the tower collapsed",
    "You memorized all %d of the secret codes for gaining entry to Octavius Vault"
}

function MM_EndRoundboard:show()
	gui.EnableScreenClicker(true)

    // Main panel
	local Back = vgui.Create("DPanel")
	Back:SetSize(width, height) 
	Back:SetPos(ScrW() + width, hScrH)
    Back.xpos = ScrW() + width/2
    Back.positioned = false
    
    // Close button
    local size = 32*wratio
    local CloseButton = vgui.Create("DButton")
    CloseButton:SetPos(width-16*wratio-size, 16*hratio)
    CloseButton:SetParent(Back)	
    CloseButton:SetColor(Color(0, 0, 0, 255))
    CloseButton:SetFont("MMDefaultFont")
    CloseButton:SetText("X")
    CloseButton:SetSize(size, size)
    CloseButton.DoClick = function() MM_EndRoundboard:hide() end
    CloseButton.Paint = function() end
    
    // Title
    local title = "Your achievements this round"
    local text = vgui.Create("DLabel", Back)
    surface.SetFont("MMDefaultFont")
    text:SetFont("MMDefaultFont")
    text:SetPos(width/2-surface.GetTextSize(title)/2, 12*hratio)
    text:SetColor(Color(0, 0, 0, 255))
    text:SetText(title)
    text:SizeToContents()
    
    // Achievement text list
    local textstack = nil
    
    // Character model
    if (LocalPlayer():GetModel() != nil) then
        local CharModel = vgui.Create("DModelPanel", Back)
        local size = width/2
        CharModel:SetEnabled(false)
        CharModel:SetPos(-100*wratio,  300*hratio-size/2)
        CharModel:SetSize(size, size)
        CharModel:SetAnimated(false)
        CharModel:SetAnimSpeed(0)
        CharModel:SetModel(LocalPlayer():GetModel())
        CharModel.Entity:SetSkin(LocalPlayer():GetSkin())
        CharModel:SetCamPos(Vector(50,-30, 60))
        function CharModel:LayoutEntity(Entity) return end
    end
    
    // Treats
    Back.treats = GAMEMODE.PlayerStats[LocalPlayer():SteamID64().."_round"]
    Back.treatsicons = {}
    Back.treatssorted = false
    Back.treatslabel = nil
    
    // Animations
    function Back:Think() 
        if (self.xpos > hScrW - width/2) then
            self.xpos = Lerp(RealFrameTime()*10, self.xpos, hScrW - width/2)
            if (self.xpos-32*wratio < hScrW - width/2) then
                self.positioned = true
            end
        end
        Back:SetPos(self.xpos, hScrH-height/2)

        // Try retrieving the stats again if they still haven't arrived
        if (self.treats == nil) then
            self.treats = GAMEMODE.PlayerStats[LocalPlayer():SteamID64().."_round"]
        end
        
        // Handle stat text generation
        if (self.treats != nil && textstack == nil) then
            textstack = {}
            local statsorder = {
                [1] = {"Damage_Given", 0, "You dealt %d damage"},
                [2] = {"Damage_Received", 0, "You took %d damage"},
                [3] = {"Treats_Earned", 0, "You earned %d treats"},
                [4] = {"Tricks_Used", 0, "You used %d tricks"},
                [5] = {"Candy_Consumed", 0, "You somehow ate Candy Corn %d times"},
                [6] = {"Melee_Kills", 0, "You earned %d kills with melee weapons"},
                [7] = {"Primary_Kills", 0, "You earned %d kills with primary weapons"},
                [8] = {"Handgun_Kills", 0, "You earned %d kills with secondary weapons"},
                [9] = {"Throwable_Kills", 0, "You earned %d kills with throwable weapons"},
            }
            for k, v in pairs(self.treats) do
                if (string.StartWith(k, "treat_")) then
                    statsorder[3][2] = statsorder[3][2] + v
                else
                    for i=1, #statsorder do
                        if (statsorder[i][1] == k) then
                            statsorder[i][2] = v
                        end
                    end
                end
            end
            for k, v in pairs(statsorder) do
                if (statsorder[k][2] != 0) then
                    table.insert(textstack, {text=string.Replace(statsorder[k][3], "%d", tostring(math.Round(statsorder[k][2]))), item=nil})
                end
            end
            if (#LocalPlayer():GetWeaponKills() != 0) then
                table.insert(textstack, {text="You killed with "..tostring(#LocalPlayer():GetWeaponKills()).." different weapons", item=nil})
            end
            if (LocalPlayer():GetMaxLifeKills() != 0) then
                table.insert(textstack, {text="Your highest spree was "..tostring(LocalPlayer():GetMaxLifeKills()).." kills", item=nil})
            end
            if (LocalPlayer():GetMaxLifeTime() != 0) then
                table.insert(textstack, {text="Your longest life was "..string.FormattedTime(LocalPlayer():GetMaxLifeTime(), "%02i:%02i"), item=nil})
            end
            table.insert(textstack, {text=string.Replace(table.Random(wackyachievements), "%d", tostring(math.random(0, 20))), item=nil})
        end
        
        // Render stuff once the scoreboard is positioned
        if (self.positioned) then
            local xpos = 300*wratio
            local ypos = 80*hratio
            local previous = nil
            if (textstack != nil && textstack != {}) then
                for k, v in pairs(textstack) do
                    if (v.item == nil) then
                        if (previous != nil && previous.xposoffset > 100) then
                            break
                        end
                        v.item = vgui.Create("DLabel", self)
                        v.item.xposoffset = 255
                        v.item:SetFont("MMTabs")
                        v.item:SetText(v.text)
                        v.item:SizeToContents()
                    else
                        v.item.xposoffset = Lerp(RealFrameTime()*10, v.item.xposoffset, 0)
                    end
                    v.item:SetPos(xpos+v.item.xposoffset*wratio, ypos)
                    v.item:SetColor(Color(0, 0, 0, 255-v.item.xposoffset))
                    ypos = ypos + 34*hratio
                    previous = v.item
                end
            end
            
            // Handle treats display
            if (self.treats != nil) then
                if (!self.treatssorted) then
                    local temp = {}
                    for k, v in pairs(self.treats) do
                        if (string.StartWith(k, "treat_")) then
                            table.insert(temp, {string.sub(k, 7), v})
                        end
                    end
                    self.treatssorted = true
                    self.treats = temp
                end
                if (#self.treats != 0) then
                    local maxperrow = 15
                    local size = 64
                    local xstart = 16*wratio
                    if (#self.treats < maxperrow) then
                        xstart = (width/2-size*wratio/2) - (size*wratio/2)*((#self.treats-1)%maxperrow)
                    end
                    local x = xstart
                    local y = height - 240*hratio
                    local previous = nil
                    local row = 0
                    
                    if (self.treatslabel == nil) then
                        local text = "Hover your cursor over each icon to see their specifics!"
                        self.treatslabel = vgui.Create("DLabel", Back)
                        surface.SetFont("MMEndScore")
                        self.treatslabel:SetFont("MMEndScore")
                        self.treatslabel:SetPos(width/2-surface.GetTextSize(text)/2, y - 32*hratio)
                        self.treatslabel:SetColor(Color(0, 255, 0, 255))
                        self.treatslabel:SetText(text)
                        self.treatslabel:SizeToContents()
                    end
                    for k, tbl in pairs(self.treats) do
                        local medal = tbl[1]
                        local amount = tbl[2]
                        if (self.treatsicons[medal] == nil) then
                            if (previous != nil && previous.alpha < 100) then
                                break
                            end
                            local treaticon = vgui.Create("DImageButton", Back)
                            treaticon:SetPos(x, y)
                            treaticon:SetEnabled(true)
                            treaticon:SetSize(size*wratio, size*hratio)
                            treaticon:SetContentAlignment(5)
                            treaticon:SetImage("vgui/hud/treats/"..medal..".png")
                            treaticon:SetTooltip(medaldescriptions[medal])
                            treaticon.alpha = 0
                            function treaticon:Paint(w, h)
                                if self:IsHovered() then
                                    draw.RoundedBox(8, 0, 0, w, h, Color(0, 255, 0, treaticon.alpha))
                                end
                            end
                            if (amount > 1) then
                                local text = "x"..amount
                                local treatslabel = vgui.Create("DLabel", treaticon)
                                surface.SetFont("MMEndScore")
                                local texw, texh = surface.GetTextSize(text)
                                treatslabel:SetFont("MMEndScore")
                                treatslabel:SetPos(size*wratio-texw, size*hratio-texh)
                                treatslabel:SetColor(Color(0, 255, 0, 255))
                                treatslabel:SetText(text)
                                treatslabel:SizeToContents()
                            end
                            self.treatsicons[medal] = treaticon
                        else
                            self.treatsicons[medal].alpha = Lerp(RealFrameTime()*20, self.treatsicons[medal].alpha, 255)
                        end
                        x = x + 64*wratio
                        if (x + 64*wratio > width) then
                            left = #self.treats - k
                            xstart = 16*wratio
                            if (left < maxperrow) then
                                xstart = (width/2-size*wratio/2) - (size*wratio/2)*((left-1)%maxperrow)
                            end
                            x = xstart
                            y = y + 80*hratio
                        end
                        self.treatsicons[medal]:SetColor(Color(255, 255, 255, self.treatsicons[medal].alpha))
                        previous = self.treatsicons[medal]
                    end
                end
            end
        end
    end
	function Back:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(255, 145, 0, 205))
    end
    
    // Panel hiding
	function MM_EndRoundboard:hide()
		gui.EnableScreenClicker(false)
		Back:Remove()
	end
end

hook.Add("Tick", "MM_EndRoundboardShow", function()

    if GetConVar("mm_endroundboard"):GetBool() then 
        if (IsValid(LocalPlayer()) && LocalPlayer():Team() != TEAM_SPECT) then
            if (GAMEMODE:GetRoundState() == GMSTATE_ENDING && !boardshown) then
                if (showboardtime == 0) then
                    showboardtime = CurTime()+GetConVar("mm_endroundboard_time"):GetInt()
                end
                if (showboardtime < CurTime()) then
                    MM_EndRoundboard:show()
                    showboardtime = 0
                    boardshown = true
                end
            end

            if (boardshown && (GAMEMODE:GetRoundState() == GMSTATE_BUYTIME || GAMEMODE:GetRoundState() == GMSTATE_ROUND)) then
                boardshown = false
                showboardtime = 0
                MM_EndRoundboard:hide()
            end
        end
    end
    
end)