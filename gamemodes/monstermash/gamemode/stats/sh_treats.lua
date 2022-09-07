function GM:GivePlayerTreat(ply, treat)
    if ply:Team() == TEAM_COOPOTHER then return end
    self:IncrementPlayerStat(ply, "treat_"..treat)
end

local lasttreatsound = 0
function GM:AddTreatDisplay(treatname)
    if SERVER then return end

    if lasttreatsound < CurTime() then
        if ((LocalPlayer():GetWeaponTable()["Trick"] != "None" && LocalPlayer():GetTreatStack() >= GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].cost) || (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().instanttrick)) then
            surface.PlaySound("gameplay/trick_ready.wav")
        else
            surface.PlaySound("ui/bell1.wav")
        end
        lasttreatsound = CurTime() + 0.05
    end
    
    if (LocalPlayer().TreatDisplays == nil) then
        LocalPlayer().TreatDisplays = {}
    end
    table.insert(LocalPlayer().TreatDisplays, {
        treat = treatname, 
        time = CurTime()+3,
        mat = Material("vgui/hud/"..string.Replace(treatname, "treat_", "treats/")..".png")
    })
end

function GM:GetTreatDisplays()
    if SERVER then return end
    local toremove = {}
    
    if (LocalPlayer().TreatDisplays == nil) then
        LocalPlayer().TreatDisplays = {}
        return LocalPlayer().TreatDisplays
    end
    
    for i=#LocalPlayer().TreatDisplays, 1, -1 do
        if LocalPlayer().TreatDisplays[i].time < CurTime() then
            table.remove(LocalPlayer().TreatDisplays, i)
        end
    end
    
    return LocalPlayer().TreatDisplays
end