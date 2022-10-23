AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local metaplayer = FindMetaTable("Player")

function metaplayer:SetLastDamage(dmginfo)
    self:SetNWInt("MM_PlayerLastDamageType", dmginfo:GetDamageType())
    self:SetNWInt("MM_PlayerLastDamageCustom", dmginfo:GetDamageCustom())
    self:SetNWInt("MM_PlayerLastDamageAmount", dmginfo:GetDamage())
    if (dmginfo:GetAttacker() != self && !dmginfo:GetAttacker():IsWorld()) then
        self:SetNWEntity("MM_PlayerLastDamageAttacker", dmginfo:GetAttacker())
        self:SetNWEntity("MM_PlayerLastDamageInflictor", dmginfo:GetInflictor())
    end
    if (CurTime() == self:GetNWFloat("MM_PlayerLastDamageTime")) then
        self:SetNWInt("MM_PlayerCummulativeDamage", self:GetNWInt("MM_PlayerCummulativeDamage")+dmginfo:GetDamage())
    else
        self:SetNWInt("MM_PlayerCummulativeDamage", dmginfo:GetDamage())
        self:SetNWFloat("MM_PlayerLastDamageTime", CurTime())
    end
    if (self.dmgtable == nil) then
        self.dmgtable = {}
    end
    if (self.dmgtable[tostring(dmginfo:GetAttacker())] == nil) then
        self.dmgtable[tostring(dmginfo:GetAttacker())] = {}
    end
    self.dmgtable[tostring(dmginfo:GetAttacker())].attacker = self:GetNWEntity("MM_PlayerLastDamageAttacker")
    self.dmgtable[tostring(dmginfo:GetAttacker())].inflictor = self:GetNWEntity("MM_PlayerLastDamageInflictor")
    self.dmgtable[tostring(dmginfo:GetAttacker())].time = CurTime()
    if SERVER then
        self:AddDamageStack(dmginfo)
    end
end

function metaplayer:DoneLoadout()
    if (self:Team() == TEAM_SPECT) then
        if CLIENT then
            net.Start("MM_DoneLoadoutClientside")
            net.SendToServer()
        else
            if (!GAMEMODE:InWackyRound() || GAMEMODE:WackyRoundData().mode == MODE_DEATHMACTH) then
                self:SetTeam(TEAM_MONST)
                self:Spawn()
            elseif (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().mode == MODE_CONVERT) then
                self:SetTeam(TEAM_COOPOTHER)
                self:Spawn()
            else
                self:SetTeam(TEAM_COOPDEAD)
            end
        end
    else
        if (GAMEMODE:GetRoundState() != GMSTATE_BUYTIME) then
            self:ChatPrint("Your loadout will change when you respawn")
        end
    end
end

function metaplayer:SetLastHitgroup(hitgroup)
    self:SetNWInt("MM_PlayerLastHitgroup", hitgroup)
end

function metaplayer:GetLastHitgroup()
    return self:GetNWInt("MM_PlayerLastHitgroup")
end

function metaplayer:ResetAbilityCoolDown(time)
    time = time or 5
    if (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().stamina_recharge != nil) then
        time = time / GAMEMODE:WackyRoundData().stamina_recharge
    end
    self:SetNWFloat("MM_PlayerAbilityCoolDown", CurTime() + time)
end

function metaplayer:CanUseAbility()
    return self:GetNWFloat("MM_PlayerAbilityCoolDown") < CurTime()
end

function metaplayer:GetAbilityCooldown()
    return self:GetNWFloat("MM_PlayerAbilityCoolDown")-CurTime()
end

function metaplayer:SetLastKiller(ply)
    self:SetNWString("MM_LastKiller", ply:SteamID64())
end

function metaplayer:SetSuperClass(class)
    self:SetNWInt("MM_PlayerSuperClass", class)
end

function metaplayer:SetLastAttackTime()
    self:SetNWFloat("MM_PlayerLastAttackTime", CurTime())
end

function metaplayer:GetLastAttackTime()
    return self:GetNWFloat("MM_PlayerLastAttackTime")
end

function metaplayer:GetSuperClass()
    return self:GetNWInt("MM_PlayerSuperClass")
end

function metaplayer:IsSuper()
    return self:GetNWInt("MM_PlayerSuperClass") != SUPERCLASS_NONE
end

function metaplayer:SetNextHeal()
    self:SetNWFloat("MM_NextHeal", CurTime()+20)
    self:SetNWInt("MM_HealCount", self:GetNWInt("MM_HealCount") + 1)
    if (self:GetNWInt("MM_HealCount") == 3) then
        self:GiveTreat("eat_candy_corn")
    end
end

function metaplayer:GetNextHeal()
    return self:GetNWFloat("MM_NextHeal")
end

function metaplayer:InitializeWeapons()
    self.WeaponTemp = {
        ["Melee"] = "None", 
        ["Handgun"] = "None", 
        ["Primary"] = "None", 
        ["Throwable"] = "None",
        ["Trick"] = "None",
        ["Trick_NextLife"] = "None"
    }
end

function metaplayer:GetWeaponTable()
    return self.WeaponTemp
end

