AddCSLuaFile()

function GM:InitializeRounds()
    self.MMGamemode_RoundNum = 0
    self.MMGamemode_RoundBuyTime = 0
    self.MMGamemode_RoundTime = 0
    self.MMGamemode_RoundEndTime = 0
    self.MMGamemode_RoundsToWacky = GetConVar("mm_wackyfrequency"):GetInt()
    self.MMGamemode_RoundState = GMSTATE_BUYTIME
    self.MMGamemode_RoundWinnerType = 0
    self.MMGamemode_RoundWinnerName = ""
    self.MMGamemode_RoundWinnerEntity = nil
    self.MMGamemode_SuperPlayer = nil
    self.MMGamemode_WackyRound = ""
    self.MMGamemode_FirstBlood = false
    self:StartNewRound()
end

function GM:GetRoundNum()
    return self.MMGamemode_RoundNum
end

function GM:GetRoundBuyTime()
    return self.MMGamemode_RoundBuyTime
end

function GM:GetRoundTime()
    return self.MMGamemode_RoundTime
end

function GM:GetRoundEndTime()
    return self.MMGamemode_RoundEndTime
end

function GM:GetRoundsToWacky()
    return self.MMGamemode_RoundsToWacky
end

function GM:GetRoundState()
    return self.MMGamemode_RoundState
end

function GM:GetRoundWinnerType()
    return self.MMGamemode_RoundWinnerType
end

function GM:GetRoundWinnerName()
    return self.MMGamemode_RoundWinnerName
end

function GM:GetRoundWinnerEntity()
    return self.MMGamemode_RoundWinnerEntity
end

function GM:GetSuperPlayer()
    return self.MMGamemode_SuperPlayer
end

function GM:GetWackyRound()
    return self.MMGamemode_WackyRound
end

function GM:GetFirstBlood()
    return self.MMGamemode_FirstBlood
end

function GM:SetFirstBlood()
    self.MMGamemode_FirstBlood = true
end

function GM:InWackyRound()
    return self:GetWackyRound() != ""
end

function GM:WackyRoundData()
    return self.WackyRounds[self:GetWackyRound()]
end

if SERVER then
    util.AddNetworkString("MMGLOBAL_SetRoundState")
    util.AddNetworkString("MMGLOBAL_SetRoundNum")
    util.AddNetworkString("MMGLOBAL_SetRoundBuyTime")
    util.AddNetworkString("MMGLOBAL_SetRoundTime")
    util.AddNetworkString("MMGLOBAL_SetRoundEndTime")
    util.AddNetworkString("MMGLOBAL_SetRoundEndTime")
    util.AddNetworkString("MMGLOBAL_SetRoundsToWacky")
    util.AddNetworkString("MMGLOBAL_SetRoundWinnerType")
    util.AddNetworkString("MMGLOBAL_SetRoundWinnerName")
    util.AddNetworkString("MMGLOBAL_SetRoundWinnerEntity")
    util.AddNetworkString("MMGLOBAL_SetSuperPlayer")
    util.AddNetworkString("MMGLOBAL_SetWackyRound")
end

function GM:SetRoundState(val)
    self.MMGamemode_RoundState = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundState", true)
            net.WriteInt(val, 32)
        net.Broadcast()
    end
end

function GM:SetRoundNum(val)
    self.MMGamemode_RoundNum = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundNum", true)
            net.WriteInt(val, 32)
        net.Broadcast()
    end
end

function GM:SetRoundBuyTime(val)
    self.MMGamemode_RoundBuyTime = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundBuyTime", true)
            net.WriteFloat(val)
        net.Broadcast()
    end
end

function GM:SetRoundTime(val)
    self.MMGamemode_RoundTime = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundTime", true)
            net.WriteFloat(val)
        net.Broadcast()
    end
end

function GM:SetRoundEndTime(val)
    self.MMGamemode_RoundEndTime = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundEndTime", true)
            net.WriteFloat(val)
        net.Broadcast()
    end
end

function GM:SetRoundsToWacky(val)
    self.MMGamemode_RoundsToWacky = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundsToWacky", true)
            net.WriteInt(val, 32)
        net.Broadcast()
    end
end

function GM:SetRoundWinnerType(val)
    self.MMGamemode_RoundWinnerType = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundWinnerType", true)
            net.WriteInt(val, 32)
        net.Broadcast()
    end
end

function GM:SetRoundWinnerName(val)
    self.MMGamemode_RoundWinnerName = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundWinnerName", true)
            net.WriteString(val)
        net.Broadcast()
    end
end

function GM:SetRoundWinnerEntity(val)
    self.MMGamemode_RoundWinnerEntity = val
    if SERVER then
        net.Start("MMGLOBAL_SetRoundWinnerEntity", true)
            net.WriteEntity(val)
        net.Broadcast()
    end
