AddCSLuaFile()

function DoTrick_Bats(self, dmginfo)

    // Emit bats
    local effectdata = EffectData()
    effectdata:SetOrigin( self:GetPos()+Vector(0,0,90) )
    util.Effect( "mm_batsexplosion", effectdata )
    
    // Create the damageinfo object
    local dmginfo = DamageInfo()
    dmginfo:SetAttacker(self)
    dmginfo:SetInflictor(self)
    dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_BATS))
    
    // Scare people around us
    for k, v in pairs(player.GetAll()) do
        if v != self && v:GetPos():Distance(self:GetPos()) < 256 then
            if (!v:IsDodgeRolling()) then
                v:SetStatusEffect(STATUS_BATS, dmginfo, 2.5)
            end
        end
    end
    
    // Teleport the player to a random spawn
    if (SERVER) then
        local spawns = ents.FindByClass("info_player_start")
        local random_entry = math.random(#spawns)
        self:SetPos(spawns[random_entry]:GetPos())
    end
end

function DoTrick_Invisible(self, dmginfo)
    self:SetStatusEffect(STATUS_INVISIBLE, nil, 10)
end

function DoTrick_Broom(self, dmginfo)
    self:SetStatusEffect(STATUS_BROOM, nil, 1.5)
end

hook.Add("PlayerTick", "MM_BroomTrick", function(ply, mv)
    if (ply:HasStatusEffect(STATUS_BROOM)) then
        if (ply:IsOnGround() && ply:GetStatusEffectTime(STATUS_BROOM) > 1.4) then
            mv:SetButtons(IN_JUMP)
        end
        ply:SetVelocity(Vector(0,0,600) + ply:GetAimVector()*2.5)
        ply:SetBodygroup(5, 1)
    elseif (ply:GetBodygroup(5) == 1) then
        ply:SetBodygroup(5, 0)
    end
end)

function DoTrick_Armor(self, dmginfo)
    if SERVER then
        self:SetBloodColor( BLOOD_COLOR_MECH )
        self:SetModel("models/monstermash/armor.mdl")
    end
end

function DoTrick_Skeletons(self, dmginfo)
    if SERVER then
        local num = 12
        for i=1, num do
            local skull = ents.Create("sent_mm_skellington")
            skull:SetPos(self:GetPos()+Vector(128*math.cos(((i-1)/num)*6.283185), 128*math.sin(((i-1)/num)*6.283185), 64))
            skull:Spawn()
            skull:Activate()
            skull.Master = self
        end
    end
end

hook.Add("PrePlayerDraw", "MM_InvisibleTrickPlayer", function(ply)
    if (ply:HasStatusEffect(STATUS_INVISIBLE)) then return true end
end)

function GM:PreDrawPlayerHands(hands, vm, ply, wep)
   if (ply:HasStatusEffect(STATUS_INVISIBLE)) then return true end
end

GM.Tricks = {}
GM.Tricks["broom"]         = { active = DoTrick_Broom }
GM.Tricks["kamikaze"]      = { active = DoTrick_Bats }
GM.Tricks["invisible"]     = { active = DoTrick_Invisible }
GM.Tricks["armor"]         = { active = DoTrick_Armor }
GM.Tricks["skeleton_army"] = { active = DoTrick_Skeletons }