hook.Add("ShowHelp", "MM_Menu", function(ply)
    umsg.Start("mm_menu", ply)
    umsg.End()
end)

hook.Add("ShowTeam", "MM_MenuCharacter", function(ply)
    umsg.Start("mm_character", ply)
    umsg.End()
end)

hook.Add("ShowSpare1", "MM_MenuLoadout", function(ply)
    umsg.Start("mm_loadout", ply)
    umsg.End()
end)

hook.Add("ShowSpare2", "MM_MenuOptions", function(ply)
    umsg.Start("mm_options", ply)
    umsg.End()
end)