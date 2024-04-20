function GM:GivePlayerTreat(ply, treat)
    if ply:Team() == TEAM_COOPOTHER then return end
    self:IncrementPlayerStat(ply, "treat_"..treat)
end

local lasttreatsound = 0
function GM:AddTreatDisplay(treatname)
    if SERVER then return end
    
    if (LocalPlayer().TreatDisplays == nil) then
        LocalPlayer().TreatDisplays = {}
    end
    table.insert(LocalPlayer().TreatDisplays, {
        treat = treatname, 
        time = CurTime()+3,
        mat = Material("vgui/hud/"..string.Replace(treatname, "treat_", "treats/")..".png")
    })

    if lasttreatsound < CurTime() then
        timer.Simple(0, function()
            if ((LocalPlayer():GetWeaponTable()["Trick"] != "None" && LocalPlayer():GetTreatStack() >= GAMEMODE.Weapons["Trick"][LocalPlayer():GetWeaponTable()["Trick"]].cost) || (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().instanttrick)) then
                surface.PlaySound("gameplay/trick_ready.wav")
            else
                surface.PlaySound("ui/bell1.wav")
            end
        end)
        lasttreatsound = CurTime() + 0.05
    end
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

local function WeaponHasKillFlag(wep, flag)
    if (wep == nil || !IsValid(wep)) then return nil end
    return (wep:IsWeapon() && bit.band(wep.KillFlags, flag) != 0)
end