end

function GM:SetSuperPlayer(val)
    self.MMGamemode_SuperPlayer = val
    if SERVER then
        net.Start("MMGLOBAL_SetSuperPlayer", true)
            net.WriteEntity(val)
        net.Broadcast()
    end
end

function GM:SetWackyRound(val)
    self.MMGamemode_WackyRound = val
    if SERVER then
        net.Start("MMGLOBAL_SetWackyRound", true)
            net.WriteString(val)
        net.Broadcast()
    end
end

if CLIENT then
    net.Receive("MMGLOBAL_SetRoundState", function()
        GAMEMODE:SetRoundState(net.ReadInt(32))
    end)
    net.Receive("MMGLOBAL_SetRoundNum", function()
        GAMEMODE:SetRoundNum(net.ReadInt(32))
    end)
    net.Receive("MMGLOBAL_SetRoundBuyTime", function()
        GAMEMODE:SetRoundBuyTime(net.ReadFloat())
    end)
    net.Receive("MMGLOBAL_SetRoundTime", function()
        GAMEMODE:SetRoundTime(net.ReadFloat())
    end)
    net.Receive("MMGLOBAL_SetRoundEndTime", function()
        GAMEMODE:SetRoundEndTime(net.ReadFloat())
    end)
    net.Receive("MMGLOBAL_SetRoundsToWacky", function()
        GAMEMODE:SetRoundsToWacky(net.ReadInt(32))
    end)
    net.Receive("MMGLOBAL_SetRoundWinnerType", function()
        GAMEMODE:SetRoundWinnerType(net.ReadInt(32))
    end)
    net.Receive("MMGLOBAL_SetRoundWinnerName", function()
        GAMEMODE:SetRoundWinnerName(net.ReadString())
    end)
    net.Receive("MMGLOBAL_SetRoundWinnerEntity", function()
        GAMEMODE:SetRoundWinnerEntity(net.ReadEntity())
    end)
    net.Receive("MMGLOBAL_SetSuperPlayer", function()
        GAMEMODE:SetSuperPlayer(net.ReadEntity())
    end)
    net.Receive("MMGLOBAL_SetWackyRound", function()
        GAMEMODE:SetWackyRound(net.ReadString())
    end)
end

function GM:RequestRoundDataRefresh(ply)
    net.Start("MMGLOBAL_SetRoundState", true)
        net.WriteInt(self:GetRoundState(), 32)
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundNum", true)
        net.WriteInt(self:GetRoundNum(), 32)
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundBuyTime", true)
        net.WriteFloat(self:GetRoundBuyTime())
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundTime", true)
        net.WriteFloat(self:GetRoundTime())
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundEndTime", true)
        net.WriteFloat(self:GetRoundEndTime())
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundsToWacky", true)
        net.WriteInt(self:GetRoundsToWacky(), 32)
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundWinnerType", true)
        net.WriteInt(self:GetRoundWinnerType(), 32)
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundWinnerName", true)
        net.WriteString(self:GetRoundWinnerName())
    net.Send(ply)
    net.Start("MMGLOBAL_SetRoundWinnerEntity", true)
        net.WriteEntity(self:GetRoundWinnerEntity())
    net.Send(ply)
    net.Start("MMGLOBAL_SetSuperPlayer", true)
        net.WriteEntity(self:GetSuperPlayer())
    net.Send(ply)
    net.Start("MMGLOBAL_SetWackyRound", true)
        net.WriteString(self:GetWackyRound())
    net.Send(ply)
end

function GM:CheckWinner()
    for k, v in pairs(player.GetAll()) do
        if (v:GetScore() >= GetConVar("mm_point_limit"):GetInt()) then
            return v
        end
    end
    return nil
end

function GM:GetHighestScorers()
    local winners = {}
    local highest = 0
    for k, v in pairs(player.GetAll()) do
        if (v:GetScore() == highest) then
            table.insert(winners, v)
        end
        if (v:GetScore() > highest) then
            highest = v:GetScore()
            winners = {v}
        end
    end
    return winners
end

