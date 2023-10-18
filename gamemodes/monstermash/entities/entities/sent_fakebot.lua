AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.AdminSpawnable  = true

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------

function ENT:Initialize()

	self:SetModel( "models/monstermash/banshee_final.mdl" )
	
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	//self.loco:SetClimbAllowed(true)
	//self.loco:SetJumpGapsAllowed(true)
	
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have a enemy
----------------------------------------------------
function ENT:HaveEnemy()
	-- If our current enemy is valid
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		-- If the enemy is too far
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()		-- Return false if the search finds nothing
		end	
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new one
		return self:FindEnemy()
	end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k,v in ipairs( _ents ) do
		if ( v:IsPlayer() ) then
			-- We found one so lets set it as our enemy and return true
			self:SetEnemy(v)
			return true
		end
	end	
	-- We found nothing so we will set our enemy as nil (nothing) and return false
	self:SetEnemy(nil)
	return false
end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if ( self:HaveEnemy() ) then
			-- Now that we have an enemy, the code in this block will run
			self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
			//self:PlaySequenceAndWait( "plant" )		-- Lets make a pose to show we found a enemy
			//self:PlaySequenceAndWait( "hunter_angry" )-- Play an animation to show the enemy we are angry
			//self:PlaySequenceAndWait( "unplant" )	-- Get out of the pose
			self:StartActivity( ACT_HL2MP_RUN )			-- Set the animation
			self.loco:SetDesiredSpeed( 450 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
			self.loco:SetAcceleration(900)			-- We are going to run at the enemy quickly, so we want to accelerate really fast
			self:ChaseEnemy( ) 						-- The new function like MoveToPos.
			self.loco:SetAcceleration(400)			-- Set this back to its default since we are done chasing the enemy
			self:PlaySequenceAndWait( "charge_miss_slide" )	-- Lets play a fancy animation when we stop moving
			self:StartActivity( ACT_HL2MP_STAND_IDLE )			--We are done so go back to idle
			-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
			-- unless you put stuff after the if statement. Then that will be run before it loops
		else
			-- Since we can't find an enemy, lets wander
			-- Its the same code used in Garry's test bot
			self:StartActivity( ACT_HL2MP_WALK )			-- Walk anmimation
			self.loco:SetDesiredSpeed( 200 )		-- Walk speed
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units (yielding)
			self:StartActivity( ACT_HL2MP_IDLE )
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(2)
		
	end

end	

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is one.
----------------------------------------------------
function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() ) do
	
		if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, self:GetEnemy():GetPos())-- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end