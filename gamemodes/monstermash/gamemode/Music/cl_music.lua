function MusicPlay(ply, args, dointro)
    if ply.Music then
        MusicStop(ply)
    end
    if !ply.Music && args[1] != nil && tonumber(args[1]) <= #MusicList && tonumber(args[1]) >= 1 then
        ply.MusicIndex = tonumber(args[1])
        if (ply.MusicVolume == nil) then
            ply.MusicVolume = 1;
        end
        if MusicList[ply.MusicIndex].startingsong != "" && dointro then
            sound.PlayFile( MusicList[ply.MusicIndex].startingsong, "", function(station, num, err)
                if IsValid( station ) then 
                    ply.Music = station
                    ply.Music:Play()
                    ply.Music:SetVolume(ply.MusicVolume, 0)
                end
            end)
            ply.MusicStart = true
            ply.MusicTimer = CurTime() + MusicList[ply.MusicIndex].dur_starting
        else
            sound.PlayFile( MusicList[ply.MusicIndex].song, "", function(station)
                if IsValid( station ) then 
                    ply.Music = station
                    ply.Music:Play()
                    ply.Music:SetVolume(ply.MusicVolume, 0)
                end
            end)
            ply.MusicStart = false
            ply.MusicTimer = CurTime() + MusicList[ply.MusicIndex].dur_song
        end
    end
end

function MusicStop(ply)
    if ply.Music then
        ply.Music:Stop()
        ply.Music = nil
    end
end

local lastroundstate = 0
function MusicThink(ply)
    // Set some starting variables
    if !ply.MusicStarterPack then
        ply.MusicStarterPack = true
        ply.MusicVolume = 1
        ply.MusicAutoNext = false
        ply.MusicLoop = false
        ply.MusicShuffle = false
        ply.MusicIndex = 0
        ply.MusicStart = false
        ply.MusicPaused = false
        ply.MusicRoundEnd = false
        ply.MusicRoundStart = false
        ply.MusicFadeout = false
        ply.MusicListening = false
        ply.MusicWackyPlaying = false
        for i=1, #MusicList do
            local sng = MusicList[i].song
            sng = string.Replace(sng, "sound/", "")
            util.PrecacheSound( sng )
        end
    end
    
    if !file.Exists( MusicList[1].song, "GAME" ) then
        return 
    end
    
    // Wacky round music
    /*
    if GAMEMODE:GetRoundsToWacky() == 0 then
        if GetGlobalVariable("WackyRound_Event") == 0 then
            if ply == GetGlobalVariable("WackyRound_COOPOther") then return end
            if !GetGlobalVariable("Game_Over") && !ply.MusicWackyPlaying then
                ply.MusicWackyPlaying = true
                sound.PlayFile( "sound/weapons/stick/BERSUCC.mp3", "", function(station, num, err)
                    if IsValid( station ) then 
                        ply.WackyMusic = station
                        ply.WackyMusic:Play()
                        ply.WackyMusic:SetVolume(0.01)
                    end
                end)
            elseif !GetGlobalVariable("Game_Over") && ply.MusicWackyPlaying then
                if GetGlobalVariable("WackyRound_COOPOther") == nil then return end
                local dist = ply:GetPos():Distance(GetGlobalVariable("WackyRound_COOPOther"):GetPos())
                if ply.WackyMusic then
                    if dist < 1000 then
                        ply.WackyMusic:SetVolume((1-dist/1024)*0.2)
                    else
                        ply.WackyMusic:SetVolume(0.01)
                    end
                end
            end
        end
    elseif GetGlobalVariable("RoundsToWacky") != nil && GetGlobalVariable("RoundsToWacky") != 0 then
        ply.MusicWackyPlaying = false
        if ply.WackyMusic then
            ply.WackyMusic:Stop()
            ply.WackyMusic = nil
        end
    end
    */
    
    // Replace music on round start/end
    if (!ply.MusicPaused && GAMEMODE:GetRoundState() == GMSTATE_ENDING) then
        if ply.Music then
            MusicStop(ply)
        end
        ply.MusicPaused = true
    elseif (ply.MusicPaused && GAMEMODE:GetRoundState() == GMSTATE_ROUND && lastroundstate == GMSTATE_BUYTIME) then
        ply.MusicPaused = false
        ply.MusicRoundEnd = false
        ply.MusicRoundStart = false
        if ply.MusicListening then
            MusicPlay(ply, {tostring(ply.MusicIndex)}, true)
        end
    end 
    
    // Fade music out
    if ply.Music && ply.MusicStart == false && ply.MusicLoop == false && ply.MusicListening && ply.MusicTimer != nil && ply.MusicTimer <= CurTime()+1 then
        ply.Music:SetVolume(ply.MusicVolume*(ply.MusicTimer - CurTime()))
    end
    
    // Handle music
    if ply.Music && ply.MusicListening && ply.MusicTimer != nil && ply.MusicTimer <= CurTime() then
        
        if ply.MusicStart then                                              // If the song has an intro, do this
            MusicStop(ply)  
            MusicPlay(ply, {tostring(ply.MusicIndex)}, false)
            ply.MusicStart = false
        elseif ply.MusicAutoNext then                                       // If AutoNext, go to the next song
            if ply.MusicShuffle then
                local oldindex = ply.MusicIndex
                while ply.MusicIndex == oldindex do
                    ply.MusicIndex = math.random(1, #MusicList)
                end
            else
                ply.MusicIndex = ply.MusicIndex + 1
                if ply.MusicIndex > #MusicList then
                    ply.MusicIndex = 1
                end
            end
            MusicStop(ply)
            MusicPlay(ply, {tostring(ply.MusicIndex)}, true)
            ply:ChatPrint("Now playing "..MusicList[ply.MusicIndex].name.." by "..MusicList[ply.MusicIndex].author)
        elseif ply.MusicLoop then                                           // If Loop, Loop the song (not playing the intro)
            MusicStop(ply)
            MusicPlay(ply, {tostring(ply.MusicIndex)}, false)
        elseif ply.MusicShuffle then                                        // If Shuffle, pick the next random song
            local oldindex = ply.MusicIndex
            while ply.MusicIndex == oldindex do
                ply.MusicIndex = math.random(1, #MusicList)
            end
            MusicStop(ply)
            MusicPlay(ply, {tostring(ply.MusicIndex)}, true)
            ply:ChatPrint("Now playing "..MusicList[ply.MusicIndex].name.." by "..MusicList[ply.MusicIndex].author)
        else                                                                // Else, stop the music
            MusicStop(ply)
            ply.MusicListening = false
        end

    end
    lastroundstate = GAMEMODE:GetRoundState()
end

concommand.Add( "mm_musicplayerstart", function( ply, cmd, args )
    MusicPlay(ply, args, true)
end)

concommand.Add( "mm_musicplayervolume", function( ply, cmd, args )
    if args[1] != nil then
        ply.MusicVolume = args[1]
        if ply.Music then
            ply.Music:SetVolume(ply.MusicVolume)
        end
    end
end)

concommand.Add( "mm_musicplayerstop", function( ply )
    MusicStop(ply)
end)