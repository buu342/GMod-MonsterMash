local wratio = ScrW()/1600
local hratio = ScrH()/900

local mat_heart_dark      = Material("vgui/hud/heart_dark.png")
local mat_heart_light     = Material("vgui/hud/heart_light.png")
local mat_leg_left        = Material("vgui/hud/leg_left.png")
local mat_leg_right       = Material("vgui/hud/leg_right.png")
local mat_arm_left        = Material("vgui/hud/arm_left.png")
local mat_arm_right       = Material("vgui/hud/arm_right.png")
local mat_skeleton_base   = Material("vgui/hud/base.png")
local mat_corn_empty2     = Material("vgui/hud/candy_corn_empty2.png")
local mat_corn_full       = Material("vgui/hud/candy_corn_full.png")
local mat_corn_flash      = Material("vgui/hud/candy_corn_flash.png")
local mat_hud_base        = Material("vgui/hud/hud_base")
local mat_gravestone      = Material("vgui/hud/gravestone.png")
local mat_gravestonetrick = Material("vgui/hud/gravestone_backdrop")
local mat_stamina         = Material("vgui/hud/stamina")
local mat_candy           = Material("vgui/hud/treats/candy.png")
local mat_hitindicator    = Material("vgui/hud/hit_indicator")

local mat_bleedout      = Material("vgui/hud/bleedout")

local Selections = {
    "Melee",
    "Side Arm",
    "Primary",
    "Throwable"
}

local currenthint = 1
local currentskeldeth = 1
local lasthint = 1
local lastskeldeath = 1
local hinttime = 0
local deathhints = {
    "Looking for a budget-friendly way to earn treats? Try pelting the toilet paper roll at opponents, it’s a free item.",
    "Less effective weapons will grant more points per kill than their bigger, more grandiose counterparts.",
    "While some weapons may earn more or fewer base points, certain weapons can earn certain situational treats much easier.",
    "Missing an arm will make most guns 1/3rd as accurate and take 3x longer to reload.",
    "Remember to eat your candy corn for partial health restoration whenever you have a moment away from danger.",
    "Get creative with your loadout. You might find fun, bizarre weapon combinations that work for you.",
    "The biggest, most expensive weapons aren’t necessarily the best fit for all battles. Consider a weapon set that exploits the weaknesses of your opponent’s loadouts.",
    "Didn’t bring a melee weapon? There’s always your candle!",
    "Smacking opponents with your candle has a chance to engulf them in flames.",
    "Being concussed will reverse your left/right controls and remove your crosshair until you recover.",
    "Players who successfully earn kills while concussed, bleeding, or missing a limb, will earn an extra treat.",
    "All melee weapons are extra effective when attacking from behind.",
    "Bleeding starts harsh but gradually dampens out, however you may want to heal as soon as it starts.",
    "Lose both your arms? Headbutt them!",
    "Someone outgunning you at every turn? Try jamming their guns with the gore jar to tip the odds in your favor.",
    "Need to handicap an enemy sharpshooter? Fight back with the sawblade launcher.",
    "Though it may not deal much damage, the fence post has the longest reach of all the melee weapons. Use it to strike opponents from beyond the reach of their own melee weapons.",
    "The spider ‘nade splatters a sticky web on the floor which can trap foes in place. Throw it where opponents are walking towards to stop them in their tracks.",
    "The axe is a jack of all trades; it deals moderate damage, is the only melee weapon which can deal all three status effects, and can decapitate foes as well.",
    "The wacky round is always around the corner, there’s no telling what it may be!",
    "Look out for opponents weilding the battle axe, it grants the owner +25 health and can slice you clean in half with one swing.",
    "When an enemy projectile is heading towards you, dodgeroll out of the way to avoid all direct damage.",
    "If you are easily spooked by screamers, you can disable the haunted urn’s ghastliness in your options.",
    "If you get motion sick easily, you can disable electrocution screen shake effects and the dodge rolling view effect in options.",
    "Melee dashes are best used for bridging the gap between you and an opponent, or making a quick escape.",
    "Tricks are abilities that can give you an edge in or out of combat, but they must be earned with treats before you can use them.",
    "Be sure to kill the person who had killed you last to earn an extra treat.",
    "Remember, a well-rounded loadout will give you more options for handling combat than a loadout invested in fewer weapons.",
    "It’s not about how many kills you get, it’s about how many points you earn. Try using lower-tier weapons to earn the highest score.",
    "Although it’s best suited for close-range combat, the Cremator’s secondary attack blasts out a powerful fireball for striking targets at a distance.",
    "Striking someone with a melee weapon during a dash will deal 20% additional damage.",
    "When choosing a melee weapon, decide what you’re trying to optimize your loadout for. Extra points, bleeding, dismembering, concussing, or perhaps a little bit of everything.",
    "Although they have no alternate attacks, the Coach Gun and Sawblade Launcher are the only primary weapons that can remove limbs.",
    "Finishing a melee dash will render you unable to dodgeroll out of harm’s way until your stamina has recharged!",
    "Using a fully randomized loadout will grant an aditional treat.",
    "If your gun’s crosshairs aren’t red, you’re not close enough to your opponent for your shots to reach them. Get closer!",
    "Scoring a kill while barely clinging to life will earn you an extra treat.",
    "The stake kills most opponents with a single stab, but is left in their body after usage. Consider how many foes you’ll be taking on before deciding if you can risk losing your melee weapon in the middle of a fight.",
    "Some guns can explode heads with a fatal headshot, granting a treat as a reward.",
    "Honor melee weapon fights. Use your own melee weapon to kill a melee-weilding opponent for extra treats.",
    "Though lacking in stealth, the chainsaw is the most viscious melee weapon of them all.",
    "The De-Animator can be equally dangerous to its user as it can be to their enemies. Overcharging will explode it right in your own hands!",
    "The De-Animator can fire a devestating electrical blast to obliterate opponents, though bear in mind the user will be vulnerable for a moment afterwards as they’re electrocuted by the aftermath.",
    "Most primary weapons have an alternate attack which you may find useful for certain situations.",
    "The Dueling Pistol will hold its weilder in place as they charge it for damage, making it more optimized for defensive situations.",
    "Though it doesn’t deal any direct damage, the Haunted Urn can allow you to freeze opponents in place, giving you a moment to capitalize on their vulnerability.",
    "If a foe is hiding out of sight, most throwables or weapons with splash damage can flush them out by hitting near their cover.",
    "The minigun is a devestating weapon which can mow players down with ease, but the weilder can easily be handicapped with a gorejar or the removal of a limb.",
    "Be sure to read the description and stats of your selected weapon on the loadout menu to get an idea of how your weapon works."
}

