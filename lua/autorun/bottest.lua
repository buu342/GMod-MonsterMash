function drawThePath( path, time )
	local prevArea
	for _, area in pairs( path ) do
		debugoverlay.Sphere( area:GetCenter(), 8, time or 9, color_white, true  )
		if ( prevArea ) then
			debugoverlay.Line( area:GetCenter(), prevArea:GetCenter(), time or 9, color_white, true )
		end

		area:Draw()
		prevArea = area
	end
end

function Astar( start, goal )
	if ( !IsValid( start ) || !IsValid( goal ) ) then return false end
	if ( start == goal ) then return true end

	start:ClearSearchLists()

	start:AddToOpenList()

	local cameFrom = {}

	start:SetCostSoFar( 0 )

	start:SetTotalCost( heuristic_cost_estimate( start, goal ) )
	start:UpdateOnOpenList()

	while ( !start:IsOpenListEmpty() ) do
		local current = start:PopOpenList() // Remove the area with lowest cost in the open list and return it
		if ( current == goal ) then
			return reconstruct_path( cameFrom, current )
		end

		current:AddToClosedList()

		for k, neighbor in pairs( current:GetAdjacentAreas() ) do
			local newCostSoFar = current:GetCostSoFar() + heuristic_cost_estimate( current, neighbor )

			if ( neighbor:IsUnderwater() ) then // Add your own area filters or whatever here
				continue
			end
			
			if ( ( neighbor:IsOpen() || neighbor:IsClosed() ) && neighbor:GetCostSoFar() <= newCostSoFar ) then
				continue
			else
				neighbor:SetCostSoFar( newCostSoFar );
				neighbor:SetTotalCost( newCostSoFar + heuristic_cost_estimate( neighbor, goal ) )

				if ( neighbor:IsClosed() ) then
				
					neighbor:RemoveFromClosedList()
				end

				if ( neighbor:IsOpen() ) then
					// This area is already on the open list, update its position in the list to keep costs sorted
					neighbor:UpdateOnOpenList()
				else
					neighbor:AddToOpenList()
				end

				cameFrom[ neighbor:GetID() ] = current:GetID()
			end
		end
	end

	return false
end

function heuristic_cost_estimate( start, goal )
	// Perhaps play with some calculations on which corner is closest/farthest or whatever
	return start:GetCenter():Distance( goal:GetCenter() )
end

// using CNavAreas as table keys doesn't work, we use IDs
function reconstruct_path( cameFrom, current )
	local total_path = { current }

	current = current:GetID()
	while ( cameFrom[ current ] ) do
		current = cameFrom[ current ]
		table.insert( total_path, navmesh.GetNavAreaByID( current ) )
	end
	return total_path
end

function AstarVector( start, goal )
	local startArea = navmesh.GetNearestNavArea( start )
	local goalArea = navmesh.GetNearestNavArea( goal )
	return Astar( startArea, goalArea )
end

local rePathDelay = 1 // How many seconds need to pass before we need to remake the path to keep it updated
hook.Add( "StartCommand", "astar_example", function( ply, cmd )

	// Only run this code on bots, and only if bot_mimic is set to 0
	if ( !ply:IsBot() ) then return end

	cmd:ClearButtons()
	cmd:ClearMovement()

	local currentArea = navmesh.GetNearestNavArea( ply:GetPos() )

	// internal variable to regenerate the path every X seconds to keep the pace with the target player
	ply.lastRePath = ply.lastRePath or 0

	// internal variable to limit how often the path can be (re)generated
	ply.lastRePath2 = ply.lastRePath2 or 0 

	if ( ply.path && ply.lastRePath + rePathDelay < CurTime() && currentArea != ply.targetArea ) then
		ply.path = nil
		ply.lastRePath = CurTime()
	end

	if ( !ply.path && ply.lastRePath2 + rePathDelay < CurTime() ) then

		local targetPos = Entity( 1 ):GetPos() // target position to go to, the first player on the server
		local targetArea = navmesh.GetNearestNavArea( targetPos )

		ply.targetArea = nil
		ply.path = Astar( currentArea, targetArea )
		if ( !istable( ply.path ) ) then // We are in the same area as the target, or we can't navigate to the target
			ply.path = nil // Clear the path, bail and try again next time
			ply.lastRePath2 = CurTime()
			return
		end
		//PrintTable( ply.path )

		// TODO: Add inbetween points on area intersections
		// TODO: On last area, move towards the target position, not center of the last area
		table.remove( ply.path ) // Just for this example, remove the starting area, we are already in it!
	end

	// We have no path, or its empty (we arrived at the goal), try to get a new path.
	if ( !ply.path || #ply.path < 1 ) then
		ply.path = nil
		ply.targetArea = nil
		return
	end

	// We got a path to follow to our target!
	drawThePath( ply.path, .1 ) // Draw the path for debugging

	// Select the next area we want to go into
	if ( !IsValid( ply.targetArea ) ) then
		ply.targetArea = ply.path[ #ply.path ]
	end

	// The area we selected is invalid or we are already there, remove it, bail and wait for next cycle
	if ( !IsValid( ply.targetArea ) || ( ply.targetArea == currentArea && ply.targetArea:GetCenter():Distance( ply:GetPos() ) < 64 ) ) then
		table.remove( ply.path ) // Removes last element
		ply.targetArea = nil
		return
	end

	// We got the target to go to, aim there and MOVE
	local targetang = ( ply.targetArea:GetCenter() - ply:GetPos() ):GetNormalized():Angle()
	cmd:SetViewAngles( targetang )
	cmd:SetForwardMove( 1000 )

	local nextspotheight = currentArea:ComputeAdjacentConnectionHeightChange(ply.targetArea)
	//print(nextspotheight)
	if (ply.JumpCooldown == nil || ply.JumpCooldown < CurTime()) then
		ply.JumpCrouch = false
		if (nextspotheight > 30) then
			cmd:SetButtons(bit.bor(IN_JUMP, IN_DUCK))
			ply.JumpCrouch = true
			ply.JumpCooldown = CurTime() + 0.5
		elseif (nextspotheight > 18) then
			cmd:SetButtons(IN_JUMP)
			ply.JumpCooldown = CurTime() + 0.5
		end
	end
	if (ply.JumpCrouch && !ply:IsOnGround()) then
		cmd:SetButtons(IN_DUCK)
	end

end )