function metaplayer:GetLastDamage()
    local dmg = {
        totalamount = self:GetNWInt("MM_PlayerCummulativeDamage"),
        amount = self:GetNWInt("MM_PlayerLastDamageAmount"),
        type = self:GetNWInt("MM_PlayerLastDamageType"),
        custom = self:GetNWInt("MM_PlayerLastDamageCustom"),
        attacker = self:GetNWEntity("MM_PlayerLastDamageAttacker"),
        inflictor = self:GetNWEntity("MM_PlayerLastDamageInflictor"),
        time = self:GetNWFloat("MM_PlayerLastDamageTime"),
        dmgtable = self.dmgtable
    }
    return dmg
end

function metaplayer:BuyWeapon(wep, slot)
    local oldweps = table.Copy(self.WeaponTemp)
    if (self.WeaponTemp == nil) then
        self:InitializeWeapons()
    end
    
    if (slot != "Trick" && slot != "Trick_NextLife" && self.WeaponTemp[slot] == wep) then
        return -1
    end
    
    if (slot == "Trick" || slot == "Trick_NextLife") then
        self.WeaponTemp["Trick_NextLife"] = wep
        if SERVER then
            net.Start("MM_UpdateWeaponTemp")
                net.WriteString("Trick_NextLife")
                net.WriteString(wep)
            net.Send(self)
        end
        if (GAMEMODE:GetRoundState() == GMSTATE_BUYTIME && (!GAMEMODE:InWackyRound() || !GAMEMODE:WackyRoundData().allow_buy)) then
            if (wep != "Random") then
                self.WeaponTemp["Trick"] = wep
                if SERVER then
                    net.Start("MM_UpdateWeaponTemp")
                        net.WriteString("Trick")
                        net.WriteString(self.WeaponTemp["Trick"])
                    net.Send(self)
                end
            else
                self:GiveRandomTrick()
            end
        end
        return self:GetNWInt("MM_Gold")
    end

    local cost = 0
    for k, v in pairs(self.WeaponTemp) do
        if (k != slot && k != "Trick" && k != "Trick_NextLife") then
            cost = cost + GAMEMODE.Weapons[k][v].cost
        end
    end
        
    local finalcost = cost+GAMEMODE.Weapons[slot][wep].cost
    if (finalcost <= GetConVar("mm_budget"):GetInt()) then
        self.WeaponTemp[slot] = wep
        if SERVER then
            net.Start("MM_UpdateWeaponTemp")
                net.WriteString(slot)
                net.WriteString(wep)
            net.Send(self)
        end
        self:SetNWInt("MM_Gold", GetConVar("mm_budget"):GetInt()-finalcost)
        
        if ((!GAMEMODE:InWackyRound() || (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().allow_buy != false)) && SERVER && (self:Team() == TEAM_MONST || self:Team() == TEAM_COOPMONST) && self != GAMEMODE:GetSuperPlayer()) then
            if (GAMEMODE:GetRoundState() == GMSTATE_BUYTIME) then
                self:StripWeapon(oldweps[slot])
                if (wep != "Random" && wep != "None") then
                    self:GiveWeapon(wep, slot)
                    self:SelectWeapon(wep)
                end
            end
        end
        
        return self:GetNWInt("MM_Gold")
    end
    
    return -1
end

function metaplayer:GiveRandomTrick()
    if SERVER then
        local tricksnametable = {}
        for k, v in pairs(GAMEMODE.Weapons["Trick"]) do
            if (k != "None" && k != "Random") then
                table.insert(tricksnametable, k)
            end
        end
        self.WeaponTemp["Trick"] = table.Random(tricksnametable)
        net.Start("MM_UpdateWeaponTemp")
            net.WriteString("Trick")
            net.WriteString(self.WeaponTemp["Trick"])
        net.Send(self)
    end
end