function GM:StartNewRound()
    RunConsoleCommand("gmod_admin_cleanup")
    self:SetRoundState(GMSTATE_BUYTIME)
    if SERVER then
        self.MMGamemode_FirstBlood = false
        self:SetRoundBuyTime(CurTime() + GetConVar("mm_buytime"):GetInt())
    end
    if SERVER then
        for k, v in pairs(player.GetAll()) do
            if IsValid(v) then
                if (self:GetSuperPlayer() == v) then
                    v:SetTeam(TEAM_COOPOTHER)
                elseif (v:Team() != TEAM_SPECT) then
                    if (self:InWackyRound() && (self:WackyRoundData().mode == MODE_CONVERT || self:WackyRoundData().mode == MODE_PVSUPER || self:WackyRoundData().mode == MODE_PVM)) then
                        v:SetTeam(TEAM_COOPMONST)
                    else
                        v:SetTeam(TEAM_MONST)
                    end
                end
                v:Spawn()
                v:ResetScore()
                v:ResetLifeStats()
                v:ResetTreatStack()
                v:SetDeaths(0)
                v:Freeze(true)
                if (IsFirstTimePredicted()) then v:ChatPrint("Buy time! "..GetConVar("mm_buytime"):GetInt().." Seconds") end
                self:ResetPlayerRoundStats(v)
            end
        end
    end
    if SERVER && !self:InWackyRound() then
        umsg.Start("mm_loadout", nil)
        umsg.End()
    end
end

function GM:BeginRound()
    local time = GetConVar("mm_roundtime"):GetInt()
    self:SetRoundState(GMSTATE_ROUND)
    if (self:InWackyRound() && self.WackyRounds[self:GetWackyRound()].limit_time != nil) then
        time = self.WackyRounds[self:GetWackyRound()].limit_time
    end
    self:SetRoundTime(CurTime() + time)
    for k, v in pairs(player.GetAll()) do
        if IsValid(v) then
            v:Freeze(false)
            if (IsFirstTimePredicted()) then v:ChatPrint("Round start! "..time.." Seconds") end
        end
    end
end

function GM:EndCurrentRound(reason)
    self:SetRoundState(GMSTATE_ENDING)
    self:SetRoundEndTime(CurTime() + GetConVar("mm_endtime"):GetInt())
    self:SetRoundNum(self:GetRoundNum()+1)
    if (reason != nil) then
        self:SetRoundWinnerType(TEAM_INVALID)
        self:SetRoundWinnerName(reason)
    end
    if SERVER then
        if (GetConVar("mm_slomo_duration"):GetInt() > 0) then
            game.SetTimeScale(0.4)
        end
        
        for k, v in pairs(player.GetAll()) do
            if (IsFirstTimePredicted()) then v:ChatPrint("Round end! "..GetConVar("mm_endtime"):GetInt().." Seconds") end
        end
    end
end

