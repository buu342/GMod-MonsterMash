SWEP.SelectIcon = "vgui/entities/mm_sawedoff"
SWEP.Cost = 30
SWEP.Points = 40

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )

game.AddAmmoType( { 
 name = "ammo_shotgun",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Sawed-Off"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/monstermash/c_sawedoff.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_sawedoff.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "pistol" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/coachgun/fire2.wav" 
SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 2 
SWEP.Primary.Ammo = "ammo_shotgun"
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Spread = 1.2
SWEP.Primary.NumberofShots = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 6
SWEP.Primary.Delay = 0.5
SWEP.Primary.Force = 2
SWEP.Primary.DrawCrosshair = false

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseDistance = true
SWEP.ShootDistance = 320