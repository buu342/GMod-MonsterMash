util.AddNetworkString("MM_CreateScreenBlood")

hook.Add("EntityTakeDamage","ScreenBloodMirrorHurtHook", function(victim, dmginfo)
    if dmginfo:GetAttacker():IsPlayer() && victim:IsPlayer() && victim:GetCharacter().bloodtype == BLOODTYPE_NORMAL && victim:GetPos():Distance(dmginfo:GetAttacker():GetPos()) < 125 then
        net.Start("MM_CreateScreenBlood", true)
        net.Send(dmginfo:GetAttacker())
    end
end)