local BloodTex = {
    surface.GetTextureID("screendecals/shot1"),
    surface.GetTextureID("screendecals/shot2"),
    surface.GetTextureID("screendecals/shot3"),
    surface.GetTextureID("screendecals/shot4"),
    surface.GetTextureID("screendecals/shot5"),
    surface.GetTextureID("screendecals/shot6"),
}

local BloodEnt = {}

net.Receive("MM_CreateScreenBlood", function(len, ply)
    if !GetConVar("mm_screenblood"):GetBool() then return end
    local blood = {
        alpha = 255,
        tex = table.Random(BloodTex),
        size = math.random(320,375),
        rotation = math.random(0,360),
        x = math.random(ScrW()*0.2,ScrW()*0.8),
        y = math.random(ScrH()*0.2,ScrH()*0.9),
    }
    table.insert(BloodEnt, blood)
end)

hook.Add("HUDPaint","MM_ScreenBlood", function()
    for i = #BloodEnt, 1, -1 do
        if BloodEnt[i].alpha > 0 then
            BloodEnt[i].alpha = BloodEnt[i].alpha - RealFrameTime()*60
        end
        surface.SetDrawColor(255, 0, 0, math.Clamp(BloodEnt[i].alpha, 0, 255))
        surface.SetTexture(BloodEnt[i].tex)
        surface.DrawTexturedRectRotated(BloodEnt[i].x, BloodEnt[i].y, BloodEnt[i].size, BloodEnt[i].size, BloodEnt[i].rotation)
        if (BloodEnt[i].alpha <= 0) then
            table.remove(BloodEnt, i)
        end
    end
end)