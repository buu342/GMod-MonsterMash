if currentPlaylist then return end // Prevent autorefresh

local MUSFLAG_LOOP     = 0x01
local MUSFLAG_SHUFFLE  = 0x02
local MUSFLAG_AUTOPLAY = 0x04

local MUSSTATE_NONE   = 0
local MUSSTATE_SONG   = 1
local MUSSTATE_PAUSED = 2

local currentSong = nil
local currentEntry = nil
local currentVolume = 1.0
local currentState = MUSSTATE_NONE
local currentFlags = 0
local oldState = MUSSTATE_NONE

local currentPlaylist = {}


function GeneratePlaylist(startsong)
    startsong = MusicList[startsong]
    currentPlaylist = {}
    
    local whitelist = {}
    local musicsettings = util.JSONToTable(file.Read("monstermash/music.json", "DATA") or "")
    if (musicsettings == nil) then
        musicsettings = {}
    end
    
    for k, v in ipairs(MusicList) do
        if (musicsettings[v.name] != false) then
            table.insert(whitelist, v)
        end
    end
    
    if (#whitelist == 0) then return end

    if (MusicGetShuffle()) then
        if (startsong != nil) then
            table.insert(currentPlaylist, startsong)
            table.RemoveByValue(whitelist, startsong)
        end
        for i=1, #whitelist do
            local entry = table.Random(whitelist)
            table.insert(currentPlaylist, entry)
            table.RemoveByValue(whitelist, entry)
        end
    elseif (MusicGetAutoPlay()) then
        local index = 1
        for i=1, #MusicList do
            if (MusicList[i] == startsong) then
                if (table.HasValue(whitelist, MusicList[i])) then
                    index = table.KeyFromValue(whitelist, MusicList[i])
                    table.insert(currentPlaylist, MusicList[i])
                else
                    index = math.random(1, #whitelist)
                end
                break
            end
        end
        for i=index+1, #whitelist do
            table.insert(currentPlaylist, whitelist[i])
        end
        for i=1, index do
            table.insert(currentPlaylist, whitelist[i])
        end
    end
    
    /*
    print("**********************************")
    print("Generated Playlist:")
    for i=1, #currentPlaylist do
        print(i.." "..currentPlaylist[i].name)
    end
    */
end

function MusicPlay(args, dointro)
    local song = args[1]
    if (song == nil) then return end
    song = tonumber(song)
    
    // Ensure the music files exists
    if song == 0 || !file.Exists(MusicList[song].song, "GAME") then
        return 
    end
    
    // Stop the current song
    if (currentSong) then
        MusicStop()
    end
    
    // Play the song
    if (song != nil && song <= #MusicList) then
        currentEntry = MusicList[song]
        sound.PlayFile(currentEntry.song, "noblock", function(station, num, err)
            if IsValid(station) then 
                currentSong = station
                if (currentEntry.loopstart != nil && !dointro) then
                    currentSong:SetTime(currentEntry.loopstart)
                end
                if (GAMEMODE:GetRoundState() == GMSTATE_ROUND) then
                    currentSong:Play()
                end
                currentSong:SetVolume(currentVolume, 0)
            end
        end)
        LocalPlayer():ChatPrint("Now playing: "..currentEntry.name..", by "..currentEntry.author..".")
        oldState = currentState
        currentState = MUSSTATE_SONG
    end
end

function MusicStop()
    if (currentSong) then
        currentSong:Stop()
        currentSong = nil
        currentEntry = nil
        oldState = currentState
        currentState = MUSSTATE_NONE
    end
end

function MusicPause()
    if (currentSong) then
        currentSong:Pause()
        oldState = currentState
        currentState = MUSSTATE_PAUSED
    end
end

function MusicThink()
    if (currentSong == nil) then return end
    
    // Pause music during round endings/buy time
    if (currentState != MUSSTATE_PAUSED && GAMEMODE:GetRoundState() == GMSTATE_ENDING) then
        MusicPause()
    elseif (currentState == MUSSTATE_PAUSED && GAMEMODE:GetRoundState() == GMSTATE_ROUND) then
        currentState = oldState
        currentSong:Play()
        LocalPlayer():ChatPrint("Resuming: "..currentEntry.name..", by "..currentEntry.author..".")
    end
    
    // Music finished
    if (currentSong:GetTime()+0.01 >= currentSong:GetLength()) then
    
        // Loop music
        if (MusicGetLooping()) then
            if (currentEntry.loopstart != nil) then
                currentSong:SetTime(currentEntry.loopstart)
            else
                currentSong:SetTime(0)
            end
            currentSong:Play()
        else
            local args = {}
            if (MusicGetShuffle() || MusicGetAutoPlay()) then // Shuffle or auto-play next
                local i = table.KeyFromValue(currentPlaylist, currentEntry)
                if (i == nil) then i = 0 end
                i = i % #currentPlaylist + 1
                args[1] = table.KeyFromValue(MusicList, currentPlaylist[i])
                MusicPlay(args, true)
            else
                MusicStop()
            end
        end
    end
end

function MusicSetVolume(args)
    if (currentSong) then
        currentVolume = args
        currentSong:SetVolume(currentVolume)
    end
end

function MusicSetTime(args)
    if (currentSong) then
        currentSong:SetTime(args)
    end
end

function MusicSetLooping(val)
    if (val) then
        currentFlags = bit.bor(currentFlags, MUSFLAG_LOOP)
    else
        currentFlags = bit.band(currentFlags, bit.bnot(MUSFLAG_LOOP))
    end
end

function MusicSetShuffle(val)
    if (val) then
        currentFlags = bit.bor(currentFlags, MUSFLAG_SHUFFLE)
    else
        currentFlags = bit.band(currentFlags, bit.bnot(MUSFLAG_SHUFFLE))
    end
end

function MusicSetAutoPlay(val)
    if (val) then
        currentFlags = bit.bor(currentFlags, MUSFLAG_AUTOPLAY)
    else
        currentFlags = bit.band(currentFlags, bit.bnot(MUSFLAG_AUTOPLAY))
    end
end

function MusicGetCurrentSong()
    return currentEntry
end

function MusicGetVolume()
    return currentVolume
end

function MusicGetTime()
    if (currentSong != nil) then
        return currentSong:GetTime()
    else
        return 0
    end
end

function MusicGetLength()
    if (currentSong != nil) then
        return currentSong:GetLength()
    else
        return 0
    end
end

function MusicGetLooping()
    return (bit.band(currentFlags, MUSFLAG_LOOP) == MUSFLAG_LOOP)
end

function MusicGetShuffle()
    return (bit.band(currentFlags, MUSFLAG_SHUFFLE) == MUSFLAG_SHUFFLE)
end

function MusicGetAutoPlay()
    return (bit.band(currentFlags, MUSFLAG_AUTOPLAY) == MUSFLAG_AUTOPLAY)
end

concommand.Add("mm_musicplayerstart", function(ply, cmd, args)
    GeneratePlaylist(args[1])
    MusicPlay(args, true)
end)

concommand.Add("mm_musicplayervolume", function(ply, cmd, args)    
    if (args[1] != nil) then
        MusicSetVolume(args)
    end
end)

concommand.Add("mm_musicplayerposition", function(ply, cmd, args)
    if (args[1] != nil) then
        MusicSetTime(args)
    end
end)

concommand.Add("mm_musicplayerstop", function(ply)
    MusicStop()
end)