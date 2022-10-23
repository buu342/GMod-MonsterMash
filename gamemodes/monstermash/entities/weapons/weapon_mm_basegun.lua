AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basebase")

SWEP.PrintName = "Base base"
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.CSMuzzleFlashes = true

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/c_pistol.mdl" 
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Slot = 1
SWEP.UseHands = true
SWEP.Base = "weapon_mm_basebase"

SWEP.Primary.Sound = Sound("sound/pewpew.wav") 
SWEP.Primary.Damage = 1000
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 30 
SWEP.Primary.Ammo = "None"
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.02
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.TakeAmmo = 1


/*------------------------------------------------
                Monster Mash Settings
------------------------------------------------*/

SWEP.SelectIcon = Material("vgui/entities/mm_colt")
SWEP.Cost = 0
SWEP.Points = 0

SWEP.KillFlags = 0


// Crosshair

SWEP.CrosshairMaterial         = Material("")
SWEP.CrosshairSize             = 0
SWEP.CrosshairChargeMaterial   = Material("")
SWEP.CrosshairChargeSize       = 0
SWEP.CrosshairRechargeMaterial = Material("")
SWEP.CrosshairRechargeSize     = 0


// Holdtypes

SWEP.HoldType         = "Pistol" 
SWEP.HoldTypeAttack   = "Pistol"
SWEP.HoldTypeAttack2  = ""
SWEP.HoldTypeReload   = "Pistol"
SWEP.HoldTypeCrouch   = "Pistol"


// Speed

SWEP.RunSpeed    = 200
SWEP.ShootSpeed  = 80 
SWEP.ReloadSpeed = 120
SWEP.ChargeSpeed = 80 


// Extra primary/secondary stuff

SWEP.Primary.UseRange   = false
SWEP.Primary.Range      = nil
SWEP.Primary.ProjectileForce = 10000
SWEP.Primary.ProjectileEntity = "prop_physics"
SWEP.Primary.ProjectileChargeup = false
SWEP.Primary.ProjectileTarget = false
SWEP.Primary.ProjectilePassDamage = true
SWEP.Primary.Chargeup = false
SWEP.Primary.ChargeTime = 1
SWEP.Primary.ChargeShrinksXHair = false
SWEP.Primary.ChargeDamage = 75
SWEP.Primary.ChargeCrouch = true
SWEP.Primary.ChargeCancel = false
SWEP.Primary.ChargeEarly = true
SWEP.Primary.ChargeForce = 1000
SWEP.Primary.ChargeShootMax = false
SWEP.Primary.ChargeEmptyShoot = true
SWEP.Primary.ChargeDependsAmmo = false
SWEP.Primary.OverChargeTime = 0
SWEP.Primary.OverChargeAmount = 0
SWEP.Primary.SpecialCooldown = 0
SWEP.Primary.SpecialCooldownGivesAmmo = false
SWEP.Primary.FireMode = FIREMODE_BULLET
SWEP.Primary.BurstFire = false
SWEP.Primary.BurstTime = 0
SWEP.Primary.BurstCount = 3
SWEP.Primary.TakeAmmoAffectsBulletCount = false
SWEP.Primary.TakeAmmoAffectsShootability = false
SWEP.Primary.Zoom = false
SWEP.Primary.ZoomMax = 10
SWEP.Primary.LoopSound = false
SWEP.Primary.LoopStartSound = nil
SWEP.Primary.LoopEndSound = nil
SWEP.Primary.BulletForce = 0
SWEP.Primary.BulletArc = false
SWEP.Primary.ShockTime = 0
SWEP.Primary.IgniteIfDamage = -1
SWEP.Primary.OverChargeWarningSound = Sound("weapons/deanimator/overcharged.wav")
SWEP.Primary.ArmMissingAffectsAim = true
SWEP.Primary.Magnetism = true
SWEP.Primary.MaxChargeToMagnetise = false
SWEP.Primary.HideCharge = false

SWEP.Secondary.UseRange = false
SWEP.Secondary.Range    = 256
SWEP.Secondary.ProjectileForce = 10000
SWEP.Secondary.ProjectileEntity = "prop_physics"
SWEP.Secondary.ProjectileChargeup = false
SWEP.Secondary.ProjectileTarget = false
SWEP.Secondary.ProjectilePassDamage = true
SWEP.Secondary.Chargeup = false
SWEP.Secondary.ChargeTime = 1
SWEP.Secondary.ChargeShrinksXHair = false
SWEP.Secondary.ChargeDamage = 75
SWEP.Secondary.ChargeForce = 1000
SWEP.Secondary.ChargeShootMax = false
SWEP.Secondary.ChargeEmptyShoot = true
SWEP.Secondary.ChargeDependsAmmo = false
SWEP.Secondary.ChargeCrouch = true
SWEP.Secondary.ChargeCancel = false
SWEP.Secondary.ChargeEarly = false
SWEP.Secondary.OverChargeTime = 0
SWEP.Secondary.OverChargeAmount = 0
SWEP.Secondary.SpecialCooldown = 0
SWEP.Secondary.SpecialCooldownGivesAmmo = false
SWEP.Secondary.FireMode = FIREMODE_NONE
SWEP.Secondary.BurstFire = false
SWEP.Secondary.BurstTime = 0
SWEP.Secondary.BurstCount = 3
SWEP.Secondary.TakeAmmoAffectsBulletCount = false
SWEP.Secondary.TakeAmmoAffectsShootability = false
SWEP.Secondary.Zoom = false
SWEP.Secondary.ZoomMax = 10
SWEP.Secondary.LoopSound = false
SWEP.Secondary.LoopStartSound = nil
SWEP.Secondary.LoopEndSound = nil
SWEP.Secondary.BulletForce = 0
SWEP.Secondary.BulletArc = false
SWEP.Secondary.ShockTime = 0
SWEP.Secondary.IgniteIfDamage = -1
SWEP.Secondary.OverChargeWarningSound = Sound("weapons/deanimator/overcharged.wav")
SWEP.Secondary.ArmMissingAffectsAim = true
SWEP.Secondary.Magnetism = true
SWEP.Secondary.MaxChargeToMagnetise = false
SWEP.Secondary.HideCharge = false

SWEP.UseWindup = false

// Other stuff

