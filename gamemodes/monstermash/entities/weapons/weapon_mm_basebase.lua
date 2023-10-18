AddCSLuaFile()

SWEP.PrintName = "Base base"

SWEP.SelectIcon = Material("vgui/entities/mm_boner")
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/c_pistol.mdl" 
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFlip = false
SWEP.KillFeed = "%a killed %v somehow..."

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
 
SWEP.UseHands = false

SWEP.Base = "weapon_base"

SWEP.HoldType = "pistol" 
SWEP.HoldTypeProne    = ""

SWEP.Primary.Sound = Sound("sound/pewpew.wav") 
SWEP.Primary.Damage = 1000
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 30 
SWEP.Primary.Ammo = "None"
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 5
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.02
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


/*------------------------------------------------
                Monster Mash Settings
------------------------------------------------*/

SWEP.SwayScale	 = 0
SWEP.BobScale	 = 0
SWEP.MMSwayScale = 60
SWEP.CrouchPos = Vector(-1,-1,.5)
SWEP.CrouchAng = Vector(0, 0, 0)

SWEP.SelectIcon = Material("vgui/entities/mm_colt")
SWEP.Cost = 25
SWEP.Points = 40

SWEP.KillFlags = 0

SWEP.BleedChance     = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.CrosshairMaterial         = Material("")
SWEP.CrosshairSize             = 0
SWEP.CrosshairXDisplacement    = 0
SWEP.CrosshairYDisplacement    = 0
SWEP.CrosshairChargeMaterial   = Material("")
SWEP.CrosshairChargeSize       = 0
SWEP.CrosshairRechargeMaterial = Material("")
SWEP.CrosshairRechargeSize     = 0
SWEP.CrosshairOverchargeMaterial = Material("")
SWEP.CrosshairOverchargeSize     = 0
SWEP.CrosshairChargeType         = CHARGETYPE_BAR
SWEP.CrosshairChargeColor        = Color(255,0,0, 100)
SWEP.CrosshairRechargeType       = CHARGETYPE_SHRINK
SWEP.CrosshairRechargeColor      = Color(255,255,255, 100)
SWEP.CrosshairOverchargeType     = CHARGETYPE_BAR
SWEP.CrosshairOverchargeColor    = Color(255, 255, 0, 100)
SWEP.OverChargeDecrease = 1

SWEP.RunSpeed     = 220
SWEP.ShootSpeed   = 220
SWEP.ReloadSpeed  = 220
SWEP.GoreJarSpeed = 120
SWEP.NoLegsSpeed  = 85
SWEP.NoSpeed      = 1
SWEP.ChargeSpeed  = 400

SWEP.Primary.UseRange   = false
SWEP.Primary.Range      = nil
SWEP.Secondary.UseRange = false
SWEP.Secondary.Range    = nil

SWEP.EquipSound = Sound("weapons/melee_draw.wav")
SWEP.IdleSound = nil

SWEP.ChargeEffect = ""
SWEP.MuzzleEffect = "mm_muzzle"
SWEP.EjectEffect = "ShellEject"
SWEP.FlameThrower = false
SWEP.JustShot = false

SWEP.IsMMGun = true
SWEP.Ownership = nil
SWEP.SpawnTime = 0

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 10, "MMBase_OverChargeAmount")
    self:NetworkVar("Int", 11, "MMBase_BurstCount")
    self:NetworkVar("Float", 10, "MMBase_Charge")
    self:NetworkVar("Float", 11, "MMBase_ReloadTimer")
    self:NetworkVar("Float", 12, "MMBase_ShootTimer")
    self:NetworkVar("Float", 13, "MMBase_RandSeed")
    self:NetworkVar("Float", 14, "MMBase_Windup")
    self:NetworkVar("Float", 15, "MMBase_LoopSoundRepeat")
    self:NetworkVar("Bool", 10, "MMBase_Deploying")
end

function SWEP:Initialize()
    self.Primary.DefaultClip = self.Primary.ClipSize
    self:SetClip1(self.Primary.DefaultClip)
    self:SetMMBase_RandSeed(CurTime())
    self:SetWeaponHoldType(self.HoldType)
    self:SetMMBase_Charge(0)
    self.SpawnTime = CurTime()
end 

function SWEP:Deploy()
    self:SetMMBase_ShootTimer(CurTime() + 1)
    self:SetMMBase_Deploying(true)
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:EmitSound(self.EquipSound)
    if self.IdleSound != nil then
        self:EmitSound(self.IdleSound, 75, 100, 1, CHAN_VOICE2)
    end
    self.Ownership = self.Owner
    return true
end

function SWEP:Holster(wep)
    if self.IdleSound != nil then
        self:EmitSound("empty.wav", 75, 100, 1, CHAN_VOICE2)
    end
    self.Owner.PrevWeapon = self
    return true
end

function SWEP:Think()

    self:HandleExtraPunch()

    self:HandleTimers()
    
    self:HandleMovementSpeed()
    
    self:HandleHoldTypes()
    
    self:HandlePlayerHull()
    
    self:HandleDodgeRollStuff()
    
    self:HandleTaunts()

end

// Random numbers are a big nono in multiplayer, so we need something deterministic
function SWEP:RandomRange(val1, val2)
    self:SetMMBase_RandSeed((self:GetMMBase_RandSeed()*CurTime())%147483648)
    local div = 147483648 / (val2-val1)
    local ans = val1 + (self:GetMMBase_RandSeed() / div)
    return ans
end

function SWEP:HandleExtraPunch()
end

