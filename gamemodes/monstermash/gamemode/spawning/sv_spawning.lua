function GM:PlayerInitialSpawn(ply)
    ply:SetCharacter("Deer Haunter")
    ply:SetCharacterSkin(0)
    ply:InitializeWeapons()
    if (ply:IsBot()) then
        ply:SetTeam(TEAM_MONST)
    else
        ply:SetTeam(TEAM_SPECT)
    end
    ply:ConCommand("mm_menu")
    GAMEMODE:RequestRoundDataRefresh(ply)
end

function GM:PlayerSpawn(ply)
    ply:ViewPunchReset()
    ply:UnSpectate()
    ply:SetCanZoom(false)
    ply:StripWeapons()
    
    if (ply:Team() == TEAM_SPECT || ply:Team() == TEAM_COOPDEAD) then
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SetObserverMode(OBS_MODE_ROAMING)
    else
        player_manager.SetPlayerClass(ply, "mm_player")
        ply:ClearStatusEffects()
        ply:ResetAllWeaponCooldowns()
        ply:ClearWeaponSlots()
        ply:HandleCharacter()
        ply:SetBloodColor(DONT_BLEED)
        ply:ShouldDropWeapon(true)
        ply:SetSpawnTime()
        ply:Give("weapon_mm_candlestick")
        ply:HandleWeapons()
        ply:SetJumpPower(200)
        ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
        GAMEMODE:MakeSpawnDirt(ply)
        if (GAMEMODE:GetSuperPlayer() == ply) then
            ply:SetBloodColor(BLOOD_COLOR_MECH)
        end
        if (GAMEMODE:GetRoundState() == GMSTATE_BUYTIME) then
            ply:Freeze(true)
        end
    end
end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel(ply, ent)

    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)
    if (info) then
        ent:SetModel(info.model)
        ent:SetSkin(ply:GetCharacterSkin())
        ent:SetBodyGroups(info.body)
    end

end

function GM:MakeSpawnDirt(ply)
    if (ply:Team() == TEAM_MONST) then
        if (GetConVar("mm_spawnprotect"):GetBool()) then
            ply:SetStatusEffect(STATUS_SPAWNPROTECTED, nil, 1)
        end
        ply:SetStatusEffect(STATUS_SPAWNING, nil, 1.5)
        local ent = ents.Create("sent_mm_spawndirt")
        ent:SetPos(ply:GetPos())	
        ent:SetAngles(ply:GetAngles()+Angle(0,180,0))
        ent:Spawn()
        ent:SetNWString("PlayerModel", ply:GetModel())
        ent:SetModel(ply:GetModel())
        ent:SetSkin(ply:GetSkin())
        ent:SetOwner(ply)
        ent.Owner = ply
    end
end