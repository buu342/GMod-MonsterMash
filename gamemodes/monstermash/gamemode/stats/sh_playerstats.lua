if SERVER then
    util.AddNetworkString("RequestPlayerStats")
    util.AddNetworkString("SendPlayerStats")
    util.AddNetworkString("IncrementPlayerStatClient")
    util.AddNetworkString("ModifyPlayerStatIfBetterClient")
    util.AddNetworkString("ResetPlayerStatClient")
end

net.Receive("RequestPlayerStats", function(len, pl)
    local caller, ply
    caller = net.ReadEntity()
    ply = net.ReadEntity()
    
    GAMEMODE:RequestPlayerStats(caller, ply)
end)

net.Receive("IncrementPlayerStatClient", function(len, pl)
    local stat, amount, id
    stat = net.ReadString()
    amount = net.ReadInt(32)
    id = LocalPlayer():SteamID64()
    
    if (GAMEMODE.PlayerStats[id.."_round"] == nil) then
        GAMEMODE.PlayerStats[id.."_round"] = {}
    end
    
    if (GAMEMODE.PlayerStats[id.."_round"][stat] == nil) then
        GAMEMODE.PlayerStats[id.."_round"][stat] = amount
    else
        GAMEMODE.PlayerStats[id.."_round"][stat] = GAMEMODE.PlayerStats[id.."_round"][stat] + amount
    end
    
    if (string.sub(stat, 1, 6) == "treat_") then
        GAMEMODE.AddTreatDisplay(LocalPlayer(), stat)
    end
end)

net.Receive("ModifyPlayerStatIfBetterClient", function(len, pl)
    local stat, value, id
    stat = net.ReadString()
    value = net.ReadInt(32)
    id = LocalPlayer():SteamID64()
    
    if (GAMEMODE.PlayerStats[id.."_round"] == nil) then
        GAMEMODE.PlayerStats[id.."_round"] = {}
    end
    
    if (GAMEMODE.PlayerStats[id.."_round"][stat] == nil) then
        GAMEMODE.PlayerStats[id.."_round"][stat] = value
    elseif (value > GAMEMODE.PlayerStats[id.."_round"][stat]) then
        GAMEMODE.PlayerStats[id.."_round"][stat] = value
    end
    
    if (string.sub(stat, 1, 6) == "treat_") then
        GAMEMODE.AddTreatDisplay(LocalPlayer(), stat)
    end
end)

net.Receive("ResetPlayerStatClient", function(len, pl)
    local id = LocalPlayer():SteamID64()
    GAMEMODE.PlayerStats[id.."_round"] = {}
end)

net.Receive("SendPlayerStats", function(len, pl)
    local ply = net.ReadEntity()
    local size = net.ReadInt(32)
    local size2 = net.ReadInt(32)
    local data = util.JSONToTable(util.Decompress(net.ReadData(size)))
    local data2 = util.JSONToTable(util.Decompress(net.ReadData(size2)))
    GAMEMODE.PlayerStats[ply:SteamID64()] = data
    GAMEMODE.PlayerStats[ply:SteamID64().."_round"] = data2
end)

function GM:RequestPlayerStats(caller, ply)
    if CLIENT then
        net.Start("RequestPlayerStats")
            net.WriteEntity(caller)
            net.WriteEntity(ply)
        net.SendToServer()
    else
        if (self.PlayerStats[ply:SteamID64()] == nil) then
            self.PlayerStats[ply:SteamID64()] = {}
        end
        if (self.PlayerStats[ply:SteamID64().."_round"] == nil) then
            self.PlayerStats[ply:SteamID64().."_round"] = {}
        end
        local data = util.Compress(util.TableToJSON(self.PlayerStats[ply:SteamID64()]))
        local data2 = util.Compress(util.TableToJSON(self.PlayerStats[ply:SteamID64().."_round"]))
    
        net.Start("SendPlayerStats")
            net.WriteEntity(ply)
            net.WriteInt(data:len(), 32)
            net.WriteInt(data2:len(), 32)
            net.WriteData(data, data:len())
            net.WriteData(data2, data2:len())
        net.Send(caller)
    end
end

function GM:SavePlayerStats(ply)
    if CLIENT then return end
    local id
    if isstring(ply) then
        id = ply
    else
        id = ply:SteamID64()
    end
    local converted = util.TableToJSON(self.PlayerStats[id])
    file.Write("monstermash/mm_playerdata_"..id..".json", converted)
end