function SWEP:HandleTimers()
    if self:GetMMBase_ShootTimer() != 0 && self:GetMMBase_ShootTimer() < CurTime() then
        self:SetMMBase_ShootTimer(0)
        self:SetMMBase_Deploying(false)
    end
    
    if self:GetMMBase_ReloadTimer() != 0 && self:GetMMBase_ReloadTimer() < CurTime() then
        self:SetMMBase_ReloadTimer(0)
        self.Owner:GetViewModel():SetPlaybackRate(1)
    end    
    
    if self:GetMMBase_LoopSoundRepeat() != 0 && self:GetMMBase_LoopSoundRepeat() < CurTime() then
        self:SetMMBase_LoopSoundRepeat(0)
        if self.IdleSound != nil then
            self:EmitSound(self.IdleSound, 75, 100, 1, CHAN_VOICE2)
        end
    end
    
    if self:GetMMBase_OverChargeAmount() > 0 then
        if self:GetMMBase_OverChargeAmount() >= 100 then
            self:ExplodePlayer()
        end
        self:SetMMBase_OverChargeAmount(self:GetMMBase_OverChargeAmount()-self.OverChargeDecrease)
        if self:GetMMBase_OverChargeAmount() < 0 then
            self:SetMMBase_OverChargeAmount(0)
        end
    end
end

function SWEP:HandleMovementSpeed()
    if !IsValid(self.Owner) || !self.Owner:Alive() then return end
    local speed = 220
    
    // Spooked speed
    if self.Owner:HasStatusEffect(STATUS_SPOOKED) || self.Owner:HasStatusEffect(STATUS_BATS) || self.Owner:HasStatusEffect(STATUS_ELECTROCUTED) || self.Owner:HasStatusEffect(STATUS_SELFELECTROCUTED) || self.Owner:IsDodgeRolling() then
        if !self.Owner:IsFrozen() then
            self.Owner:Freeze(true)
        end
    elseif GAMEMODE:GetRoundState() != GMSTATE_BUYTIME then
        if self.Owner:IsFrozen() then
            self.Owner:Freeze(false)
        end
    end
    
    // Spiderweb speed
    if self.Owner:HasStatusEffect(STATUS_SPIDERWEBBED) then
        speed = math.min(speed, self.NoSpeed)
    end
    
    // Missing a leg speed
    if self.Owner:MissingALeg() && !self.Owner:MissingBothLegs() then
        speed = math.min(speed, self.NoSpeed)
    end
    
    // Gorejar speed
    if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
        speed = math.min(speed, self.GoreJarSpeed)
    end
    
    // Reloading speed
    //if self:GetMMBase_ReloadTimer() != 0 then
    //    if (self.Owner:MissingBothLegs() || self.Owner:MissingALeg()) then
    //        speed = math.min(speed, self.NoSpeed)
    //    else
    //        speed = math.min(speed, self.ReloadSpeed)
    //    end
    //end
    
    // Shooting speed
    if (self:GetMMBase_ShootTimer() != 0 && !self:GetMMBase_Deploying()) || self:GetMMBase_Windup() != 0 || self:GetMMBase_BurstCount() != 0 then
        if (self.Owner:MissingBothLegs()) then
            speed = math.min(speed, self.NoSpeed)
        else
            speed = math.min(speed, self.ShootSpeed)
        end
    end
    
    // Taunt speed
    if self.Owner:HasStatusEffect(STATUS_TAUNT) then
        speed = math.min(speed, 1)
    end
    
    // Normal movement speed
    if (self.Owner:MissingBothLegs()) then
        speed = math.min(speed, self.NoLegsSpeed)
    else
        local multiplier = 1
        if (self.Base == "weapon_mm_basemelee") then
            local tr = self.Owner:GetEyeTrace()
            if (IsValid(tr.Entity) && tr.Entity:IsPlayer()) then
                if (tr.HitPos:Distance(tr.StartPos) < 150) then
                    multiplier = 1+math.max(0, self:GetMMBase_MeleeSwing()-CurTime())*3
                end
                if (self:Backstab()) then
                    multiplier = 1.2
                end
            end
        end
        speed = math.min(speed, self.RunSpeed)*multiplier
    end
    
    // Melee charging
    if self.Owner:IsMeleeCharging() && self.Owner:GetActiveWeapon().Base == "weapon_mm_basemelee" then
        speed = self.ChargeSpeed
    end
    
    // Set the speed
    self:SetMovementSpeed(speed)
    
    // Handle hopping
    self:HandleHop()
end

function SWEP:SetMovementSpeed(speed)
    if self.Owner:GetRunSpeed() != speed then
        self.Owner:SetRunSpeed(speed)
        self.Owner:SetWalkSpeed(speed)
    end
end

local CMoveData = FindMetaTable("CMoveData")
function CMoveData:RemoveKeys(keys)
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band(self:GetButtons(), bit.bnot(keys))
	self:SetButtons(newbuttons)
end

hook.Add("SetupMove", "MM_DisableStuffIfNoLegs", function(ply, mvd, cmd)
    if gmod.GetGamemode().Name != "Monster Mash" then return end
	if ply:MissingBothLegs() then
		if mvd:KeyDown(IN_JUMP) then
			mvd:RemoveKeys(IN_JUMP)
		end
		if mvd:KeyDown(IN_DUCK) then
			mvd:RemoveKeys(IN_DUCK)
		end
	end
    
    if ply:MissingALeg() && !ply:MissingBothLegs() then
        if ply:GetNWFloat("MM_NextHop") >= CurTime() then
            if mvd:KeyDown(IN_JUMP) then
                mvd:RemoveKeys(IN_JUMP)
            end
        end
    end
end)