local skeletondeaths = {
    "It is too late. There is already a skeleton inside of you.",
    "It's Boner Time!",
    "Clickity-Clack, get into my sack.",
    "Get spooked",
    "Shrieking skulls shocked your soul"
}

local SelectTime = {
    0, 0, 0, 0
}

local function DrawVerticalImageBar(x, y, w, h, mat, matalpha, percent, text, textcol, textyadd)
    local time = 1-percent
    local texturesize = h*hratio
    surface.SetMaterial(mat)
    surface.SetDrawColor(255, 255, 255, matalpha)
    surface.DrawTexturedRectUV(x, y+(texturesize-texturesize*time), w*wratio, texturesize*time, 0, 1-time, 1, 1)
    if (text != nil) then
        if (textcol == nil) then
            textcol = Color(255,255,255,255)
        end
        draw.SimpleTextOutlined(text, "MMDefaultFont", x+(w*wratio)/2, y+(h*hratio)/2+textyadd, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
    end
end

local heartbeatloop = nil
local oldscore = 0
local scorelist = {}
local baranim = 0
local oldstamina = 0
local oldcorncharge = 0
local staminacolor = Color(255, 115, 0, 255)
local cornfade = 0
local damagedir = {}
hook.Add("HUDPaint", "MM_HUD", function()
    

    /*****************************************
                 Damage Indicator
    *****************************************/
    if LocalPlayer():GetLastDamage().time+1 > CurTime() then
		surface.SetDrawColor(255, 255, 255, (LocalPlayer():GetLastDamage().time+1 - CurTime())*255)
		surface.SetMaterial(mat_bleedout)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

    /*****************************************
                   Round Timer
    *****************************************/
    if (GAMEMODE:GetRoundState() != GMSTATE_INVALID) then
        local time 
        local append = nil
        local overtime = false
        surface.SetFont("MMDefaultFont")
        
        if GAMEMODE:GetRoundState() == GMSTATE_BUYTIME then
            time = math.floor(GAMEMODE:GetRoundBuyTime()-CurTime())
            append = "Buy Time"
        elseif GAMEMODE:GetRoundState() == GMSTATE_ENDING then
            time = math.floor(GAMEMODE:GetRoundEndTime()-CurTime())
            append = "Round End"
        else
            time = math.floor(GAMEMODE:GetRoundTime()-CurTime())
        end
        if time <= 0 then
            time = 0
            if (GAMEMODE:GetRoundState() == GMSTATE_ROUND) then
                overtime = true
            end
        end
        local mins = math.floor(time/60)
        local secs = math.floor(time%60) 
        if mins < 10 then
            mins = "0"..tostring(mins)
        else
            mins = tostring(mins)
        end
        
        if secs < 10 then
            secs = "0"..tostring(secs)
        else
            secs = tostring(secs)
        end
        local col = Color(255,105,0,255)
        if math.floor(time/60) == 0 && time%60 < 30 && GAMEMODE:GetRoundState() == GMSTATE_ROUND then
            col = Color(255,0,0,255)
        end
        
        local yplus = 0
        local xsize, ysize = surface.GetTextSize("Hello")
        if (!overtime) then
            if (append != nil) then
                yplus = ysize
                draw.SimpleTextOutlined(append, "MMDefaultFont", ScrW()/2, ScreenScale(20)/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            draw.SimpleTextOutlined(mins..":"..secs, "MMDefaultFont", ScrW()/2, ScreenScale(20)/2+yplus, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255)) 
        else
            if (GAMEMODE:GetRoundTime() == 0) then
                draw.SimpleTextOutlined("Sudden Death", "MMDefaultFont", ScrW()/2, ScreenScale(20)/2+yplus, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255)) 
            else
                draw.SimpleTextOutlined("Overtime", "MMDefaultFont", ScrW()/2, ScreenScale(20)/2+yplus, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        end
        if (GAMEMODE:GetRoundState() == GMSTATE_BUYTIME) then
            if (GAMEMODE:InWackyRound()) then
                draw.SimpleTextOutlined("Wacky round time", "MMDefaultFont", ScrW()/2, ScrH()-ysize, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined(GAMEMODE:GetWackyRound(), "MMDefaultFont", ScrW()/2, ScrH()/2, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                if (LocalPlayer() == GAMEMODE:GetSuperPlayer()) then
                    draw.SimpleTextOutlined(GAMEMODE:WackyRoundData().round_message2, "MMDefaultFont", ScrW()/2, ScrH()/2+ysize, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                else
                    local tcolor = Color(255, 105, 0, 255)
                    if (LocalPlayer():Team() == TEAM_COOPMONST) then
                        tcolor = Color(0, 255, 0, 255)
                    end
                    draw.SimpleTextOutlined(GAMEMODE:WackyRoundData().round_message1, "MMDefaultFont", ScrW()/2, ScrH()/2+ysize, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            else
                local validplayers = {}
                for k, v in pairs(player.GetAll()) do
                    if (v:Team() != TEAM_SPECT) then table.insert(validplayers, v) end
                end
                if (#validplayers > 1) then
                    if (GAMEMODE:GetRoundsToWacky() != 1) then
                        draw.SimpleTextOutlined("Wacky round in "..GAMEMODE:GetRoundsToWacky().." rounds", "MMDefaultFont", ScrW()/2, ScrH()-ysize, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
                    else
                        draw.SimpleTextOutlined("Wacky round next round", "MMDefaultFont", ScrW()/2, ScrH()-ysize, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
                    end
                else
                    draw.SimpleTextOutlined("Not enough players for wacky rounds", "MMDefaultFont", ScrW()/2, ScrH()-ysize, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
                end
            end
        end
    end
    
    /*****************************************
                      Winner
    *****************************************/   
    if (GAMEMODE:GetRoundState() == GMSTATE_ENDING) then
        if (GAMEMODE:GetRoundWinnerType() != TEAM_INVALID) then
            if (GAMEMODE:GetRoundWinnerEntity() != LocalPlayer()) then
                draw.SimpleTextOutlined(GAMEMODE:GetRoundWinnerName().." is the gravekeeper", "MMDefaultFont", ScrW()/2, ScrH()/2-128, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            else
                draw.SimpleTextOutlined("You are the hit of the land!", "MMDefaultFont", ScrW()/2, ScrH()/2-128, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        else
            draw.SimpleTextOutlined(GAMEMODE:GetRoundWinnerName(), "MMDefaultFont", ScrW()/2, ScrH()/2-128, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
    end
    
    /*****************************************
                 Health Indicator
    *****************************************/
    if (LocalPlayer():Alive() && LocalPlayer():Health() <= 20 && heartbeatloop == nil && LocalPlayer():Health() > 0) then
        heartbeatloop = CreateSound(LocalPlayer(), "gameplay/heartbeatloop.wav")
        heartbeatloop:Play()
    elseif ((!LocalPlayer():Alive() || LocalPlayer():Health() > 20 || LocalPlayer():Health() <= 0) && heartbeatloop) then
        heartbeatloop:Stop()
        heartbeatloop = nil
    end
        
    if LocalPlayer():Alive() && LocalPlayer():Team() != TEAM_COOPDEAD && LocalPlayer():Team() != TEAM_SPECT then
            
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(mat_hud_base)
        surface.DrawTexturedRect(33*wratio, ScrH()-200*hratio, 245*wratio, 180*hratio)
        
        if !LocalPlayer():MissingBothLegs() then
            local staminasize = 220*wratio
            local stamina = staminasize
            baranim = baranim + FrameTime()/10
            if (LocalPlayer():GetAbilityCooldown() > 0) then
                local subtractamount = 5
                if (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().stamina_recharge != nil) then
                    subtractamount = subtractamount / GAMEMODE:WackyRoundData().stamina_recharge
                end
                stamina = staminasize*(1-(LocalPlayer():GetAbilityCooldown())/subtractamount)
            end
            if (oldstamina > 0 && LocalPlayer():GetAbilityCooldown() <= 0) then
                surface.PlaySound("gameplay/stamina_recharge.wav")
                staminacolor = Color(255, 255, 255, 255)
            end
            oldstamina = LocalPlayer():GetAbilityCooldown()
            surface.SetDrawColor(staminacolor) 
            staminacolor = Color(staminacolor.r, Lerp(3*FrameTime(), staminacolor.g, 115), Lerp(3*FrameTime(), staminacolor.b, 0), 255)
            surface.SetMaterial(mat_stamina)
            surface.DrawTexturedRectUV(46*wratio, ScrH()-51*hratio, stamina, 27*hratio, 0-baranim+(1-stamina/staminasize), 0, 1-baranim, 0.2)
        end
        
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(mat_heart_dark)
        surface.DrawTexturedRect(60*wratio, ScrH()-152*hratio, 53*wratio, 80*hratio)
        local col = Color(255,255,255,255)
        if LocalPlayer():HasStatusEffect(STATUS_BLEED) then
            col = Color(255,0,0,255)
        end
        DrawVerticalImageBar(60*wratio, math.floor(ScrH()-151*hratio), 53, 80, mat_heart_light, 255, 1-LocalPlayer():Health()/LocalPlayer():GetMaxHealth(), LocalPlayer():Health(), col, 7*hratio)
        
        if !LocalPlayer():MissingBothLegs() then
            if !LocalPlayer():MissingLeftLeg() then
                surface.SetMaterial(mat_leg_left)
                surface.DrawTexturedRect(140*wratio, ScrH()-115*hratio, wratio*17/1.4, hratio*62/1.4)
            end
            
            if !LocalPlayer():MissingRightLeg() then
                surface.SetMaterial(mat_leg_right)
                surface.DrawTexturedRect(160*wratio, ScrH()-115*hratio, wratio*31/1.4, hratio*65/1.4)
            end
        end
        
        if !LocalPlayer():MissingBothArms() then
            if !LocalPlayer():MissingLeftArm() then
                surface.SetMaterial(mat_arm_left)
                surface.DrawTexturedRect(120*wratio, ScrH()-141*hratio, wratio*33/1.4, hratio*29/1.4)
            end
            
            if !LocalPlayer():MissingRightArm() then
                surface.SetMaterial(mat_arm_right)
                surface.DrawTexturedRect(156*wratio, ScrH()-152*hratio, wratio*31/1.4, hratio*27/1.4)
            end
        end
        
        surface.SetMaterial(mat_skeleton_base)
        surface.DrawTexturedRect(140*wratio, ScrH()-152*wratio, wratio*34/1.4, hratio*61/1.4)
        
        surface.SetMaterial(mat_corn_empty2)
        surface.DrawTexturedRect(194*wratio, ScrH()-151*hratio, 58*wratio, 80*hratio)
        if !LocalPlayer():MissingBothArms() then
            local percent = math.Clamp((LocalPlayer():GetNextHeal()-CurTime())/20,0,20)
            local regentimetext = nil
            if (LocalPlayer():GetNextHeal() > CurTime()) then
                regentimetext = math.ceil(LocalPlayer():GetNextHeal()-CurTime())
            end
            if (oldcorncharge > 0 && percent == 0 && oldcorncharge != 1) then
                surface.PlaySound("gameplay/candycorn_recharge.wav")
                cornfade = 255
            end
            oldcorncharge = percent
            DrawVerticalImageBar(194*wratio, math.floor(ScrH()-151*hratio), 58, 80, mat_corn_full, 255, percent, regentimetext, Color(255, 255, 255, 255), 7*hratio)
        
            cornfade = Lerp(3*FrameTime(), cornfade, 0)
            if (cornfade > 1) then
                surface.SetMaterial(mat_corn_flash)
                surface.SetDrawColor(255, 255, 255, cornfade)
                surface.DrawTexturedRect(194*wratio, math.floor(ScrH()-151*hratio), 58*wratio, math.ceil(80*hratio))
            end
        end
        
    end
      
    /*****************************************
                Directional Damage
    *****************************************/
	if (LocalPlayer():Alive()) then
		surface.SetMaterial(mat_hitindicator)
		for k, v in pairs(damagedir) do
			if v.time < CurTime() then
				table.remove(damagedir, k)
			end
			local radius = 128
			local dirf = (LocalPlayer():GetPos() - v.dir):GetNormalized():Dot(EyeAngles():Forward())
			local dirr = (LocalPlayer():GetPos() - v.dir):GetNormalized():Dot(EyeAngles():Right())
			surface.SetDrawColor(255, 255, 255, math.Clamp(v.time-CurTime(), 0, 1)*255)
			surface.DrawTexturedRectRotated(ScrW()/2 - dirr*radius*wratio, ScrH()/2 + dirf*radius*hratio, 32*wratio, 64*hratio, math.deg(math.atan2(dirr, -dirf)))
		end
	end
	  
    /*****************************************
                    Tricks
    *****************************************/
    if LocalPlayer():Alive() && LocalPlayer():Team() != TEAM_COOPDEAD && LocalPlayer():Team() != TEAM_SPECT then
        if (oldscore != LocalPlayer():GetScore() && LocalPlayer():GetScore() != 0) then
            table.insert(scorelist, {
                score = LocalPlayer():GetScore()-oldscore,
                time = CurTime()+1
            })
        end
        
        
        if (LocalPlayer():Team() != TEAM_COOPOTHER) then
            // Tombstone trick aura
            if (LocalPlayer():GetWeaponTable() != nil) then
                local trickamount = 0
                local matalpha = 255
                if (LocalPlayer():HasStatusEffect(STATUS_INVISIBLE)) then
                    trickamount = LocalPlayer():GetStatusEffectTime(STATUS_INVISIBLE)/15
                elseif (LocalPlayer():HasStatusEffect(STATUS_SIGHT)) then
                    trickamount = LocalPlayer():GetStatusEffectTime(STATUS_SIGHT)/30
                elseif (LocalPlayer():HasStatusEffect(STATUS_BROOM)) then
                    trickamount = LocalPlayer():GetStatusEffectTime(STATUS_BROOM)/1.5
                elseif (GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].cost != 0) then
                    trickamount = LocalPlayer():GetTreatStack()/GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].cost
                end
                if (trickamount == 1) then
                    matalpha = 255*math.abs(math.sin(CurTime()*4))
                end
                DrawVerticalImageBar(ScrW()-108*wratio, ScrH()-math.floor(155*hratio), 101, 146, mat_gravestonetrick, matalpha, 1-trickamount)
                surface.SetMaterial(mat_gravestonetrick)
                surface.DrawTexturedRectUV(ScrW()-108*wratio, ScrH()-math.floor(155*hratio)+146*hratio*(1-trickamount), 101*wratio, math.ceil(146*hratio*trickamount), 0, 1-trickamount, 1, 1)
                surface.SetDrawColor(255, 255, 255, 255)
            end
        end
        
        // Tombstone trick texture
        surface.SetMaterial(mat_gravestone)
        surface.DrawTexturedRect(ScrW()-100*wratio, ScrH()-147*hratio, 85*wratio, 131*hratio)
        if (!GAMEMODE:InWackyRound() || GAMEMODE:WackyRoundData().mode == MODE_DEATHMATCH) then
            draw.SimpleTextOutlined(LocalPlayer():GetScore(), "MMDefaultFont", ScrW()-56*wratio, ScrH()-76*hratio, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        else
            draw.SimpleTextOutlined(#team.GetPlayers(TEAM_COOPMONST), "MMDefaultFont", ScrW()-56*wratio, ScrH()-76*hratio, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
        
        // Trick icon
        if (LocalPlayer():Team() != TEAM_COOPOTHER && LocalPlayer():GetWeaponTable() != nil && GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].icon != -1) then
            surface.SetMaterial(GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].icon)
            surface.DrawTexturedRect(ScrW()-100*wratio, ScrH()-244*hratio, 85*wratio, 85*hratio)
            surface.SetDrawColor(255, 255, 255, 255)        
        end
        
        if #scorelist > 0 then
            for k, v in pairs(scorelist) do
                local time = (v.time-CurTime())
                local col = Color(0, 255, 0, 255*time)
                if (v.score <= 10) then
                    col = Color(255, 0, 0, 255*time)
                elseif (v.score <= 20) then
                    col = Color(255, 192, 0, 255*time)
                elseif (v.score <= 25) then
                    col = Color(255, 255, 0, 255*time)
                elseif (v.score <= 40) then
                    col = Color(192, 255, 0, 255*time)
                elseif (v.score > 75) then
                    col = Color(255, 0, 255, 255*time)
                end
                draw.SimpleTextOutlined("+"..tostring(v.score), "MMDefaultFont", ScrW()-56*hratio, ScrH()-(76-(1-time)*100)*hratio, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255*time))
                if (v.time < CurTime()) then
                    table.remove(scorelist, k)
                end
            end
        end
    end
    
    /*****************************************
                Weapon selection
    *****************************************/
    if LocalPlayer():Alive() && LocalPlayer():Team() != TEAM_COOPDEAD && LocalPlayer():Team() != TEAM_SPECT then
        local width = 128*wratio
        local height = 128*hratio
        local startx = ScrW()/2 - width*2
        local starty = ScrH()-height
        local x = startx
        local y = starty-16*hratio
        for i=1, 4 do
            if IsValid(LocalPlayer():GetWeaponSlot(i)) then
                if SelectTime[i] > CurTime() then
                    local time = SelectTime[i]-CurTime()
                    draw.RoundedBox(16, x, y, width, height, Color(0,0,0,time*105))
                    draw.RoundedBox(16, x+2, y+2, width-4, height-4, Color(255,105,0,time*105))
                    surface.SetDrawColor(255, 255, 255, time*255)
                    surface.SetMaterial(LocalPlayer():GetWeaponSlot(i).SelectIcon)
                    surface.DrawTexturedRect(x+2*wratio, y+2*hratio, width-4*wratio, height-4*hratio)
                    draw.SimpleTextOutlined(Selections[i], "MMDefaultFont", x+width/2-2*wratio, y+height-26*hratio , Color(255,105,0,time*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,time*255))
                end
            end
            x = x+width
        end
    end

    /*****************************************
                Press E to pick up
    *****************************************/
    
    local tr = util.TraceHull({
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + (LocalPlayer():GetAimVector() * 100),
        filter = LocalPlayer(),
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10),
        mask = MASK_SHOT_HULL
    })
    
    if LocalPlayer():Alive() && tr.Hit && tr.Entity:IsWeapon() && LocalPlayer():Team() != TEAM_COOPDEAD && LocalPlayer():Team() != TEAM_SPECT && !LocalPlayer():IsSuper() then
        if !LocalPlayer():HasWeapon(tr.Entity:GetClass()) then
            if LocalPlayer():MissingBothArms() then
                draw.SimpleTextOutlined("You have no arms!", "MMDefaultFont", ScrW()/2, ScrH()/2-64*hratio, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            else
                draw.SimpleTextOutlined("Press E to pick up "..tr.Entity.PrintName, "MMDefaultFont", ScrW()/2, ScrH()/2-64*hratio, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        else
            draw.SimpleTextOutlined("You already have a "..tr.Entity.PrintName, "MMDefaultFont", ScrW()/2, ScrH()/2-64*hratio, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end 
    end
    
    /*****************************************
                      Treats
    *****************************************/
    if LocalPlayer():Alive() then
        local treats = LocalPlayer():GetTreatDisplays()
        //if (treats != nil) then
            local numtreats = #treats
            if numtreats != 0 then
                for i=1, numtreats do
                    local size = ScrW()*0.07
                    local curr = treats[i]
                    if (curr.xpos == nil) then
                        curr.xpos = ScrW()/2-size/2
                    end
                    curr.xtarget = ScrW()/2-size/2+(i-1)*size-((numtreats-1)/2)*size
                    curr.xpos = Lerp(0.1, curr.xpos, curr.xtarget)
                    
                    if curr.time < CurTime()+0.5 then
                        surface.SetDrawColor(255, 255, 255, 255*(curr.time-CurTime())/0.5)
                    else
                        surface.SetDrawColor(255, 255, 255, 255)
                    end
                    surface.SetMaterial(mat_candy)
                    surface.DrawTexturedRect(curr.xpos, ScrH()/5, size, size*1.2)
                    surface.SetMaterial(curr.mat)
                    surface.DrawTexturedRect(curr.xpos+size/4, ScrH()/5+(size*1.4)/4, size/2, size/2)
                end
            end
        //end
    end
    
    /*****************************************
                 Death Cam Hints
    *****************************************/
    if !LocalPlayer():Alive() then
        if (hinttime == 0) then
            hinttime = CurTime()+1.5
        end
        if hinttime < CurTime() then
            // Killer
            if (IsValid(LocalPlayer():GetNWEntity("MM_Killer"))) then
                if (LocalPlayer():GetObserverMode() == OBS_MODE_FREEZECAM) then
                    if LocalPlayer():GetNWEntity("MM_Killer") == LocalPlayer() then
                        draw.SimpleTextOutlined("You killed yourself to death.", "MMDefaultFont", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    elseif LocalPlayer():GetNWEntity("MM_Killer"):IsPlayer() then
                        draw.SimpleTextOutlined(LocalPlayer():GetNWEntity("MM_Killer"):GetName().." sent you back to the grave."	, "MMDefaultFont", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    elseif LocalPlayer():GetNWEntity("MM_Killer").IsMMNPC then
                        if currentskeldeth == lastskeldeath then
                            currentskeldeth = math.random(1,#skeletondeaths)
                        end
                        draw.SimpleTextOutlined(skeletondeaths[currentskeldeth], "MMDefaultFont", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    end
                else
                    draw.SimpleTextOutlined("Press F3 to change your loadout", "MMDefaultFont", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
            
            // Death Hint
            if (GetConVar("mm_deathtips"):GetInt() == 1) then
                if currenthint == lasthint then
                    currenthint = math.random(1,#deathhints)
                end
                surface.SetFont("MMDefaultFont")
                local text = {deathhints[currenthint]}
                local text_w, text_h = surface.GetTextSize(text[1])
                
                local k = 1
                local done = false
                if text_w > ScrW() then
                    local words = string.Explode(" ", text[1])
                    local renderstring = ""
                    text = {}
                    for i=1, #words do
                        local testsentence = renderstring.." "..words[i]
                        local tw, th = surface.GetTextSize(testsentence)
                        if (tw > ScrW() - 32*wratio) then
                            table.insert(text, renderstring)
                            renderstring = words[i]
                        elseif (i == #words) then
                            table.insert(text, testsentence)
                        else
                            renderstring = testsentence
                        end
                    end
                end
                //PrintTable(text)
                for i=1, #text do
                    draw.SimpleTextOutlined(text[i], "MMDefaultFont", ScrW()/2, ScrH()-text_h-text_h*(#text-i), Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
        end
	elseif LocalPlayer():Alive() then
        if (hinttime != 0) then
            hinttime = 0
            lasthint = currenthint
            lastskeldeath = currentskeldeth
        end
    end
    
    oldscore = LocalPlayer():GetScore()
end)

hook.Add("PreDrawHalos", "MM_WeaponHalos", function()
    local tr = util.TraceHull({
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + (LocalPlayer():GetAimVector() * 100),
        filter = LocalPlayer(),
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10),
        mask = MASK_SHOT_HULL
    })

    if LocalPlayer():Alive() && tr.Hit && tr.Entity:IsWeapon() then
        halo.Add({tr.Entity}, Color(255,105,0,255), 2, 2, 1, true, false)
        draw.SimpleTextOutlined("Press E to pick up "..tr.Entity.PrintName, "MMDefaultFont", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
    end
end)

hook.Add("PostPlayerDraw", "MM_HUDNameAmmo", function(ply)
    local tr = util.GetPlayerTrace(LocalPlayer())
    local trace = util.TraceLine(tr)
    
	if trace.Hit && trace.HitNonWorld && ply == trace.Entity then
        //for i=1, 
        local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
        pos.z = pos.z + 30
        local ang = ply:EyeAngles()
        local dist = LocalPlayer():GetPos():Distance(ply:GetPos())
        
        cam.Start3D2D(pos, EyeAngles():Right():Angle() + Angle(0,0,90), 0.25)
            draw.SimpleTextOutlined(ply:Nick(),"MMDefaultFont_noscale", 0,2, team.GetColor(ply:Team()) , TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
            draw.SimpleTextOutlined(ply:Health(),"MMDefaultFont_noscale", 0,42, team.GetColor(ply:Team()) , TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
        cam.End3D2D()
    end
end)

local fixedmaterial = false
hook.Add("RenderScreenspaceEffects", "MM_LowHPOverlay", function()
    if (LocalPlayer():Alive() && LocalPlayer():Health() <= 20 && LocalPlayer():Health() > 0) then
        DrawMaterialOverlay("vgui/hud/werewolf_overlay_red", 0.1)
        if (!fixedmaterial) then
            LocalPlayer():ConCommand("mat_reloadmaterial \"vgui/hud/werewolf_overlay_red\"")
            fixedmaterial = true
        end
    end
end)

// Hide HL2 health HUD
hook.Add("HUDShouldDraw", "MM_HideHL2HUD", function(name)
	if (name == "CHudHealth") then
		return false
	end	
    if (name == "CHudWeaponSelection") then
		return false
	end
end)

// Hide player info when looking at someone
function GM:HUDDrawTargetID()
end

hook.Add ("PlayerBindPress", "MM_WeaponSelection", function(ply, bind, pressed)

    if pressed then

        // Flashlight
        if (string.find(bind, "impulse 100")) then
            if ply:HasWeapon("weapon_mm_candlestick") then
                RunConsoleCommand("use", "weapon_mm_candlestick")
                return true
            end
        end
        
        // Weapon selection
        if #ply:GetWeapons() > 0 then
            // 1 2 3 4
            for i=1, 4 do
                if (string.find(bind, "slot"..tostring(i))) then
                    if ply:HasWeaponSlot(i) && IsValid(ply:GetWeaponSlot(i)) then
                        RunConsoleCommand("use", ply:GetWeaponSlot(i):GetClass())
                        SelectTime[i] = CurTime()+1
                        RunConsoleCommand("play", "gameplay/switch.wav")
                        return true
                    end
                end
            end
            
            // Scroll up
            if (string.find(bind, "invnext")) then
                local cur = ply:GetActiveWeapon().Slot
                for i=1, 4 do
                    cur = (cur+1)%4
                    if ply:HasWeaponSlot(cur+1) && IsValid(ply:GetWeaponSlot(cur+1)) then
                        RunConsoleCommand("use", ply:GetWeaponSlot(cur+1):GetClass())
                        SelectTime[cur+1] = CurTime()+1
                        RunConsoleCommand("play", "gameplay/switch.wav")
                        return true
                    end
                end
            end
        
            // Scroll down
            if (string.find(bind, "invprev")) then
                local cur = ply:GetActiveWeapon().Slot
                for i=1, 4 do
                    cur = (3+cur)%4
                    if ply:HasWeaponSlot(cur+1) && IsValid(ply:GetWeaponSlot(cur+1)) then
                        RunConsoleCommand("use", ply:GetWeaponSlot(cur+1):GetClass())
                        SelectTime[cur+1] = CurTime()+1
                        RunConsoleCommand("play", "gameplay/switch.wav")
                        return true
                    end
                end
            end
        end
    end
end)

local deadtime = 0
local g_station = nil
hook.Add("CalcView", "MM_EndOfMMCalcView", function(ply, pos, angles, fov)
    if (GetConVar("mm_endofmonstermash"):GetBool()) then
        if LocalPlayer():Alive() then 
            deadtime = 0 
            if g_station != nil then 
                g_station:Stop() 
                g_station = nil
            end 
            return 
        else
            if (deadtime == 0) then
                LocalPlayer():SetEyeAngles(Angle(90,0,0))
                sound.PlayURL ("https://vgmsite.com/soundtracks/the-end-of-evangelion/rtweigrm/11%20-%20komm%2C%20s%C3%BCsser%20tod%20%28m-10%20director%27s%20edit.%20version%29.mp3", "", function(station)
                    if (IsValid(station)) then
                        station:Play()
                        g_station = station
                    end
                end)
            end
            
            local view = {
                origin = pos + Vector(0,0,deadtime),
                angles = Angle(90,0,0),
                fov = fov,
                drawviewer = false
            }
            deadtime = deadtime+0.05
            return view
        end
    end
end)


net.Receive("MM_DamageDirection", function(len)
	if (table.Count(damagedir) < 8) then
		table.insert(damagedir, {dir=net.ReadVector(), time=CurTime()+1})
	elseif (damagdir != nil) then
		local smallest = 0
		for k, v in pairs(damagdir) do
			if (smallest == 0) then
				smallest = v
			elseif (v.time < smallest) then
				smallest = v
			end
		end
		smallest.dir = net.ReadVector()
		smallest.time = CurTime()+1
	end
end)

hook.Add( "RenderScreenspaceEffects", "OldTimeyMode", function()

    if (GetConVar("mm_oldtimeymode"):GetBool()) then
        local tab = {
            [ "$pp_colour_addr" ] = 0,
            [ "$pp_colour_addg" ] = 0,
            [ "$pp_colour_addb" ] = 0,
            [ "$pp_colour_brightness" ] = 0,
            [ "$pp_colour_contrast" ] = 1,
            [ "$pp_colour_colour" ] = 0,
            [ "$pp_colour_mulr" ] = 0,
            [ "$pp_colour_mulg" ] = 0,
            [ "$pp_colour_mulb" ] = 0
        }
        
        DrawColorModify(tab)
        DrawMaterialOverlay("animated/film_grain", 0)
    end

end )