GM.Name 	= "Monster Mash"
GM.Author 	= "People"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

team.SetUp( 1, "Monsters", Color( 255, 140, 0, 255 ) )
team.SetUp( 2, "Spectators", Color( 0, 0, 0, 255 ) )
team.SetUp( 3, "COOP-Monsters", Color( 0, 255, 0, 255 ) )
team.SetUp( 4, "COOP-Other", Color( 194,120,194, 255 ) )
team.SetUp( 5, "COOP-Dead", Color( 0, 0, 0, 255 ) )

include( 'player_class/mm_player.lua' )
include( 'Menu/weapon_descriptions.lua' )
include( 'Spawning/spookyspawn.lua' )
include( 'globals.lua' )

CreateConVar( "mm_budget", "100", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_kill_limit", "500", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_aimsize", "20", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_aimrange", "1000", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_aimspeed", "3", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_tasermanmode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_ludicrousgibs", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_wackyfrequency", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_healthregentime", "2", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)
CreateConVar( "mm_medals", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_UNREGISTERED)

function GM:Initialize()

	self.BaseClass.Initialize( self )
    ImplementWeapons()
    SetGlobalVariable("ForceGame_Over", false)
    SetGlobalVariable("Game_Over", false)
    SetGlobalVariable("Winner", "")
    SetGlobalVariable("WackyRound_Extra", 0)
    SetGlobalVariable("RoundsToWacky", GetConVar("mm_wackyfrequency"):GetInt())
    SetGlobalVariable("WackyRound_COOP", false)
    SetGlobalVariable("WackyRound_COOPOther", nil)
    SetGlobalVariable("WackyRound_Event", -1)
    SetGlobalVariable("RoundStartTimer", 0)

end

hook.Add("KeyPress", "DoubleJump", function(pl, k)
	if pl:GetNWString("Buff") == "double_jump" then
		if not pl or not pl:IsValid() or k~=2 then
			return
		end
			
		if not pl.Jumps or pl:IsOnGround() then
			pl.Jumps=0
		end
		
		if pl.Jumps==1 then return end
		
		pl.Jumps = pl.Jumps + 1
		if pl.Jumps==1 then
			local ang = pl:GetAngles()
			local forward, right = ang:Forward(), ang:Right()
			
			local vel = -1 * pl:GetVelocity() -- Nullify current velocity
			vel = vel + Vector(0, 0, 400) -- Add vertical force
			
			local spd = pl:GetMaxSpeed()
			
			if pl:KeyDown(IN_FORWARD) then
				vel = vel + forward * spd
			elseif pl:KeyDown(IN_BACK) then
				vel = vel - forward * spd
			end
			
			if pl:KeyDown(IN_MOVERIGHT) then
				vel = vel + right * spd
			elseif pl:KeyDown(IN_MOVELEFT) then
				vel = vel - right * spd
			end
			
			pl:SetVelocity(vel)
		end
	end
end)

net.Receive( "DoLeftDive", function( len, ply )
    local v = net.ReadEntity()
    v:AnimRestartMainSequence()
    v:SetCycle(0.17)
    v:Freeze(true)
    v:SetNWFloat("DiveCooldown", CurTime()+5)
    v:SetNWFloat("DivingLeft", CurTime()+0.5)
end )

net.Receive( "DoRightDive", function( len, ply )
    local v = net.ReadEntity()
    v:AnimRestartMainSequence()
    v:SetCycle(0)
    v:Freeze(true)
    v:SetNWFloat("DiveCooldown", CurTime()+5)
    v:SetNWFloat("DivingRight", CurTime()+0.5)
end )

function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

    if ply:GetNWFloat("DivingLeft") > CurTime() then
        ply:SetPlaybackRate( 1 )
    else
        ply:SetPlaybackRate( rate )
    end

	if ( ply:InVehicle() ) then

		local Vehicle = ply:GetVehicle()

		-- We only need to do this clientside..
		if ( CLIENT ) then
			--
			-- This is used for the 'rollercoaster' arms
			--
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )
			local dp2 = fwd:Dot( Velocity )

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 && dp || 0 ) + dp2 * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then steer = 0 ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( "vehicle_steer", steer )

		end

	end

	if ( CLIENT ) then
		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

concommand.Add( "mm_rebuildweapons", function( ply )
    if table.HasValue(admins, ply:SteamID()) && SERVER then
        ImplementWeapons()
        net.Start( "RebuildWeapons" )
        net.Broadcast()
    end
end )

net.Receive( "RebuildWeapons", function(len, pl)
    ImplementWeapons()
end )

net.Receive("ResetLimbs", function(len, ply)
    LocalPlayer():SetNWInt("LegMissing", 0)
	LocalPlayer():SetNWInt("ArmMissing", 0)
end)