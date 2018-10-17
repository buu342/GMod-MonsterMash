/*-----------------------------------------------------------------------
Now you're probably wondering, BUT BUU HUU, WHY ARE YOU MAKING YOUT OWN
GLOBAL VARIABLE SYSTEM WHEN GMOD ALREADY HAS ONE?
Because that global variable system can go to heck. Seriously. Anything
that wasn't a bool, string or entity would be overwritten to 0 when
players took fall damage, effectively ending the rounds early. Why? God
knows. Jesus christ, I had to write this bloody file at 3AM, the day 
BEFORE release.
SetGlobalInt, Float, or whatever. Go to hell, in that nice secluded spot
where my my hopes and dreams are at.
-----------------------------------------------------------------------*/

GAMEMODEGLOBAL_MapRoundCount = 0
GAMEMODEGLOBAL_ForceGame_Over = false
GAMEMODEGLOBAL_Game_Over = false
GAMEMODEGLOBAL_Winner = ""
GAMEMODEGLOBAL_WackyRound_Extra = 0
GAMEMODEGLOBAL_RoundsToWacky = GetConVar("mm_wackyfrequency"):GetInt()
GAMEMODEGLOBAL_WackyRound_COOP = false
GAMEMODEGLOBAL_WackyRound_COOPOther = nil
GAMEMODEGLOBAL_WackyRound_Event = -1
GAMEMODEGLOBAL_RoundStartTimer = 0

if SERVER then
    util.AddNetworkString("GAMEMODEGLOBAL_MapRoundCount")
    util.AddNetworkString("GAMEMODEGLOBAL_ForceGame_Over")
    util.AddNetworkString("GAMEMODEGLOBAL_Game_Over")
    util.AddNetworkString("GAMEMODEGLOBAL_Winner")
    util.AddNetworkString("GAMEMODEGLOBAL_WackyRound_Extra")
    util.AddNetworkString("GAMEMODEGLOBAL_RoundsToWacky")
    util.AddNetworkString("GAMEMODEGLOBAL_WackyRound_COOP")
    util.AddNetworkString("GAMEMODEGLOBAL_WackyRound_COOPOther")
    util.AddNetworkString("GAMEMODEGLOBAL_WackyRound_Event")
    util.AddNetworkString("GAMEMODEGLOBAL_RoundStartTimer")
end

function SetGlobalVariable(var, value)
    for i=1, 2 do
        if i == 1 then 
            if CLIENT then return end
        else
            if SERVER then return end
        end
        net.Start("GAMEMODEGLOBAL_"..var)

        if var == "MapRoundCount" then
            net.WriteInt(value, 32)
            GAMEMODEGLOBAL_MapRoundCount = value
        elseif var == "ForceGame_Over" then
            net.WriteBool(value)
            GAMEMODEGLOBAL_ForceGame_Over = value
        elseif var == "Game_Over" then
            net.WriteBool(value)
            GAMEMODEGLOBAL_Game_Over = value
        elseif var == "Winner" then
            net.WriteString(value)
            GAMEMODEGLOBAL_Winner = value
        elseif var == "WackyRound_Extra" then
            net.WriteInt(value, 32)
            GAMEMODEGLOBAL_WackyRound_Extra = value
        elseif var == "RoundsToWacky" then
            net.WriteInt(value, 32)
            GAMEMODEGLOBAL_RoundsToWacky = value
        elseif var == "WackyRound_COOP" then
            net.WriteBool(value)
            GAMEMODEGLOBAL_WackyRound_COOP = value
        elseif var == "WackyRound_COOPOther" then
            net.WriteEntity(value)
            GAMEMODEGLOBAL_WackyRound_COOPOther = value
        elseif var == "WackyRound_Event" then
            net.WriteInt(value, 32)
            GAMEMODEGLOBAL_WackyRound_Event = value
        elseif var == "RoundStartTimer" then
            net.WriteFloat(value)
            GAMEMODEGLOBAL_RoundStartTimer = value
        end
        
        if i == 1 then 
            net.Broadcast()
        else
            net.SendToServer()
        end
    end
end

function GetGlobalVariable(var)
    if var == "MapRoundCount" then
        return GAMEMODEGLOBAL_MapRoundCount
    elseif var == "ForceGame_Over" then
        return GAMEMODEGLOBAL_ForceGame_Over
    elseif var == "Game_Over" then
        return GAMEMODEGLOBAL_Game_Over
    elseif var == "Winner" then
        return GAMEMODEGLOBAL_Winner
    elseif var == "WackyRound_Extra" then
        return GAMEMODEGLOBAL_WackyRound_Extra
    elseif var == "RoundsToWacky" then
        return GAMEMODEGLOBAL_RoundsToWacky
    elseif var == "WackyRound_COOP" then
        return GAMEMODEGLOBAL_WackyRound_COOP
    elseif var == "WackyRound_COOPOther" then
        return GAMEMODEGLOBAL_WackyRound_COOPOther
    elseif var == "WackyRound_Event" then
        return GAMEMODEGLOBAL_WackyRound_Event
    elseif var == "RoundStartTimer" then
        return GAMEMODEGLOBAL_RoundStartTimer
    end
end

net.Receive("GAMEMODEGLOBAL_MapRoundCount", function(len, ply)
    val = net.ReadInt(32)
    GAMEMODEGLOBAL_MapRoundCount = val
end)

net.Receive("GAMEMODEGLOBAL_ForceGame_Over", function(len, ply)
    val = net.ReadBool()
    GAMEMODEGLOBAL_ForceGame_Over = val
end)

net.Receive("GAMEMODEGLOBAL_Game_Over", function(len, ply)
    val = net.ReadBool()
    GAMEMODEGLOBAL_Game_Over = val
end)

net.Receive("GAMEMODEGLOBAL_Winner", function(len, ply)
    val = net.ReadString()
    GAMEMODEGLOBAL_Winner = val
end)

net.Receive("GAMEMODEGLOBAL_WackyRound_Extra", function(len, ply)
    val = net.ReadInt(32)
    GAMEMODEGLOBAL_WackyRound_Extra = val
end)

net.Receive("GAMEMODEGLOBAL_RoundsToWacky", function(len, ply)
    val = net.ReadInt(32)
    GAMEMODEGLOBAL_RoundsToWacky = val
end)

net.Receive("GAMEMODEGLOBAL_WackyRound_COOP", function(len, ply)
    val = net.ReadBool()
    GAMEMODEGLOBAL_WackyRound_COOP = val
end)

net.Receive("GAMEMODEGLOBAL_WackyRound_COOPOther", function(len, ply)
    val = net.ReadEntity()
    GAMEMODEGLOBAL_WackyRound_COOPOther = val
end)

net.Receive("GAMEMODEGLOBAL_WackyRound_Event", function(len, ply)
    val = net.ReadInt(32)
    GAMEMODEGLOBAL_WackyRound_Event = val
end)

net.Receive("GAMEMODEGLOBAL_RoundStartTimer", function(len, ply)
    val = net.ReadFloat()
    GAMEMODEGLOBAL_RoundStartTimer = val
end)