SWEP.CanReload = true
SWEP.ReloadSlowedByArm = true
SWEP.ReloadOutTime = 0.1
SWEP.ReloadInTime  = 0.9
SWEP.ReloadAmount = -1
SWEP.ReloadAmountMax = 6
SWEP.AutoReload = false
SWEP.AutoReloadTime = 1

SWEP.ShotgunReload = false
SWEP.ShotgunReloadAnimIn = ACT_SHOTGUN_RELOAD_START
SWEP.ShotgunReloadAnimLoop = ACT_VM_RELOAD
SWEP.ShotgunReloadAnimOut = ACT_SHOTGUN_RELOAD_FINISH

SWEP.KillFlags = 0
SWEP.TracerName = "Tracer"
SWEP.TracerName2 = ""
SWEP.SlowMoTracer = true
SWEP.ImpactEffect = ""
SWEP.ImpactDecal = ""
SWEP.ImpactDecalSize = 1
SWEP.ImpactEffectOnPlayers = false

SWEP.UsesProjectile = false
SWEP.AttackAnim = ACT_VM_PRIMARYATTACK
SWEP.AttackAnimStop = nil
SWEP.Attack2Anim = nil
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.ChargeAnim = nil
SWEP.UnchargeAnim = nil

SWEP.MakeThumperDust = false
SWEP.DamageMultiplierDistance = -1

SWEP.GoreJarDelay = 3

SWEP.IsAcidic = false
SWEP.LoopSound = nil
SWEP.DidLoopStart = false

SWEP.EquipSound = Sound("Weapons/deploy.wav")

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Int", 0, "MMBase_ReloadShotgunState")
    self:NetworkVar("Int", 1, "MMBase_LastShotType")
    self:NetworkVar("Float", 0, "MMBase_ReloadTimerAmmo")
    self:NetworkVar("Float", 1, "MMBase_ReloadShotgunTimer")
    self:NetworkVar("Float", 2, "MMBase_ReloadAutoTimer")
    self:NetworkVar("Float", 3, "MMBase_OverChargeTime")
end

function SWEP:PrimaryAttack()
    if self.UseWindup && (self:GetMMBase_Windup() == 0 || self:GetMMBase_Windup() > CurTime()) then return end
    if self:GetMMBase_BurstCount() != 0 then return end
    if self:GetMMBase_ReloadShotgunState() == 2 then self:SetMMBase_ReloadShotgunState(3) end
    if self.Primary.Chargeup && !self.Primary.ChargeShootMax && self.Owner:KeyDown(IN_ATTACK) then return end
    if self.Primary.Chargeup && !self.Primary.ChargeEarly && self:GetMMBase_Charge() != 100 then return end
    self:RemoveSpawnProtection()
    self:DoAttack(self.Primary)
    self:SetMMBase_LastShotType(1)
end 

function SWEP:SecondaryAttack()
    if self:GetMMBase_BurstCount() != 0 then return end
    if self:GetMMBase_ReloadShotgunState() == 2 then self:SetMMBase_ReloadShotgunState(3) end
    if self.Secondary.Chargeup && self.Owner:KeyDown(IN_ATTACK2) then return end
    if self.Secondary.Chargeup && !self.Secondary.ChargeEarly && self:GetMMBase_Charge() != 100 then return end
    self:RemoveSpawnProtection()
    self:DoAttack(self.Secondary)
    self:SetMMBase_LastShotType(2)
end

function SWEP:DoAttack(mode)
    if (mode.FireMode == FIREMODE_BULLET) then
        self:MM_ShootBullet(mode)
    elseif (mode.FireMode == FIREMODE_PROJECTILE) then
        self:MM_ShootProjectile(mode)
    elseif (mode.FireMode == FIREMODE_CUSTOM) then
        self:MM_ShootCustom(mode)
    end
end

function SWEP:HandleTimers()
    BaseClass.HandleTimers(self)
    
    if self:GetMMBase_ReloadTimerAmmo() != 0 && self:GetMMBase_ReloadTimerAmmo() < CurTime() then
        if self.ShotgunReload then
            self:SetClip1(self:Clip1()+1)
            self:SetMMBase_ReloadTimerAmmo(0)
        elseif (self:Clip1() != 0) && self.ReloadInTime != 0 then
            self:SetClip1(0)
            self:SetMMBase_ReloadTimerAmmo(CurTime() + self.ReloadInTime/self.Owner:GetViewModel():GetPlaybackRate())
        else
            if self.ReloadAmount != -1 then
                self:SetClip1(math.min(self:Clip1() + self.ReloadAmount, self.ReloadAmountMax))
            else
                self:SetClip1(self:GetMaxClip1())
            end
            self:SetMMBase_ReloadTimerAmmo(0)
        end
    end
    
    if self:GetMMBase_ReloadShotgunState() == 1 && self:GetMMBase_ReloadShotgunTimer() < CurTime() then
        self:SetMMBase_ReloadShotgunState(2)
    end
    
    if self:GetMMBase_ReloadShotgunState() == 2 && self:GetMMBase_ReloadShotgunTimer() < CurTime() then
        if self:Clip1() == self:GetMaxClip1() then
            self:SetMMBase_ReloadShotgunState(3)
        end
    end
    
    if self:GetMMBase_ReloadShotgunState() == 2 && self:GetMMBase_ReloadShotgunTimer() < CurTime() then
        self:SendWeaponAnim(self.ShotgunReloadAnimLoop)
        
        if self.Owner:MissingAnArm() && self.ReloadSlowedByArm then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
        end
        
        local time = self.Owner:GetViewModel():SequenceDuration()/self.Owner:GetViewModel():GetPlaybackRate()
        self:SetMMBase_ReloadTimer(CurTime() + time*10)
        self:SetMMBase_ReloadShotgunTimer(CurTime() + time)
        
        self:SetMMBase_ReloadTimerAmmo(CurTime() + self.ReloadOutTime/time)
    end
    
    if self:GetMMBase_ReloadShotgunState() == 3 && self:GetMMBase_ReloadShotgunTimer() < CurTime() then
        self:SendWeaponAnim(self.ShotgunReloadAnimOut)
        
        if self.Owner:MissingAnArm() && self.ReloadSlowedByArm then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
        end
        
        local time = self.Owner:GetViewModel():SequenceDuration()/self.Owner:GetViewModel():GetPlaybackRate()
        self:SetMMBase_ReloadTimer(CurTime() + time)
        self:SetMMBase_ReloadShotgunTimer(CurTime() + time)
        self:SetMMBase_ReloadShotgunState(4)
    end
    
    if self:GetMMBase_ReloadShotgunState() == 4 && self:GetMMBase_ReloadShotgunTimer() < CurTime() then
        self:SetMMBase_ReloadShotgunState(0)
    end
        