if SERVER then
    util.AddNetworkString("MM_RequestCharacterChange")
    net.Receive("MM_RequestCharacterChange", function(len, ply)
        local name = net.ReadString()
        ply.CharacterTemp = name
    end)
    
    util.AddNetworkString("MM_RequestSkinChange")
    net.Receive("MM_RequestSkinChange", function(len, ply)
        local skin = net.ReadInt(32)
        ply.CharacterSkinTemp = skin
    end)
    
    util.AddNetworkString("MM_RequestWeaponChange")
    net.Receive("MM_RequestWeaponChange", function(len, ply)
        local wep = net.ReadString()
        local slot = net.ReadString()
        ply:BuyWeapon(wep, slot)
    end)
    util.AddNetworkString("MM_UpdateWeaponTemp")
    util.AddNetworkString("MM_UpdateWeapon")
    util.AddNetworkString("MM_UpdateStatusEffects")
    util.AddNetworkString("MM_UpdateScore")
    util.AddNetworkString("MM_UpdateTreatStack")
    util.AddNetworkString("MM_UpdateWeaponCooldown")
    
    function metaplayer:AddDamageStack(dmginfo)
        if (self.DamageStack == nil) then
            self.DamageStack = {}
        end
        table.insert(self.DamageStack, {
            time = CurTime(), 
            damage = dmginfo:GetDamage(), 
            attacker = dmginfo:GetAttacker(), 
            inflictor = dmginfo:GetInflictor(), 
            custom = dmginfo:GetDamageCustom(),
            type = dmginfo:GetDamageType()
        })
    end

    function metaplayer:ClearDamageStack()
        self.DamageStack = {}
    end

    function metaplayer:GetDamageStack()
        return self.DamageStack
    end

    function metaplayer:ClearLifeEarnedTreats()
        self.EarnedLifeTreats = {}
    end

    function metaplayer:EarnedTreatInLife(treat)
        if self.EarnedLifeTreats == nil then
            return false
        end
        for k, v in pairs(self.EarnedLifeTreats) do
            if (v == treat) then
                return true
            end
        end
        return false
    end
    
    function metaplayer:AddLifeEarnedTreats(treat)
        if !self:Alive() then return end
        if (self.EarnedLifeTreats == nil) then
            self.EarnedLifeTreats = {}
        end
        table.insert(self.EarnedLifeTreats, treat)
    end
    
    function metaplayer:HandleCharacter(overridemdl, overrideskin)
        if (self.CharacterTemp == nil) then
            self.CharacterTemp = self:GetCharacterName()
        end
        
        if (self.CharacterSkinTemp == nil) then
            self.CharacterSkinTemp = self:GetNWInt("MM_CharacterSkin")
        end
        
        if (overridemdl == nil) then
            if (self:GetCharacterName() != self.CharacterTemp) then
                if (self.CharacterTemp == "Random") then
                    local validlist = {}
                    for k, v in pairs(GAMEMODE.Characters) do
                        if !v.unlisted && self:CanUseCharacter(k) && k != "Random" then
                            table.insert(validlist, k)
                        end
                    end
                    self:SetNWString("MM_Character", table.Random(validlist))
                else
                    self:SetNWString("MM_Character", self.CharacterTemp)
                end
            end
            
            if (self:GetNWInt("MM_CharacterSkin") != self.CharacterSkinTemp || self.CharacterTemp == "Random") then
                if (self.CharacterTemp == "Random") then
                    if (self:GetCharacter().skins == nil) then
                        self:SetNWInt("MM_CharacterSkin", 0)
                    else
                        self:SetNWInt("MM_CharacterSkin", math.random(#self:GetCharacter().skins)-1)
                    end
                else
                    self:SetNWInt("MM_CharacterSkin", self.CharacterSkinTemp)
                end
            end
        
            self:SetModel(self:GetCharacter().model)
            self:SetSkin(self:GetCharacterSkin())
        else
            self:SetNWString("MM_Character", overridemdl)
            self:SetModel(self:GetCharacter().model)
            self:SetSkin(overrideskin or 0)
        end
        self:SetupHands()
    end
    
    function metaplayer:HandleWeapons()
        if (!GAMEMODE:InWackyRound() || (GAMEMODE:WackyRoundData().loadout_override == nil && GAMEMODE:GetSuperPlayer() != self)) then
            local extracost = 0
            local prefferedorder = {"Primary", "Handgun", "Melee", "Throwable"}
            for i=#prefferedorder, 1, -1 do
                local k = prefferedorder[i]
                local v = self.WeaponTemp[k]
                if k != "Trick" && v != "None" then
                    extracost = extracost + self:GiveWeapon(v, k, extracost)
                end
            end
            if (self.WeaponTemp["Trick_NextLife"] == "Random" && self:GetTreatStack() == 0) then
                self:GiveRandomTrick()
            elseif (self.WeaponTemp["Trick"] != self.WeaponTemp["Trick_NextLife"] && self.WeaponTemp["Trick_NextLife"] != "Random") then
                self:ResetTreatStack()
                self.WeaponTemp["Trick"] = self.WeaponTemp["Trick_NextLife"]
                if SERVER then
                    net.Start("MM_UpdateWeaponTemp")
                        net.WriteString("Trick")
                        net.WriteString(self.WeaponTemp["Trick"])
                    net.Send(self)
                end
            end
        elseif (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().loadout_override != nil) then
            for k, v in pairs(GAMEMODE:WackyRoundData().loadout_override) do
                if (v != "None" && k != "Trick") then
                    self:GiveWeapon(v, k)
                elseif (k == "Trick" && GAMEMODE:WackyRoundData().loadout_override["Trick"] != nil) then
                    self.WeaponTemp["Trick"] = GAMEMODE:WackyRoundData().loadout_override["Trick"]
                    if SERVER then
                        net.Start("MM_UpdateWeaponTemp")
                            net.WriteString("Trick")
                            net.WriteString(self.WeaponTemp["Trick"])
                        net.Send(self)
                    end
                end
            end
        end
    end
end

if CLIENT then
    function metaplayer:RequestCharacterChange(name)
        net.Start("MM_RequestCharacterChange")
            net.WriteString(name)
        net.SendToServer()
        self.CharacterTemp = name
    end
    
    function metaplayer:RequestSkinChange(skin)
        net.Start("MM_RequestSkinChange")
            net.WriteInt(skin, 32)
        net.SendToServer()
        self.CharacterSkinTemp = skin
    end
    
    net.Receive("MM_UpdateWeaponTemp", function(len, ply)
        local str = net.ReadString()
        LocalPlayer().WeaponTemp[str] = net.ReadString()
    end)
    
    net.Receive("MM_UpdateWeapon", function(len, ply)
        local str = net.ReadString()
        LocalPlayer():SetNWString(str, net.ReadString())
    end)
    
    net.Receive("MM_UpdateStatusEffects", function(len, ply)
        local effect 
        LocalPlayer():SetNWInt("MM_StatusEffects", net.ReadInt(32))
        effect = net.ReadString()
        time = net.ReadFloat()
        duration = net.ReadFloat()
        if (duration != 0) then
            LocalPlayer():SetNWInt("MM_StatusEffectDuration"..effect, time+duration)
            LocalPlayer():SetNWInt("MM_StatusEffectMaxTime"..effect, duration)
        end
    end)
    
    net.Receive("MM_UpdateScore", function(len, ply)
        local pl = net.ReadEntity()
        pl:SetNWInt("MM_PlayerScore", net.ReadInt(32))
    end)
    
    net.Receive("MM_UpdateTreatStack", function(len, ply)
        LocalPlayer():SetNWInt("MM_PlayerTreatStack", net.ReadInt(32))
    end)
    
    net.Receive("MM_UpdateWeaponCooldown", function(len, ply)
        local weapon = net.ReadString()
        local ctime = net.ReadFloat()
        local time = net.ReadFloat()
        LocalPlayer():SetNWFloat("MM_WeaponCooldown_"..weapon, ctime + time)
        LocalPlayer():SetNWInt("MM_WeaponCooldownMax_"..weapon, time)
    end)
end

function metaplayer:SetCharacter(name)
    self:SetNWString("MM_Character", name)
end

function metaplayer:SetCharacterSkin(skin)
    self:SetNWInt("MM_CharacterSkin", skin)
end

function metaplayer:GetCharacterName()
    return self:GetNWString("MM_Character")
end

function metaplayer:GetCharacter()
    return GAMEMODE.Characters[self:GetCharacterName()]
end

function metaplayer:GetCharacterTemp()
    return self.CharacterTemp
end

function metaplayer:GetSkinTemp()
    return self.CharacterSkinTemp
end

function metaplayer:GetCharacterSkin()
    return self:GetNWInt("MM_CharacterSkin")
end

function metaplayer:IsCharacter(character)
    return self:GetCharacter() == GAMEMODE.Characters[character]
end

function metaplayer:CanUseCharacter(name)
    return (!GAMEMODE.Characters[name].special || table.HasValue(GAMEMODE.CharacterSpecials[name], self:SteamID()))
end

function metaplayer:ClearStatusEffects()
    self:SetNWInt("MM_StatusEffects", 0)
    if SERVER then
        net.Start("MM_UpdateStatusEffects")
            net.WriteInt(self:GetNWInt("MM_StatusEffects"), 32)
            net.WriteString("")
            net.WriteFloat(0)
            net.WriteFloat(0)
        net.Send(self)
    end
    self:SetSuperClass(SUPERCLASS_NONE)
    self:SetNWInt("MM_KillFlags", 0)
    self:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_BOTH)
    self:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_BOTH)
    self:SetNWInt("MM_PlayerLastHitgroup", 0)
    self:SetNWEntity("MM_Killer", nil)
    self:SetNWInt("MM_MaxLifeKills", 0)
    self:SetNWFloat("MM_MaxLifeTime", 0)
    if SERVER then
        self:ClearDamageStack()
        self:ClearLifeEarnedTreats()
    end
