SWEP.SelectIcon = "vgui/entities/mm_revolver"
SWEP.Cost = 15
SWEP.Points = 40

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )

local soundData = {
    name   = "Weapon_686.HammerBack" ,
    channel  = CHAN_WEAPON,
    volume   = 0.7,
    soundlevel  = 100,
    pitchstart  = 100,
    pitchend  = 100,
    sound   = "weapons/revolver/magnum_close.wav"
}
sound.Add(soundData)

local soundData = {
    name   = "Weapon_686.Load_3" ,
    channel  = CHAN_WEAPON,
    volume   = 0.7,
    soundlevel  = 100,
    pitchstart  = 100,
    pitchend  = 100,
    sound   = "weapons/revolver/magnum_dump.wav"
}
sound.Add(soundData)

local soundData = {
    name   = "Weapon_686.Load_6" ,
    channel  = CHAN_WEAPON,
    volume   = 0.7,
    soundlevel  = 100,
    pitchstart  = 100,
    pitchend  = 100,
    sound   = "weapons/revolver/magnum_insert.wav"
}
sound.Add(soundData)

game.AddAmmoType( { 
 name = "ammo_revolver",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Revolver"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_revolver.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_revolver.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "revolver" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/revolver/fire1.wav" 
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6 
SWEP.Primary.Ammo = "ammo_revolver"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 0.8
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseDistance = true
SWEP.ShootDistance = 1152