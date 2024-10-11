AddCSLuaFile()

function DoTrick_Bats(self, dmginfo)

    // Emit bats
    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos()+Vector(0,0,90))
    util.Effect("mm_batsexplosion", effectdata)
    
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
    if self:HasStatusEffect(STATUS_INVISIBLE) then return end
    self:SetStatusEffect(STATUS_INVISIBLE, nil, 15)
end

function DoTrick_Broom(self, dmginfo)
    if self:HasStatusEffect(STATUS_BROOM) then return end
    self:SetStatusEffect(STATUS_BROOM, nil, 1.5)
end

function DoTrick_Sight(self, dmginfo)
    if self:HasStatusEffect(STATUS_SIGHT) then return end
    self:SetStatusEffect(STATUS_SIGHT, nil, 30)
end

function DoTrick_Fury(self, dmginfo)
    self:RemoveStatusEffect(STATUS_MISSINGLLEG)
    self:RemoveStatusEffect(STATUS_MISSINGRLEG)
    self:RemoveStatusEffect(STATUS_MISSINGLARM)
    self:RemoveStatusEffect(STATUS_MISSINGRARM)
    self:SetBodygroup(GIBGROUP_ARMS, GIBGROUP_ARMS_BOTH)
    self:SetBodygroup(GIBGROUP_LEGS, GIBGROUP_LEGS_BOTH)
    self:EmitSound("weapons/flamethrower/fireball.mp3")
    self:SetHealth(self:GetMaxHealth())
    self:SetStatusEffect(STATUS_TAUNT, nil, self:SequenceDuration(self:LookupSequence("taunt_mm_zombie"))-0.25)
    self:SetStatusEffect(STATUS_FURY, nil, self:SequenceDuration(self:LookupSequence("taunt_mm_zombie"))-0.25)
        
    if SERVER then
        self:GodEnable()
        timer.Simple(self:SequenceDuration(self:LookupSequence("taunt_mm_zombie"))-0.25, function() if IsValid(self) then self:GodDisable() end end)
        local ent = ents.Create("sent_mm_burstbarrier")
        if (!IsValid(ent)) then return end
        ent.Force = 1
        ent.Owner = self
        ent.Inflictor = self
        ent.Dir = self:GetAimVector()
        ent:SetPos(self:EyePos() + (self:GetAimVector() * 64))
        ent:SetAngles(self:EyeAngles())
        ent:Spawn()
        
        local phys = ent:GetPhysicsObject()
        if IsValid(phys)then 
            local velocity = self:GetAimVector()
            velocity = velocity*ent.Force
            phys:ApplyForceCenter(velocity)
        else
            ent:Remove()
        end
    end
end

function DoTrick_Werewolf(self, dmginfo)
    if self:IsSuper() then return end
    if SERVER then
        local originalmax = self:GetMaxHealth()
        self:SetModel("models/monstermash/werewolf.mdl")
        self:SetMaxHealth(100 + (75*(player.GetCount()-1)))
        self:SetHealth(self:GetMaxHealth()*(self:Health()/originalmax))
        self:StripWeapons()
        self:Give("weapon_mm_wolfclaws")
        self:SetCycle(0)
        self:SetStatusEffect(STATUS_TAUNT, nil, self:SequenceDuration(self:LookupSequence("taunt_mm_werewolf_howl"))-0.25)
        self:SetSuperClass(SUPERCLASS_WOLF)
        self:RemoveStatusEffect(STATUS_MISSINGLLEG)
        self:RemoveStatusEffect(STATUS_MISSINGRLEG)
        self:RemoveStatusEffect(STATUS_MISSINGLARM)
        self:RemoveStatusEffect(STATUS_MISSINGRARM)
        self:EmitSound("gameplay/round_end.wav")
    end
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
    if self:GetBloodColor() == BLOOD_COLOR_MECH then return end
    if SERVER then
        self:SetBloodColor(BLOOD_COLOR_MECH)
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
    if (ply:HasStatusEffect(STATUS_INVISIBLE)) then
        ply.wasinvis = true
        ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
        ply:SetColor(Color(255, 255, 255, math.max(0, 100*(ply:GetLastAttackTime()+1-CurTime()))))
        if (ply:GetLastAttackTime()+1 < CurTime()) then
            ply:SetRenderMode(RENDERMODE_NORMAL)
            ply:SetColor(Color(255, 255, 255, 255))
            return true
        end
    else
        if (ply.wasinvis) then
            ply:SetRenderMode(RENDERMODE_NORMAL)
            ply:SetColor(Color(255, 255, 255, 255))
        end
    end
end)

function GM:PreDrawPlayerHands(hands, vm, ply, wep)
   if (ply:HasStatusEffect(STATUS_INVISIBLE)) then return true end
end

local color_purple = Color(163, 73, 164)
hook.Add("PreDrawHalos", "MM_SightBuffWallhacks", function()
    if (LocalPlayer():HasStatusEffect(STATUS_SIGHT)) then
        local ply = {}
        for k, v in ipairs(player.GetAll()) do
            if (v:Team() != TEAM_SPECT && v != LocalPlayer()) then
                if (v:Team() == TEAM_MONST || v:Team() != LocalPlayer():Team()) then
                    table.insert(ply, v)
                end
            end
        end
        halo.Add(ply, color_purple, 3, 3, 5, true, true)
    end
end)

local color_red = Color(255, 0, 0)
hook.Add("PreDrawHalos", "MM_WolfSenses", function()
    if (LocalPlayer():GetSuperClass() == SUPERCLASS_WOLF) then
        local ply = {}
        for k, v in ipairs(player.GetAll()) do
            if (v:Team() != TEAM_SPECT && v != LocalPlayer()) then
                if (v:Team() == TEAM_MONST || v:Team() != LocalPlayer():Team()) then
                    table.insert(ply, v)
                end
            end
        end
        halo.Add(ply, color_red, 3, 3, 5, true, false)
    end
end)


GM.Tricks = {}
GM.Tricks["broom"]         = { active = DoTrick_Broom }
GM.Tricks["kamikaze"]      = { active = DoTrick_Bats }
GM.Tricks["invisible"]     = { active = DoTrick_Invisible }
GM.Tricks["armor"]         = { active = DoTrick_Armor }
GM.Tricks["skeleton_army"] = { active = DoTrick_Skeletons }
GM.Tricks["sight"]         = { active = DoTrick_Sight }
GM.Tricks["fury"]          = { active = DoTrick_Fury }
GM.Tricks["werewolf"]      = { active = DoTrick_Werewolf }