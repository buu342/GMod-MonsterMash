/* And Then A Skeleton Popped Out! */

hook.Add("DoPlayerDeath", "MM_SkeletonPoppedOutDeath", function(victim, attacker, dmginfo)
    if (GAMEMODE:GetWackyRound() == "And Then A Skeleton Popped Out!" && victim != attacker && IsValid(attacker)) then
        if (attacker:IsPlayer() && victim:HasKillFlag(KILL_GIB)) then
            local skel = ents.Create("sent_mm_jitterskull")
            skel:SetPos(victim:GetPos()+Vector(0, 0, 50))
            skel:SetAngles(victim:GetAngles())
            skel:Spawn()
            skel:Activate()
        else
            local skel = ents.Create("sent_mm_skellington")
            skel:SetPos(victim:GetPos()+Vector(0, 0, 50))
            skel:SetAngles(victim:GetAngles())
            skel:Spawn()
            skel:Activate()        
        end
    end
end)


/* Cycler */

local nextcycle = 0
hook.Add("Think", "MM_CyclerThink", function()
    if (GAMEMODE:GetWackyRound() == "Cycler") then
        if (nextcycle < CurTime()) then
            nextcycle = CurTime() + 10
            for l, w in pairs (player.GetAll()) do
                w:StripWeapons()
                w:Give("weapon_mm_candlestick")
                local extracost = 0
                local prefferedorder = {"Primary", "Handgun", "Melee", "Throwable"}
                for i=#prefferedorder, 1, -1 do
                    local k = prefferedorder[i]
                    local v, g = table.Random(GAMEMODE.Weapons[k])
                    if g != "None" && g != "Random" then
                        extracost = extracost + w:GiveWeapon(g, k, extracost)
                    end
                end
                w:ResetTreatStack()
                w:GiveRandomTrick()
            end
        end
    elseif (nextcycle != 0) then
        nextcycle = 0
    end
end)


/* Bullet Time */

local nextslow = 0
hook.Add("Think", "MM_SlowMoThink", function()
    if (GAMEMODE:GetWackyRound() == "Bullet Time" && GAMEMODE:GetRoundState() == GMSTATE_ROUND) then
        if (nextslow < CurTime()) then
            if (game.GetTimeScale() == 1) then
                net.Start("MM_PlayUISound", true)
                    net.WriteString("gameplay/slowmo_start.wav")
                net.Broadcast()
                nextslow = CurTime() + 3
                game.SetTimeScale(0.4)
            else
                net.Start("MM_PlayUISound", true)
                    net.WriteString("gameplay/slowmo_end.wav")
                net.Broadcast()
                nextslow = CurTime() + 10
                game.SetTimeScale(1)
            end
        end
    elseif (nextslow != 0) then
        nextslow = 0
    end
end)


/* Unstable */

local explodesound = {Sound("weapons/pumpkin/pumpkin_explode1.wav"), Sound("weapons/pumpkin/pumpkin_explode2.wav"), Sound("weapons/pumpkin/pumpkin_explode3.wav")}
hook.Add("DoPlayerDeath", "MM_UnstableDeath", function(victim, attacker, dmg)
    if (GAMEMODE:GetWackyRound() == "Unstable" && victim != attacker) then
        victim:SetKillFlag(KILL_GIB)
        
        local dmginfo = DamageInfo()
        dmginfo:SetDamage(175)
        if attacker != nil then
            dmginfo:SetAttacker(attacker)
        end
        if dmg:GetInflictor() != nil then
            dmginfo:SetInflictor(dmg:GetInflictor())
        end
        util.BlastDamageInfo(dmginfo, victim:GetPos(), 200)
        victim:EmitSound(table.Random(explodesound), 140)
        
        local effectdata4 = EffectData()
        effectdata4:SetStart(victim:GetPos()) 
        effectdata4:SetOrigin(victim:GetPos())
        effectdata4:SetScale(1)
        util.Effect("HelicopterMegaBomb", effectdata4)
        
        local effectdata4 = EffectData()
        effectdata4:SetStart(victim:GetPos()) 
        effectdata4:SetOrigin(victim:GetPos())
        effectdata4:SetScale(1)
        util.Effect("mm_pumpkin_explosion", effectdata4)
            
        local shake = ents.Create("env_shake")
        shake:SetOwner(victim)
        shake:SetPos(victim:GetPos())
        shake:SetKeyValue("amplitude", "2000")	// Power of the shake
        shake:SetKeyValue("radius", "500")		// Radius of the shake
        shake:SetKeyValue("duration", "2.5")	// Time of shake
        shake:SetKeyValue("frequency", "255")	// How hard should the screenshake be
        shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
        shake:Spawn()
        shake:Activate()
        shake:Fire("StartShake", "", 0)
        
        local startp = victim:GetPos()
        local traceinfo = {start = startp, endpos = startp - Vector(0,0,50), filter = victim, mask = MASK_SOLID_BRUSHONLY}
        local trace = util.TraceLine(traceinfo)
        local todecal1 = trace.HitPos + trace.HitNormal
        local todecal2 = trace.HitPos - trace.HitNormal
        util.Decal("Antlion.Splat", todecal1, todecal2)
    end
end)


