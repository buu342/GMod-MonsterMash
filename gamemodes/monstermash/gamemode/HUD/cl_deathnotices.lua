local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice" )
local Deaths = {}
local otherkiller = ""

local function RecvPlayerKilledByPlayer()

	local victim	= net.ReadEntity()
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()

    if ( !IsValid( attacker ) ) then return end
	if ( !IsValid( victim ) ) then return end
    local bleeded = false
    if victim:GetNWBool("DiedFromBleed") && IsValid(victim:GetNWEntity("MM_BleedOwner")) && attacker == victim:GetNWEntity("MM_BleedOwner") && IsValid(victim:GetNWEntity("MM_BleedInflictor")) && victim:GetNWEntity("MM_BleedInflictor"):GetClass() != nil && inflictor == victim:GetNWEntity("MM_BleedInflictor"):GetClass() then
        bleeded = true
    end
	GAMEMODE:AddDeathNotice2( attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team(), bleeded )

end
net.Receive( "PlayerKilledByPlayer", RecvPlayerKilledByPlayer )

local function RecvPlayerKilledSelf()

	local victim = net.ReadEntity()
	if ( !IsValid( victim ) ) then return end
    
    local attacker
    local attackerteam
    local inflictor
    if victim:GetNWEntity("MM_Assister") == NULL then
        attacker = nil
        attackerteam = 0
        inflictor = "suicide"
    else
        attacker = victim:GetNWEntity("MM_Assister"):Name()
        attackerteam = victim:GetNWEntity("MM_Assister"):Team()
        if !IsValid(victim:GetNWEntity("MM_AssisterInflictor")) || victim:GetNWEntity("MM_AssisterInflictor"):GetClass() == nil then return end
        inflictor = tostring(victim:GetNWEntity("MM_AssisterInflictor"):GetClass())
    end
    
	GAMEMODE:AddDeathNotice2( attacker, attackerteam, inflictor, victim:Name(), victim:Team(), false )

end
net.Receive( "PlayerKilledSelf", RecvPlayerKilledSelf )

local function RecvPlayerKilled()

	local victim	= net.ReadEntity()
	if ( !IsValid( victim ) ) then return end
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()
    GAMEMODE:AddDeathNotice2( attacker, -1, inflictor, victim:Name(), victim:Team(), false )
    

end
net.Receive( "PlayerKilled", RecvPlayerKilled )

local function RecvPlayerKilledNPC()

	local victimtype = net.ReadString()
	local victim	= "#" .. victimtype
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()

	--
	-- For some reason the killer isn't known to us, so don't proceed.
	--
	if ( !IsValid( attacker ) ) then return end
	
	if attacker:GetClass() == "entityflame" then
	GAMEMODE:AddDeathNotice2( "Fire", nil, inflictor, victim, -1, false )
	else
	GAMEMODE:AddDeathNotice2( attacker:Name(), attacker:Team(), inflictor, victim, -1, false )
	end
	
	local bIsLocalPlayer = ( IsValid(attacker) && attacker == LocalPlayer() )
	
	local bIsEnemy = IsEnemyEntityName( victimtype )
	local bIsFriend = IsFriendEntityName( victimtype )
	
	if ( bIsLocalPlayer && bIsEnemy ) then
		achievements.IncBaddies()
	end
	
	if ( bIsLocalPlayer && bIsFriend ) then
		achievements.IncGoodies()
	end
	
	if ( bIsLocalPlayer && ( !bIsFriend && !bIsEnemy ) ) then
		achievements.IncBystander()
	end

end
net.Receive( "PlayerKilledNPC", RecvPlayerKilledNPC )

local function RecvNPCKilledNPC()

	local victim	= "#" .. net.ReadString()
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()

	GAMEMODE:AddDeathNotice2( attacker, -1, inflictor, victim, -1, false )

end
net.Receive( "NPCKilledNPC", RecvNPCKilledNPC )