function SWEP:HandleHop()
    if !IsValid(self.Owner) || !self.Owner:Alive() then return end
    if !self.Owner:MissingALeg() || self.Owner:MissingBothLegs() then return end
    if self:GetMMBase_ReloadTimer() != 0 then return end
    if !self.Owner:IsOnGround() then return end
    
    local power_jump = 150
    local power_forward = 200
    
    if self.Owner:GetNWFloat("MM_NextHop") == 0 then
        self.Owner:SetNWFloat("MM_NextHop", CurTime() + 0.35)
    end
    
    if self.Owner:GetNWFloat("MM_NextHop") < CurTime() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT)) then
        self.Owner:SetGroundEntity(NULL)
        self.Owner:SetNWFloat("MM_NextHop",0)
        
        // Bleed on the floor
        if (self.Owner:GetCharacter().bloodtype == BLOODTYPE_NORMAL) then
            local vPoint
            
            if self.Owner:MissingLeftLeg() then
                vPoint = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Thigh"))
            elseif self.Owner:MissingRightLeg() then
                vPoint = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Thigh"))
            end
            
            local effectdata = EffectData()
            effectdata:SetOrigin(vPoint)
            util.Effect("BloodImpact", effectdata)
        
            local start = self.Owner:GetPos()
            local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
            util.Decal("Blood", btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal, self.Owner)
        end
        
        local vec = Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0):GetNormalized()
        local ang = Angle(0,0,0)
        if self.Owner:KeyDown(IN_FORWARD) && !(self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT) || self.Owner:KeyDown(IN_BACK)) then
            vec = vec
        elseif self.Owner:KeyDown(IN_BACK) && !(self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT) || self.Owner:KeyDown(IN_FORWARD)) then
            vec = -vec
        elseif self.Owner:KeyDown(IN_MOVELEFT) && !(self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVERIGHT)) then
            ang = Angle(0,-90,0)
            vec = -vec
        elseif self.Owner:KeyDown(IN_MOVERIGHT) && !(self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT)) then
            ang = Angle(0,90,0)
            vec = -vec
        elseif self.Owner:KeyDown(IN_FORWARD) && self.Owner:KeyDown(IN_MOVERIGHT) then
            ang = Angle(0,-45,0)
        elseif self.Owner:KeyDown(IN_FORWARD) && self.Owner:KeyDown(IN_MOVELEFT) then
            ang = Angle(0,45,0)
        elseif self.Owner:KeyDown(IN_BACK) && self.Owner:KeyDown(IN_MOVERIGHT) then
            ang = Angle(0,45,0)
            vec = -vec
        elseif self.Owner:KeyDown(IN_BACK) && self.Owner:KeyDown(IN_MOVELEFT) then
            ang = Angle(0,-45,0)
            vec = -vec
        end
        vec:Rotate(ang)
        self.Owner:SetVelocity(-self.Owner:GetVelocity() + vec*power_forward + Vector(0,0,1)*power_jump)
    end
end

function SWEP:HandleHoldTypes()
    if self.Owner:MissingBothArms() && self:GetClass() != "weapon_mm_headbutt" then
        if SERVER then
            local owner = self.Owner
            owner:DropWeapon(self)
            owner:StripWeapons()
            owner:Give("weapon_mm_headbutt")
        end
    elseif self.Owner:MissingLeftArm() then
        self.Owner:GetHands():SetBodygroup(1,1)
    elseif self.Owner:MissingRightArm() then
        self:SetHoldType("duel")
        self.ViewModelFlip = true
        self.Owner:GetHands():SetBodygroup(1,1)
    else
        if self.Owner:MissingBothLegs() && self.HoldTypeProne != "" then
            self:SetHoldType(self.HoldTypeProne)
        else
            self:SetHoldType(self.HoldType)
        end
        self.ViewModelFlip = false
        self.Owner:GetHands():SetBodygroup(1,0)
    end
end

function SWEP:HandlePlayerHull()
    if !IsValid(self.Owner) then return end
    if self.Owner:MissingBothLegs() then
        self.Owner:SetViewOffset(Vector(0,0,20))
        self.Owner:SetViewOffsetDucked(Vector(0,0,20))
        
        local bottom, top = self.Owner:GetHull()
        local bottom2, top2 = self.Owner:GetHullDuck()
        self.Owner:SetHull(bottom, Vector(16,16,25))
        self.Owner:SetHullDuck(bottom2, Vector(16,16,25))
    else
        if (self.Owner:GetSuperClass() == SUPERCLASS_WOLF) then
            self.Owner:SetViewOffset(Vector(0, 0, 80))
        else
            self.Owner:SetViewOffset(Vector(0, 0, 64))
        end
        self.Owner:SetViewOffsetDucked(Vector(0,0,28))
        
        local bottom, top = self.Owner:GetHull()
        local bottom2, top2 = self.Owner:GetHullDuck()
        self.Owner:SetHull(bottom, Vector(16,16,72))
        self.Owner:SetHullDuck(bottom2, Vector(16,16,36))
    end
end

function SWEP:HandleDodgeRollStuff()
    local ply = self.Owner
    if !IsValid(ply) || !ply:Alive() then return end
    if !ply:CanUseAbility() then return end
    if ply:GetWalkSpeed() <= 1 then return end
    if ply:MissingBothLegs() then return end
    if !ply:IsOnGround() || ply:HasStatusEffect(STATUS_BROOM) then return end
    if (ply:IsSuper()) then return end
    if ply:KeyDown(IN_MOVELEFT) && ply:KeyDown(IN_SPEED) then
        ply:DodgeRoll("Left")
    elseif ply:KeyDown(IN_MOVERIGHT) && ply:KeyDown(IN_SPEED) then
        ply:DodgeRoll("Right")
    end
end

function SWEP:RemoveSpawnProtection()
    if self.Owner:HasStatusEffect(STATUS_SPAWNPROTECTED) then 
        self.Owner:RemoveStatusEffect(STATUS_SPAWNPROTECTED) 
        if SERVER then 
            self.Owner:GodDisable() 
        end 
    end
end

if SERVER then
    util.AddNetworkString("ServerDoingTauntCamera")
    util.AddNetworkString("ServerDoingTrick")
