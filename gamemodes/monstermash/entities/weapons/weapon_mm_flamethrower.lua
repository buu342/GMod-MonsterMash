AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basegun" )

SWEP.PrintName = "Flamethrower"

SWEP.SelectIcon = Material("vgui/entities/mm_flamethrower")
SWEP.Cost = 45
SWEP.Points = 25
SWEP.KillFeed = "%a cremated %v."
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_flamethrower.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_flamethrower.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.Base = "weapon_mm_basegun"

SWEP.Primary.Sound          = "weapons/flamethrower/flamethrower_looping.wav"
SWEP.Primary.Damage         = 7
SWEP.Primary.TakeAmmo       = 1
SWEP.Primary.ClipSize       = 150
SWEP.Primary.Spread         = 0.25
SWEP.Primary.NumberofShots  = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Recoil         = 0.1
SWEP.Primary.Delay          = 0.03
SWEP.Primary.LoopSound      = true
SWEP.Primary.LoopStartSound = Sound("weapons/flamethrower/flamethrower_start.wav")
SWEP.Primary.LoopEndSound   = Sound("weapons/flamethrower/flamethrower_end.wav")
SWEP.Primary.FireMode       = FIREMODE_PROJECTILE
SWEP.Primary.ProjectileEntity = ""

SWEP.Secondary.Sound       = "weapons/flamethrower/fireball.mp3"
SWEP.Secondary.LoopStartSound = Sound("weapons/flamethrower/firecharge.mp3")
SWEP.Secondary.TakeAmmo    = 75
SWEP.Secondary.Recoil      = 10
SWEP.Secondary.Delay       = 1
SWEP.Secondary.ClipSize    = 1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.FireMode    = FIREMODE_PROJECTILE
SWEP.Secondary.Chargeup    = true
SWEP.Secondary.ChargeTime  = 1.75
SWEP.Secondary.ProjectileForce = 100000
SWEP.Secondary.ChargeEarly = false
SWEP.Secondary.ProjectileEntity = "sent_mm_fireball"

SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.AttackAnim = ACT_VM_PRIMARYATTACK_DEPLOYED
SWEP.AttackAnimStop = ACT_VM_PULLBACK
SWEP.Attack2Anim = ACT_VM_PULLBACK
SWEP.ChargeAnim = ACT_VM_FIDGET

SWEP.Primary.UseRange = true
SWEP.Primary.Range    = 256
SWEP.Secondary.UseRange = true
SWEP.Secondary.Range  = 256

SWEP.HoldType         = "crossbow" 
SWEP.HoldTypeAttack   = "crossbow"
SWEP.HoldTypeReload   = "crossbow"
SWEP.HoldTypeCrouch   = "crossbow"

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_carbine" )
SWEP.CrosshairChargeType = CHARGETYPE_CIRCLE
SWEP.CrosshairSize = 96
SWEP.CrosshairChargeSize = 96

SWEP.ReloadOutTime = 0.5
SWEP.ReloadInTime  = 0
SWEP.ReloadAmount = 40
SWEP.ReloadAmountMax = SWEP.Primary.ClipSize

SWEP.FlameThrower = true
SWEP.ChargeEffect = "mm_flamethrower_charge"
SWEP.EjectEffect = ""

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
	self:NetworkVar("Entity", 0, "MMFlame_FlameEntity")
    self:NetworkVar("Int", 20, "MMFlame_FlameState")
    self:NetworkVar("Float", 20, "MMFlame_FlameTimer")
end

function SWEP:Think()
    BaseClass.Think(self)
    if self.Owner:KeyDown(IN_ATTACK) && self:GetMMFlame_FlameState() == 0 && self:GetMMBase_ReloadTimer() == 0 && self:Clip1() > 0 then
        self:SetMMFlame_FlameState(1)
    end
    
    if CLIENT && !self.Owner:ShouldDrawLocalPlayer() && self:GetMMBase_Charge() > 0 then
        local effectdata4 = EffectData()
        effectdata4:SetStart( self.Owner:GetViewModel():GetAttachment("1").Pos ) 
        effectdata4:SetOrigin( self.Owner:GetViewModel():GetAttachment("1").Pos )
        effectdata4:SetAngles( self.Owner:EyeAngles() )
        effectdata4:SetScale( 1 )
        util.Effect( "mm_flamethrower_charge", effectdata4 )
    end
    
    if self:GetMMFlame_FlameState() == 1 && self.Owner:KeyDown(IN_ATTACK) && self:GetMMBase_ReloadTimer() == 0 then
        
        if SERVER && !IsValid(self:GetMMFlame_FlameEntity()) then
			local Ent = ents.Create("sent_mm_flamehitbox")
            Ent.Owner = self.Owner
            Ent.Inflictor = self
			Ent:SetModel("models/hunter/blocks/cube075x5x075.mdl")
			Ent:SetOwner(self.Owner)
			Ent:Spawn()
			self:SetMMFlame_FlameEntity(Ent)
			local phys = Ent:GetPhysicsObject()
			phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
			phys:EnableMotion(false)
		end
        
        if CLIENT && !self.Owner:ShouldDrawLocalPlayer() then
            local effectdata4 = EffectData()
            effectdata4:SetStart( self.Owner:GetViewModel():GetAttachment("1").Pos ) 
            effectdata4:SetOrigin( self.Owner:GetViewModel():GetAttachment("1").Pos )
            effectdata4:SetAngles( self.Owner:EyeAngles() )
            effectdata4:SetScale( 1 )
            util.Effect( "mm_flamethrower_flame", effectdata4 )
        end
        
        if SERVER && IsValid(self:GetMMFlame_FlameEntity()) then
            local Offset = Vector(0,0,48)
            if(self.Owner:Crouching()) then
                Offset.z = Offset.z - 0
                Offset.x = Offset.x + 0
            end
            
            local hand
            hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

            offset = hand.Ang:Right() * -10 + hand.Ang:Forward() * 128 + hand.Ang:Up() * 16

            hand.Ang:RotateAroundAxis(hand.Ang:Right(), 5)
            hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Up(), 90)

            self:GetMMFlame_FlameEntity():SetPos(hand.Pos + offset)
            self:GetMMFlame_FlameEntity():SetAngles(hand.Ang)
        end
    end
    
    if self:GetMMFlame_FlameState() == 1 && (!self.Owner:KeyDown(IN_ATTACK) || self:GetMMBase_ReloadTimer() > CurTime() || self:Clip1() == 0) then
        self:SetMMFlame_FlameState(0)
        self:SetMMBase_ShootTimer(CurTime() + self.Primary.Delay)
        if SERVER && IsValid(self:GetMMFlame_FlameEntity()) then
            self:GetMMFlame_FlameEntity():Remove()
            self:SetMMFlame_FlameEntity(nil)
        end
    end
    
end