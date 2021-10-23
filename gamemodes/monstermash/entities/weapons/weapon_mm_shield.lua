AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Shield + Revolver"

SWEP.SelectIcon = Material("vgui/entities/mm_shield")
SWEP.Cost = 20
SWEP.Points = 40
SWEP.KillFeed = "%a closed the lid on %v's coffin."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_revolver_1hand.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_shield.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound = Sound("weapons/revolver/fire1.wav")
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6 
SWEP.Primary.Ammo = "None"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize    = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Primary.UseRange = true
SWEP.Primary.Range = 1152

SWEP.HoldType         = "duel" 
SWEP.HoldTypeAttack   = "duel"
SWEP.HoldTypeReload   = "duel"
SWEP.HoldTypeCrouch   = "duel"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_revolver" )
SWEP.CrosshairSize = 40

SWEP.ReloadOutTime = 0.7
SWEP.ReloadInTime  = 1.5

SWEP.EjectEffect = ""

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
	self:NetworkVar("Entity", 0, "MMShield_ShieldEntity")
    self:NetworkVar("Int", 20, "MMShield_ShieldState")
    self:NetworkVar("Float", 20, "MMShield_ShieldTimer")
end

function SWEP:Deploy()
    BaseClass.Deploy(self)
    self:SetMMShield_ShieldState(0)
end

function SWEP:Think()
    BaseClass.Think(self)
    
    if self:GetMMShield_ShieldState() != 0 then
        self.Owner:GetViewModel():SetPlaybackRate(2)
    end
    
    if self.Owner:KeyDown(IN_ATTACK2) && self:GetMMShield_ShieldState() == 0 && self:GetMMBase_ShootTimer() < CurTime() then
        self:SetMMShield_ShieldState(1)
        self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "idle_to_blocked" ))
        self:SetMMShield_ShieldTimer(CurTime() + 0.2)
        self:SetMMBase_ShootTimer(CurTime() + 1)
    end
    
    if self:GetMMShield_ShieldState() == 1 && self:GetMMShield_ShieldTimer() < CurTime() then
        self:SetMMShield_ShieldState(2)
    end
    if self:GetMMShield_ShieldState() == 2 && self.Owner:KeyDown(IN_ATTACK2) then
        self.Owner:GetViewModel():SetSkin(1) 
        self:SetMMBase_ShootTimer(CurTime() + 1)
        self:SetHoldType("smg")
        if SERVER && !IsValid(self:GetMMShield_ShieldEntity()) then
			local Ent = ents.Create("prop_physics")
			Ent:SetModel("models/weapons/monstermash/shield_physics.mdl")
			Ent:SetOwner(self.Owner)
			Ent:Spawn()
			Ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			Ent:SetRenderMode( RENDERMODE_TRANSALPHA )
			Ent:SetColor( Color( 255, 255, 255,0) )
			self:SetMMShield_ShieldEntity(Ent)
			local phys = Ent:GetPhysicsObject()
			phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
			phys:EnableMotion(false)
		end
        
        if SERVER && IsValid(self:GetMMShield_ShieldEntity()) then
            local Offset = Vector(0,0,48)
            if(self.Owner:Crouching()) then
                Offset.z = Offset.z - 0
                Offset.x = Offset.x + 0
            end
            
            local hand
            hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

            offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 + hand.Ang:Up() * 0

            hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Up(), -90)

            self:GetMMShield_ShieldEntity():SetPos(hand.Pos + offset)
            self:GetMMShield_ShieldEntity():SetAngles(hand.Ang)
        end
    end
    
    if self:GetMMShield_ShieldState() == 2 && !self.Owner:KeyDown(IN_ATTACK2) then
        self:SetMMShield_ShieldTimer(CurTime() + 0.5)
        self:SetMMBase_ShootTimer(CurTime() + 0.5)
        self:SetMMShield_ShieldState(3)
        self.Owner:GetViewModel():SetSkin(0)
        self.Owner:GetViewModel():SetPlaybackRate(2)
        self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "blocked_to_idle" ))
        if SERVER && IsValid(self:GetMMShield_ShieldEntity()) then
            self:GetMMShield_ShieldEntity():Remove()
            self:SetMMShield_ShieldEntity(nil)
        end
    end
    
    if self:GetMMShield_ShieldState() == 3 && self:GetMMShield_ShieldTimer() < CurTime() then
        self:SetMMShield_ShieldState(0)
    end
    
    if self.Owner:MissingAnArm() && SERVER then
        self.Owner:Give("weapon_mm_revolver")
        self.Owner:SelectWeapon("weapon_mm_revolver")
        self.Owner:SetNWString("MM_WeaponSlot2", "weapon_mm_revolver")
        timer.Simple(0, function() if IsValid(self) then self.Owner:StripWeapon(self:GetClass()) end end)
    end
end