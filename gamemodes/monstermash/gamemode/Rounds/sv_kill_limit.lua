function DoRoundEndStuff()
    game.SetTimeScale( 0.4 )
    SetGlobalVariable("MapRoundCount", GetGlobalVariable("MapRoundCount")+1)
    timer.Simple(2,function() 
        game.SetTimeScale( 1 )
    end)
    timer.Simple(5,function() 
        print(GetGlobalVariable("MapRoundCount"))
        if GetGlobalVariable("MapRoundCount") == 11 then
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
                    v:Spawn()
                    v:SetDeaths( 0 )
                    v:Freeze( true )
                    timer.Simple(GetConVar("mm_buy_time"):GetInt(),function() if !IsValid(v) then return end v:Freeze( false ) SetGlobalVariable("RoundStartTimer", 0) end)
                end
            end
            RunConsoleCommand("gmod_admin_cleanup")
            SetGlobalVariable("Game_Over", false)
        end
    end)
    if GetGlobalVariable("RoundsToWacky") != 0 then
        SetGlobalVariable("RoundsToWacky", GetGlobalVariable("RoundsToWacky") - 1)
        
        if GetGlobalVariable("RoundsToWacky") == 0 then
            local randomply = table.Random(player.GetAll())
            local chance = math.random(0,1)
            if chance == 0 then
                SetGlobalVariable("WackyRound_COOPOther", randomply)
                SetGlobalVariable("WackyRound_COOP", true)
            elseif chance == 1 then
                SetGlobalVariable("WackyRound_COOP", true)
                SetGlobalVariable("WackyRound_Extra", #player.GetAll()*15)
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
end

function GM:Think()
    for k, v in pairs( ents.FindByClass("player") ) do
        if IsValid(v) then
            if GetGlobalVariable("ForceGame_Over") then
                SetGlobalVariable("ForceGame_Over", false)
                SetGlobalVariable("Game_Over", true)
                SetGlobalVariable("Winner", "No one")
                DoRoundEndStuff()
            elseif GetGlobalVariable("RoundsToWacky") != 0 && v:GetNWInt("killcounter") >= GetConVar("mm_kill_limit"):GetInt() && GetGlobalVariable("Game_Over") == false then 
                SetGlobalVariable("Game_Over", true)
				SetGlobalVariable("Winner", v:Name())
                
				DoRoundEndStuff()
            elseif GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("Game_Over") == false then
                if GetGlobalVariable("WackyRound_Event") == 0 && (#team.GetPlayers(3) == 0 || (GetGlobalVariable("WackyRound_COOPOther") != NULL && !GetGlobalVariable("WackyRound_COOPOther"):Alive()) || !IsValid(GetGlobalVariable("WackyRound_COOPOther") )) then
                    SetGlobalVariable("Game_Over", true)
                    if #team.GetPlayers(3) == 0 then
                        SetGlobalVariable("Winner", GetGlobalVariable("WackyRound_COOPOther"):Name())
                    elseif !GetGlobalVariable("WackyRound_COOPOther"):Alive() || !IsValid(GetGlobalVariable("WackyRound_COOPOther") ) then
                        SetGlobalVariable("Winner", "MonsterTeam")
                    end
                    DoRoundEndStuff()
                elseif GetGlobalVariable("WackyRound_Event") == 1 && (#team.GetPlayers(3) == 0 || GetGlobalVariable("WackyRound_Extra") <= 0) then
                    SetGlobalVariable("Game_Over", true)
                    if #team.GetPlayers(3) == 0 then
                        SetGlobalVariable("Winner", "OtherTeam")
                    elseif GetGlobalVariable("WackyRound_Extra") <= 0 then
                        SetGlobalVariable("Winner", "MonsterTeam")
                    end
                    DoRoundEndStuff()
                end
            end
        end
    end
end
