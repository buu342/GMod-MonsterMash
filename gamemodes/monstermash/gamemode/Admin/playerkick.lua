hook.Add("PlayerSay", "SkeletonKick", function(sender, text, teamchat)
    
    local split = string.Split(text, " ")
    if split[1] == nil then return end
    if teamchat then return end
    
    if split[1] == "!kick" then
        if table.HasValue(admins, sender:SteamID()) then
            if split[2] == nil then return end
            for k, v in pairs(player.GetAll()) do
                if string.find(v:Name(), split[2]) then
                    if split[3] == nil then
                        v:SetNWBool("KickPlayer", true)
                        v:SetNWBool("KickPlayerStuff", true)
                        v:SetNWString("KickPlayerReason", "No reason specified.")
                        sender:ChatPrint("Kicking "..v:Name())
                        return ""
                    else
                        local reason = string.Replace(text, split[1].." "..split[2].." ", "")
                        v:SetNWBool("KickPlayer", true)
                        v:SetNWBool("KickPlayerStuff", true)
                        v:SetNWString("KickPlayerReason", reason)
                        sender:ChatPrint("Kicking "..v:Name())
                        return ""
                    end
                end
            end
            sender:ChatPrint("Player not found")
            return ""
        else
            return "Hey everyone I just tried to do something really silly!"
        end        
    end
    
    if split[1] == "!ban" then
        if table.HasValue(admins, sender:SteamID()) then
            if split[2] == nil then return end
            for k, v in pairs(player.GetAll()) do
                if string.find(v:Name(), split[2]) then
                    if split[3] == nil || !(tonumber(split[3]) >= 0) then
                        sender:ChatPrint("You must specify ban time in minutes (or 0 for perm)")
                        return ""
                    else
                        v:SetNWBool("BanPlayer", true)
                        v:SetNWBool("BanPlayerStuff", true)
                        v:SetNWInt("BanPlayerTime", tonumber(split[3]))
                        if split[3] == 0 then
                            sender:ChatPrint("Banning "..v:Name().."permanantly.")
                        else
                            sender:ChatPrint("Banning "..v:Name().." for "..split[3].." minutes.")
                        end
                        return ""
                    end
                end
            end
            sender:ChatPrint("Player not found")
            return ""
        else
            return "Hey everyone I just tried to do something really silly!"
        end        
    end
    
end)

hook.Add("Think", "SkeletonKickThink", function()
    for k, v in pairs(player.GetAll()) do
        if (v:GetNWBool("KickPlayer") == true || v:GetNWBool("BanPlayer") == true) && v:OnGround() then
            //v:Freeze(true)
            v:SetNoDraw(true)
            if SERVER then
                v:GodEnable(true)
                v:StripWeapons()
                v:SetVelocity( -v:GetVelocity() )
                if v:GetNWBool("KickPlayerStuff") == true || v:GetNWBool("BanPlayerStuff") == true then
                    v:SetNWBool("KickPlayerStuff", false)
                    v:SetNWBool("BanPlayerStuff", false)
                    local ent = ents.Create("sent_hellkick")
                    ent:SetPos(v:GetPos())
                    ent:SetAngles(v:GetAngles())
                    ent:Spawn()
                    ent:Activate()
                    ent:SetNWString("Model", v:GetModel())
                    if v:GetNWBool("KickPlayer") == true then
                        ent:SetNWBool("KickPlayer", v:GetNWBool("KickPlayer"))
                        ent:SetNWEntity("KickPlayerEntity", v)
                        ent:SetNWString("KickPlayerReason", v:GetNWString("KickPlayerReason"))
                    else
                        ent:SetNWBool("BanPlayer", v:GetNWBool("BanPlayer"))
                        ent:SetNWEntity("BanPlayerEntity", v)
                        ent:SetNWInt("BanPlayerTime", v:GetNWInt("BanPlayerTime"))
                    end
                    ent:SetNWInt("KickPlayerSkin", v:GetSkin())
                    ent:SetNWString("KickPlayerMat", v:GetMaterial())
                    ent:SetNWInt("KickPlayerBG1", v:GetBodygroup(1))
                    ent:SetNWInt("KickPlayerBG2", v:GetBodygroup(2))
                    ent:SetNWInt("KickPlayerBG3", v:GetBodygroup(3))
                    ent:SetNWInt("KickPlayerBG4", v:GetBodygroup(4))
                end
            end
        end
    end
end)

hook.Add( "CalcView", "SkeletonKickCalcView", function( ply, pos, angles, fov )
    if (ply:GetNWBool("KickPlayer") == true || ply:GetNWBool("BanPlayer") == true) && ply:GetNoDraw() then
        local view = {}

        view.origin = pos-( angles:Forward()*100 )
        view.angles = angles
        view.fov = fov
        view.drawviewer = true

        return view
    end
end)

hook.Add( "Move", "SkeletonKickMove", function( ply, mv )
    if (ply:GetNWBool("KickPlayer") == true || ply:GetNWBool("BanPlayer") == true) && ply:GetNoDraw() then
        return true
    end
end)

//if sender:SteamID() ==  || sender:SteamID() ==  || sender:SteamID() ==   then
    
//else
