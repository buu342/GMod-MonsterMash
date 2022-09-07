AddCSLuaFile()
DEFINE_BASECLASS("weapon_mm_basemelee")

SWEP.PrintName = "Werewolf Claws"

SWEP.SelectIcon = Material("vgui/entities/mm_boner")
SWEP.Cost = 5
SWEP.Points = 75
SWEP.KillFeed = "%a clawed through %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel			= "models/weapons/monstermash/v_boner.mdl"
SWEP.WorldModel			= "models/weapons/monstermash/w_boner.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 45
SWEP.Primary.Recoil         = Angle(2,0,0)
SWEP.Primary.Delay          = 0.62
SWEP.Primary.SwingSound     = Sound("weapons/bone/swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/bone/boner1.wav"), Sound("weapons/bone/boner2.wav")}

SWEP.HoldType         = "passive" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach     = 50

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood = true
SWEP.DecalUse	= true

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 100

SWEP.KillFlags = KILL_BIFURCATE

function SWEP:ShouldDropOnDie() 
	return false
end

function SWEP:OnDrop()
    if (IsValid(self)) then
        self:Remove()
    end
end