/* Goblin Slayer */

local BERSUCC = nil
hook.Add("Tick", "MM_GoblinSlayerMusic", function()
    if (GAMEMODE:GetWackyRound() == "Goblin Slayer") then
        if LocalPlayer():IsSuper() then
            if (BERSUCC != nil) then
                BERSUCC:Stop()
                BERSUCC = nil
            end
            return 
        end
        local guts = GAMEMODE:GetSuperPlayer()
        if (IsValid(guts) && guts:Alive()) then
            if BERSUCC == nil then
                BERSUCC = CreateSound(guts, "weapons/stick/BERSUCC.mp3")
            end
            
            BERSUCC:ChangeVolume(1-guts:GetPos():Distance(LocalPlayer():GetPos())/1024)
            
            if (!BERSUCC:IsPlaying()) then
                BERSUCC:Play()
            end
        else
            if (BERSUCC != nil) then
                BERSUCC:Stop()
                BERSUCC = nil
            end
        end
    else
        if (BERSUCC != nil) then
            BERSUCC:Stop()
            BERSUCC = nil
        end
    end
end)