end

local function boolToNumber(value)
    if value == true then
        return 1
    else
        return 0
    end
end

function SWEP:DoFireDelay(mode)
    local delay = mode.Delay

    if (mode.BurstFire && self:GetMMBase_BurstCount() < mode.BurstCount) then
        self:SetMMBase_BurstCount(self:GetMMBase_BurstCount()+1)
        if self:GetMMBase_BurstCount() != mode.BurstCount then
            delay = mode.BurstTime
        end
    end
    if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
        delay = delay*self.GoreJarDelay
    end
    self:SetMMBase_ShootTimer(CurTime() + delay)
end

function SWEP:HandleHoldTypes()
    if !IsValid(self.Owner) || !self.Owner:Alive() then return end
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
        if (self:GetMMBase_LastShotType() == 2 && self.HoldTypeAttack2 != "" && self:GetMMBase_ShootTimer() > CurTime()) then
            self:SetHoldType(self.HoldTypeAttack2)
        else
            self:SetHoldType("duel")
        end
        self.ViewModelFlip = true
        self.Owner:GetHands():SetBodygroup(1,1)
    else
        if self:GetMMBase_ShootTimer() > CurTime() then
            if (self:GetMMBase_LastShotType() == 2 && self.HoldTypeAttack2 != "") then
                self:SetHoldType(self.HoldTypeAttack2)
            else
                self:SetHoldType(self.HoldTypeAttack)
            end
        elseif self:GetMMBase_ReloadTimer() > CurTime() then
            self:SetHoldType(self.HoldTypeReload)
        elseif self.Owner:Crouching() then
            self:SetHoldType(self.HoldTypeCrouch)
        else
            if self.Owner:MissingBothLegs() && self.HoldTypeProne != "" then
                self:SetHoldType(self.HoldTypeProne)
            else
                self:SetHoldType(self.HoldType)
            end
        end
        self.ViewModelFlip = false
        self.Owner:GetHands():SetBodygroup(1,0)
    end
end

function SWEP:Deploy()
    self.LoopSound = nil
    self:SetMMBase_ShootTimer(CurTime() + 1)
    self:SetMMBase_Deploying(true)
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:EmitSound(self.EquipSound)
    return true
end

function SWEP:Holster(wep)
    BaseClass.Holster(self)
    if (self:GetMMBase_BurstCount() != 0) then
        return false
    end
    if self.LoopSound != nil then
        self.LoopSound:Stop()
        self.LoopSound = nil
    end
    if self.IdleSound != nil then
        self:EmitSound("empty.wav", 75, 100, 1, CHAN_VOICE2)
    end
    self.Owner.PrevWeapon = self
    return true
end

function SWEP:MM_ShootBullet(mode)
    if !self.Owner:IsOnGround() then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    if self:Clip1() == 0 || (mode.TakeAmmoAffectsShootability && self:Clip1()-mode.TakeAmmo < 0) then 
        if (!GetConVar("mm_autoreload"):GetBool()) then
            self:EmitSound("weapons/shotgun/shotgun_empty.wav", 75, 100, 1, CHAN_ITEM) 
            self:SetMMBase_ShootTimer(CurTime() + 0.2)
        end
        return
    end
    
    local bullet = {} 
    if (mode.TakeAmmoAffectsBulletCount) then
        bullet.Num = math.min(self:Clip1(), mode.NumberofShots)
    else
        bullet.Num = mode.NumberofShots 
    end
    bullet.Src = self.Owner:GetShootPos() 
    bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
    
    // Bullet spread
    if mode.ChargeShrinksXHair then
        bullet.Spread = Vector(mode.Spread/(1+3*self:GetMMBase_Charge()/100) * 0.1 , mode.Spread/(1+3*self:GetMMBase_Charge()/100) * 0.1, 0)
    else
        bullet.Spread = Vector(mode.Spread * 0.1 , mode.Spread * 0.1, 0)
    end
    if (mode.ArmMissingAffectsAim) then
        bullet.Spread = bullet.Spread*(1+boolToNumber(self.Owner:MissingAnArm())*3)
    end
    if (mode.Magnetism && (self:GetMMBase_Charge() == 100 || !mode.MaxChargeToMagnetise)) then
        local tr = self.Owner:GetEyeTrace().Entity
        if (tr != nil && tr:IsPlayer()) then
            bullet.Spread = Vector(0,0,0)
        end
    end
    
    bullet.Tracer = 1
    if (self.SlowMoTracer && game.GetTimeScale() < 1) then
        bullet.TracerName = "mm_slowmotracer"
    elseif mode == self.Secondary && self.TracerName2 != "" then
        bullet.TracerName = self.TracerName2
    else
        bullet.TracerName = self.TracerName
    end
    if mode.BulletForce == 0 then
        bullet.Force = 1
    else
        bullet.Force = mode.BulletForce
    end
    if mode.Chargeup then
        bullet.Damage = mode.Damage+(mode.ChargeDamage*self:GetMMBase_Charge()/100)
    else
        bullet.Damage = mode.Damage 
    end
    bullet.AmmoType = mode.Ammo 
    if mode.UseRange then
        bullet.Distance = mode.Range
    end
    bullet.Callback = function(attacker, tr, dmginfo)
        self:MM_BulletCallback(attacker, tr, dmginfo, mode)
    end
    self:ShootEffects()
    
    if self.Attack2Anim != nil && mode == self.Secondary then
        self:SendWeaponAnim(self.Attack2Anim)
    elseif self.AttackAnim != ACT_VM_PRIMARYATTACK then
        self:SendWeaponAnim(self.AttackAnim)
    end
    
    if self.MakeThumperDust then
        local effectdata = EffectData()
        effectdata:SetOrigin(self.Owner:GetPos())
        effectdata:SetScale(128)
        util.Effect("ThumperDust", effectdata)
    end
    
    if self.AutoReload then
        self:SetMMBase_ReloadAutoTimer(CurTime()+self.AutoReloadTime)
    end
     
    self.Owner:FireBullets(bullet) 
    if !mode.LoopSound then
        if IsValid(self.Owner) && self.Owner:HasStatusEffect(STATUS_GOREJARED) then
            self:EmitSound(mode.Sound, 100, 50)
        else
            self:EmitSound(mode.Sound, 100)
        end
    else
        if mode.LoopStartSound != nil && !self.DidLoopStart then
            self:EmitSound(mode.LoopStartSound, 100)
            self.DidLoopStart = true
        end
        if self.LoopSound == nil then
            local filter
            if SERVER then
                filter = RecipientFilter()
                filter:AddAllPlayers()
            end
            self.LoopSound = CreateSound(self, mode.Sound, filter)
            self.LoopSound:SetSoundLevel(100)
            if self.LoopSound != nil then
                self.LoopSound:Play()
            end
            
        else
            if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
                self.LoopSound:ChangePitch(50, 0)
            else
                self.LoopSound:ChangePitch(100, 0)
            end
        end
    end
    
    if (self.Owner:IsPlayer()) then
        self.Owner:SetLastAttackTime()
    end
    
    self:SetMMBase_OverChargeTime(0)
    self.Owner:ViewPunch(Angle(self:RandomRange(-mode.Recoil/2, mode.Recoil/2) , self:RandomRange(-mode.Recoil/2, mode.Recoil/2), 0)) 
    self:SetClip1(math.Clamp(self:Clip1()-mode.TakeAmmo, 0, self:GetMaxClip1()))
    self:SetMMBase_OverChargeAmount(self:GetMMBase_OverChargeAmount() + mode.OverChargeAmount)
    self:DoFireDelay(mode)
    
    if (mode.SpecialCooldown != 0) then
        self.Owner:SetWeaponCooldown(self, mode.SpecialCooldown)
    end