end

function metaplayer:SetStatusEffect(effect, dmginfo, duration)
    if (self:IsSuper() && effect != STATUS_BLEED && effect != STATUS_MELEECHARGE && effect != STATUS_MELEECHARGEEXTRA) then return end
    if (dmginfo != nil && !self:CanBeDamagedBy(dmginfo:GetAttacker())) then return end
    self:SetNWInt("MM_StatusEffects", bit.bor(self:GetNWInt("MM_StatusEffects"), effect))
    if dmginfo != nil then
        self:SetNWEntity("MM_StatusEffectAttacker"..tostring(effect), dmginfo:GetAttacker())
        self:SetNWEntity("MM_StatusEffectInflictor"..tostring(effect), dmginfo:GetInflictor())
    end
    if duration != nil then
        local timername = "MM_TimerStatusEffect"..tostring(effect).."_"..tostring(self:EntIndex())
        self:SetNWInt("MM_StatusEffectDuration"..tostring(effect), CurTime()+duration)
        self:SetNWInt("MM_StatusEffectMaxTime"..tostring(effect), duration)
        if timer.Exists(timername) then
            timer.Adjust(timername, duration, 0, function() 
                if !IsValid(self) then return end
                self:RemoveStatusEffect(effect)
            end)
        else
            timer.Create(timername, duration, 0, function() 
                if !IsValid(self) then return end
                self:RemoveStatusEffect(effect)
            end)
        end
    end
    if SERVER then
        net.Start("MM_UpdateStatusEffects")
            net.WriteInt(self:GetNWInt("MM_StatusEffects"), 32)
            net.WriteString(tostring(effect))
            net.WriteFloat(CurTime())
            net.WriteFloat(duration or 0)
        net.Send(self)
    end
end

function metaplayer:RemoveStatusEffect(effect)
    self:SetNWInt("MM_StatusEffects", bit.band(self:GetNWInt("MM_StatusEffects"), bit.bnot(effect)))
    if SERVER then
        net.Start("MM_UpdateStatusEffects")
            net.WriteInt(self:GetNWInt("MM_StatusEffects"), 32)
            net.WriteString("")
            net.WriteFloat(0)
            net.WriteFloat(0)
        net.Send(self)
    end