--[[---------------------------------------------------------
   Name: gamemode:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 )
   Desc: Adds an death notice entry
-----------------------------------------------------------]]
function GM:AddDeathNotice2( Attacker, team1, Inflictor, Victim, team2, WasBleed )

	local Death = {}
    
	Death.time		= CurTime()

	Death.left		= Attacker
	Death.right		= Victim
	Death.icon		= Inflictor
	if team1 == nil then
		Death.color1 = Color(194,120,194,255)
		Death.color2 = Color(194,120,194,255)
	else
		if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color )
		else Death.color1 = table.Copy( team.GetColor( team1 ) ) end
		
		if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color )
		else Death.color2 = table.Copy( team.GetColor( team2 ) ) end       
	end
	if Victim == "#sent_skellington" || Victim == "#sent_creeper" || Victim == "#sent_sjas" || Victim == "#sent_jitterskull" || Victim == "#sent_yurei" then
		Death.color2 = Color(194,120,194,255)
	end
	
	if (Death.left == Death.right) then
		Death.left = nil
		Death.icon = "suicide"
	end
    
    if WasBleed then
        Death.color2 = Color(255,0,0,255)
    end
	
	table.insert( Deaths, Death )

end

local function DrawDeath( x, y, death, hud_deathnotice_time )

	local w, h = killicon.GetSize( death.icon )
	if ( !w || !h ) then return end
	
	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()
	
	local alpha = math.Clamp( fadeout * 255, 0, 255 )

	death.color2.a = alpha
	
	-- Draw Icon
	//killicon.Draw( x, y, death.icon, alpha )
	
    if ( death.left ) then
    
        local otherkiller = tostring(death.left)
        local icon = tostring(death.icon)
        if string.find(string.lower(otherkiller), "world") then
        draw.SimpleText( death.right.." tried to fly without a broom.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
        if string.find(string.lower(death.right), "sent_skellington") then
			if string.find(string.lower(icon), "entityflame") then 
				draw.SimpleText( "A skellington burned to a crisp.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
			else
				draw.SimpleText( death.left.." fought off a skellington.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
			end
			return ( y + h * 0.70 )
        end
        
        if string.find(string.lower(death.right), "sent_creeper") then
            draw.SimpleText( death.left.." surprised the Creeper.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
            return ( y + h * 0.70 )
        end
		
        if string.find(string.lower(death.right), "sent_jitterskull") then
            draw.SimpleText( death.left.." destroyed the Jitterskull.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
            return ( y + h * 0.70 )
        end
        
        if string.find(string.lower(death.right), "sent_sjas") then
            draw.SimpleText( death.left.." was too fast for Sjas.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
            return ( y + h * 0.70 )
        end
        
        if string.find(string.lower(death.right), "sent_yurei") then
            draw.SimpleText( death.left.." was not scared of Yurei.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
            return ( y + h * 0.70 )
        end
        
		if string.find(string.lower(otherkiller), "worldspawn") then
        draw.SimpleText( death.right.." tried to fly without a broom.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_bleed") then
        draw.SimpleText( death.left.." bled to death.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_stick") then
            draw.SimpleText( death.left.." showed "..death.right.." the cool stick they found at the park, thanks mom for taking me it was really fun.", "ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_acidflask") then
        draw.SimpleText( death.left.." melted "..death.right,		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_urn") then
        draw.SimpleText( death.left.." scared "..death.right.." to death.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_headbutt") then
        draw.SimpleText( death.left.." gave "..death.right.." a killer headache.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_revolver") then
        draw.SimpleText( death.left.." asked "..death.right.." if they were feeling lucky.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_coachgun") then
        draw.SimpleText( death.left.." told "..death.right.." to shop smart; shop S-Mart.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "ent_sawblade") then
        draw.SimpleText( death.left.." trimmed a little off "..death.right.."'s top.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
        if string.find(string.lower(icon), "player") then
        draw.SimpleText( death.left.." sent "..death.right.." back to heck.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
		if string.find(string.lower(icon), "mm_colt") then
        draw.SimpleText( death.left.." asked "..death.right.." if they approve of their party favors.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_deanimator") then
        draw.SimpleText( death.left.." gave "..death.right.." a jolt from their electrode.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_musketpistol") then
        draw.SimpleText( death.left.." settled their dispute with "..death.right.." like a gentlemen.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_boner") then
        draw.SimpleText( death.left.." had a bone to pick with "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_knife") then
        draw.SimpleText( death.left.." made a jack o' lantern out of "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_scythe") then
        draw.SimpleText( death.left.." guided "..death.right.."'s soul to the next realm.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_battlerifle") then
        draw.SimpleText( death.left.." rifled through "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_repeater") then
        draw.SimpleText( death.left.." shot "..death.right.."'s eye out.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_pumpshotgun") then
        draw.SimpleText( death.left.." declared open season on "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_undertaker") then
        draw.SimpleText( death.left.." nailed "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_shield") then
        draw.SimpleText( death.left.." closed the lid on "..death.right.."'s coffin.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_axe") then
        draw.SimpleText( death.left.." had a question for "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_battleaxe") then
        draw.SimpleText( death.left.." introduced "..death.right.." to their wife.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
        
        if string.find(string.lower(icon), "mm_candlestick") then
        draw.SimpleText( death.left.." shed some light on "..death.right.."'s murder.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end

        if string.find(string.lower(icon), "mm_hacksaw") then
        draw.SimpleText( death.left.." hacked "..death.right.." to pieces.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
        if string.find(string.lower(icon), "mm_mace") then
        draw.SimpleText( death.left.."'s mace was introduced to "..death.right.."'s face.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
        if string.find(string.lower(icon), "mm_pitchfork") then
        draw.SimpleText( death.left.." chased "..death.right.." out of town.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
        if string.find(string.lower(icon), "mm_shovel") then
        draw.SimpleText( death.left.." dug "..death.right.."'s grave.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
        if string.find(string.lower(icon), "mm_sword") then
        draw.SimpleText( death.left.." revealed to "..death.right.." that they were not left-handed.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
        if string.find(string.lower(icon), "ent_pumpkin_nade") then
        draw.SimpleText( death.left.." played catch with "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
		
		if string.find(string.lower(icon), "ent_cannonball") then
        draw.SimpleText( death.left.." had a ball with "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end 
        
		if string.find(string.lower(icon), "mm_hook") then
        draw.SimpleText( death.left.." was "..death.right.."'s hooker.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_carbine") then
        draw.SimpleText( death.left.."'s carbine shattered "..death.right.."'s spine.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_sawedoff") then
        draw.SimpleText( death.left.." gave "..death.right.." both barrels.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_huntingrifle") then
        draw.SimpleText( death.left.." bagged "..death.right.." as a trophy.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "mm_cleaver") then
        draw.SimpleText( death.left.." showed "..death.right.." what real cleavage looks like.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "ent_skull") then
        draw.SimpleText( death.left.." recited Hamlet with "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "ent_arrow") then
        draw.SimpleText( death.left.." practiced their archery on "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
        end
		
		if string.find(string.lower(icon), "entityflame") then
		draw.SimpleText( death.right.." is now a candle.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
		
		if string.find(string.lower(icon), "sent_skellington") then
		draw.SimpleText( death.right.." got too spooked.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
		
        if string.find(string.lower(icon), "sent_jitterskull") then
		draw.SimpleText( death.right.." was eaten by the jitterskull.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
        
		if string.find(string.lower(icon), "mm_fencepost") then
		draw.SimpleText( death.left.." was on the fence with what to do about "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
		
		if string.find(string.lower(icon), "mm_flamethrower") then
		draw.SimpleText( death.left.." cremated "..death.right..".",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
		
		if string.find(string.lower(icon), "mm_stake") then
		draw.SimpleText( death.left.." gave "..death.right.." one hell of a splinter.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
        
        if string.find(string.lower(icon), "mm_spidernade") then
		draw.SimpleText( death.left.." exploited "..death.right.."'s arachnophobia.",		"ChatFont", x + ( w / 2 ) + 160, y, death.color2, TEXT_ALIGN_RIGHT )
		end
    else
    
        draw.SimpleText(death.right.." returned to their grave.",		"ChatFont", x + ( w / 2 ) + 160 , y, death.color2, TEXT_ALIGN_RIGHT )
        
    end
	
	
    return ( y + h * 0.70 )

end

function GM:DrawDeathNotice( x, y )

	if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end

	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()
	
	-- Draw
	for k, Death in pairs( Deaths ) do

		if ( Death.time + hud_deathnotice_time > CurTime() ) then
	
			if ( Death.lerp ) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
		
	end
	
	-- We want to maintain the order of the table so instead of removing
	-- expired entries one by one we will just clear the entire table
	-- once everything is expired.
	for k, Death in pairs( Deaths ) do
		if ( Death.time + hud_deathnotice_time > CurTime() ) then
			return
		end
	end
	
	Deaths = {}

end
