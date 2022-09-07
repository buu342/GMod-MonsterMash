net.Receive("MM_DoPlayerFlinch", function(len)
	local gest = net.ReadInt(32)
	local ply = net.ReadEntity()
	ply:AnimRestartGesture(GESTURE_SLOT_FLINCH, gest, true)
end)

net.Receive("MM_PlaySoundClient", function(len)
    surface.PlaySound(net.ReadString())
end)