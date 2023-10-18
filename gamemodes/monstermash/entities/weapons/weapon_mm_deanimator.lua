AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "De-Animator"

SWEP.SelectIcon = Material("vgui/entities/mm_deanimator")
SWEP.Cost = 70
SWEP.Points = 10
SWEP.KillFeed = "%a gave %v a jolt from their electrode."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_deanimator.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_deanimator.mdl" 
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound            = "weapons/deanimator/plasma.wav"
SWEP.Primary.Damage           = 10
SWEP.Primary.TakeAmmo         = 5
SWEP.Primary.ClipSize         = 100
SWEP.Primary.Spread           = 0.1625
SWEP.Primary.NumberofShots    = 1
SWEP.Primary.Automatic        = true
SWEP.Primary.Recoil           = 0.25
SWEP.Primary.Delay            = 0.1    
SWEP.Primary.OverChargeAmount = 15
SWEP.Primary.Magnetism        = false

SWEP.Secondary.Sound       = "ambient/levels/labs/electric_explosion1.wav"
SWEP.Secondary.LoopStartSound = Sound("npc/attack_helicopter/aheli_charge_up.wav")
SWEP.Secondary.TakeAmmo    = 1
SWEP.Secondary.Recoil      = 10
SWEP.Secondary.Delay       = 1
SWEP.Secondary.Damage      = 125
SWEP.Secondary.Spread      = 0.001
SWEP.Secondary.ClipSize    = 1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.FireMode    = FIREMODE_CUSTOM
SWEP.Secondary.Chargeup    = true
SWEP.Secondary.ChargeTime  = 0.8
SWEP.Secondary.ChargeEarly = true
SWEP.Secondary.ChargeDependsAmmo = true
SWEP.Secondary.OverChargeTime = 0.5

SWEP.HoldType         = "shotgun" 
SWEP.HoldTypeAttack   = "shotgun"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "shotgun"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_caution")
SWEP.CrosshairChargeMaterial = Material("vgui/hud/crosshair_caution_fill")
SWEP.CrosshairOverchargeMaterial = Material("vgui/hud/crosshair_caution_fill")
SWEP.CrosshairSize = 64

SWEP.ReloadOutTime = 0.5
SWEP.ReloadInTime  = 1

SWEP.TracerName = "ToolTracer"
SWEP.TracerName2 = "mm_deanimatortracer"
SWEP.ImpactEffect = "MetalSpark"
SWEP.ImpactDecal = Material("decals/scorchfade_subrect") // util.DecalMaterial("FadingScorch")
SWEP.ImpactDecalSize = 0.5
SWEP.ImpactEffectOnPlayers = true

SWEP.MuzzleEffect = "ChopperMuzzleFlash"
SWEP.EjectEffect = ""
SWEP.SlowMoTracer = false

if engine.ActiveGamemode() == "monstermash" then
    SWEP.KillFlags = bit.bor(KILL_GIBTHRESHOLD, KILL_ELECTRIC)
end

function SWEP:MM_ShootCustom(mode)
    
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
    bullet.Src = self.Owner:GetShootPos() 
    bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
    self:ShootEffects()
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    self:EmitSound(self.Secondary.Sound,75,100,1,CHAN_WEAPON)
    bullet.Num = 1
    local traceply = self.Owner:GetEyeTrace()
    bullet.Spread = Vector(self.Secondary.Spread * 0.1 , self.Secondary.Spread * 0.1, 0)
    bullet.Tracer = 1
    bullet.TracerName = self.TracerName2
    bullet.Force = 1
    bullet.Damage = 0
    bullet.AmmoType = self.Primary.Ammo
    bullet.Callback = function(attacker, trace, dmginfo)
        dmginfo:SetInflictor(self)
        local TP = trace.HitPos + trace.HitNormal 
        local TM = trace.HitPos - trace.HitNormal 
        if trace.HitWorld then 
            util.Decal("scorch", TP, TM) 
        end 

        local effectdata = EffectData()
        effectdata:SetOrigin(trace.HitPos)
        util.Effect("ManhackSparks", effectdata)

        util.BlastDamage(self, self.Owner, trace.HitPos, 128, math.max(15, self.Secondary.Damage*(self:GetMMBase_Charge()/100)))

        if SERVER then
            local hBallGen = ents.Create("Prop_combine_ball")
            hBallGen:SetPos(trace.HitPos)
            hBallGen:Spawn()
            hBallGen:Fire("explode","",0)			
            
            for k, v in pairs(player.GetAll()) do
                if v:GetPos():Distance(trace.HitPos) < 128 then
                    v:Ignite(1,1)
                    if v != self.Owner then
                        local pushvel = trace.Normal * 1500
                        pushvel.z = math.Clamp(pushvel.z, 50, 100)
                        v:SetVelocity(v:GetVelocity() + pushvel)
                    end
                end
            end
        end
    end
    self.Owner:SetLastAttackTime()
    self.Owner:SetStatusEffect(STATUS_ELECTROCUTED, nil, 3*(self:GetMMBase_Charge()/100))
    self.Owner:ConCommand("play weapons/electric_machine.wav")
    self.Owner:FireBullets(bullet) 
    self:TakePrimaryAmmo(math.max(20,self:GetMMBase_Charge()))
    self:DoFireDelay(mode)
    self:SetMMBase_OverChargeTime(0)
end