end

if SERVER then
    util.AddNetworkString("MM_ElectrocuteClient")
end

net.Receive("MM_ElectrocuteClient", function(len,ply)
    LocalPlayer():SetStatusEffect(STATUS_ELECTROCUTED, nil, net.ReadInt(32))
end)

function SWEP:MM_BulletCallback(attacker, tr, dmginfo, mode)
    if (bit.band(self.KillFlags, KILL_ZAP) != 0) then
        dmginfo:SetDamageType(DMG_DISSOLVE)
    end
    if (self.DismemberChance > math.random(0, 100)) then
        dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_MISSINGLIMB))
    end
    if (self.IsAcidic) then
        dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_MELTER))
    end
    if self.DamageMultiplierDistance != -1 && tr.Entity:IsPlayer() && tr.Entity:GetPos():Distance(attacker:GetPos()) <= self.DamageMultiplierDistance then
        dmginfo:SetDamage(dmginfo:GetDamage()*1.5)
    end
    if mode == self.Primary && self.Primary.BulletForce != 0 && tr.Entity:IsPlayer() then
        local dir = (tr.HitPos-tr.StartPos):GetNormalized()
        tr.Entity:SetVelocity(Vector(dir.x, dir.y, 0)*self.Primary.BulletForce)
    end
    if mode == self.Secondary && self.Secondary.BulletForce != 0 && tr.Entity:IsPlayer() then
        local dir = (tr.HitPos-tr.StartPos):GetNormalized()
        tr.Entity:SetVelocity(Vector(dir.x, dir.y, 0)*self.Secondary.BulletForce)
    end
    if mode.ShockTime > 0 && tr.Entity:IsPlayer() && !tr.Entity:HasStatusEffect(STATUS_ELECTROCUTED) && tr.Entity:CanBeDamagedBy(dmginfo:GetAttacker()) && SERVER then
        tr.Entity:SetStatusEffect(STATUS_ELECTROCUTED, nil, mode.ShockTime)
        net.Start("MM_ElectrocuteClient")
            net.WriteInt(mode.ShockTime, 32)
        net.Send(tr.Entity)
    end
    if mode.IgniteIfDamage != -1 && dmginfo:GetDamage() >= mode.IgniteIfDamage && tr.Entity:IsPlayer() && (!tr.Entity:IsPlayer() || tr.Entity:CanBeDamagedBy(dmginfo:GetAttacker())) then
        tr.Entity:SetStatusEffect(STATUS_ONFIRE, dmginfo, 3)
    end
    
    if mode.BulletArc then
        if tr.Entity:IsPlayer() then
            local HitList = {
                //self.Owner,
                tr.Entity
            }
            self:BounceCallback(tr, HitList, 1, mode)                
        end
    end
    dmginfo:SetInflictor(self)
end

function SWEP:BounceCallback(tr, HitList, num, mode)
    num = num + 1
    if num == 4 then return end
    local dist = 384
    local ent = tr.Entity
    for k, v in pairs(player.GetAll()) do
        if (v:Team() != TEAM_SPECT && v:Team() != TEAM_COOPDEAD) then
            local maxdist = dist
            if v == self.Owner then
                maxdist = dist/2
            end
            if !table.HasValue(HitList, v) && v:GetPos():Distance(tr.HitPos) < maxdist then
                dist = v:GetPos():Distance(tr.HitPos)
                ent = v
                table.insert(HitList, v)
            end
        end
    end
    
    if ent == tr.Entity then 
        return
    else
        local bullet = {} 
        bullet.Num = 1
        bullet.Src = tr.HitPos
        bullet.Dir = (ent:GetPos()+Vector(0,0,50)-tr.HitPos):Angle():Forward()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 1
        bullet.TracerName = self.TracerName
        if self.UseDistance then
            bullet.Distance = mode.Range
        end
        bullet.Force = 1
        if mode.Chargeup then
            bullet.Damage = mode.Damage+(mode.ChargeDamage*self:GetMMBase_Charge()/100)
        else
            bullet.Damage = mode.Damage 
        end
        bullet.AmmoType = mode.Ammo 
        bullet.IgnoreEntity = tr.Entity
        bullet.Callback = function(attacker, tr2, dmginfo)
            if mode.IgniteIfDamage != -1 && dmginfo:GetDamage() >= bullet.Damage && tr.Entity:IsPlayer() && tr.Entity:CanBeDamagedBy(self.Owner) then
                tr.Entity:SetStatusEffect(STATUS_ONFIRE, dmginfo, 3)
            end
            dmginfo:SetInflictor(self)
            dmginfo:SetAttacker(self.Owner)
            dmginfo:SetDamageType(DMG_BULLET)
            self:BounceCallback(tr2, HitList, num, mode)                
		end
        tr.Entity:FireBullets(bullet) 
    end
end