end
net.Receive("ServerDoingTauntCamera", function(len, ply)
	ply:SetCycle(0)
    if (GetConVar("mm_wackytaunts"):GetInt() == 1) then
        ply:SetStatusEffect(STATUS_TAUNT, nil, 6.25)
        ply:EmitSound("gameplay/cancer.mp3")
    else
        ply:SetStatusEffect(STATUS_TAUNT, nil, ply:SequenceDuration(ply:LookupSequence(ply:GetCharacter().taunt[1]))-0.25)
    end
end)
net.Receive("ServerDoingTrick", function(len, ply)
	ply:ActivateTrick()
end)

function SWEP:HandleTaunts()
    if SERVER then return end
    if input.IsKeyDown(KEY_Z) && !LocalPlayer():HasStatusEffect(STATUS_TAUNT) && !LocalPlayer():IsSuper() then
        LocalPlayer():SetCycle(0)
        if GetConVar("mm_wackytaunts"):GetInt() == 1 then
            LocalPlayer():SetStatusEffect(STATUS_TAUNT, nil, 6.25)
        else
            LocalPlayer():SetStatusEffect(STATUS_TAUNT, nil, LocalPlayer():SequenceDuration(LocalPlayer():LookupSequence(LocalPlayer():GetCharacter().taunt[1]))-0.25)
        end
        net.Start("ServerDoingTauntCamera")
        net.SendToServer()
    end
    
    if (input.IsKeyDown(KEY_C) && LocalPlayer():GetWeaponTable()["Trick"] != "None") then
        LocalPlayer():ActivateTrick()
        net.Start("ServerDoingTrick")
        net.SendToServer()
    end
end

function SWEP:ExplodePlayer()
    self.Owner:EmitSound("weapons/cannon/explosion1.wav",140)
    self.Owner:SetKillFlag(KILL_GIB)
    if SERVER then
        util.BlastDamage(self.Owner, self.Owner, self.Owner:GetPos()+Vector(0,0,70), 200, 140)
        if self.Owner:IsValid() then
            self.Owner:Ignite(7) 
        end
    end
    
    if IsValid(self.Owner) then
        local dir = -self.Owner:GetAimVector()-Vector(0,0,self.Owner:GetAimVector().z)
        dir:Normalize()
        self.Owner:SetVelocity(dir*250)
    end
    local effectdata5 = EffectData()
    effectdata5:SetOrigin(self:GetPos())
    util.Effect("Fireball_Explosion", effectdata5) 
        
    local effectdata3 = EffectData()
    effectdata3:SetOrigin(self:GetPos())
    effectdata3:SetScale(1)
    util.Effect("ManhackSparks", effectdata3)
        
    local effectdata4 = EffectData()
    effectdata4:SetStart(self:GetPos()) 
    effectdata4:SetOrigin(self:GetPos())
    effectdata4:SetScale(1)
    util.Effect("HelicopterMegaBomb", effectdata4)
    if SERVER then
        self:Remove()
        return
    end
end

if CLIENT then
    local lastshoottime = 0
    function SWEP:DrawWorldModel()
        if (self.Owner != nil && IsValid(self.Owner) && self.Owner:HasStatusEffect(STATUS_TAUNT)) then return end
        if self:GetClass() == "weapon_mm_hook" && IsValid(self.Owner) && self.Owner:IsCharacter("Deer Haunter") then return end
        local _Owner = self:GetOwner()
        self.WorldMdl = ClientsideModel(self.WorldModel)
        if (IsValid(self.Owner)) then
            -- Specify a good position
            local offsetVec = Vector(0,0,0)
            local offsetAng = Angle(0, 0, 0)
            
            local boneid = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end
            
            if self.Owner:MissingRightArm() then
                self.WorldMdl:SetModel(string.sub(self.WorldModel, 1, string.len(self.WorldModel)-4).."_left.mdl")
            end

            self.WorldMdl:SetPos(self:GetPos())
            self.WorldMdl:SetAngles(self:GetAngles())
            self.WorldMdl:SetParent(self.Owner)
            self.WorldMdl:AddEffects(EF_BONEMERGE)
        else
            self.WorldMdl:SetPos(self:GetPos())
            self.WorldMdl:SetAngles(self:GetAngles())
        end

        if (self.Owner:IsPlayer() && self.Owner:HasStatusEffect(STATUS_INVISIBLE)) then
            self.WorldMdl:SetRenderMode(RENDERMODE_TRANSCOLOR)
            self.WorldMdl:SetColor(Color(255, 255, 255, math.max(0, 100*(self.Owner:GetLastAttackTime()+1-CurTime()))))
        else
            self.WorldMdl:SetRenderMode(RENDERMODE_NORMAL)
            self.WorldMdl:SetColor(Color(255, 255, 255, 255))
        end
        self.WorldMdl:DrawModel()
        
        if IsValid(self.Owner) then
            if self.FlameThrower && self:GetMMFlame_FlameState() == 1 && self:GetMMBase_ReloadTimer() == 0 then
                local effectdata4 = EffectData()
                effectdata4:SetStart(self.WorldMdl:GetAttachment("1").Pos) 
                effectdata4:SetOrigin(self.WorldMdl:GetAttachment("1").Pos)
                effectdata4:SetAngles(self.WorldMdl:GetAttachment("1").Ang )
                effectdata4:SetScale(1)
                util.Effect("mm_flamethrower_flame", effectdata4)
            end
            
            if self.Owner:GetLastAttackTime() > lastshoottime && self.Base == "weapon_mm_basegun" then
                if self.MuzzleEffect != "" then
                    local fx = EffectData();
                    fx:SetOrigin(self.Owner:GetShootPos());
                    fx:SetEntity(self);
                    fx:SetStart(self.Owner:GetShootPos());
                    fx:SetNormal(self.Owner:GetAimVector());
                    fx:SetAttachment(1);
                    util.Effect(self.MuzzleEffect, fx);
                end
                if self.EjectEffect != "" then
                    local fx = EffectData();
                    fx:SetOrigin(self.Owner:GetShootPos());
                    fx:SetEntity(self);
                    fx:SetStart(self.Owner:GetShootPos());
                    fx:SetNormal(self.Owner:GetAimVector());
                    fx:SetAttachment(2);
                    util.Effect(self.EjectEffect, fx);
                end
                lastshoottime = self.Owner:GetLastAttackTime()
            end            
            
            if self:GetMMBase_Charge() > 0 && self.ChargeEffect != "" then
                local effectdata4 = EffectData()
                effectdata4:SetStart(self.WorldMdl:GetAttachment("1").Pos) 
                effectdata4:SetOrigin(self.WorldMdl:GetAttachment("1").Pos)
                effectdata4:SetAngles(self.WorldMdl:GetAttachment("1").Ang )
                effectdata4:SetScale(1)
                util.Effect(self.ChargeEffect, effectdata4)
            end
        end
        
        self.WorldMdl:Remove()
    end
