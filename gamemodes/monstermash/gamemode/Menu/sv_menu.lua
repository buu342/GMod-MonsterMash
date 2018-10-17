function ModelMenu( ply )
    umsg.Start( "mm_menu", ply )
    umsg.End()
end
hook.Add("ShowHelp", "MyHook", ModelMenu)

function ModelMenu2( ply )
    umsg.Start( "mm_menu2", ply )
    umsg.End()
end
hook.Add("ShowTeam", "MyHook", ModelMenu2)