/* Bone To Pick */

hook.Add("PlayerSpawn", "MM_PlayerSpawnBoneToPick", function(ply)
    if (GAMEMODE:GetWackyRound() == "Bone To Pick") then
        timer.Simple(0, function()
            if !IsValid(ply) then return end
            if (ply:Team() == TEAM_COOPOTHER) then
                ply:HandleCharacter("Skeleton", math.random(1, #GAMEMODE.Characters["Skeleton"].skins))
                ply:StripWeapons()
                ply:GiveWeapon("weapon_mm_boner", "Melee")
                ply:GiveWeapon("weapon_mm_skull", "Throwable")
                if (GAMEMODE:GetSuperPlayer() == ply) then
                    timer.Simple(0, function() 
                        if !IsValid(ply) then return end
                        ply:SetMaxHealth(150 + 25*(player.GetCount()-1))
                        ply:SetHealth(150 + 25*(player.GetCount()-1))
                    end)
                    ply:SetSkin(0)
                else
                    ply:SetSkin(3)
                end
            end
        end)
    end
end)


/* Witching Hour */

hook.Add("PlayerSpawn", "MM_PlayerSpawnWitchHour", function(ply)
    if (GAMEMODE:GetWackyRound() == "Witching Hour") then
        timer.Simple(0, function()
            if !IsValid(ply) then return end
            ply:HandleCharacter("Witch", math.random(1, #GAMEMODE.Characters["Witch"].skins))
        end)
    end
end)


/* Goblin Slayer */

hook.Add("PlayerSpawn", "MM_PlayerSpawnGoblinSlayer", function(ply)
    if (GAMEMODE:GetWackyRound() == "Goblin Slayer") then
        timer.Simple(0, function()
            if !IsValid(ply) then return end
            if (ply:Team() == TEAM_COOPOTHER) then
                ply:HandleCharacter("Kirito")
                ply:SetSuperClass(SUPERCLASS_MRBERSERK)
                ply:StripWeapons()
                ply:GiveWeapon("weapon_mm_stick", "Melee")
                if (GAMEMODE:GetSuperPlayer() == ply) then
                    timer.Simple(0, function() 
                        if !IsValid(ply) then return end
                        ply:SetMaxHealth(100 + 50*(player.GetCount()-1))
                        ply:SetHealth(100 + 50*(player.GetCount()-1))
                    end)
                end
            end
        end)
    end
end)


/* Spooky Scary Skeletons */

local NextSkelly = 0
local SkeletonCount = 0
hook.Add("Think", "MM_ThinkSpookyScarySkeletons", function(ply)
    if (GAMEMODE:GetWackyRound() == "Spooky Scary Skeletons") then
        if (GAMEMODE:GetRoundState() != GMSTATE_ROUND) then return end
        if (NextSkelly == 0) then
            NextSkelly = CurTime() + 5
            SkeletonCount = 1
        end
        if (NextSkelly < CurTime()) then
            if (#team.GetPlayers(TEAM_COOPMONST) > 4) then
                NextSkelly = CurTime() + 1.5
            else
                NextSkelly = CurTime() + 2
            end
            local spawn = table.Random(ents.FindByClass("info_player_start"))
            local skull
            if ((SkeletonCount%10) == 0) then
                skull = ents.Create("sent_mm_jitterskull")
            else
                skull = ents.Create("sent_mm_skellington")
            end
            skull:SetPos(spawn:GetPos() + Vector(0, 0, 60))
            skull:Spawn()
            skull:Activate()
            SkeletonCount = SkeletonCount + 1
        end
    elseif (NextSkelly != 0) then
        NextSkelly = 0
        SkeletonCount = 0
        if (#team.GetPlayers(TEAM_COOPMONST) > 0) then
            local entlist = ents.FindByClass("sent_mm_jitterskull")
            for i=1, #entlist do
                entlist[i]:TakeDamage(1337, nil, nil)
            end
            entlist = ents.FindByClass("sent_mm_skellington")
            for i=1, #entlist do
                entlist[i]:TakeDamage(1337, nil, nil)
            end
        end
    end
end)
