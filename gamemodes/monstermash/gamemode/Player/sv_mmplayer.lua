AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )


local PLAYER = {}

PLAYER.TauntCam 			= TauntCamera()
PLAYER.WalkSpeed 			= 220
PLAYER.RunSpeed				= 220
PLAYER.CanUseFlashlight		= false
PLAYER.DoingTaunt 			= false

PLAYER.Character = nil

function PLAYER:ShouldDrawLocal() 
    
    if (self:HasStatusEffect(STATUS_TAUNT)) then
        if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end
    end
    
end

function PLAYER:CreateMove( cmd )
	
    if (self:HasStatusEffect(STATUS_TAUNT)) then
        if ( self.TauntCam:CreateMove( cmd, self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end
    end

end

function PLAYER:CalcView( view )

    if (self:HasStatusEffect(STATUS_TAUNT)) then
        if ( self.TauntCam:CalcView( view, self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end
    end

	-- Your stuff here
end

player_manager.RegisterClass( "mm_player", PLAYER, "player_default" )


/*
function metaplayer:CreateRagdoll()
end
*/