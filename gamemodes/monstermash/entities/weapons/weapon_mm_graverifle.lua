AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basegun")

SWEP.PrintName = "Tormentor"

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false


SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_graverifle.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_graverifle.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.SelectIcon = Material("vgui/entities/mm_graverifle")
SWEP.Cost = 50
SWEP.Points = 25
SWEP.KillFeed = "%a tormented %v to death."
 
SWEP.Primary.Sound            = "weapons/tormentor/tormentor_fire.wav" 
SWEP.Primary.Damage           = 20
SWEP.Primary.TakeAmmo         = 1
SWEP.Primary.ClipSize         = 7
SWEP.Primary.Spread           = 0
SWEP.Primary.NumberofShots    = 1
SWEP.Primary.Automatic        = true
SWEP.Primary.Recoil           = 0.3
SWEP.Primary.Delay            = 0.375
SWEP.Primary.FireMode         = FIREMODE_PROJECTILE
SWEP.Primary.ProjectileEntity = "sent_mm_seeker"
SWEP.Primary.ProjectileTarget = true
SWEP.Primary.ProjectileForce  = 400
SWEP.Primary.ProjectilePassDamage = true

SWEP.Secondary.Damage      = 20
SWEP.Secondary.Delay       = 1
SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.FireMode    = FIREMODE_CUSTOM
SWEP.Secondary.Range       = 64
SWEP.Secondary.SwingSound     = Sound("weapons/tormentor/tormentor_stab.wav")
SWEP.Secondary.SwingHitSound  = {Sound("weapons/axe/hit1.wav"), Sound("weapons/axe/hit2.wav"), Sound("weapons/axe/hit3.wav")}

SWEP.HoldType         = "rpg"
SWEP.HoldTypeAttack   = "rpg"
SWEP.HoldTypeAttack2  = "knife"
SWEP.HoldTypeReload   = "ar2"
SWEP.HoldTypeCrouch   = "ar2"

SWEP.CrosshairMaterial = Material("vgui/hud/crosshair_carbine")
SWEP.CrosshairSize = 100

SWEP.ReloadOutTime = 0.5
SWEP.ReloadInTime  = 2.1

SWEP.ScaleTable = {}

function SWEP:MM_ShootCustom(mode)
    if !self.Owner:IsOnGround() then return end
    if self:GetMMBase_ReloadTimer() != 0 || self:GetMMBase_ShootTimer() != 0 then return end
    local BoxSize = 10
    local tr = util.TraceLine({
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * mode.Range,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    })
 
    if (!IsValid(tr.Entity)) then
        tr = util.TraceHull({
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * mode.Range,
            filter = self.Owner,
            mins = Vector(-BoxSize, -BoxSize, -BoxSize),
            maxs = Vector(BoxSize, BoxSize, BoxSize),
            mask = MASK_SHOT_HULL
        })
    end
    
    if (self.Owner:MissingRightArm()) then
        self.HoldTypeAttack2  = "fist"
    end
    self.Owner:SetLastAttackTime()
    self:EmitSound(mode.SwingSound)
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    self:SetMMBase_ShootTimer(CurTime() + mode.Delay)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    if tr.Hit then
        if type(mode.SwingHitSound) == "table" then
            local snd = table.Random(mode.SwingHitSound)
            self:EmitSound(snd)
        else
            if mode.SwingHitSound != nil then
                self:EmitSound(mode.SwingHitSound)
            end
        end 
        
        if SERVER then
            local dmginfo = DamageInfo()
            local attacker = self.Owner
            local damage = mode.Damage
            local addedkillflag1 = false
            local addedkillflag2 = false
            if (!IsValid(attacker)) then attacker = self end
            dmginfo:SetAttacker(attacker)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(damage)
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_BLEED))
            tr.Entity:TakeDamageInfo(dmginfo)
        end
        
        // Push the physics object around
        local phys = tr.Entity:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:ApplyForceOffset(self.Owner:GetAimVector()*80*phys:GetMass(), tr.HitPos)
        end
    end
    
    if self.DoViewPunch then
        self.Owner:ViewPunch(mode.Recoil)
    end
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * (mode.Range+10.7))
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)
    if (trace.Hit) then
        bullet = {}
        bullet.Num    = 1
        bullet.Src    = self.Owner:GetShootPos()
        local direc = self.Owner:GetAimVector()
        direc = direc + self.Owner:GetForward() * 0
        direc = direc + self.Owner:GetRight() * 0
        direc = direc + self.Owner:GetUp() * 0
        bullet.Dir    = direc
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force  = 1
        bullet.Damage = 0
        self.Owner:FireBullets(bullet) 
    end
end

function SWEP:GetWeaponDamageScale(ply)
    if (self.ScaleTable[ply] == nil) then
        self.ScaleTable[ply] = 1
    end
    return self.ScaleTable[ply]
end

function SWEP:IncreaseWeaponDamageScale(ply)
    self.ScaleTable[ply] = self.ScaleTable[ply] + 1
end

function SWEP:ResetWeaponDamageScale(ply)
    self.ScaleTable[ply] = 1
end

hook.Add("PlayerDeath", "MM_GraveRifleResetScaling", function(ply)
    for k, v in pairs(player.GetAll()) do
        for i, j in pairs(v:GetWeapons()) do
            if (j:GetClass() == "weapon_mm_graverifle") then
                j:ResetWeaponDamageScale(ply)
                break
            end
        end
    end
end)