function SWEP:MM_ShootProjectile(mode)
    if !self.Owner:IsOnGround() then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    if (mode.SpecialCooldown != 0 && self.Owner:GetWeaponCooldown(self) > 0) then return end
    if (mode.TakeAmmo != 0 && self:Clip1() == 0) || (mode.TakeAmmoAffectsShootability && self:Clip1()-mode.TakeAmmo < 0) then 
        if (!GetConVar("mm_autoreload"):GetBool()) then
            self:EmitSound("weapons/shotgun/shotgun_empty.wav", 75, 100, 1, CHAN_ITEM) 
            self:SetMMBase_ShootTimer(CurTime() + 0.2)
        end
        return
    end
    
    if SERVER && mode.ProjectileEntity != "" then 
        local ent = ents.Create(mode.ProjectileEntity) 

        if (!IsValid(ent)) then return end
        ent.Force = mode.ProjectileForce + mode.ChargeForce*self:GetMMBase_Charge()/100
        ent.Owner = self.Owner
        ent.Inflictor = self
        if (mode.ProjectileTarget) then
            ent.Target = self.Owner:GetEyeTrace().Entity
        end
        if (mode.ProjectilePassDamage) then
            ent.Damage = mode.Damage
        end
        ent.Dir = self.Owner:GetAimVector()
        ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 64))
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()
        
        local phys = ent:GetPhysicsObject()
        if IsValid(phys)then 
            local velocity = self.Owner:GetAimVector()
            velocity = velocity * ent.Force
            phys:ApplyForceCenter(velocity)
        else
            ent:Remove()
        end
    end
    
    if !mode.LoopSound then
        if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
            self:EmitSound(mode.Sound, 100, 50)
        else
            self:EmitSound(mode.Sound, 100)
        end
    else
        if mode.LoopStartSound != nil && !self.DidLoopStart then
            self:EmitSound(mode.LoopStartSound, 100)
            self.DidLoopStart = true
        end
        if self.LoopSound == nil then
            local filter
            if SERVER then
                filter = RecipientFilter()
                filter:AddAllPlayers()
            end
            self.LoopSound = CreateSound(self, mode.Sound, filter)
            self.LoopSound:SetSoundLevel(100)
            if self.LoopSound != nil then
                self.LoopSound:Play()
            end
            
        else
            if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
                self.LoopSound:ChangePitch(50, 0)
            else
                self.LoopSound:ChangePitch(100, 0)
            end
        end
    end
    self.Owner:ViewPunch(Angle(self:RandomRange(-mode.Recoil/2, mode.Recoil/2) , self:RandomRange(-mode.Recoil/2, mode.Recoil/2), 0)) 
    self:TakePrimaryAmmo(mode.TakeAmmo)

    self:ShootEffects()
    
    if (self.Owner:IsPlayer()) then
        self.Owner:SetLastAttackTime()
    end

    if self.Attack2Anim != nil && mode == self.Secondary then
        self:SendWeaponAnim(self.Attack2Anim)
    elseif self.AttackAnim != ACT_VM_PRIMARYATTACK then
        self:SendWeaponAnim(self.AttackAnim)
    end
    
    self:DoFireDelay(mode)
    self:SetMMBase_OverChargeTime(0)
    self:SetMMBase_OverChargeAmount(self:GetMMBase_OverChargeAmount() + mode.OverChargeAmount)
    
    if (mode.SpecialCooldown != 0) then
        self.Owner:SetWeaponCooldown(self, mode.SpecialCooldown)
    end
end

function SWEP:MM_ShootCustom(mode)
end

function SWEP:MM_ShootSpiral(mode)
    if !self.Owner:IsOnGround() then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    if self:Clip1() == 0 || (mode.TakeAmmoAffectsShootability && self:Clip1()-mode.TakeAmmo < 0) then 
        if (GetConVar("mm_autoreload") != nil && !GetConVar("mm_autoreload"):GetBool()) then
            self:EmitSound("weapons/shotgun/shotgun_empty.wav", 75, 100, 1, CHAN_ITEM) 
            self:SetMMBase_ShootTimer(CurTime() + 0.2)
        end
        return
    end
    
    for i=1, mode.NumberofShots do
        local bullet = {}
        bullet.Num = 1
        bullet.Src = self.Owner:GetShootPos() 
        bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
        
        // Bullet spread
        local ang = ((self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles())+Angle(0,0,0))
        local randang = (i/mode.NumberofShots)
        ang.p = ang.p + randang*math.sin((i/mode.NumberofShots)*2*math.pi+randang)*mode.Spread*(1+boolToNumber(self.Owner:MissingAnArm())*2)
        ang.y = ang.y + randang*math.cos((i/mode.NumberofShots)*2*math.pi+randang)*mode.Spread*(1+boolToNumber(self.Owner:MissingAnArm())*2)
        //ang.p = ang.p*(1+boolToNumber(self.Owner:MissingAnArm())*3)
        //ang.y = ang.y*(1+boolToNumber(self.Owner:MissingAnArm())*3)
        bullet.Spread = Vector(0, 0, 0)
        bullet.Dir = ang:Forward()
        if (self.SlowMoTracer && game.GetTimeScale() < 1) then
            bullet.TracerName = "mm_slowmotracer"
        else
            bullet.TracerName = self.TracerName
        end
        bullet.Force = 1
        bullet.Damage = mode.Damage 
        bullet.AmmoType = mode.Ammo 
        bullet.Distance = mode.Range
        bullet.Callback = function(attacker, tr, dmginfo)
            self:MM_BulletCallback(attacker, tr, dmginfo, mode)
        end
        self.Owner:FireBullets(bullet)
    end
     
    self:ShootEffects()

    if self.Owner:HasStatusEffect(STATUS_GOREJARED) then
        self:EmitSound(mode.Sound, 100, 50)
    else
        self:EmitSound(mode.Sound, 100)
    end
    
    if self.AutoReload then
        self:SetMMBase_ReloadAutoTimer(CurTime()+self.AutoReloadTime)
    end
    
    if self.MakeThumperDust then
        local effectdata = EffectData()
        effectdata:SetOrigin(self.Owner:GetPos())
        effectdata:SetScale(128)
        util.Effect("ThumperDust", effectdata)
    end
    
    if (self.Owner:IsPlayer()) then
        self.Owner:SetLastAttackTime()
    end
    
    self.Owner:ViewPunch(Angle(self:RandomRange(-mode.Recoil/2, mode.Recoil/2) , self:RandomRange(-mode.Recoil/2, mode.Recoil/2), 0)) 
    self:SetClip1(math.Clamp(self:Clip1()-mode.TakeAmmo, 0, self:GetMaxClip1()))
    self:DoFireDelay(mode)