end

if CLIENT then
    surface.CreateFont("MM_Font_Ammo", {
        font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 96,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false ,
    })
end

function SWEP:LookingAtShootable()
    local tr = LocalPlayer():GetEyeTrace()
    return tr.Entity:IsPlayer() && !tr.Entity:HasStatusEffect(STATUS_INVISIBLE) && ((self.Owner:Team() == TEAM_COOPMONST && tr.Entity:Team() != self.Owner:Team()) || (self.Owner:Team() == TEAM_COOPOTHER && tr.Entity:Team() != self.Owner:Team()) || (tr.Entity:Team() == TEAM_MONST))
end

local function boolToNumber(value)
    if value == true then
        return 1
    else
        return 0
    end
end

if CLIENT then
    local wratio = 1920/ScrW()
    local Tex_white = surface.GetTextureID("vgui/white")
    function SWEP:DrawPercentageCircle(x, y, radius, seg, progression)
        local cir = { [1] = { x = x, y = y } }
        local cir2 = { [1] = { x = x, y = y } }

        for i = 0, seg do
            local a = math.rad((i / seg) * -360)
            cir[#cir+1] = { x = x - math.sin(a) * radius, y = y - math.cos(a) * radius }
        end

        for i = 0, progression do
            table.insert(cir2, cir[next(cir)+1])
            table.remove(cir, next(cir)+1)
        end

        surface.SetTexture(Tex_white)
        surface.SetDrawColor(self.CrosshairChargeColor)
        surface.DrawPoly(cir)
        //surface.SetDrawColor(0, 0, 0, 255)
        //surface.DrawPoly(cir2)
    end

    local wratio = ScrW()/1600
    local hratio = ScrH()/900

    function SWEP:DrawHUD()
        
        // Ammo counter
        local ammo = self:Clip1()
        if ammo != -1 then 
            draw.SimpleTextOutlined(ammo, "MM_Font_Ammo", ScrW()-150*wratio, ScrH()-60*hratio, Color(255,105,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
        
        local armMissing = 0
        armMissing = 1+boolToNumber(self.Owner:MissingAnArm())*2
        local x = self.CrosshairXDisplacement
        local y = self.CrosshairYDisplacement*armMissing
        
        
        if !self.Owner:HasStatusEffect(STATUS_CONCUSS) then

            // Charge
            if self:GetMMBase_Charge() > 0 && (!self.Primary.HideCharge || self.Owner:KeyDown(IN_ATTACK2)) then
                if self.CrosshairChargeType == CHARGETYPE_CIRCLE then
                    local size = armMissing*self.CrosshairChargeSize/2
                    size = wratio*(size/(1.5))
                    
                    self:DrawPercentageCircle(ScrW()/2, ScrH()/2, size, 100, 99-self:GetMMBase_Charge())
                elseif self.CrosshairChargeType != CHARGETYPE_NONE then
                    local size = wratio*(self.CrosshairSize/(1.5))*armMissing
                    local charge = self:GetMMBase_Charge()/100
                    local iheight = size*charge
                    local icharge = 1-charge
                    
                    surface.SetMaterial(self.CrosshairChargeMaterial)
                    surface.SetDrawColor(self.CrosshairChargeColor)
                    surface.DrawTexturedRectUV((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y+(size-charge*size), size, iheight, 0, icharge, 1, 1)
                end
            end
            
            // Recharge
            if self.CrosshairRechargeMaterial != nil && self.Owner:GetWeaponCooldown(self) > 0 then
                if self.CrosshairRechargeType == CHARGETYPE_SHRINK then
                    local size = (self.CrosshairSize+self.CrosshairRechargeSize*(self.Owner:GetWeaponCooldown(self)/self.Owner:GetWeaponCooldownMax(self)))*armMissing
                    size = wratio*(size/1.5)
                    
                    surface.SetMaterial(self.CrosshairRechargeMaterial)
                    surface.SetDrawColor(self.CrosshairRechargeColor)
                    surface.DrawTexturedRect((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y, size, size)
                elseif self.CrosshairRechargeType == CHARGETYPE_CIRCLE then
                    //self:DrawPercentageCircle(ScrW()/2, ScrH()/2, self.CrosshairChargeSize/2, 100, 99-self:GetMMBase_Charge())
                else 
                    local size = wratio*(self.CrosshairSize*armMissing/1.5)
                    local charge = 1-(self.Owner:GetWeaponCooldown(self)/self.Owner:GetWeaponCooldownMax(self)) 
                    local iheight = size*charge
                    local icharge = 1-charge
                    
                    surface.SetMaterial(self.CrosshairRechargeMaterial)
                    surface.SetDrawColor(self.CrosshairRechargeColor)
                    surface.DrawTexturedRectUV((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y+(size-charge*size), size, iheight, 0, icharge, 1, 1)
                end
            end
            
            // Overcharge
            if self.CrosshairOverchargeMaterial != nil && self:GetMMBase_OverChargeAmount() > 0 then
                if self.CrosshairOverchargeType == CHARGETYPE_SHRINK then
                    local size = (self.CrosshairSize+self.CrosshairOverchargeSize*(self:GetMMBase_OverChargeAmount()/100))*armMissing
                    size = wratio*(size/1.5)
                    
                    surface.SetMaterial(self.CrosshairOverchargeMaterial)
                    surface.SetDrawColor(self.CrosshairOverchargeColor)
                    surface.DrawTexturedRect((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y, size, size)
                elseif self.CrosshairOverchargeType == CHARGETYPE_CIRCLE then
                
                else 
                    local size = (ScrW()*self.CrosshairSize*armMissing)/2560
                    local charge = (self:GetMMBase_OverChargeAmount()/100) 
                    local iheight = size*charge
                    local icharge = 1-charge
                    
                    surface.SetMaterial(self.CrosshairOverchargeMaterial)
                    surface.SetDrawColor(self.CrosshairOverchargeColor)
                    surface.DrawTexturedRectUV((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y+(size-charge*size), size, iheight, 0, icharge, 1, 1)
                end
            end
            
            // Crosshair
            if self.CrosshairMaterial != nil then
                local size = self.CrosshairSize*armMissing
                size = wratio*(size/1.5)
                
                surface.SetMaterial(self.CrosshairMaterial)
                if (self:LookingAtShootable()) then
                    surface.SetDrawColor(255, 0, 0, 255)
                else
                    surface.SetDrawColor(255, 255, 255, 255)
                end
                surface.DrawTexturedRect((ScrW()/2)-(size/2)+x, (ScrH()/2)-(size/2)+y, size, size)
            end
        
        end

    end
end
local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

function SWEP:SetWeaponHoldType(t)

	t = string.lower(t)
	local index = ActIndex[ t ]

	if (index == nil) then
		Msg("SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n")
		t = "normal"
		index = ActIndex[ t ]
	end
	//print(self.Owner:Name().." - "..self.Owner:GetNWInt("LegMissing"))
	
    self.ActivityTranslate = {}
    self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
    self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
    self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
    self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
    self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
    self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
    self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
    self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
    self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
    self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
    self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
    self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9

	
	-- "normal" jump animation doesn't exist
	if (t == "normal") then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

	self:SetupWeaponHoldTypeForAI(t)

end

function SWEP:ShouldDropOnDie() 
	return true
end

function SWEP:OnDrop()
	self.Owner = nil
	timer.Simple(GetConVar("mm_cleanup_time"):GetInt(),function() if !IsValid(self) then return end if !self.Owner:IsPlayer() then  self:Remove() end end)
end

function SWEP:TranslateActivity(act)

    /*
    if CLIENT && act != 990 && act != 996 && act != 997 && act != 1001 then
        self.Owner:ChatPrint(act)
    end
    */

	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[ act ]) then
			return self.ActivityTranslateAI[ act ]
		end
		return -1
	end
    
    if (self.ActivityTranslate[ act ] != nil) then
        if self.Owner:MissingBothLegs() && (self.HoldTypeProne == "pistol" || self.HoldTypeProne == "revolver" || self.HoldType == "pistol" || self.HoldType == "revolver") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_IDLE_PISTOL end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_PISTOL end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_PISTOL end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_RELOAD_PRONE_PISTOL end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_RELOAD_PRONE_PISTOL end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_PISTOL end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_PISTOL end
        elseif self.Owner:MissingBothLegs() && (self.HoldType == "melee" || self.HoldType == "melee2" || self.HoldType == "knife" || self.HoldType == "slam") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_AIM_SPADE end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_AIM_SPADE end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_AIM_SPADE end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_SPADE end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_SPADE end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_SPADE end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_SPADE end
        elseif self.Owner:MissingBothLegs() && (self.HoldType == "ar2" || self.HoldType == "smg" || self.HoldType == "crossbow" || self.HoldType == "rpg" || self.HoldType == "shotgun") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_IDLE_30CAL end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_30CAL end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_30CAL end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_RELOAD_BAR end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_RELOAD_BAR end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_30CAL end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_30CAL end
        elseif self.Owner:MissingBothLegs() && (self.HoldType == "grenade"|| self.HoldType == "normal") then
            if act == ACT_MP_STAND_IDLE then                return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_WALK then                      return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_RUN then                       return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_CROUCH_IDLE then               return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_CROUCHWALK then                return ACT_DOD_PRONEWALK_AIM_GREN_FRAG end
            if act == ACT_MP_ATTACK_STAND_PRIMARYFIRE then  return ACT_DOD_PRIMARYATTACK_PRONE_GREN_FRAG end
            if act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE then return ACT_DOD_PRIMARYATTACK_PRONE_GREN_FRAG end
            if act == ACT_MP_RELOAD_STAND then              return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_RELOAD_CROUCH then             return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_JUMP then                      return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_RANGE_ATTACK1 then                return ACT_DOD_PRONE_AIM_GREN_FRAG end
            if act == ACT_MP_SWIM then                      return ACT_DOD_PRONE_AIM_GREN_FRAG end
        else
            return self.ActivityTranslate[ act ]
        end
    end

	return -1

end

if CLIENT then
	-- This is where all the sexy movement in the viewmodel happens. This shit is bootyfull
	-- If you guys get the chance, go give Kudo's to MushroomGuy for teaching me Lerp
	-- Lerp is one of the coolest and most sexy things to come to Garry's Mod
	-- Wow are these comments that interesting that you're still reading them?
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	local Current_Aim = Angle(0,0,0)
	local Off, Off2, Off3, dist = 0, 0, 0, 0
	local ironsighttime = 0
	SWEP.LastEyePosition = Angle(0,0,0)
	SWEP.EyePosition = Angle(0,0,0)
    SWEP.JumpTime = 0
    SWEP.LandTime = 0
	
	function SWEP:ManipulateViewModel(pos, ang)

		if !IsValid(self.Owner) then return end
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
		
		/*--------------------------------------------
				  Animation Transition Speed 
		--------------------------------------------*/
		
		if self.LandTime > RealTime() && !(self.Owner:IsOnGround()) then
			TestVector = LerpVector(20*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(20*FrameTime(),TestVectorAngle,TestVectorAngleTarget)
        elseif IsValid(self.Owner) && !(self.Owner:KeyDown(IN_DUCK) && walkspeed > 40) then
            TestVector = LerpVector(10*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(10*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
        elseif (self.Owner:KeyDown(IN_DUCK) || ply:MissingBothLegs()) && walkspeed > 40 then 
            TestVector = LerpVector(4*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(4*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
		else
            TestVector = LerpVector(5*FrameTime(),TestVector,TestVectorTarget) 
            TestVectorAngle = LerpVector(5*FrameTime(),TestVectorAngle,TestVectorAngleTarget) 
        end
		
		ang:RotateAroundAxis(ang:Right(),TestVectorAngle.x )
		ang:RotateAroundAxis(ang:Up(),TestVectorAngle.y)
		ang:RotateAroundAxis(ang:Forward(),TestVectorAngle.z)
		
		pos = pos + TestVector.z * ang:Up()
		pos = pos + TestVector.y * ang:Forward()
		pos = pos + TestVector.x * ang:Right()
		if !IsValid(self.Owner) then return end
		local Tr = self.Owner:GetEyeTrace()
		

        /*--------------------------------------------
		Ironsight, Crouching, Near Wall, Ladder and Sprinting
		--------------------------------------------*/
		
        if self.Owner:GetMoveType() == MOVETYPE_LADDER then 
            TestVectorTarget = Vector(0,0,2)
            TestVectorAngleTarget = Vector(-40,0,0)
        elseif self.Owner:KeyDown(IN_DUCK) then 
            TestVectorTarget = self.CrouchPos
            TestVectorAngleTarget = self.CrouchAng
        else
            TestVectorTarget = Vector(0,0,0)
            TestVectorAngleTarget = Vector(0,0,0)
        end
        
        
        /*--------------------------------------------
                        1 arm reload
        --------------------------------------------*/
		
        if self:GetClass() != "weapon_mm_wand" then
            if (self.Owner:MissingAnArm() && self:GetMMBase_ReloadTimer() > CurTime() && ((self:GetMMBase_ReloadTimer()-CurTime())/(self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate()))) > 0.1)  || ((self:GetClass() == "weapon_mm_pumpshotgun" || self:GetClass() == "weapon_mm_repeater") && self:GetMMBase_ReloadShotgunState() != 0 && self.Owner:MissingAnArm()) then
                TestVectorTarget = TestVectorTarget + Vector(10,0,5)
                TestVectorAngleTarget = TestVectorAngleTarget + Vector(-50,0,0)
            elseif self.Owner:MissingAnArm() && self:GetMMBase_ReloadTimer() > CurTime() && ((self:GetMMBase_ReloadTimer()-CurTime())/(self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate()))) <= 0.1 then
                TestVectorAngleTarget = TestVectorAngleTarget + Vector(-20,0,0)
            end
        end
        
        
		/*--------------------------------------------
					 Viewmodel Jump Sway
		--------------------------------------------*/
        
        -- Custom jumping animation
        if !self.Owner:IsOnGround() then
            self.LandTime = RealTime() + 0.31
        end
        
        if (self.Owner:GetMoveType() == MOVETYPE_NOCLIP || self.Owner:GetMoveType() == MOVETYPE_LADDER || self.Owner:WaterLevel() > 1) || (self.LandTime < RealTime() && self.LandTime != 0) then
            self.LandTime = 0
            self.JumpTime = 0
        end

        if self.Owner:KeyDownLast(IN_JUMP) then
            if self.JumpTime == 0 then
                self.JumpTime = RealTime() + 0.31
                self.LandTime = 0
            end
        end
    
        -- Use this if you gotta https://www.desmos.com/calculator/cahqdxeshd
        local function BezierY(f,a,b,c)
            f = f*3.2258
            return (1-f)^2 *a + 2*(1-f)*f*b + (f^2)*c
        end
        if self.Owner:WaterLevel() < 1 then
            if self.JumpTime > RealTime() then
                local f = 0.31 - (self.JumpTime-RealTime())

                local xx = BezierY(f,0,-4,0)
                local yy = 0
                local zz = BezierY(f,0,-2,-5)
                
                local pt = BezierY(f,0,-4.36,10)
                local yw = xx
                local rl = BezierY(f,0,-10.82,-5)
                
                TestVectorTarget = TestVectorTarget + Vector(xx, yy, zz)
                TestVectorAngleTarget = TestVectorAngleTarget + Vector(pt, yw, rl)
            elseif !ply:IsOnGround() && (ply:GetMoveType() != MOVETYPE_NOCLIP && self.Owner:GetMoveType() != MOVETYPE_LADDER) then
                local BreatheTime = RealTime() * 30
                TestVectorTarget = TestVectorTarget + Vector(math.cos(BreatheTime/2)/16, 0, -5+(math.sin(BreatheTime/3)/16))
                TestVectorAngleTarget = TestVectorAngleTarget + Vector(10-(math.sin(BreatheTime/3)/4), math.cos(BreatheTime/2)/4, -5)
            elseif self.LandTime > RealTime() then
                local f = (self.LandTime-RealTime())
                
                local xx = BezierY(f,0,-4,0)
                local yy = 0
                local zz = BezierY(f,0,-2,-5)
                
                local pt = BezierY(f,0,-4.36,10)
                local yw = xx
                local rl = BezierY(f,0,-10.82,-5)
                
                TestVectorTarget = TestVectorTarget + Vector(xx, yy, zz)
                TestVectorAngleTarget = TestVectorAngleTarget + Vector(pt, yw, rl)
            end
        else
            TestVectorTarget = TestVectorTarget + Vector(0 ,0 , math.Clamp(self.Owner:GetVelocity().z / 1000,-1,1))
        end
		
		
		/*--------------------------------------------
					  Viewmodel Bobbing
		--------------------------------------------*/
		
        if ply:IsOnGround() then
			if walkspeed > 20 then
				local BreatheTime = RealTime() * 16
                local roll = 0
                local yaw = 0
                if (ply:MissingLeftArm() && self.Owner:KeyDown(IN_MOVELEFT)) || self.Owner:KeyDown(IN_MOVERIGHT) then
                    if ((self.Primary.ChargeCrouch || self.Secondary.ChargeCrouch) && self:GetMMBase_Charge() != 0) || ply:MissingALeg() then
                        roll = 0
                    else
                        roll = -7*(walkspeed/self.Owner:GetWalkSpeed())
                        if self.Owner:KeyDown(IN_MOVELEFT) then
                            roll = -roll
                        end
                    end
                elseif (ply:MissingLeftArm() && self.Owner:KeyDown(IN_MOVERIGHT)) || self.Owner:KeyDown(IN_MOVELEFT) then
                    yaw = 4*(walkspeed/200)
                    if (self.Owner:KeyDown(IN_MOVERIGHT)) then
                        yaw = -yaw
                    end
                end
                TestVectorTarget = TestVectorTarget - Vector((-math.cos(BreatheTime/2)/5)*walkspeed/200+yaw/5,0,0)
                TestVectorAngleTarget = TestVectorAngleTarget - Vector((math.Clamp(math.cos(BreatheTime),-0.3,0.3)*1.2)*walkspeed/200,(-math.cos(BreatheTime/2)*1.2)*walkspeed/200+yaw,roll)
			else
				local BreatheTime = RealTime() * 2
				TestVectorTarget = TestVectorTarget - Vector(math.cos(BreatheTime/4)/4,0,-math.cos(BreatheTime/5)/4)
				TestVectorAngleTarget = TestVectorAngleTarget - Vector(math.cos(BreatheTime/5),math.cos(BreatheTime/4),math.cos(BreatheTime/7))
			end            
		end 
		
	
		/*--------------------------------------------
						Viewmodel Sway
		--------------------------------------------*/
		
        self.LastEyePosition = self.EyePosition
        
        Current_Aim = LerpAngle(5*FrameTime(), Current_Aim, ply:EyeAngles())
        
        self.EyePosition = Current_Aim - ply:EyeAngles()
        self.EyePosition.y = math.AngleDifference(Current_Aim.y, math.NormalizeAngle(ply:EyeAngles().y)) -- Thank you MushroomGuy for telling me this function even existed    
        
        ang:RotateAroundAxis(ang:Right(), math.Clamp(4*self.EyePosition.p/self.MMSwayScale,-4,4))
        ang:RotateAroundAxis(ang:Up(), math.Clamp(-4*self.EyePosition.y/self.MMSwayScale,-4,4))

        pos = pos + math.Clamp((-1.5*self.EyePosition.p/self.MMSwayScale),-1.5,1.5) * ang:Up()
        pos = pos + math.Clamp((-1.5*self.EyePosition.y/self.MMSwayScale),-1.5,1.5) * ang:Right()
        
        if ply:IsDodgeRolling() then
            local time
            if LocalPlayer():HasStatusEffect(STATUS_ROLLRIGHT) then
                time = (LocalPlayer():GetStatusEffectTime(STATUS_ROLLRIGHT))
            else
                time = (LocalPlayer():GetStatusEffectTime(STATUS_ROLLLEFT))
            end
        end
		return pos, ang
	end
end

local myfov = 75
local myfov_t = 90
local lastangle = nil
hook.Add("CalcView", "MM_CalcView", function(ply, origin, angles, fov)
    if ply:GetActiveWeapon().IsMMGun then
        local vmpos, vmang = ply:GetActiveWeapon():ManipulateViewModel(Vector(origin.x, origin.y, origin.z), Angle(angles.p, angles.y, angles.r))
        ply:GetViewModel():SetRenderOrigin(vmpos) 
        ply:GetViewModel():SetRenderAngles(vmang)
        ply:GetActiveWeapon().vmpos = vmpos
        ply:GetActiveWeapon().vmang = vmang
    end
end)

hook.Add("PlayerCanPickupWeapon", "MM_AllowWeaponPickup", function(ply, wep)
    if (CurTime() == wep.SpawnTime) then 
        return true 
    end
    
    if (ply:Team() == TEAM_COOPOTHER) then return false end
    if (!ply:KeyDown(IN_USE)) then return false end
    if ply:HasWeapon(wep:GetClass()) then return false end
    if ply:MissingBothArms() then return false end
    if (ply:IsSuper()) then return false end
    
    local trace = util.TraceHull({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + (ply:GetAimVector() * 100),
        filter = ply,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10),
        mask = MASK_SHOT_HULL
    })
    
    if (!trace.Entity || !trace.Entity:IsValid() || trace.Entity != wep) then
        return false
    else
        ply:DropWeaponSlot(wep.Slot+1)
        ply:GiveWeapon(wep)
        return true
    end
end)

if SERVER then
    util.AddNetworkString("MM_EquipHeal")
end

net.Receive("MM_EquipHeal", function(len, ply)
    if (ply:GetNextHeal() < CurTime() && ply:Health() < ply:GetMaxHealth()) then
        ply:Give("weapon_mm_candycorn")
        ply:SelectWeapon("weapon_mm_candycorn")
        ply:SetNextHeal()
    end
end)

hook.Add("OnSpawnMenuOpen", "MM_Heal", function()
    if (LocalPlayer():GetNextHeal() < CurTime() && LocalPlayer():Health() < LocalPlayer():GetMaxHealth()) && !LocalPlayer():IsSuper() then
        net.Start("MM_EquipHeal")
        net.SendToServer()
    end
end)

hook.Add("AllowPlayerPickup", "MM_AllowPickupStuff", function(ply, ent)
    return false
end)