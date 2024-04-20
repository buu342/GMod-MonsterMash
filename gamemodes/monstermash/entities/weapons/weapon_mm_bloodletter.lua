AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Blood Letter"

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false


SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/monstermash/c_bloodletter.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_bloodletter.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.SelectIcon = Material("vgui/entities/mm_bloodletter")
SWEP.Cost = 55
SWEP.Points = 25
SWEP.KillFeed = "%a sucked %v dry."
 
SWEP.Primary.Sound         = Sound("weapons/bloodletter/bloodletter_fire.wav")
SWEP.Primary.Damage        = 7
SWEP.Primary.TakeAmmo      = 1
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Spread        = 0.165
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.Recoil        = 0.2875
SWEP.Primary.Delay         = 0.125

SWEP.Secondary.ClipSize        = 0
SWEP.Secondary.DefaultClip     = 0
SWEP.Secondary.FireMode        = FIREMODE_CUSTOM
SWEP.Secondary.Automatic       = false
SWEP.Secondary.Ammo            = "none"
SWEP.Secondary.SpecialCooldown = 15

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 1024

SWEP.HoldType         = "rpg" 
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_revolver")
SWEP.CrosshairSize = 40

SWEP.ReloadOutTime = 0.8
SWEP.ReloadInTime  = 1.2

SWEP.TracerName = "mm_undertakertracer"
SWEP.MuzzleEffect = ""
SWEP.EjectEffect = ""

SWEP.CrosshairRechargeMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairRechargeSize     = 96

SWEP.Attack2Anim = ACT_VM_SECONDARYATTACK

SWEP.StackTable = {}

function SWEP:MM_BulletCallback(attacker, tr, dmginfo, mode)
    BaseClass.MM_BulletCallback(self, attacker, tr, dmginfo, mode)
    if (tr.Entity:IsPlayer()) then
        self:IncreaseWeaponDamageScale(tr.Entity)
    end
end

function SWEP:MM_ShootCustom(mode)
    if !self.Owner:IsOnGround() then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    if (mode.SpecialCooldown != 0 && self.Owner:GetWeaponCooldown(self) > 0) then return end
    if table.IsEmpty(self.StackTable) then return end
    for k, v in pairs(self.StackTable) do
        if (SERVER) then
            local damage = self.Primary.Damage*self:GetWeaponDamageScale(k)
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker(self.Owner)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(damage)
            dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_BLEED))
            k:TakeDamageInfo(dmginfo)
            k:EmitSound("weapons/bloodletter/bloodletter_dart_explosion.wav")
            self.Owner:SetHealth(math.min(self.Owner:Health() + damage, self.Owner:GetMaxHealth()))
        end
        self:ResetWeaponDamageScale(k)
    end
    
    self.Owner:SetLastAttackTime()
    self:SendWeaponAnim(self.Attack2Anim)
    
    if (mode.SpecialCooldown != 0) then
        self.Owner:SetWeaponCooldown(self, mode.SpecialCooldown)
    end
end

function SWEP:GetWeaponDamageScale(ply)
    return self.StackTable[ply]
end

function SWEP:IncreaseWeaponDamageScale(ply)
    if (self.StackTable[ply] == nil) then
        self.StackTable[ply] = 1
        return
    end
    self.StackTable[ply] = self.StackTable[ply] + 1
end

function SWEP:ResetWeaponDamageScale(ply)
    self.StackTable[ply] = nil
end

hook.Add("PlayerDeath", "MM_BloodLetterResetScaling", function(ply)
    for k, v in pairs(player.GetAll()) do
        for i, j in pairs(v:GetWeapons()) do
            if (j:GetClass() == "weapon_mm_bloodletter") then
                j:ResetWeaponDamageScale(ply)
                break
            end
        end
    end
end)