end

function metaplayer:GetStatusEffects()
    return self:GetNWInt("MM_StatusEffects")
end

function metaplayer:HasStatusEffect(effect)
    return (bit.band(self:GetNWInt("MM_StatusEffects"), effect) == effect)
end

function metaplayer:GetStatusEffectMaxTime(effect)
    if self:HasStatusEffect(effect) then
        return self:GetNWInt("MM_StatusEffectMaxTime"..tostring(effect))
    end
    return nil
end

function metaplayer:GetStatusEffectTime(effect)
    if self:HasStatusEffect(effect) then
        return self:GetNWInt("MM_StatusEffectDuration"..tostring(effect))-CurTime()
    end
    return 0
end

function metaplayer:GetStatusEffectAttacker(effect)
    if self:HasStatusEffect(effect) then
        return self:GetNWEntity("MM_StatusEffectAttacker"..tostring(effect))
    end
    return nil
end

function metaplayer:GetStatusEffectInflictor(effect)
    if self:HasStatusEffect(effect) then
        return self:GetNWEntity("MM_StatusEffectInflictor"..tostring(effect))
    end
    return nil
end

function metaplayer:ClearKillFlags()
    self:SetNWInt("MM_KillFlags", 0)
end

function metaplayer:SetKillFlag(flag)
    self:SetNWInt("MM_KillFlags", bit.bor(self:GetNWInt("MM_KillFlags"), flag))
end

function metaplayer:GetKillFlags()
    return self:GetNWInt("MM_KillFlags")
end

function metaplayer:HasKillFlag(flag)
    return (bit.band(self:GetNWInt("MM_KillFlags"), flag) == flag)
end

function metaplayer:GetGold()
    return self:GetNWInt("MM_Gold", GetConVar("mm_budget"):GetInt())
end

function metaplayer:CountMissingLimbs()
    local count = 0
    local value = bit.band(self:GetNWInt("MM_StatusEffects"), bit.bor(STATUS_MISSINGLLEG, STATUS_MISSINGRLEG, STATUS_MISSINGLARM, STATUS_MISSINGRARM))
    while (value != 0) do
        count = count + 1
        value = bit.band(value, value - 1)
    end
    return count
end

function metaplayer:MissingLeftArm()
    return (self:HasStatusEffect(STATUS_MISSINGLARM))
end

function metaplayer:MissingRightArm()
    return (self:HasStatusEffect(STATUS_MISSINGRARM))
end

function metaplayer:MissingAnArm()
    return (self:HasStatusEffect(STATUS_MISSINGLARM) || self:HasStatusEffect(STATUS_MISSINGRARM))
end

function metaplayer:MissingBothArms()
    return (self:HasStatusEffect(STATUS_MISSINGLARM) && self:HasStatusEffect(STATUS_MISSINGRARM))
end

function metaplayer:MissingLeftLeg()
    return (self:HasStatusEffect(STATUS_MISSINGLLEG))
end

function metaplayer:MissingRightLeg()
    return (self:HasStatusEffect(STATUS_MISSINGRLEG))
end

function metaplayer:MissingALeg()
    return (self:HasStatusEffect(STATUS_MISSINGLLEG) || self:HasStatusEffect(STATUS_MISSINGRLEG))
end

function metaplayer:MissingBothLegs()
    return (self:HasStatusEffect(STATUS_MISSINGLLEG) && self:HasStatusEffect(STATUS_MISSINGRLEG))
end

function metaplayer:DodgeRoll(side)
    if CLIENT && !IsFirstTimePredicted() then return end
    local status
    local cycle
    if side == "Left" then
        status = STATUS_ROLLLEFT
        cycle = 0.17
    else
        status = STATUS_ROLLRIGHT
        cycle = 0
    end
    self:ResetAbilityCoolDown()
    self:AnimRestartMainSequence()
    self:SetCycle(cycle)
    self:Freeze(true)
    self:SetStatusEffect(status, nil, 0.5)
    if SERVER then
        net.Start("MM_SetAnimCycle")
            net.WriteFloat(cycle)
            net.WriteEntity(self)
        net.Broadcast()
    end
end

function metaplayer:IsDodgeRolling()
    return (self:HasStatusEffect(STATUS_ROLLLEFT) || self:HasStatusEffect(STATUS_ROLLRIGHT))
end

function metaplayer:MeleeCharge()
    if CLIENT && !IsFirstTimePredicted() then return end
    self:ResetAbilityCoolDown()
    self:AnimRestartMainSequence()
    self:SetCycle(0)
    self:Freeze(true)
    self:SetStatusEffect(STATUS_MELEECHARGE, nil, 1)
    if SERVER then
        net.Start("MM_SetAnimCycle")
            net.WriteFloat(0)
            net.WriteEntity(self)
        net.Broadcast()
    end
end

function metaplayer:IsMeleeCharging()
    return (self:HasStatusEffect(STATUS_MELEECHARGE))
end

function metaplayer:StoreWeaponKill(inflictor)
    GAMEMODE:StorePlayerWeaponKill(self, inflictor)
end

function metaplayer:GetWeaponKills()
    return GAMEMODE:GetPlayerWeaponKills(self)
end

