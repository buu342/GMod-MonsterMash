function DoRoundEndStuff()
    game.SetTimeScale( 0.4 )
    SetGlobalVariable("MapRoundCount", GetGlobalVariable("MapRoundCount")+1)
    timer.Simple(2,function() 
        game.SetTimeScale( 1 )
    end)
    timer.Simple(5,function() 
    
        local RoundTime = GetConVar("mm_roundtimer"):GetInt()
        if GetGlobalVariable("RoundsToWacky") != 0 then
            SetGlobalVariable("RoundsToWacky", GetGlobalVariable("RoundsToWacky") - 1)
            
            if GetGlobalVariable("RoundsToWacky") == 0 then
                local randomply = table.Random(player.GetAll())
                local chance = math.random(0,6)
                if chance == 0 then // Guts
                    SetGlobalVariable("WackyRound_COOPOther", randomply)
                    SetGlobalVariable("WackyRound_COOP", true)
                    RoundTime = 2*60+#player.GetAll()*30
                elseif chance == 1 then // Skelly wave
                    SetGlobalVariable("WackyRound_COOP", true)
                    RoundTime = 2*60+#player.GetAll()*30
                elseif chance == 2 then // Dodgeball
                    SetGlobalVariable("WackyRound_COOP", false)
                    RoundTime = 2*60
                elseif chance == 3 then // Luidcrous
                    SetGlobalVariable("WackyRound_COOP", false)
                    RoundTime = 4*60        
                elseif chance == 4 then // Skeleton popped out
                    SetGlobalVariable("WackyRound_COOP", false)
                    RoundTime = 4*60         
                elseif chance == 5 then // Matrix
                    SetGlobalVariable("WackyRound_COOP", false)
                    RoundTime = 2*60
                    SetGlobalVariable("WackyRound_Extra", CurTime() + GetConVar("mm_buy_time"):GetInt() + math.random(8, 12))                
                elseif chance == 6 then // Random Loadout
                    SetGlobalVariable("WackyRound_COOP", false)
                    RoundTime = 4*60
                    SetGlobalVariable("WackyRound_Extra", CurTime() + GetConVar("mm_buy_time"):GetInt() + 10)
                end
                SetGlobalVariable("WackyRound_Event", chance)
            end
        else
            SetGlobalVariable("WackyRound_Extra", 0)
            SetGlobalVariable("RoundsToWacky", GetConVar("mm_wackyfrequency"):GetInt())
            SetGlobalVariable("WackyRound_COOP", false)
            SetGlobalVariable("WackyRound_COOPOther", nil)
            SetGlobalVariable("WackyRound_Event", -1)
        end
    
        if GetGlobalVariable("MapRoundCount") >= GetConVar("mm_maxrounds"):GetInt()+1 then
            game.LoadNextMap()
        else
            game.SetTimeScale( 1 )
            SetGlobalVariable("RoundStartTimer", CurTime()+GetConVar("mm_buy_time"):GetInt())
            for k, v in pairs( ents.FindByClass("player") ) do
                if IsValid(v) then
                    if v:Team() != 2 then
                        v:Team(1)
                    end
                    v:SetNWInt("killcounter", 0)
                    v:SetNWInt("MM_MedalsEarned",0)
                    v:Spawn()
                    v:SetDeaths( 0 )
                    v:Freeze( true )
                    timer.Simple(GetConVar("mm_buy_time"):GetInt(),function() if !IsValid(v) then return end v:Freeze( false ) SetGlobalVariable("RoundStartTimer", 0) SetGlobalVariable("RoundTime", CurTime() + RoundTime) end)
                end
            end
            RunConsoleCommand("gmod_admin_cleanup")
            SetGlobalVariable("Game_Over", false)
        end
    end)
end

function GM:Think()
    local playerscores = {}
    for k, v in pairs( ents.FindByClass("player") ) do
        if IsValid(v) then
            playerscores[v] = v:GetNWInt("killcounter")
        end
    end
    
    local max_val = -1
    local max_ply = nil
    local max_num = 0
    for k, v in pairs(playerscores) do
        if v > max_val then
            max_val, max_ply = v, k
        end
    end
    
    for k, v in pairs(playerscores) do
        if playerscores[k] == max_val then
            max_num = max_num + 1
        end
    end
    
    if GetGlobalVariable("ForceGame_Over") then
        SetGlobalVariable("ForceGame_Over", false)
        SetGlobalVariable("Game_Over", true)
        SetGlobalVariable("Winner", "No one")
        DoRoundEndStuff()
    elseif GetGlobalVariable("RoundStartTimer") == 0 && GetGlobalVariable("RoundsToWacky") != 0 && GetGlobalVariable("Game_Over") == false then 
        if max_val >= GetConVar("mm_point_limit"):GetInt() || GetGlobalVariable("RoundTime") < CurTime() then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())            
            end
            DoRoundEndStuff()
        end
    elseif GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("Game_Over") == false then
        if GetGlobalVariable("WackyRound_Event") == 0 && (#team.GetPlayers(3) == 0 || (GetGlobalVariable("WackyRound_COOPOther") != nil && GetGlobalVariable("WackyRound_COOPOther") != NULL && !GetGlobalVariable("WackyRound_COOPOther"):Alive()) || !IsValid(GetGlobalVariable("WackyRound_COOPOther") )) then
            SetGlobalVariable("Game_Over", true)
            if #team.GetPlayers(3) == 0 then
                SetGlobalVariable("Winner", GetGlobalVariable("WackyRound_COOPOther"):Name())
            elseif !GetGlobalVariable("WackyRound_COOPOther"):Alive() || !IsValid(GetGlobalVariable("WackyRound_COOPOther") ) then
                SetGlobalVariable("Winner", "MonsterTeam")
            end
            DoRoundEndStuff()
        elseif GetGlobalVariable("WackyRound_Event") == 1 && (#team.GetPlayers(3) == 0 || GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if #team.GetPlayers(3) == 0 then
                SetGlobalVariable("Winner", "OtherTeam")
            else
                SetGlobalVariable("Winner", "MonsterTeam")
            end
            DoRoundEndStuff()
        elseif GetGlobalVariable("WackyRound_Event") == 2 && (GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())
            end
            DoRoundEndStuff()
        elseif GetGlobalVariable("WackyRound_Event") == 3 && (GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())
            end
            DoRoundEndStuff()        
        elseif GetGlobalVariable("WackyRound_Event") == 4 && (GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())
            end
            DoRoundEndStuff()        
        elseif GetGlobalVariable("WackyRound_Event") == 5 && (GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())
            end
            DoRoundEndStuff()
        elseif GetGlobalVariable("WackyRound_Event") == 6 && (GetGlobalVariable("RoundTime") < CurTime()) then
            SetGlobalVariable("Game_Over", true)
            if max_num > 1 then
                SetGlobalVariable("Winner", "No one")
            else
                SetGlobalVariable("Winner", max_ply:Name())
            end
            DoRoundEndStuff()
        end
    end

end
