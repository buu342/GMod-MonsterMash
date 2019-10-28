function BuffsThink()
	for k, v in pairs( ents.FindByClass("player") ) do
        if v:GetNWString("buff") == "kamikaze" then
            local vPoint = v:GetPos()+Vector(0,0,90)
            local effectdata = EffectData()
            effectdata:SetOrigin( vPoint )
            util.Effect( "boo", effectdata )
            
            for j, l in pairs(player.GetAll()) do
                if l:GetPos():Distance(v:GetPos()) < 256 then
                    if l != v && !l:HasGodMode() && l:Alive() && l:GetNWFloat("DivingRight") < CurTime() && l:GetNWFloat("DivingLeft") < CurTime() then
                        l:ConCommand("play gameplay/bats.wav")
                        l:SetNWFloat("MM_BleedTime", CurTime() + 1)
                        l:SetNWInt("MM_BleedDamage", 7)
                        l:SetNWEntity("MM_BleedOwner", v)
                        l:SetNWEntity("MM_BleedInflictor", v)
                        l:SetNWFloat("Spooked", CurTime()+2.5)
                        l:SetNWFloat("Spooked_Bats", CurTime()+2.5)
                        l:SetNWFloat("MM_Assister", v)
                        l:SetNWEntity("MM_AssisterInflictor", v)
                        timer.Simple(2.5, function() if !IsValid(v) then return end l:SetNWEntity("MM_Assister", NULL) l:SetNWString("MM_AssisterInflictor", "suicide") end)
                    end
                end
            end
            
            v:SetNWString("buff", "")
        end
        
        if v:GetNWString("buff") == "skeleton_army" then
            local num = 12
            for i=1, num do
                local skull = ents.Create("sent_skellington")
                skull:SetPos(v:GetPos()+Vector(128*math.cos(((i-1)/num)*6.283185), 128*math.sin(((i-1)/num)*6.283185), 64))
                skull:Spawn()
                skull:Activate()
                skull.Master = v
            end
            v:SetNWString("buff", "")
        end
        
        if v:GetNWString("buff") == "invisible" then
            v:SetRenderMode(RENDERMODE_TRANSALPHA)
            v:SetColor(Color(255, 255, 255, 10))
            v:SetNWBool("MM_UsingInvisibility", true)
            v:SetNWString("buff", "")
        end
        if v:GetNWBool("MM_UsingInvisibility") && v:GetNWFloat("DiveCooldown") > 0 then
            v:SetNWFloat("DiveCooldown", v:GetNWFloat("DiveCooldown")-0.025)
            if v:GetNWFloat("DiveCooldown") <= 0 then
                v:SetNWBool("MM_UsingInvisibility", false)
                v:SetRenderMode(RENDERMODE_TRANSALPHA)
                v:SetColor(Color(255, 255, 255, 255))
            end
        end
        
        if v:GetNWString("buff") == "broom" then
            if v:GetNWFloat("DiveCooldown") >= 5 then
                v:SetVelocity(Vector(0,0,200) + Vector(0,0,-1*v:GetVelocity().z) + v:GetAimVector()*2.5)
                v:ConCommand("+jump")
                timer.Simple(0.1, function() v:ConCommand("-jump") end)
                v:SetNWBool("MM_UsingBroom", true)
                v:SetNWString("buff", "")
            end
        end
        
        if v:GetNWBool("MM_UsingBroom") && v:GetNWFloat("DiveCooldown") > 0 then
            v:SetVelocity(Vector(0,0,200) + Vector(0,0,-1*v:GetVelocity().z) + v:GetAimVector()*2.5)
            v:SetNWFloat("DiveCooldown", v:GetNWFloat("DiveCooldown")-0.08)
            v:SetBodygroup(5, 1)
            if v:GetNWFloat("DiveCooldown") <= 0 then
                v:SetNWBool("MM_UsingBroom", false)
            end
        else
            v:SetBodygroup(5, 0)
        end
    end
end
hook.Add("Think", "BuffsThink", BuffsThink)

function doublejump(ply, key)
end
hook.Add("KeyPress", "doublejump", doublejump)