if SERVER then
    util.AddNetworkString("MM_SetAnimCycle")
    util.AddNetworkString("MM_DoneLoadoutClientside")
    
    net.Receive("MM_DoneLoadoutClientside", function(len, ply)
        ply:DoneLoadout()
    end)

end

net.Receive("MM_SetAnimCycle", function(len)
    local cycle = net.ReadFloat()
    local ply = net.ReadEntity()
    
    if (ply == nil || !IsValid(ply) || !ply:IsPlayer()) then return end
    if LocalPlayer() == ply then return end
    ply:AnimRestartMainSequence()
    ply:SetCycle(cycle or 0)
end)


local flinchAnim = {
    ACT_FLINCH_HEAD,
    ACT_FLINCH_PHYSICS,
    ACT_FLINCH_STOMACH,
    ACT_FLINCH_SHOULDER_LEFT,
    ACT_FLINCH_SHOULDER_RIGHT,
    ACT_FLINCH_BACK
}
function metaplayer:Flinch(anim)
    if CLIENT then return end
    if anim != nil then
        net.Start("MM_DoPlayerFlinch")
            net.WriteInt(anim, 32)
            net.WriteEntity(self)
        net.Broadcast()    
    else
        net.Start("MM_DoPlayerFlinch")
            net.WriteInt(flinchAnim[math.random(1, #flinchAnim)], 32)
            net.WriteEntity(self)
        net.Broadcast()
    end
end

function metaplayer:SetWeaponCooldown(weapon, time)
    local wepname = weapon
    if (!isstring(weapon)) then
        wepname = weapon:GetClass()
    end
    self:SetNWFloat("MM_WeaponCooldown_"..wepname, CurTime() + time)
    self:SetNWInt("MM_WeaponCooldownMax_"..wepname, time)
    if self.weaponCooldowns == nil then
        self.weaponCooldowns = {}
    end
    table.insert(self.weaponCooldowns, wepname)
    if SERVER then
        net.Start("MM_UpdateWeaponCooldown")
            net.WriteString(wepname)
            net.WriteFloat(CurTime())
            net.WriteFloat(time)
        net.Send(self)
    end
end

function metaplayer:GetWeaponCooldown(weapon)
    if (weapon == nil || !IsValid(weapon)) then return 0 end
    local varName = "MM_WeaponCooldown_"..weapon:GetClass()
    if (self:GetNWFloat(varName) < CurTime()) then
        return 0
    end
    return self:GetNWFloat(varName) - CurTime()
end

function metaplayer:GetWeaponCooldownMax(weapon)
    return self:GetNWInt("MM_WeaponCooldownMax_"..weapon:GetClass())
end

function metaplayer:ResetAllWeaponCooldowns()
    if self.weaponCooldowns == nil then
        self.weaponCooldowns = {}
        return
    end
    for i=1, #self.weaponCooldowns do
        self:SetWeaponCooldown(self.weaponCooldowns[i], 0)
    end
    self:SetNWFloat("MM_NextHeal", 0)
end

function metaplayer:GiveWeapon(weapon, category, extracost)
    if type(weapon) != "string" then
        weapon = weapon:GetClass()
    end
    
    if (weapon == "Random") then
        local valid = {}
        for k, v in pairs(GAMEMODE.Weapons[category]) do
            if (k != "Random" && v.cost+extracost <= self:GetGold()) then
                table.insert(valid, k)
            end
        end
        if (#valid > 0) then
            local weapon = table.Random(valid)
            if (weapon != "None") then
                if SERVER then
                    local swep = self:Give(weapon)
                    self:SetNWString("MM_WeaponSlot"..tostring(swep.Slot+1), weapon)
                    net.Start("MM_UpdateWeapon")
                        net.WriteString("MM_WeaponSlot"..tostring(swep.Slot+1))
                        net.WriteString(weapon)
                    net.Send(self)
                end
                self:SelectWeapon(weapon)
                return GAMEMODE.Weapons[category][weapon].cost
            end
        end
        return 0
    end
    
    if self:HasWeapon(weapon) then return 0 end
    
    if SERVER then
        local swep = self:Give(weapon)
        self:SetNWString("MM_WeaponSlot"..tostring(swep.Slot+1), weapon)
        net.Start("MM_UpdateWeapon")
            net.WriteString("MM_WeaponSlot"..tostring(swep.Slot+1))
            net.WriteString(weapon)
        net.Send(self)
    end
    self:SelectWeapon(weapon)
    return 0
end

function metaplayer:HasWeaponSlot(slot)
    return self:GetNWString("MM_WeaponSlot"..tostring(slot)) != ""
end

function metaplayer:GetWeaponSlot(slot)
    return LocalPlayer():GetWeapon(self:GetNWString("MM_WeaponSlot"..tostring(slot)))
end

function metaplayer:DropWeaponSlot(slot)
    if CLIENT then return end
    if (self:GetNWString("MM_WeaponSlot"..tostring(slot)) != "") then
        local wep = self:GetWeapon(self:GetNWString("MM_WeaponSlot"..tostring(slot)))
        if (wep != nil && IsValid(wep)) then
            self:DropWeapon(self:GetWeapon(self:GetNWString("MM_WeaponSlot"..tostring(slot))))
        end
        self:SetNWString("MM_WeaponSlot"..tostring(slot), "")
    end
end

function metaplayer:ClearWeaponSlots()
    for i=1, 4 do
        self:SetNWString("MM_WeaponSlot"..tostring(i), "")
    end
end

function metaplayer:LoadStats()
    if !file.Exists("mm_playerstats_"..self:SteamID64()..".json", "DATA") then
        self.PlayerStats = {}
        file.Write("mm_playerstats_"..self:SteamID64()..".json", self.PlayerStats)
    else
        self.PlayerStats = util.JSONToTable(file.Read("mm_playerstats_"..self:SteamID64()..".json"))
    end
end

function metaplayer:SaveStats()
    file.Write("mm_playerstats_"..self:SteamID64()..".json", self.PlayerStats)
end

function metaplayer:GiveTreat(treat)
    if (self:GetStatusEffectTime(STATUS_SIGHT) > 0) then return end
    if (self:GetStatusEffectTime(STATUS_INVISIBLE) > 0) then return end
    if (self:GetBloodColor() == BLOOD_COLOR_MECH) then return end
    GAMEMODE:GivePlayerTreat(self, treat)
    self:AddTreatStack()
    self:AddLifeEarnedTreats(treat)
end

function metaplayer:GetTreatDisplays()
    return GAMEMODE:GetTreatDisplays()
end

function metaplayer:SetLastKiller(ply)
    if (ply == nil) then
        self:SetNWString("MM_LastKiller", "")
    elseif (ply:IsPlayer()) then
        self:SetNWString("MM_LastKiller", ply:SteamID64())
    end
end

function metaplayer:GetLastKiller()
    return self:GetNWString("MM_LastKiller")
end

function metaplayer:GetLastKiller()
    return self:GetNWString("MM_LastKiller")
end

function metaplayer:AddLifeKill()
    self:SetNWInt("MM_LifeKills", self:GetNWInt("MM_LifeKills")+1)
    if (self:GetNWInt("MM_LifeKills") > self:GetNWInt("MM_MaxLifeKills")) then
        self:SetNWInt("MM_MaxLifeKills", self:GetNWInt("MM_LifeKills"))
    end
end

function metaplayer:GetLifeKills()
    return self:GetNWInt("MM_LifeKills")
end

function metaplayer:GetMaxLifeKills()
    return self:GetNWInt("MM_MaxLifeKills")
end

function metaplayer:SetSpawnTime()
    self:SetNWFloat("MM_SpawnTime", CurTime())
end

function metaplayer:GetSpawnTime()
    return self:GetNWFloat("MM_SpawnTime")
end

function metaplayer:SetDieTime()
    if (self:GetNWFloat("MM_SpawnTime") - CurTime() > self:GetNWFloat("MM_MaxLifeTime")) then
        self:SetNWFloat("MM_MaxLifeTime", self:GetNWFloat("MM_SpawnTime") - CurTime())
    end
end

function metaplayer:GetMaxLifeTime()
    return self:GetNWFloat("MM_MaxLifeTime")
end

function metaplayer:ResetLifeStats()
    self:SetNWInt("MM_LifeKills", 0)
    self:SetNWInt("MM_HealCount", 0)
    self:SetNWInt("MM_LifeTime", 0)
end

function metaplayer:LoseLeg()
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(0)
    dmginfo:SetDamageCustom(STATUS_MISSINGLIMB)
    GAMEMODE:LoseLimb(self, dmginfo, math.random(3, 4))
end

function metaplayer:LoseArm()
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(0)
    dmginfo:SetDamageCustom(STATUS_MISSINGLIMB)
    GAMEMODE:LoseLimb(self, dmginfo, math.random(1, 2))
end

function metaplayer:GetScore()
    return self:GetNWInt("MM_PlayerScore")
end

function metaplayer:AddScore(score)
    if (score == nil) then score = 10 end
    self:SetNWInt("MM_PlayerScore", self:GetNWInt("MM_PlayerScore")+score)
    if SERVER then
        net.Start("MM_UpdateScore")
            net.WriteInt(self:GetNWInt("MM_PlayerScore"), 32)
            net.WriteEntity(self)
        net.Broadcast(self)
    end
end

function metaplayer:ResetScore()
    self:SetNWInt("MM_PlayerScore", 0)
    if SERVER then
        net.Start("MM_UpdateScore")
            net.WriteInt(0, 32)
            net.WriteEntity(self)
        net.Broadcast(self)
    end
end

function metaplayer:GetTreatStack()
    return self:GetNWInt("MM_PlayerTreatStack")
end

function metaplayer:AddTreatStack()
    if (self:GetTreatStack() < GAMEMODE.Weapons["Trick"][self:GetWeaponTable()["Trick"]].cost) then
        self:SetNWInt("MM_PlayerTreatStack", self:GetNWInt("MM_PlayerTreatStack")+1)
        if (GAMEMODE:InWackyRound() && GAMEMODE:WackyRoundData().instanttrick) then
            self:SetNWInt("MM_PlayerTreatStack", GAMEMODE.Weapons["Trick"][self:GetWeaponTable()["Trick"]].cost)
        end
        if SERVER then
            net.Start("MM_UpdateTreatStack")
                net.WriteInt(self:GetNWInt("MM_PlayerTreatStack"), 32)
            net.Send(self)
        end
    end
end

function metaplayer:ResetTreatStack()
    self:SetNWInt("MM_PlayerTreatStack", 0)
    if SERVER then
        net.Start("MM_UpdateTreatStack")
            net.WriteInt(self:GetNWInt("MM_PlayerTreatStack"), 32)
        net.Send(self)
    end
end

function metaplayer:ActivateTrick()
    if (self:GetWeaponTable()["Trick"] == nil) then return end
    if (GAMEMODE.Tricks[self:GetWeaponTable()["Trick"]] == nil) then return end
    if (self:GetTreatStack() < GAMEMODE.Weapons["Trick"][self:GetWeaponTable()["Trick"]].cost) then return end
    if (self:Team() == TEAM_COOPOTHER) then return end
    self:ResetTreatStack()
    GAMEMODE.Tricks[self:GetWeaponTable()["Trick"]].active(self)
    self:IncrementPlayerStat("Tricks_Used")
    if (CLIENT) then
        surface.PlaySound("ui/spooky.wav")
    end
end

function metaplayer:IncrementPlayerStat(stat, amount)
    GAMEMODE:IncrementPlayerStat(self, stat, amount)
end

function metaplayer:ModifyPlayerStatIfBetter(stat, value)
    GAMEMODE:ModifyPlayerStatIfBetter(self, stat, value)
end

function metaplayer:CanBeDamagedBy(ply)
    if (ply == nil || !IsValid(ply)) then return true end
    if (self == ply) then return true end
    if (!ply:IsPlayer()) then return true end
    if (ply:Team() == TEAM_SPECT || ply:Team() == TEAM_COOPDEAD) then return false end
    if (self:Team() == TEAM_SPECT || self:Team() == TEAM_COOPDEAD) then return false end
    if (self:Team() == TEAM_COOPMONST && ply:Team() == TEAM_COOPMONST) then return false end
    if (self:Team() == TEAM_COOPOTHER && ply:Team() == TEAM_COOPOTHER) then return false end
    if (self:IsDodgeRolling()) then return false end
    if (self:HasStatusEffect(STATUS_SPAWNPROTECTED) || self:HasGodMode()) then return false end
    return true
end

function TauntCamera()
	local CAM = {}
	local WasOn					= false
	local CustomAngles			= Angle(0, 0, 0)
	local PlayerLockAngles		= nil
	local InLerp				= 0
	local OutLerp				= 1

	CAM.ShouldDrawLocalPlayer = function(self, ply, on)
		return on || OutLerp < 1
	end

	CAM.CalcView = function(self, view, ply, on)
        if (!ply:Alive() || !IsValid(ply:GetViewEntity()) || ply:GetViewEntity() != ply) then on = false end
        if (WasOn != on) then
            if (on) then InLerp = 0 end
            if (!on) then OutLerp = 0 end
            WasOn = on
        end

        if (!on && OutLerp >= 1) then
            CustomAngles = view.angles * 1
            PlayerLockAngles = nil
            InLerp = 0
            return
        end

        if (PlayerLockAngles == nil) then return end
        local TargetOrigin = view.origin - CustomAngles:Forward() * 100
        local tr = util.TraceHull({ start = view.origin, endpos = TargetOrigin, mask = MASK_SHOT, filter = player.GetAll(), mins = Vector(-8, -8, -8), maxs = Vector(8, 8, 8) })
        TargetOrigin = tr.HitPos + tr.HitNormal

        if (InLerp < 1) then
            InLerp = InLerp + FrameTime() * 5.0
            view.origin = LerpVector(InLerp, view.origin, TargetOrigin)
            view.angles = LerpAngle(InLerp, PlayerLockAngles, CustomAngles)
            return true
        end

        if (OutLerp < 1) then
            OutLerp = OutLerp + FrameTime() * 3.0
            view.origin = LerpVector(1-OutLerp, view.origin, TargetOrigin)
            view.angles = LerpAngle(1-OutLerp, PlayerLockAngles, CustomAngles)
            return true
        end

        view.angles = CustomAngles * 1
        view.origin = TargetOrigin
        return true
	end

	CAM.CreateMove = function(self, cmd, ply, on)
        if (!ply:Alive()) then on = false end
        if (!on) then return end

        if (PlayerLockAngles == nil) then
            PlayerLockAngles = CustomAngles * 1
        end

        CustomAngles.pitch	= CustomAngles.pitch	+ cmd:GetMouseY() * 0.01
        CustomAngles.yaw	= CustomAngles.yaw		- cmd:GetMouseX() * 0.01

        cmd:SetViewAngles(PlayerLockAngles)
        cmd:ClearButtons()
        cmd:ClearMovement()
        return true
	end

	return CAM
end

local PLAYER = {}
PLAYER.TauntCam = TauntCamera()

function PLAYER:ShouldDrawLocal() 
	if self.TauntCam:ShouldDrawLocalPlayer(self.Player, self.Player:HasStatusEffect(STATUS_TAUNT)) then return true end
end

function PLAYER:CreateMove(cmd)
	if self.TauntCam:CreateMove(cmd, self.Player, self.Player:HasStatusEffect(STATUS_TAUNT)) then return true end
end

function PLAYER:CalcView(view)
	if (self.TauntCam:CalcView(view, self.Player, self.Player:HasStatusEffect(STATUS_TAUNT))) then return true end
end

player_manager.RegisterClass("mm_player", PLAYER, "player_default")