net.Receive( "DoPlayerFlinch", function(len)

	local gest = net.ReadInt(32)
	local ply = net.ReadEntity()
	ply:AnimRestartGesture( GESTURE_SLOT_FLINCH, gest, true )

end )