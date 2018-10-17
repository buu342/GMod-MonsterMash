AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )


local PLAYER = {}

PLAYER.TauntCam 			= TauntCamera()
PLAYER.WalkSpeed 			= 220
PLAYER.RunSpeed				= 220
PLAYER.CanUseFlashlight		= false
PLAYER.DoingTaunt 			= false

function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )
	
	if ( self.TauntCam:CreateMove( cmd, self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )
	if ( self.TauntCam:CalcView( view, self.Player, (self.Player:IsPlayingTaunt() || self.Player:GetNWBool("DoingTauntCamera")) ) ) then return true end

	-- Your stuff here

end

player_manager.RegisterClass( "mm_player", PLAYER, "player_default" )


hook.Add("CalcMainActivity", "animations_deanimator", function(ply, velocity)

	if IsValid(ply:GetActiveWeapon()) && ply:GetNWFloat("MM_Deanimatorstun") > CurTime() then
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
        if ply:GetNWInt("LegMissing") != 3 then
            ply.CalcSeqOverride = ply:LookupSequence( "zombie_attack_frenzy" )
        end
		return ply.CalcIdeal, ply.CalcSeqOverride
	end

	/* if ply:GetNWBool("DoingTauntCamera") == true && ply:GetActiveWeapon().Base == "mm_melee_base" then
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
		ply.CalcSeqOverride = ply:LookupSequence( "seq_batonswing" )
		return ply.CalcIdeal, ply.CalcSeqOverride
	else*/ 
    if ply:GetNWFloat("DivingLeft") > CurTime() then
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
        ply.CalcSeqOverride = -1
        ply.CalcSeqOverride = ply:LookupSequence( "FlipLeft" )
        return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:GetNWFloat("DivingRight") > CurTime() then
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
        ply.CalcSeqOverride = -1
        ply.CalcSeqOverride = ply:LookupSequence( "FlipRight" )
        return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:GetNWBool("DoingTauntCamera") == true then
		if ply:GetModel() == "models/monstermash/scarecrow_final.mdl" then
			ply.CalcIdeal = ACT_MP_STAND_IDLE
			ply.CalcSeqOverride = -1
			ply.CalcSeqOverride = ply:LookupSequence( "ragdoll" )
			return ply.CalcIdeal, ply.CalcSeqOverride
		elseif ply:GetModel() == "models/monstermash/nosferatu_final.mdl" || ply:GetModel() == "models/monstermash/guest_final.mdl" then
			ply.CalcIdeal = ACT_MP_STAND_IDLE
			ply.CalcSeqOverride = -1
			ply.CalcSeqOverride = ply:LookupSequence( "menu_gman" )
			return ply.CalcIdeal, ply.CalcSeqOverride
		end
	end
end)