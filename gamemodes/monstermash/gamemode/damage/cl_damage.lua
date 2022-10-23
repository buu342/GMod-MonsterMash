net.Receive("MM_DoPlayerFlinch", function(len)
	local gest = net.ReadInt(32)
	local ply = net.ReadEntity()
    if (ply != nil && IsValid(ply) && ply:IsPlayer()) then
        ply:AnimRestartGesture(GESTURE_SLOT_FLINCH, gest or ACT_FLINCH_HEAD, true)
    end
end)

net.Receive("MM_PlaySoundClient", function(len)
    surface.PlaySound(net.ReadString())
end)