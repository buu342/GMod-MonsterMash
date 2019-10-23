/*-----------------------------------------------------
				   Setup on spawn
------------------------------------------------------*/

hook.Add("PlayerSpawn","SpookyPlayerSpawning", function(ply)
	if gmod.GetGamemode().Name == "Monster Mash" && ply:Team() == 1 then
		ply:SetNWFloat("DoSpawnAnim",CurTime()+1.5)
		ply:SetNWVector("DoSpawnPos",ply:GetPos())
		local ent = ents.Create("sent_spawndirt")
		ent:SetPos(ply:GetPos())	
		ent:SetAngles(ply:GetAngles()+Angle(0,180,0))
		ent:Spawn()
        ent:SetNWString("PlayerModel", ply:GetModel())
		ent:SetModel(ply:GetModel())
		ent:SetSkin(ply:GetSkin())
		ent:SetOwner(ply)
        ent.Owner = ply
	end
end)


/*-----------------------------------------------------
			Dirt effect and hiding the player
------------------------------------------------------*/

hook.Add("Think","SpookyPlayerSpawningAnimation", function()
    if gmod.GetGamemode().Name == "Monster Mash" then
        for k, v in pairs( player.GetAll() ) do 
            if v:GetNWFloat("DoSpawnAnim") > CurTime() then
                local effectdata = EffectData()
                effectdata:SetOrigin( v:GetNWVector("DoSpawnPos") )
                util.Effect( "dirtgib", effectdata )
                v:SetNoDraw(true)
                v:SetJumpPower(0)
                v:SetCrouchedWalkSpeed( 0 )
            elseif v:GetNWFloat("DoSpawnAnim") != 0 then
                v:SetNoDraw(false)
                v:SetNWFloat("DoSpawnAnim",0)
                v:SetJumpPower(200)
                v:SetCrouchedWalkSpeed( 0.25 )
            end
        end
    end
end)
if SERVER then return end


/*-----------------------------------------------------
					Force Crouching
------------------------------------------------------*/

hook.Add("CreateMove","SpookyPlayerSpawningCrouching",function(cmd)
    if gmod.GetGamemode().Name == "Monster Mash" then
        if LocalPlayer():GetNWFloat("DoSpawnAnim") > CurTime() then
            cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
        end
    end
end)

/*-----------------------------------------------------
				    Move the view
------------------------------------------------------*/

hook.Add( "CalcView", "MyCalcView", function( ply, pos, angles, fov )
    if gmod.GetGamemode().Name == "Monster Mash" then
        if ply:GetNWFloat("DoSpawnAnim") > CurTime() then
            local view = {}
            view.origin = pos-Vector(0,0,(30*(((ply:GetNWFloat("DoSpawnAnim")-CurTime())/1.5))))
            view.angles = angles
            view.fov = fov
            return view
        end
        if ply:GetNWFloat("DivingRight") > CurTime() && GetConVar("mm_rollrotatescreen"):GetInt() == 1 then
            local view = {}
            local time = (ply:GetNWFloat("DivingRight")-CurTime())
            local down
            if time > 0.4 then
                down = (1-((time-0.4)/0.1))*40
            elseif time < 0.1 then
                down = (time/0.1)*40
            else
                down = 40
            end
            view.origin = pos+Vector(0,0,-down)
            view.angles = angles+Angle(0,0,-((ply:GetNWFloat("DivingRight")-CurTime())/0.5)*360)
            view.fov = fov
            return view
        end
        if ply:GetNWFloat("DivingLeft") > CurTime() && GetConVar("mm_rollrotatescreen"):GetInt() == 1 then
            local view = {}
            local time = (ply:GetNWFloat("DivingLeft")-CurTime())
            local down
            if time > 0.4 then
                down = (1-((time-0.4)/0.1))*40
            elseif time < 0.1 then
                down = (time/0.1)*40
            else
                down = 40
            end
            view.origin = pos+Vector(0,0,-down)
            view.angles = angles+Angle(0,0,((ply:GetNWFloat("DivingLeft")-CurTime())/0.5)*360)
            view.fov = fov
            return view
        end        
        if ply:GetNWFloat("MM_Hallucinate") > CurTime() then
            local view = {}
            local totalang = 120
            view.origin = pos+Vector(0,0,0)
            view.angles = angles+Angle(0,0,totalang/2-math.abs(math.sin(-CurTime()/4)*totalang))
            view.fov = fov
            return view
        end
    end
end)


/*-----------------------------------------------------
				   Move the viewmodel
------------------------------------------------------*/

hook.Add( "CalcViewModelView", "MyCalcViewModelViewGrave", function( wep, vm, oldpos, oldang, pos, ang )
    if gmod.GetGamemode().Name == "Monster Mash" then
        if wep:GetOwner():GetNWFloat("DoSpawnAnim") > CurTime() then
            pos = oldpos-( ang:Up()*(30*(((wep:GetOwner():GetNWFloat("DoSpawnAnim")-CurTime())/1.5))))
            return pos
        end
        if wep:GetOwner():GetNWFloat("DivingRight") > CurTime() then
            local time = (wep:GetOwner():GetNWFloat("DivingRight")-CurTime())
            local down
            if time > 0.4 then
                down = (1-((time-0.4)/0.1))*40
            elseif time < 0.1 then
                down = (time/0.1)*40
            else
                down = 40
            end
            pos = oldpos+Vector(0,0,-down)
            ang = oldang+Angle(0,0,-(time/0.5)*360)
            return pos, ang
        end
        if wep:GetOwner():GetNWFloat("DivingLeft") > CurTime() then
            local time = (wep:GetOwner():GetNWFloat("DivingLeft")-CurTime())
            local down
            if time > 0.4 then
                down = (1-((time-0.4)/0.1))*40
            elseif time < 0.1 then
                down = (time/0.1)*40
            else
                down = 40
            end
            pos = oldpos+Vector(0,0,-down)
            ang = oldang+Angle(0,0,(time/0.5)*360)
            return pos, ang
        end
    end
end)

/*
local Mat = Material("models/weapons/monstermash/flamethrower/flamethrower_hot") 
function HotFlameThrower() 
	cam.Start3D( EyePos(), EyeAngles(), 68.5 ) 
    cam.IgnoreZ( true )
        for k, v in pairs( ents.GetAll() ) do 
            if IsValid(v) && v:GetClass() == "viewmodel" && v:GetClass() != "gmod_hands" then
                render.SetBlend( 0 ) 
                render.MaterialOverride( Mat )
                v:DrawModel()
                render.MaterialOverride( 0 ) 
                render.SetBlend( 1 ) 
            end
        end 
    cam.IgnoreZ( false )
	cam.End3D() 
end 
hook.Add("RenderScreenspaceEffects","HotFlameThrower",HotFlameThrower)