local PlayedSound = nil
function GM:UpdateRound()   
    if (SERVER && (PlayedSound == nil || (self:GetRoundState() == GMSTATE_BUYTIME && (PlayedSound[2] || PlayedSound[3])))) then
        PlayedSound = {}
        PlayedSound[1] = false
        PlayedSound[2] = false
        PlayedSound[3] = false
    end
    
    if (self:GetRoundState() == GMSTATE_BUYTIME) then
        
        if (SERVER && !PlayedSound[1] && (self:GetRoundBuyTime()-CurTime()) < 4) then
            net.Start("MM_PlayUISound", true)
                net.WriteString("gameplay/round_start.wav")
            net.Broadcast()
            PlayedSound[1] = true
        end
        
        if (self:GetRoundBuyTime() < CurTime()) then
            self:SetRoundWinnerName("")
            self:SetRoundWinnerEntity(nil)
            self:SetRoundWinnerType(TEAM_INVALID)
            self:BeginRound()
        end
    end
    
    if (self:GetRoundState() == GMSTATE_ROUND) then
        local winner = self:CheckWinner()
        local scorers = self:GetHighestScorers()
        
        if (SERVER && !PlayedSound[2] && self:GetRoundTime() < CurTime()+30) then
            net.Start("MM_PlayUISound", true)
                net.WriteString("ui/time_ending.wav")
            net.Broadcast()
            PlayedSound[2] = true
        end
        
        if (!self:InWackyRound() || self.WackyRounds[self:GetWackyRound()].mode == MODE_DEATHMATCH) then
            if (self:GetRoundTime() < CurTime() || winner != nil) then
                if (#scorers == 1) then
                    if (winner == nil) then
                        winner = scorers[1]
                    end
                    self:SetRoundWinnerName(winner:Name())
                    self:SetRoundWinnerEntity(winner)
                    self:SetRoundWinnerType(TEAM_MONST)
                    self:EndCurrentRound()
                else
                    self:SetRoundTime(0)
                end
            end
        else
            if (self.WackyRounds[self:GetWackyRound()].mode == MODE_LMS) then
                local lastcount = {}
                for k, v in pairs(player.GetAll()) do
                    if (v:Team() == TEAM_MONST) then
                        table.insert(lastcount, v)
                    end
                end
                if (#lastcount == 0) then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName("There is no winner")
                    self:EndCurrentRound()
                elseif (#lastcount == 1) then
                    self:SetRoundWinnerName(lastcount[1]:Name())
                    self:SetRoundWinnerEntity(lastcount[1])
                    self:SetRoundWinnerType(TEAM_MONST)
                    self:EndCurrentRound()
                end
            elseif (self.WackyRounds[self:GetWackyRound()].mode == MODE_PVM) then
                local lastcount = {}
                for k, v in pairs(player.GetAll()) do
                    if (v:Team() == TEAM_COOPMONST) then
                        table.insert(lastcount, v)
                    end
                end
                if (#lastcount == 0) then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_aiwin)
                    self:EndCurrentRound()
                elseif self:GetRoundTime() < CurTime() then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_playerswin)
                    self:EndCurrentRound()
                end
            elseif (self.WackyRounds[self:GetWackyRound()].mode == MODE_CONVERT) then
                local lastcount = {}
                for k, v in pairs(player.GetAll()) do
                    if (v:Team() == TEAM_COOPMONST) then
                        table.insert(lastcount, v)
                    end
                end
                if (#lastcount == 0) then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_monsterwin)
                    self:EndCurrentRound()
                elseif self:GetRoundTime() < CurTime() then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_playerswin)
                    self:EndCurrentRound()
                end
            elseif (self.WackyRounds[self:GetWackyRound()].mode == MODE_PVSUPER) then
                local plycount = {}
                local supercount = {}
                for k, v in pairs(player.GetAll()) do
                    if (v:Team() == TEAM_COOPMONST) then
                        table.insert(plycount, v)
                    end
                    if (v:Team() == TEAM_COOPOTHER) then
                        table.insert(supercount, v)
                    end
                end
                if (#plycount == 0) then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_monsterwin)
                    self:EndCurrentRound()
                elseif (#supercount == 0 || self:GetRoundTime() < CurTime()) then
                    self:SetRoundWinnerType(TEAM_INVALID)
                    self:SetRoundWinnerName(self.WackyRounds[self:GetWackyRound()].text_playerswin)
                    self:EndCurrentRound()
                end
            end
        end
    end

    if (self:GetRoundState() == GMSTATE_ENDING) then
        if (SERVER && !PlayedSound[3]) then
            net.Start("MM_PlayUISound", true)
                net.WriteString("gameplay/round_end.wav")
            net.Broadcast()
            PlayedSound[3] = true
        end
        
        if SERVER then
            if (self:GetRoundEndTime() < CurTime()+GetConVar("mm_endtime"):GetInt()-GetConVar("mm_slomo_duration"):GetInt() && game.GetTimeScale() != 1) then
                game.SetTimeScale(1)
            end
        end
            
        if (self:GetRoundEndTime() < CurTime() && SERVER) then
            if (self:GetRoundNum() >= GetConVar("mm_maxrounds"):GetInt()) then
                game.LoadNextMap()
            end
            local validplayers = {}
            for k, v in pairs(player.GetAll()) do
                if (v:Team() != TEAM_SPECT) then table.insert(validplayers, v) end
            end
            if (self:GetRoundsToWacky() <= 1 && #validplayers > 1) then
                local round, roundname = table.Random(self.WackyRounds)
                if (self:GetWackyRound() != "") then
                   round = self.WackyRounds[self:GetWackyRound()]
                   roundname = self:GetWackyRound()
                end
                if (round.mode == MODE_PVSUPER || round.mode == MODE_CONVERT) then
                    self:SetSuperPlayer(table.Random(validplayers))
                end
                self:SetWackyRound(roundname)
                self:SetRoundsToWacky(GetConVar("mm_wackyfrequency"):GetInt()+1)
            else
                self:SetWackyRound("")
                self:SetSuperPlayer(nil)
                self:SetRoundsToWacky(self:GetRoundsToWacky()-1)
                if (self:GetRoundsToWacky() <= 1 && #validplayers < 2) then
                    self:SetRoundsToWacky(GetConVar("mm_wackyfrequency"):GetInt())
                end
            end
            self:StartNewRound()
        end
    end
    
end

if SERVER then
    util.AddNetworkString("MM_EndCurrentRound")
    util.AddNetworkString("MM_ForceWacky")
    util.AddNetworkString("MM_PlayUISound")

    net.Receive("MM_EndCurrentRound", function(len, ply)
        if (ply:IsAdmin()) then
            GAMEMODE:EndCurrentRound(net.ReadString())
        end
    end)
    net.Receive("MM_ForceWacky", function(len, ply)
        if (ply:IsAdmin()) then
            GAMEMODE:SetRoundsToWacky(0)
            GAMEMODE:SetWackyRound(net.ReadString())
            GAMEMODE:EndCurrentRound("Forcing Wacky Round")
        end
    end)
end

net.Receive("MM_PlayUISound", function(len, ply)
    surface.PlaySound(net.ReadString())
end)