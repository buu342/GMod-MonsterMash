util.AddNetworkString( "DoPlayerFlinch" )

hook.Add( "ScalePlayerDamage", "FlinchPlayersOnHit", function(ply, grp)
	if ply:IsPlayer() then
		local group = nil
		local hitpos = {
				[HITGROUP_HEAD] = ACT_FLINCH_HEAD,
				[HITGROUP_CHEST] = ACT_FLINCH_CHEST,
				[HITGROUP_STOMACH] = ACT_FLINCH_STOMACH,
				[HITGROUP_LEFTARM] = ACT_FLINCH_LEFTARM,
				[HITGROUP_RIGHTARM] = ACT_FLINCH_RIGHTARM,
				[HITGROUP_LEFTLEG] = ACT_FLINCH_LEFTLEG,
				[HITGROUP_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
			}
		
		if hitpos[grp] == nil then
			group = ACT_FLINCH_PHYSICS
		else
			group = hitpos[grp]
		end
		
		net.Start( "DoPlayerFlinch" )
			net.WriteInt( group, 32 )
			net.WriteEntity( ply )
		net.Broadcast()
		
	end

end )