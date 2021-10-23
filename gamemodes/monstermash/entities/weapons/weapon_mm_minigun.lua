AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Minigun"

SWEP.SelectIcon = Material("vgui/entities/mm_minigun")
SWEP.Cost = 65
SWEP.Points = 10
SWEP.KillFeed = "%a gunned %v down in the streets of Detroit."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 45
SWEP.ViewModel = "models/weapons/monstermash/c_minigun.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_minigun.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound            = "weapons/minigun/minigun_fire.wav"
SWEP.Primary.Damage           = 2
SWEP.Primary.TakeAmmo         = 1
SWEP.Primary.ClipSize         = 100
SWEP.Primary.Spread           = 0.5
SWEP.Primary.NumberofShots    = 2
SWEP.Primary.Automatic        = true
SWEP.Primary.Recoil           = 0.3
SWEP.Primary.Delay            = 0.0375
SWEP.Primary.FireMode         = FIREMODE_BULLET
SWEP.Primary.ChargeEmptyShoot = false
SWEP.Primary.Magnetism        = false

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 1536

SWEP.HoldType         = "crossbow" 
SWEP.HoldTypeAttack   = "crossbow"
SWEP.HoldTypeReload   = "crossbow"
SWEP.HoldTypeCrouch   = "crossbow"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairChargeType = CHARGETYPE_NONE
SWEP.CrosshairSize = 96

SWEP.ChargeAnim = ACT_VM_RECOIL2
SWEP.ChargeLoopAnim = ACT_VM_RECOIL1
SWEP.UnchargeAnim = ACT_VM_RECOIL3

SWEP.UseWindup = true
SWEP.WindupStartSound   = Sound("weapons/minigun/minigun_wind_up.wav")
SWEP.WindupLoopSound    = Sound("weapons/minigun/minigun_spin.wav")
SWEP.WindupEndSound     = Sound("weapons/minigun/minigun_wind_down.wav")

SWEP.CanReload = false
SWEP.ReloadAmount = 1
SWEP.AutoReload = true
SWEP.AutoReloadTime = 0.11
SWEP.DamageMultiplierDistance = 320

SWEP.MuzzleEffect = "mm_muzzle"
SWEP.EjectEffect = ""

SWEP.GoreJarDelay = 8

function SWEP:IsShooting()
    return (self.Owner:KeyDown(IN_ATTACK) || self.Owner:KeyDown(IN_ATTACK2))
end

if (CLIENT) then

    local function MM_MinigunBarrel(vm, ply, wep)
        if (wep:GetClass() == "weapon_mm_minigun") then
        
            -- Initialize all the variables
            if (wep.BoneAccel == nil) then
                wep.BoneAccel = 0
            end
            if (wep.BoneAngle == nil) then
                wep.BoneAngle = 0
            end
            if (vm.ManipulatedMinigunBarrel == nil) then
                vm.ManipulatedMinigunBarrel = false
            end
            
            -- If we're not paused
            if (!game.SinglePlayer() || !gui.IsGameUIVisible()) then
            
                -- If we're shooting
                if (wep:IsShooting()) then
                
                    -- Accelerate the barrel and knob
                    wep.BoneAccel = math.Clamp(wep.BoneAccel+FrameTime()*10, 0, 7)

                else
                
                    -- Decelerate the barrel/knob
                    wep.BoneAccel = Lerp(FrameTime()*2, wep.BoneAccel, 0)

                end
                
                -- Set the barrel bone angle to the new angles
                wep.BoneAngle = (wep.BoneAngle+wep.BoneAccel*FrameTime()*130)%360
                
                -- Manipulate the bone angles
                vm:ManipulateBoneAngles(vm:LookupBone("ValveBiped.bone2"), Angle(0,0,wep.BoneAngle))
            end
            
            -- Mark the bone angles as manipulated
            vm.ManipulatedMinigunBarrel = true
        elseif (vm.ManipulatedMinigunBarrel) then
        
            -- Reset all the bone angles
            for i=0, vm:GetBoneCount() do
                vm:ManipulateBoneAngles(i, Angle(0,0,0))
            end
            vm.ManipulatedMinigunBarrel = false
        end
    end
    hook.Add("PreDrawViewModel", "MM_MinigunBarrel", MM_MinigunBarrel)
end