end

function SWEP:AdjustMouseSensitivity()
    local maxrange
    if self.Primary.UseRange then
        maxrange = math.min(768, self.Primary.Range)
    else
        maxrange = 768
    end
    
    local ent = self.Owner:GetEyeTrace().Entity
    if ent != nil && ent:IsPlayer() && ent:GetPos():Distance(self.Owner:GetPos()) < maxrange && !ent:HasStatusEffect(STATUS_INVISIBLE) then
        return 0.375
    else
        return 1
    end
end

SWEP.originalXHairSize = -1
SWEP.originalXHairSizeCharge = -1
function SWEP:Think()
    BaseClass.Think(self)

    if self.LoopSound != nil then
        if (self.Secondary.BurstFire && self:GetMMBase_BurstCount() == 0) || self:Clip1() == 0 || !self.Primary.BurstFire && !self.Secondary.BurstFire && !self.Owner:KeyDown(IN_ATTACK) then
            self.LoopSound:Stop()
            self.LoopSound = nil
            if self.Primary.LoopEndSound != nil then
                self:EmitSound(self.Primary.LoopEndSound) 
                self.DidLoopStart = false
                if self.AttackAnimStop != nil then
                    self:SendWeaponAnim(self.AttackAnimStop)
                end
            end
            if self.Secondary.LoopEndSound != nil then
                self:EmitSound(self.Secondary.LoopEndSound) 
                self.DidLoopStart = false
                if self.AttackAnimStop != nil then
                    self:SendWeaponAnim(self.AttackAnimStop)
                end
            end
        end
    end
    
    if self.AutoReload then
        if self:Clip1() != self:GetMaxClip1() && self:GetMMBase_ShootTimer() == 0 && self:GetMMBase_Windup() == 0 then
            if self:GetMMBase_ReloadAutoTimer() < CurTime() then
                self:SetClip1(math.min(self:Clip1()+self.ReloadAmount, self:GetMaxClip1()))
                self:SetMMBase_ReloadAutoTimer(CurTime()+self.AutoReloadTime)
            end
        end
    end
    
    if self.UseWindup then
        if (self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2)) && self.Owner:IsOnGround() && self:Clip1() != 0 then
            if self:GetMMBase_Windup() == 0 && self:GetMMBase_ReloadTimer() == 0 && self:GetMMBase_ShootTimer() == 0 then
                self:SetMMBase_ShootTimer(CurTime()+1)
                self:SetMMBase_Windup(CurTime()+1)
                self:EmitSound(self.WindupStartSound) 
                self:SendWeaponAnim(self.ChargeAnim)
            end
            if self:GetMMBase_Windup() != 0 && self:GetMMBase_Windup() < CurTime() then
                if self.Owner:KeyDown(IN_ATTACK) then
                    self:PrimaryAttack()
                    self:SetMMBase_Charge(100)
                elseif self:GetMMBase_Charge() != 0 then
                    self:SetMMBase_Charge(0)
                    self.DidLoopStart = false
                    self:EmitSound(self.WindupLoopSound) 
                    self:SendWeaponAnim(self.ChargeLoopAnim)
                    self:SetMMBase_ShootTimer(CurTime()+0.1)
                end
            else
                self:SetMMBase_Charge(100)
            end
        elseif self:GetMMBase_Windup() != 0 then
            self:SetMMBase_Windup(0)
            self:SetMMBase_Charge(0)
            self.DidLoopStart = false
            self:EmitSound(self.WindupEndSound) 
            self:SendWeaponAnim(self.UnchargeAnim)
        end
    end
    
    if (self:Clip1() == 0 ||
        (self.Primary.BurstFire && self:GetMMBase_BurstCount() == self.Primary.BurstCount) || (self.Secondary.BurstFire && self:GetMMBase_BurstCount() == self.Secondary.BurstCount) ||
        (self.Primary.BurstFire && self.Primary.TakeAmmoAffectsShootability && self:Clip1() < self.Primary.TakeAmmo) || (self.Secondary.BurstFire && self.Secondary.TakeAmmoAffectsShootability && self:Clip1() < self.Secondary.TakeAmmo)) then
        self:SetMMBase_BurstCount(0)
    elseif (self:GetMMBase_BurstCount() != 0) then
        if self:GetMMBase_ShootTimer() < CurTime() && self.Primary.BurstFire then
            self:DoAttack(self.Primary)
        end
        if self:GetMMBase_ShootTimer() < CurTime() && self.Secondary.BurstFire then
            self:DoAttack(self.Secondary)
        end
    end
    
    if self.originalXHairSize == -1 then
        self.originalXHairSize = self.CrosshairSize
        self.originalXHairSizeCharge = self.CrosshairChargeSize
    end
    
    if (self.Primary.SpecialCooldownGivesAmmo || self.Secondary.SpecialCooldownGivesAmmo) && self.Owner:GetWeaponCooldown(self) == 0 then
        if self.ReloadAmount != -1 then
            self:SetClip1(math.min(self:Clip1() + self.ReloadAmount, 6))
        else
            self:SetClip1(self:GetMaxClip1())
        end
    end

    if IsValid(self.Owner) then
        if self:Clip1() != 0 && self.Owner:IsOnGround() && self:GetMMBase_ReloadTimer() == 0 && self:GetMMBase_ShootTimer() == 0 && !self.UseWindup then 
            if self.Primary.Chargeup && self.Secondary.ChargeCancel && self.Owner:KeyDown(IN_ATTACK2) then
            
                if self.Primary.ChargeEmptyShoot then
                    self:SetMMBase_Charge(0)
                end
                if self.Primary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                end
                if (self.Primary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
                if self.Secondary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                end
                if (self.Secondary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
                self:SetMMBase_ShootTimer(CurTime() + 0.5)
            elseif self.Primary.Chargeup && self.Owner:KeyDown(IN_ATTACK) && self:Clip1() >= self.Primary.TakeAmmo then
                local maxcharge = 100
                if (self.Primary.ChargeDependsAmmo) then
                    maxcharge = self:Clip1()
                end
                
                if self:GetMMBase_Charge() == 0 then
                    if self.ChargeAnim != nil then
                        self:SendWeaponAnim(self.ChargeAnim)
                    end
                    if self.Primary.LoopStartSound != nil && !self.DidLoopStart then
                        self:EmitSound(self.Primary.LoopStartSound, 100)
                        self.DidLoopStart = true
                    end
                    if self.Primary.Zoom then
                        self.Owner:SetFOV(self.Primary.ZoomMax, 1.5)
                    end
                end
                if self:GetMMBase_Charge() < maxcharge then
                    self:SetMMBase_Charge(self:GetMMBase_Charge()+self.Primary.ChargeTime)
                end
                if self:GetMMBase_Charge() >= maxcharge then
                    self:SetMMBase_Charge(maxcharge)
                    if maxcharge == 100 && self.Primary.OverChargeTime != 0 && self:GetMMBase_OverChargeTime() == 0 then
                        self:SetMMBase_OverChargeTime(CurTime()+self.Primary.OverChargeTime)
                        self:EmitSound(self.Primary.OverChargeWarningSound)
                    end
                    if self:GetMMBase_OverChargeTime() != 0 && self:GetMMBase_OverChargeTime() < CurTime() then
                        self:ExplodePlayer()
                    end
                    if (self.Primary.ChargeShootMax) then
                        self:PrimaryAttack()
                    end
                end
                if self.Primary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize/(1+self:GetMMBase_Charge()/100)
                    self.CrosshairChargeSize = self.originalXHairSizeCharge/(1+self:GetMMBase_Charge()/100)
                end
                self.Owner:SetWalkSpeed(self.ChargeSpeed)
                self.Owner:SetRunSpeed(self.ChargeSpeed)
                
            elseif self.Primary.Chargeup && self:GetMMBase_Charge() != 0 && self.Owner:KeyReleased(IN_ATTACK) then
            
                self:PrimaryAttack()
                self:SetMMBase_Charge(0)
                self.DidLoopStart = false
                if self.Primary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                    self.CrosshairChargeSizeSize = self.originalXHairSizeCharge
                end
                if (self.Primary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
                
            end
            
            if self.Secondary.Chargeup && self.Primary.ChargeCancel && self.Owner:KeyDown(IN_ATTACK) then
                self:SetMMBase_Charge(0)
                if self.Primary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                end
                if (self.Primary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
                if self.Secondary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                end
                if (self.Secondary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
                self:SetMMBase_ShootTimer(CurTime() + 0.5)
            elseif self.Secondary.Chargeup && self.Owner:KeyDown(IN_ATTACK2) && self:Clip1() >= self.Secondary.TakeAmmo then
                local maxcharge = 100
                if (self.Secondary.ChargeDependsAmmo) then
                    maxcharge = self:Clip1()
                end
            
                if self:GetMMBase_Charge() == 0 then
                    if self.ChargeAnim != nil then
                        self:SendWeaponAnim(self.ChargeAnim)
                    end
                    if self.Secondary.LoopStartSound != nil && !self.DidLoopStart then
                        self:EmitSound(self.Secondary.LoopStartSound, 100)
                        self.DidLoopStart = true
                    end
                    if self.Secondary.Zoom then
                        self.Owner:SetFOV(self.Secondary.ZoomMax, 1.5)
                    end
                end
                if self:GetMMBase_Charge() < maxcharge then
                    self:SetMMBase_Charge(self:GetMMBase_Charge()+self.Secondary.ChargeTime)
                end
                if self:GetMMBase_Charge() >= maxcharge then
                    self:SetMMBase_Charge(maxcharge)
                    if maxcharge == 100 && self.Secondary.OverChargeTime != 0 && self:GetMMBase_OverChargeTime() == 0 then
                        self:SetMMBase_OverChargeTime(CurTime()+self.Secondary.OverChargeTime)
                        self:EmitSound(self.Secondary.OverChargeWarningSound)
                    end
                    if self:GetMMBase_OverChargeTime() != 0 && self:GetMMBase_OverChargeTime() < CurTime() then
                        self:ExplodePlayer()
                    end
                    if (self.Secondary.ChargeShootMax) then
                        self:SecondaryAttack()
                    end
                end
                if self.Secondary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize/(1+self:GetMMBase_Charge()/100)
                    self.CrosshairChargeSize = self.originalXHairSizeCharge/(1+self:GetMMBase_Charge()/100)
                end
                if IsValid(self.Owner) then
                    self.Owner:SetWalkSpeed(self.ChargeSpeed)
                    self.Owner:SetRunSpeed(self.ChargeSpeed)
                end
            elseif self.Secondary.Chargeup && self:GetMMBase_Charge() != 0 && self.Owner:KeyReleased(IN_ATTACK2) then
                self:SecondaryAttack()
                self:SetMMBase_Charge(0)
                self.DidLoopStart = false
                if self.Secondary.ChargeShrinksXHair then
                    self.CrosshairSize = self.originalXHairSize
                    self.CrosshairChargeSizeSize = self.originalXHairSizeCharge
                end
                if (self.Secondary.Zoom) then
                    self.Owner:SetFOV(0, 0)
                end
            end
            
        else
            if (!self.Owner:KeyDown(IN_ATTACK) || self.Primary.ChargeEmptyShoot) && !self.UseWindup then
                self:SetMMBase_Charge(0)
            end
            if self.Primary.ChargeShrinksXHair then
                self.CrosshairSize = self.originalXHairSize
            end
            if (self.Primary.Zoom) then
                self.Owner:SetFOV(0, 0)
            end
            if self.Secondary.ChargeShrinksXHair then
                self.CrosshairSize = self.originalXHairSize
            end
            if (self.Secondary.Zoom) then
                self.Owner:SetFOV(0, 0)
            end
        end
    end
end

function SWEP:Reload()
    if !self.CanReload then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    if self:Clip1() >= self:GetMaxClip1() then return end

    if self.ShotgunReload then
        self.Owner:SetAnimation(PLAYER_RELOAD)
        self:SendWeaponAnim(self.ShotgunReloadAnimIn)
        
        if self.Owner:MissingAnArm() && self.ReloadSlowedByArm then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
        end
        
        local time = self.Owner:GetViewModel():SequenceDuration()/self.Owner:GetViewModel():GetPlaybackRate()
        self:SetMMBase_ReloadTimer(CurTime() + time*10)
        self:SetMMBase_ReloadShotgunTimer(CurTime() + time)
        self:SetMMBase_ReloadShotgunState(1)
    else
        self.Owner:SetAnimation(PLAYER_RELOAD)
        self:SendWeaponAnim(self.ReloadAnim)
        
        if self.Owner:MissingAnArm() && self.ReloadSlowedByArm then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
        end

        local time = self.Owner:GetViewModel():GetPlaybackRate()
        self:SetMMBase_ReloadTimer(CurTime() + self.Owner:GetViewModel():SequenceDuration()/time)
        
        if (self:Clip1() == 0) then
            self:SetMMBase_ReloadTimerAmmo(CurTime() + self.ReloadOutTime/time + self.ReloadInTime/time)
        else
            self:SetMMBase_ReloadTimerAmmo(CurTime() + self.ReloadOutTime/time)
        end
    end
end

function SWEP:LookingAtShootable()
    local tr = LocalPlayer():GetEyeTrace()
    if (tr.Entity:IsPlayer() && !tr.Entity:HasStatusEffect(STATUS_INVISIBLE) && ((self.Owner:Team() == TEAM_COOPMONST && tr.Entity:Team() != self.Owner:Team()) || (self.Owner:Team() == TEAM_COOPOTHER && tr.Entity:Team() != self.Owner:Team()) || (tr.Entity:Team() == TEAM_MONST))) then
        if self.Primary.UseRange then
            return tr.HitPos:Distance(tr.StartPos) < self.Primary.Range
        elseif self.Secondary.UseRange then
            return tr.HitPos:Distance(tr.StartPos) < self.Secondary.Range 
        else
            return true
        end
    end
    return false
end

function SWEP:DoImpactEffect(tr, nDamageType)
    if self.ImpactEffect != "" || (tr.Entity:IsPlayer() && !self.ImpactEffectOnPlayers) then
        if tr.Entity:IsPlayer() && IsFirstTimePredicted() then
            local ply = tr.Entity
            local effectdata = EffectData()
            effectdata:SetOrigin(tr.HitPos + tr.HitNormal)
            effectdata:SetNormal(tr.HitNormal)
            effectdata:SetStart(tr.HitPos + tr.HitNormal)
            effectdata:SetScale(0.75)
            
            if self.ImpactEffectOnPlayers then
                local effectdata = EffectData()
                effectdata:SetOrigin(tr.HitPos)
                effectdata:SetNormal(tr.HitNormal)
                util.Effect(self.ImpactEffect, effectdata)
            end
            
            if (IsValid(ply) && ply:IsPlayer() && ply:GetCharacter() != nil) then
                if (ply:GetCharacter().bloodtype == BLOODTYPE_NONE) then
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                elseif (ply:GetCharacter().bloodtype == BLOODTYPE_HAY) then
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                    util.Effect("WheelDust", effectdata)
                elseif (ply:GetCharacter().bloodtype == BLOODTYPE_GREEN) then
                    util.Effect("AntlionGib", effectdata)
                else
                    if (GetConVar("mm_confetti"):GetBool()) then
                        util.Effect("mm_confetti", effectdata)
                    else
                        util.Effect("BloodImpact", effectdata)
                        local startp = tr.HitPos
                        local endp = startp + tr.Normal*50
                        local traceinfo = {
                            start = startp, 
                            endpos = endp, 
                            filter = tr.Entity, 
                            mask = MASK_SOLID_BRUSHONLY
                        }
                        
                        // Emit the trace and draw the decal
                        local trace = util.TraceHull(traceinfo)
                        local todecal1 = trace.HitPos + trace.HitNormal
                        local todecal2 = trace.HitPos - trace.HitNormal
                        util.Decal("Blood", todecal1, todecal2)
                    end
                end
            end
            return true
        end
        
        local length = (tr.HitPos-tr.StartPos):Length()
        if (self:GetMMBase_LastShotType() == 1 && self.Primary.UseRange && length > self.Primary.Range) then return true end
        if (self:GetMMBase_LastShotType() == 2 && self.Secondary.UseRange && length > self.Secondary.Range) then return true end
        local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos)
        effectdata:SetNormal(tr.HitNormal)
        util.Effect(self.ImpactEffect, effectdata)
        if (type(self.ImpactDecal) == "table" || self.ImpactDecal != "") && !tr.Entity:IsPlayer() && CLIENT then
            if type(self.ImpactDecal) == "table" then
                util.DecalEx(self.ImpactDecal[math.random(1, #self.ImpactDecal-1)], tr.Entity, tr.HitPos, tr.HitNormal, Color(255, 255, 255, 255), self.ImpactDecalSize, self.ImpactDecalSize)
            else
                util.DecalEx(self.ImpactDecal, tr.Entity, tr.HitPos, tr.HitNormal, Color(255, 255, 255, 255), self.ImpactDecalSize, self.ImpactDecalSize)
            end
        end
        return true
    else
        return false
    end
end

hook.Add("StartCommand", "DisableCrouchWithMusket", function(ply, cmd)

    if IsValid(ply) && ply:Alive() && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon() != nil && ply:GetActiveWeapon().IsMMGun then
        
        if (!ply:GetActiveWeapon().Primary.ChargeCrouch || !ply:GetActiveWeapon().Primary.ChargeCrouch) && ply:GetActiveWeapon():GetMMBase_Charge() != 0 then
            cmd:RemoveKey(IN_DUCK)
        end
    end

end)

function SWEP:FireAnimationEvent(pos, ang, event, options)

	-- Disables animation based muzzle event
	if (event == 5001) then 
        if self.MuzzleEffect != "" then
            local fx = EffectData();
            fx:SetOrigin(self.Owner:GetShootPos());
            fx:SetEntity(self);
            fx:SetStart(self.Owner:GetShootPos());
            fx:SetNormal(self.Owner:GetAimVector());
            fx:SetAttachment(1);
            util.Effect(self.MuzzleEffect, fx);
        end
        return true 
    end	

	-- Disable thirdperson muzzle flash
	if (event == 5003) then return true end

end

hook.Add("StartCommand", "MM_GunBaseAutoReload", function(ply, cmd)
    if (CLIENT && ply:GetActiveWeapon() != nil && ply:GetActiveWeapon().Base == "weapon_mm_basegun" && GetConVar("mm_autoreload"):GetBool() && ply:GetActiveWeapon():Clip1() == 0) then
        cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_RELOAD))
    end
end)  