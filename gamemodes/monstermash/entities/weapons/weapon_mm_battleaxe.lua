AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basemelee" )

SWEP.PrintName = "Battle Axe"

SWEP.SelectIcon = Material("vgui/entities/mm_battleaxe")
SWEP.Cost = 50
SWEP.Points = 20
SWEP.KillFeed = "%a went medieval on %v."

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel	   = "models/weapons/monstermash/v_battleaxe.mdl"
SWEP.WorldModel	   = "models/weapons/monstermash/w_battleaxe.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.Base = "weapon_mm_basemelee"

SWEP.Primary.Damage         = 125
SWEP.Primary.Recoil         = Angle(0,5,0)
SWEP.Primary.Delay          = 2
SWEP.Primary.SwingSound     = Sound("crowbar/iceaxe_swing1.wav")
SWEP.Primary.SwingHitSound  = {Sound("weapons/axe/hit1.wav"), Sound("weapons/axe/hit2.wav"), Sound("weapons/axe/hit3.wav")}

SWEP.HoldType         = "melee2" 
SWEP.HoldTypeAttack   = "melee2"

SWEP.SwingTime = 0.35
SWEP.Reach     = 70

SWEP.DecalLeaveBullethole = false
SWEP.DecalMakeBlood       = true
SWEP.DecalUse	          = true
SWEP.DecalDirection       = 1
SWEP.DecalSpeed           = 0.04

SWEP.BleedChance     = 100
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 100
SWEP.BurnChance      = 0

SWEP.KillFlags = KILL_BIFURCATE

hook.Add("PlayerSpawn", "MM_BattleAxeHP", function(ply)
    timer.Simple(0, function() 
        if !IsValid(ply) then return end
        if ply:HasWeapon("weapon_mm_battleaxe") then
            ply:SetMaxHealth(125)
            ply:SetHealth(125)
        else
            ply:SetMaxHealth(100)
        end
    end)
end)