function GM:LoadPlayerStats(ply)
    local id
    if isstring(ply) then
        id = ply
    else
        id = ply:SteamID64()
    end
    local fname = "monstermash/mm_playerdata_"..id..".json"
    
    if !file.Exists(fname, "DATA") then 
        self.PlayerStats[id] = {} 
        return 
    end
    
    local json = file.Read(fname, "DATA")
    local data = util.JSONToTable(json)
    if data != nil then
        self.PlayerStats[id] = data
    end
end

function GM:ResetPlayerRoundStats(ply)
    local id = ply:SteamID64()
    self.PlayerStats[id.."_round"] = nil
    if (self.PlayerWeaponKills == nil) then
        self.PlayerWeaponKills = {}
    end 
    self.PlayerWeaponKills[id] = {}
    if SERVER then
        net.Start("ResetPlayerStatClient")
        net.Send(ply)
    end
end

function GM:IncrementPlayerStat(ply, stat, amount)
    local id = ply:SteamID64()
    if amount == nil then
        amount = 1
    end
    
    if (self.PlayerStats[id] == nil) then
        self:LoadPlayerStats(ply)
    end
    
    if (self.PlayerStats[id.."_round"] == nil) then
        self.PlayerStats[id.."_round"] = {}
    end
    
    if (self.PlayerStats[id] == nil) then
        self.PlayerStats[id] = {}
    end
    
    if (self.PlayerStats[id][stat] == nil) then
        self.PlayerStats[id][stat] = amount
    else
        self.PlayerStats[id][stat] = self.PlayerStats[id][stat] + amount
    end
    
    if (self.PlayerStats[id.."_round"][stat] == nil) then
        self.PlayerStats[id.."_round"][stat] = amount
    else
        self.PlayerStats[id.."_round"][stat] = self.PlayerStats[id.."_round"][stat] + amount
    end
    
    if SERVER then
        net.Start("IncrementPlayerStatClient")
            net.WriteString(stat)
            net.WriteInt(amount, 32)
        net.Send(ply)
    end
end

function GM:ModifyPlayerStatIfBetter(ply, stat, value)
    local id = ply:SteamID64()
    
    if (self.PlayerStats[id] == nil) then
        self:LoadPlayerStats(ply)
    end
    
    if (self.PlayerStats[id.."_round"] == nil) then
        self.PlayerStats[id.."_round"] = {}
    end
    
    if (self.PlayerStats[id] == nil) then
        self.PlayerStats[id] = {}
    end
    
    if (self.PlayerStats[id][stat] == nil) then
        self.PlayerStats[id][stat] = value
    elseif value > self.PlayerStats[id][stat] then
        self.PlayerStats[id][stat] = value
    end
    
    if (self.PlayerStats[id.."_round"][stat] == nil) then
        self.PlayerStats[id.."_round"][stat] = value
    elseif value > self.PlayerStats[id.."_round"][stat] then
        self.PlayerStats[id.."_round"][stat] = value
    end
    
    if SERVER then
        net.Start("ModifyPlayerStatIfBetterClient")
            net.WriteString(stat)
            net.WriteInt(amount, 32)
        net.Send(ply)
    end
end

function GM:StorePlayerWeaponKill(ply, weapon)
    local id = ply:SteamID64()
    if (self.PlayerWeaponKills == nil) then
        self.PlayerWeaponKills = {}
    end 
    if self.PlayerWeaponKills[id] == nil then
        self.PlayerWeaponKills[id] = {}
    end
    if (!table.HasValue(self.PlayerWeaponKills[id], weapon)) then
        table.insert(self.PlayerWeaponKills[id], weapon)
    end
end

function GM:GetPlayerWeaponKills(ply)
    local id = ply:SteamID64()
    if (self.PlayerWeaponKills == nil) then
        self.PlayerWeaponKills = {}
    end 
    if self.PlayerWeaponKills[id] == nil then
        self.PlayerWeaponKills[id] = {}
    end
    return self.PlayerWeaponKills[ply:SteamID64()]
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "mm_player_connect", function(data) 
	local id = util.SteamIDTo64(data.networkid)
    GAMEMODE.PlayerStats[id] = {}
    GAMEMODE.PlayerStats[id.."_round"] = {}
    GAMEMODE:LoadPlayerStats(id)
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "mm_player_disconnect", function(data) 
	local id = util.SteamIDTo64(data.networkid)
    GAMEMODE:SavePlayerStats(id)
    GAMEMODE.PlayerStats[id] = nil
    GAMEMODE.PlayerStats[id.."_round"] = nil
end)    