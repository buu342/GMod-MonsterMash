AddCSLuaFile()

local Feed = {}

local SuicideMessages = {
    " became an hero.",
    " committed sewer slide.",
    " committed sudoku.",
    " fucking died.",
    " comitted toaster bath.",
    " died of ligma.",
    " returned to their grave.",
    " went back to sleep.",
    " decided this whole 'rising from the grave to terrorize the living' thing wasn't really working out.",
    " gave up on life. Or death. Undeath?",
    " went to the great Haunted House in the sky. Or Hell. One or the other.",
    " stepped on a LEGO.",
    " couldn't handle the pressure.",
    " is likely trying to see all the variations of the suicide killfeed messages...",
    " didn't want to be alive anymore or something.",
    " just fucking gave up.",
    " removed themselves from the corporeal world.",
    " had their controller unplugged and they died.",
    " went home to monster mashturbate.",
    " had information on the Clinton family.",
    " lived in a society.",
    " decided to visit the Home For Infinite Losers.",
    " was detained by the IRS for committing tax fraud.",
    " went home to take a spooky dooky.",
    " was frightened by their own intelligence.",
    " did not return the slab, and suffered the curse.",
}

local function AddKillFeed(killtable)
    local attackername, victimname
    local tbl = {
        color = Color(255, 105, 0),
        time = CurTime()+10,
        text = ""
    }
    
    if killtable.attacker:IsPlayer() then
        attackername = killtable.attacker:GetName()
    else
        attackername = tostring(killtable.attacker)
    end
    
    if killtable.victim:IsPlayer() then
        victimname = killtable.victim:GetName()
    else
        victimname = tostring(killtable.victim)
    end
    
    // Fall damage
    if killtable.attacker:IsWorld() then
        tbl.text = victimname.." tried to fly without a broom"
    end
    
    // Skeletons
    if (killtable.attacker != nil && IsValid(killtable.attacker)) then
    
        // Player's skeleton
        if (killtable.attacker:IsPlayer() && killtable.inflictor != nil && IsValid(killtable.inflictor) && killtable.inflictor:GetClass() == "sent_mm_skellington") then
            tbl.text = victimname.." did not expect "..attackername.."'s boner"
            tbl.color = Color(178, 0, 255)
        end
        
        // Skeleton NPC
        if (killtable.attacker:GetClass() == "sent_mm_skellington") then
            tbl.text = victimname.." did not expect the boner"
            tbl.color = Color(178, 0, 255)
        end
        
        // Jitterskull
        if killtable.attacker:GetClass() == "sent_mm_jitterskull" then
            tbl.text = victimname.." was eaten by the Jitterskull"
            tbl.color = Color(178, 0, 255)
        end
    end
    
    if bit.band(killtable.killflags, KILL_BLEED) > 0 then
        tbl.color = Color(255, 0, 0)
    end
    
    if bit.band(killtable.killflags, KILL_FIRE) > 0 then
        tbl.text = attackername.." fried "..victimname
    end
    
    if bit.band(killtable.killflags, KILL_BATS) > 0 then
        tbl.text = attackername.." gave "..victimname.." the scariest moment of their life"
    end
    
    if bit.band(killtable.killflags, KILL_FURY) > 0 then
        tbl.text = attackername.." said \"It's fury time!\", and then they fury'd all over "..victimname
    end
     
    // Suicide
    if killtable.attacker == killtable.victim then
        tbl.text = attackername..SuicideMessages[math.random(#SuicideMessages)]
    end
    
    if tbl.text == "" && killtable.inflictor:IsWeapon() then
        tbl.text = killtable.inflictor.KillFeed
        tbl.text = string.Replace(tbl.text, "%a", attackername)
        tbl.text = string.Replace(tbl.text, "%v", victimname)
    end
    
    table.insert(Feed, tbl)
end

hook.Add("HUDPaint", "MM_KillFeed", function()
    
    if !table.IsEmpty(Feed) then
        local i=0
        local gap = 32
        for k, v in pairs(Feed) do
            local x, y
            x = ScrW()/1.15
            y = 48
            if (v.time-1 < CurTime()) then
                v.color.a = 255*(v.time-CurTime())
                if (v.time-CurTime() < 0) then
                    v.color.a = 0
                end
            end
            draw.SimpleText(v.text, "ChatFont", x + 160, y+i, v.color, TEXT_ALIGN_RIGHT)
            i = i+gap
            if (v.time-1 < CurTime()) then
                i = i - gap*(1-(v.time-CurTime()))
            end
            if (v.time < CurTime()) then
                table.remove(Feed, 1)
            end
        end
    end
    
end)

local g_station = nil
net.Receive("MMPlayerKilled", function(len, ply)
    local killtable = net.ReadTable()
    AddKillFeed(killtable)
end)

local g_station = nil
net.Receive("MMNPCKilled", function(len, ply)
    table.insert(Feed, net.ReadTable())
end)

function GM:DrawDeathNotice(x, y)
end