function GM:GiveMedalsOnDeath(victim, attacker, dmginfo)
    local inflictor = dmginfo:GetInflictor()
    if (victim == attacker || attacker:IsWorld()) then
        local vicstring = tostring(victim)
        local dmgtable = victim:GetLastDamage().dmgtable
        local smallest = vicstring
        local smallesttime = CurTime()-4
        
        if (dmgtable != nil) then
            for k, v in pairs(dmgtable) do
                if k != vicstring && v.time > smallesttime then
                    smallest = k
                    smallesttime = v.time
                end
            end
            
            if smallest != vicstring then
                attacker = dmgtable[smallest].attacker
                inflictor = dmgtable[smallest].inflictor
                if (attacker:IsPlayer()) then
                    attacker:GiveTreat("assisted_suicide")
                end
            end
            
            local thisplayerhit = {}
            for k, v in pairs(player.GetAll()) do
                if (v:Alive() && v:GetLastDamage().dmgtable != nil) then
                    for a, b in pairs(v:GetLastDamage().dmgtable) do
                        if (b.attacker == victim && b.time == CurTime()) then
                            table.insert(thisplayerhit, v)
                            break
                        end
                    end
                end
            end
            if (#thisplayerhit > 0) then
                victim:GiveTreat("youtried")
            end
        end
    end
end

function GM:GiveTreatsOnKill(victim, attacker, dmginfo)

    if (victim != attacker && attacker:IsPlayer()) then
        local attacker_hitnonmelee = false
        local attacker_hitmeleelast = false
        local stacksize = #victim:GetDamageStack()
        local inflictor = dmginfo:GetInflictor()
        attacker:StoreWeaponKill(inflictor)
        
        for k, v in pairs (victim:GetDamageStack()) do
            if k != stacksize && v.attacker == attacker && v.inflictor != nil && v.inflictor:IsWeapon() && v.inflictor.Base != "weapon_mm_basemelee" then
                attacker_hitnonmelee = true
            end
            if (k == stacksize) then
                if (v.inflictor != nil && v.inflictor.Base == "weapon_mm_basemelee") then
                    attacker_hitmeleelast = true
                end
            end
        end
    
        if (!inflictor.IsMMNPC) then
            attacker:AddLifeKill()
        end
        attacker:AddScore(inflictor.Points)
        
        if (inflictor != nil && inflictor:IsWeapon()) then
            if (inflictor.slot == 0) then
                attacker:IncrementPlayerStat("Melee_Kills")
            elseif (inflictor.slot == 1) then
                attacker:IncrementPlayerStat("Handgun_Kills")
            elseif (inflictor.slot == 2) then
                attacker:IncrementPlayerStat("Primary_Kills")
            elseif (inflictor.slot == 3) then
                attacker:IncrementPlayerStat("Throwable_Kills")
            end
        end
        
        if (#attacker:GetDamageStack() > 2) then
            local lastdamage1 = nil
            local lastdamage2 = nil
            for i = #attacker:GetDamageStack(), 1, -1 do
                if (lastdamage1 == nil) then
                    if (attacker:GetDamageStack()[i].time+10 < CurTime()) then
                        break
                    end
                    lastdamage1 = attacker:GetDamageStack()[i].attacker
                elseif (attacker:GetDamageStack()[i].attacker != lastdamage1) then
                    lastdamage2 = attacker:GetDamageStack()[i].attacker
                    if (attacker:GetDamageStack()[i].time+10 < CurTime()) then
                        lastdamage2 = nil
                    end
                    break
                end
            end
            if ((lastdamage1 == victim && lastdamage2 == attacker.lastkill) || (lastdamage2 == victim && lastdamage1 == attacker.lastkill)) then
                attacker:GiveTreat("two_attackers")
            end
        end
        
        if (attacker_hitnonmelee && attacker_hitmeleelast) then
            attacker:GiveTreat("finish_with_melee")
        end
        if (!GAMEMODE:GetFirstBlood()) then
            attacker:GiveTreat("firstblood")
            GAMEMODE:SetFirstBlood()
        end
        if (attacker:GetLifeKills() == 3) then
            attacker:GiveTreat("killstreak")
        end
        if victim:HasKillFlag(KILL_BLEED) then
            attacker:GiveTreat("bleed")
        end
        if victim:HasKillFlag(KILL_FIRE) then
            attacker:GiveTreat("fire")
        end
        if attacker:GetLastKiller() == victim:SteamID64() then
            attacker:GiveTreat("revenge")
            attacker:SetLastKiller(nil)
        end
        if (attacker:GetSpawnTime()+10 > CurTime()) then
            attacker:GiveTreat("kill_upon_spawning")
        end
        if (inflictor.Base == "weapon_mm_basemelee" && inflictor.Base == "weapon_mm_basemelee") then
            attacker:GiveTreat("melee_duel")
        end
        if (inflictor.Base == "weapon_mm_basemelee" && inflictor.Base == "weapon_mm_basegun") then
            attacker:GiveTreat("melee_guns")
        end
        for k, v in pairs (attacker.WeaponTemp) do
            if (v == "Random" && k != "Trick_NextLife" && inflictor != nil && IsValid(inflictor) && GAMEMODE.Weapons[k][inflictor:GetClass()] != nil) then
                attacker:GiveTreat("random")
            end
        end
        if (!inflictor.IsMMNPC) then
            if (attacker:Alive() && attacker:Health() <= 20) then
                attacker:GiveTreat("neardeath")
            end
            if (!attacker:Alive()) then
                attacker:GiveTreat("post_mortem")
            end
            if (attacker:HasStatusEffect(STATUS_BLEED)) then
                attacker:GiveTreat("killwhilebleeding")
            end
            if (attacker:HasStatusEffect(STATUS_CONCUSS)) then
                attacker:GiveTreat("killwhileconcussed")
            end
            if (attacker:HasStatusEffect(STATUS_GOREJARED)) then
                attacker:GiveTreat("killwhilegorejar")
            end
            if (victim:HasStatusEffect(STATUS_GOREJARED)&& victim:GetActiveWeapon().Base == "weapon_mm_basegun") then
                attacker:GiveTreat("killed_jammed")
            end
            if (attacker:MissingAnArm() || attacker:MissingALeg()) then
                attacker:GiveTreat("killwhilelimbless")
            end
            if (attacker:HasStatusEffect(STATUS_HALLUCINATING)) then
                attacker:GiveTreat("while_tripping")
            end
            if (WeaponHasKillFlag(inflictor, KILL_BACKSTAB)) then
                attacker:GiveTreat("backstab")
            end
            if (attacker:HasStatusEffect(STATUS_SPOOKED) || attacker:HasStatusEffect(STATUS_SPIDERWEBBED) || 
                attacker:HasStatusEffect(STATUS_BATS) || attacker:HasStatusEffect(STATUS_SELFELECTROCUTED)) then
                attacker:GiveTreat("while_immobilized")
            end
            if (victim:HasStatusEffect(STATUS_SPOOKED) || victim:HasStatusEffect(STATUS_SPIDERWEBBED) || 
                victim:HasStatusEffect(STATUS_BATS) || victim:HasStatusEffect(STATUS_SELFELECTROCUTED)) then
                attacker:GiveTreat("immobilized")
            end
            if (attacker:GetPos():Distance(victim:GetPos()) >= 1024) then
                attacker:GiveTreat("longrange")
            end
            if (IsValid(victim:GetActiveWeapon()) && victim:GetActiveWeapon().Base == "weapon_mm_basegun" && victim:GetActiveWeapon():GetMMBase_ReloadTimer() > CurTime()) then
                attacker:GiveTreat("killed_reloading")
            end
            if (victim:HasStatusEffect(STATUS_MELEECHARGE)) then
                attacker:GiveTreat("dash_kill")
            end
            if (attacker:HasStatusEffect(STATUS_MELEECHARGE) || attacker:HasStatusEffect(STATUS_MELEECHARGEEXTRA)) then
                attacker:GiveTreat("dash")
            end
            if (!victim:IsOnGround()) then
                attacker:GiveTreat("airborne")
            end
            if (IsValid(victim:GetActiveWeapon()) && victim:GetActiveWeapon():GetClass() == "weapon_mm_candycorn") then
                attacker:GiveTreat("kill_healing")
            end
        end
        if (victim:GetLifeKills() >= 3) then
            attacker:GiveTreat("spree_ender")
        end
        victim:SetLastKiller(attacker)
        attacker.lastkill = victim
    end
end