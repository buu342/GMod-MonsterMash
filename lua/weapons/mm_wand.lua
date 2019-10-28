SWEP.SelectIcon = "vgui/entities/mm_wand"
SWEP.Cost = 65
SWEP.Points = 10

SWEP.CrosshairMaterial = Material( "vgui/hud/crosshair_cannon" )
SWEP.CrosshairChargeMaterial = Material( "vgui/hud/crosshair_cannon_fill" )

game.AddAmmoType( { 
 name = "ammo_revolver",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName = "Wand"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_wand.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_wand.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "knife" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "weapons/wand/wand_fire.wav"
SWEP.Primary.Damage = 60
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "flame"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Spread = 0.14
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 0

SWEP.Secondary.Sound = "weapons/wand/wand_deflect.wav"
SWEP.Secondary.Damage = 25
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.TakeAmmo = 2
SWEP.Secondary.Delay = 1.5
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseDistance = false

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
    self:NetworkVar("Float",2,"Gun_Charge")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
    self:NetworkVar("Bool",1,"Gun_Reloading")
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
    //self.Owner:DrawViewModel(false)
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    elseif self:GetGun_FakeTimer1() > 0 && CurTime() < self:GetGun_FakeTimer1() then
		self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
	elseif self:GetGun_Reloading() == false then
		self.Owner:SetWalkSpeed(self.WalkSpeed)
		self.Owner:SetRunSpeed(self.WalkSpeed)
	end

    if IsValid(self.Owner) && (self.Owner:KeyReleased(IN_ATTACK2) || !self.Owner:OnGround() )   then
		self:SetGun_Charge(0)
        self:EmitSound("common/null.wav",75,100,1,CHAN_WEAPON)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
    end
    
    if self:GetGun_Reloading() == true && self:GetGun_FakeTimer2() < CurTime() then
        self:SetGun_Reloading(false)
        self:SetClip1( math.min(self:Clip1() + 2, 6) )
    end
    if self:GetGun_Reloading() == false then
        self:LegsDismembered()
    end

    if self.Owner:KeyDown(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() then
        if self:GetGun_Reloading() == true then return end        if self:Clip1() < 1 then return end
        if self:GetGun_Reloading() == true then return end
        if !self.Owner:OnGround() then return end
        self:SetGun_Charge(self:GetGun_Charge()+1)
        if self:GetGun_Charge() > 100 then
            self:SetGun_Charge(100)
        end
    end

    if self.Owner:KeyReleased(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() then
        if self:Clip1() < 1 then return end
        if self:GetGun_Reloading() == true then return end
        if !self.Owner:OnGround() then return end
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        end
        if CLIENT && GetViewEntity() == self.Owner then
            local effectdata4 = EffectData()
            effectdata4:SetStart( self.Owner:GetViewModel():GetAttachment(1).Pos ) 
            effectdata4:SetOrigin( self.Owner:GetViewModel():GetAttachment(1).Pos )
            effectdata4:SetAngles( self.Owner:EyeAngles() )
            effectdata4:SetScale( 1 )
            util.Effect( "magic_staff2", effectdata4 )
        end
        
        if SERVER then
            local effectdata4 = EffectData()
            local pos = self.Owner:GetShootPos()
                pos = pos + self.Owner:GetAngles():Up() 	* -20
                pos = pos + self.Owner:GetAngles():Right()	* 10
                pos = pos + self.Owner:GetAngles():Forward()* 30
            effectdata4:SetStart( pos ) 
            effectdata4:SetOrigin( pos )
            effectdata4:SetAngles( self.Owner:EyeAngles() )
            effectdata4:SetScale( 1 )
            util.Effect( "magic_staff2", effectdata4 )
        end
            
        local rnda = self.Primary.Recoil * -1 
        local rndb = self.Primary.Recoil * math.random(-1, 1) 
        //self.Owner:FireBullets( bullet ) 
        self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
        self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
         
        if self.Owner:GetNWFloat("Bloodied") > CurTime() then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*4 )
            self.Owner:GetViewModel():SetPlaybackRate( 0.5 )
        else
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        end
        self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
        self:SetGun_FakeTimer1(CurTime() + 0.5)
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        self:EmitSound(Sound(self.Primary.Sound), 75, 100, 1, CHAN_ITEM )
        if SERVER then
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            local grenade = ents.Create("ent_magicball")

            local pos = self.Owner:GetShootPos()
            pos = pos + self.Owner:GetForward() * 0
            pos = pos + self.Owner:GetRight() * 10
            pos = pos + self.Owner:GetUp() * -5
            
             
            local ang = self.Owner:EyeAngles()
            ang = ang:Forward()
            
            grenade:SetPos(pos)
            grenade:SetAngles(self.Owner:GetAngles())
            grenade:SetOwner(self.Owner)
            grenade:Spawn()
            grenade:Activate()
            grenade.Inflictor = self
            grenade.Owner = self.Owner
            local phys = grenade:GetPhysicsObject()
            self.Force = 2000 + self:GetGun_Charge()*50
            phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 0))
        end
        self:SetGun_Charge(0)
    end
end

function SWEP:Reload()
    if self:GetGun_Reloading() == false && self:Clip1() != 6  then
        self:SetGun_Reloading(true)
        self:SetGun_Charge(0)        
        self:SendWeaponAnim(ACT_VM_RELOAD)
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()*1
        self:SetNextPrimaryFire( CurTime() + AnimationTime )
        self:SetNextSecondaryFire( CurTime() + AnimationTime )
        self:SetGun_FakeTimer2(CurTime() + AnimationTime)
        self:EmitSound("weapons/wand/wand_reload.wav", 75, 100, 1, CHAN_ITEM)
        if self.Owner:GetNWInt("LegMissing") > 0 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
    if self:Clip1() < self.Secondary.TakeAmmo || self:GetNextPrimaryFire() > CurTime() then return end
    for k, v in pairs(player.GetAll()) do
        if ( SERVER ) then
            if v != self.Owner && v:GetPos():Distance(self.Owner:GetPos()) < 256 && self.Owner:VisibleVec(v:GetPos()+Vector(0,0,10)) then
                local damage = DamageInfo()
                damage:SetDamage(self.Secondary.Damage)
                damage:SetAttacker(self.Owner)
                damage:SetInflictor(self)
                v:TakeDamageInfo(damage)
                local phys = v:GetPhysicsObject()
                if ( IsValid( phys ) ) then
                    local dir = (v:GetPos()-self.Owner:GetPos()):Angle():Forward()
                    dir:Normalize()
                    if v:OnGround() then
                        v:SetVelocity(dir*2500)
                    else
                        v:SetVelocity(dir*2500/4)
                    end
                end
            end
        end
    end
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    if SERVER then
        self.Owner:SetAnimation(PLAYER_ATTACK1)
    end
    self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
    self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
    local effectdata4 = EffectData()
    local pos = self.Owner:GetShootPos()
        pos = pos + self.Owner:GetAngles():Up() 	* -20
        pos = pos + self.Owner:GetAngles():Right()	* 10
        pos = pos + self.Owner:GetAngles():Forward()* 30
    effectdata4:SetStart( pos ) 
    effectdata4:SetOrigin( pos )
    effectdata4:SetAngles( self.Owner:EyeAngles() )
    effectdata4:SetScale( 1 )
    util.Effect( "expandball", effectdata4 )
    self:EmitSound(Sound(self.Secondary.Sound), 75, 100, 1, CHAN_ITEM)
    if SERVER then
        local barrier = ents.Create("ent_magicbarrier")
        barrier:SetPos(pos)
        barrier:Spawn()
        barrier:SetOwner(self.Owner)
        barrier:Activate()
    end
    self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
end

function SWEP:FireAnimationEvent(pos,ang,event)
	if (event==5001) then 
		return true
	end
end

function SWEP:Holster()
	if IsValid(self.Owner) then 
        self.Owner:DrawViewModel(true)
        if self.Owner:GetNWInt("LegMissing") > 0 then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.DefaultWalkSpeed)
            self.Owner:SetRunSpeed(self.DefaultWalkSpeed)
        end
        self:SetGun_FakeTimer1(0)
        self:SetGun_FakeTimer2(0)
        return true
	end
end