SWEP.SelectIcon = "vgui/entities/mm_deanimator"
SWEP.Cost = 75

game.AddAmmoType( { 
 name = "ammo_zap",
 dmgtype = DMG_BULLET,
 tracer = TRACER_LINE,
 force = 2000
} )

SWEP.PrintName = "DeAnimator"
    
SWEP.Author = "Demo"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Demo"

SWEP.Category = "Monster Mash"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/monstermash/c_deanimator.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_deanimator.mdl" 
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "mm_gun_base"

SWEP.Primary.Sound = "ambient/levels/labs/electric_explosion1.wav" 
SWEP.Primary.Damage = 125
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 100
SWEP.Primary.Ammo = "ammo_zap"
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Spread = 0.001
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 4
SWEP.Primary.Force = 0
SWEP.HoldType = "shotgun"

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 175

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"Gun_FakeTimer1")
	self:NetworkVar("Float",1,"Gun_FakeTimer2")
	self:NetworkVar("Float",2,"Gun_CanShootTimer")
	self:NetworkVar("Float",3,"Gun_Charge")
	self:NetworkVar("Float",4,"Gun_Cooldown")
	self:NetworkVar("Float",5,"Gun_Cooldown2")
	self:NetworkVar("Float",6,"Gun_Shake")
    self:NetworkVar("Bool",0,"Gun_MessWithArmStuff")
    self:NetworkVar("Bool",1,"Gun_CanCharge")
end


function SWEP:PrimaryAttack()
end 

function SWEP:Deploy()
	self:SetGun_Charge(0)
	self:SetNextPrimaryFire( CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
	self:EmitSound("buttons/combine_button3.wav")
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    end
	return true 
end

function SWEP:Initialize()
	if CLIENT then
		self.JumpTime = 0
		self.LandTime = 0
	end
    util.PrecacheSound(self.Primary.Sound) 
	self:SetWeaponHoldType( self.HoldType )
	self:SetGun_Charge(0)
end 

function SWEP:Think()
    if self.Owner:GetNWInt("LegMissing") == 3 then
        self.Owner:SetWalkSpeed(85)
        self.Owner:SetRunSpeed(85)
    else
        self.Owner:SetWalkSpeed(self.WalkSpeed)
        self.Owner:SetRunSpeed(self.WalkSpeed)
    end
	
	if self.Owner:KeyPressed(IN_ATTACK) && self:GetNextPrimaryFire() < CurTime() && self.Owner:OnGround() && self:Clip1() >= 20 then
		self:EmitSound("npc/attack_helicopter/aheli_charge_up.wav",60,100,1,CHAN_WEAPON)
        self:SetGun_CanCharge(true)
	end
	
	if self.Owner:KeyDown(IN_ATTACK) && self:GetGun_CanCharge() == true && !self.Owner:KeyDown(IN_ATTACK2) && self:GetNextPrimaryFire() < CurTime() && self.Owner:OnGround() && self:Clip1() >= 20 then
        self.Owner:SetWalkSpeed(self.ShootSpeed)
		self.Owner:SetRunSpeed(self.ShootSpeed)
		if self:GetGun_Charge() >= 150 then
            self.Owner:EmitSound("weapons/cannon/explosion1.wav",140)
            if SERVER then
                self.Owner:TakeDamage(1337, self.Owner, self)
                if self.Owner:IsValid() then
                    self.Owner:Ignite(7) 
                end
            end
            
            if IsValid(self.Owner) then
                local dir = -self.Owner:GetAimVector()-Vector(0,0,self.Owner:GetAimVector().z)
                dir:Normalize()
                self.Owner:SetVelocity(dir*250)
            end
            local effectdata5 = EffectData()
			effectdata5:SetOrigin( self:GetPos() )
			util.Effect( "Fireball_Explosion", effectdata5 ) 
				
			local effectdata3 = EffectData()
			effectdata3:SetOrigin( self:GetPos() )
			effectdata3:SetScale( 1 )
			util.Effect( "ManhackSparks", effectdata3 )
				
			local effectdata4 = EffectData()
			effectdata4:SetStart( self:GetPos() ) 
			effectdata4:SetOrigin( self:GetPos() )
			effectdata4:SetScale( 1 )
			util.Effect( "HelicopterMegaBomb", effectdata4 )
			if SERVER then
				self:Remove()
                return
			end
		else
            self:SetGun_Charge(self:GetGun_Charge()+0.85)
            if (self:GetGun_Charge() > self:Clip1() && self:Clip1() != 100) then
                self:SetGun_Charge(self:Clip1())
            end
		end
	end
	
	if IsValid(self.Owner) && self.Owner:GetNWFloat("MM_Deanimatorstun") > CurTime() then 
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetBonePosition( self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") ) )
		util.Effect( "StunstickImpact", effectdata )
        if GetConVar("mm_deanimatorshake") != nil && GetConVar("mm_deanimatorshake"):GetInt() == 1 then
            self.Owner:ViewPunch(Angle(math.Rand(-2,2),math.Rand(-2,2),0))
        end
		self:SetGun_Shake(CurTime()+1)
	elseif IsValid(self.Owner) && self:GetGun_Shake() > CurTime() then
		local punch = (self:GetGun_Shake()-CurTime())*(2/3)
        if GetConVar("mm_deanimatorshake") != nil && GetConVar("mm_deanimatorshake"):GetInt() == 1 then
            self.Owner:ViewPunch(Angle(math.Rand(-punch,punch),math.Rand(-punch,punch),0))
        end
	end
	
	if self.Owner:KeyReleased(IN_ATTACK) && !self.Owner:KeyDown(IN_ATTACK2) && self:GetGun_CanCharge() == true && self:GetNextPrimaryFire() < CurTime() && self:Clip1() >= 20 then
        if self:GetGun_Charge() > 100 then
            self:SetGun_Charge(100)
        end
		self:ShootEffects()
        self.Owner:SetCycle(0)
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay*(self:GetGun_Charge()/100)+1 )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay*(self:GetGun_Charge()/100)+1 ) 
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:EmitSound(self.Primary.Sound,75,100,1,CHAN_WEAPON)
		self.Owner:ConCommand("play weapons/electric_machine.wav")
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward()
		pos = pos + self.Owner:GetRight() 
		pos = pos + self.Owner:GetUp()
		local bullet = {} 
        self:TakePrimaryAmmo(math.max(20,self:GetGun_Charge()))
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = pos
		bullet.Dir = self.Owner:GetAimVector() 
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 1
		bullet.TracerName = "deanimatortracer"
		bullet.Force = self.Primary.Force 
		bullet.Damage = 0//math.max(12.5, self.Primary.Damage*(self:GetGun_Charge()/100))
		bullet.AmmoType = self.Primary.Ammo
		bullet.Callback = function(attacker, trace, dmginfo)
            dmginfo:SetInflictor(self)
            local TP = trace.HitPos + trace.HitNormal 
            local TM = trace.HitPos - trace.HitNormal 
            if trace.HitWorld then 
                util.Decal( "scorch", TP, TM ) 
            end 
            
            local effectdata = EffectData()
            effectdata:SetOrigin( trace.HitPos )
            util.Effect( "ManhackSparks", effectdata )
            
			if SERVER then
				local hBallGen = ents.Create("Prop_combine_ball")
				hBallGen:SetPos(trace.HitPos)
				hBallGen:Spawn()
				hBallGen:Fire("explode","",0)			
				
				for k, v in pairs( player.GetAll() ) do
					if v:GetPos():Distance(trace.HitPos) < 128 then
						v:Ignite(1,1)
					end
				end
				
			end
            util.BlastDamage(self, self.Owner, trace.HitPos, 128, math.max(15, self.Primary.Damage*(self:GetGun_Charge()/100)))
		end
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
		self.Owner:SetNWFloat("MM_Deanimatorstun",CurTime()+3*(self:GetGun_Charge()/100))
		self:SetGun_Cooldown2(CurTime()+4*(self:GetGun_Charge()/100)+1)
        timer.Simple(0, function() if IsValid(self) then self:SetGun_Charge(0) end end)
		self.Owner:FireBullets( bullet ) 

	end
	
	if  IsValid(self.Owner) && (self.Owner:KeyReleased(IN_ATTACK) || !self.Owner:OnGround() || self.Owner:KeyPressed(IN_ATTACK2) )   then
		self:EmitSound("common/null.wav",75,100,1,CHAN_WEAPON)
        self:SetGun_Charge(0)
        self:SetGun_CanCharge(false)
        if self.Owner:GetNWInt("LegMissing") == 3 then
            self.Owner:SetWalkSpeed(85)
            self.Owner:SetRunSpeed(85)
        else
            self.Owner:SetWalkSpeed(self.WalkSpeed)
            self.Owner:SetRunSpeed(self.WalkSpeed)
        end
	end
	if CLIENT then

		if !self.Owner:IsOnGround() then
			self.LandTime = RealTime() + 0.31
		end

		if (self.Owner:GetMoveType() == MOVETYPE_NOCLIP || self.Owner:GetMoveType() == MOVETYPE_LADDER || self.Owner:WaterLevel() > 1 ) || (self.LandTime < RealTime() && self.LandTime != 0) then
			self.LandTime = 0
			self.JumpTime = 0
		end

		if self.Owner:KeyDownLast( IN_JUMP ) then
			if self.JumpTime == 0 then
				self.JumpTime = RealTime() + 0.31
				self.LandTime = 0
			end
		end
	end
	
	self:LegsDismembered()
end

function SWEP:Reload()
	if self:Clip1() < self:GetMaxClip1() then
		self.Owner:SetAmmo(self.Primary.DefaultClip, self:GetPrimaryAmmoType())
        self.Weapon:DefaultReload( ACT_VM_RELOAD )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        if self.Owner:GetNWInt("ArmMissing") > 0 then
            self.Owner:GetViewModel():SetPlaybackRate(0.5)
            AnimationTime = self.Owner:GetViewModel():SequenceDuration()*(1/self.Owner:GetViewModel():GetPlaybackRate())
        end
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
        self:SetGun_FakeTimer2(CurTime() + AnimationTime)
        if self.Owner:GetNWInt("LegMissing") > 0  then
            self.Owner:SetWalkSpeed(1)
            self.Owner:SetRunSpeed(1)
        else
            self.Owner:SetWalkSpeed(self.ReloadSpeed)
            self.Owner:SetRunSpeed(self.ReloadSpeed)
        end
	end
end

function ElectricEffect() 
	cam.Start3D( EyePos(), EyeAngles() ) 
	for k, v in pairs( ents.GetAll() ) do 
		if IsValid(v) && v:IsPlayer() && v:GetNWFloat("MM_Deanimatorstun") > CurTime() then 
			render.SetBlend( 1 )
			render.MaterialOverride( Material("models/player/monstermash/gibs/shock") ) 
			v:DrawModel() 
			render.SetBlend( 1 ) 
			render.MaterialOverride( 0 ) 
		end
	end 
	cam.End3D() 
end 
hook.Add("RenderScreenspaceEffects","ElectricEffect",ElectricEffect)