AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basebase" )

SWEP.PrintName = "Base base"
    
SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 70
SWEP.ViewModel  = "models/weapons/monstermash/v_boner.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_boner.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
 
SWEP.UseHands = true

SWEP.Base = "weapon_mm_basebase"

SWEP.Primary.Damage      = 1000
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo        = "None"
SWEP.Primary.Spread      = 0.1
SWEP.Primary.Automatic   = true
SWEP.Primary.Recoil      = Angle(0,0,0)
SWEP.Primary.Delay       = 0.02
SWEP.Primary.SwingTime   = 1
SWEP.Primary.SpecialCooldown = 0
SWEP.Primary.SwingHold   = false
SWEP.Primary.LoopSound   = nil

SWEP.Secondary.Damage = 0
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.Delay = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


/*------------------------------------------------
                Monster Mash Settings
------------------------------------------------*/

SWEP.KillFlags = 0

SWEP.BleedChance     = 0
SWEP.BurnChance      = 0
SWEP.ConcussChance   = 0
SWEP.DismemberChance = 0

SWEP.CrosshairMaterial         = Material( "" )
SWEP.CrosshairSize             = 0
SWEP.CrosshairRechargeMaterial = Material( "" )
SWEP.CrosshairRechargeSize     = 0

SWEP.RunSpeed    = 220
SWEP.ShootSpeed  = SWEP.RunSpeed 

SWEP.HoldType         = "melee" 
SWEP.HoldTypeAttack   = "melee"

SWEP.SwingTime = 0.3
SWEP.Reach = 50
SWEP.BoxSize   = 10
SWEP.HurtPunch = 50

SWEP.DecalUse	    = true         -- Use sexy melee decals
SWEP.DecalAmount    = 5            -- How many decals to make
SWEP.DecalSpread    = 20	       -- How spread is each decal? Use wisely to avoid green crap
SWEP.DecalSpeed     = 0.002        -- How quickly are the decals generated?
SWEP.DecalDirection = 1            -- Set to -1 to go from left to right
SWEP.DecalMaterial  = "ManhackCut" -- Decal, duh
SWEP.DecalCount     = 1            -- Triple bullet decals

SWEP.ChargeSpeed = 400

SWEP.AttackAnim = ACT_VM_HITCENTER
SWEP.AttackAnimLoopStart = ACT_VM_IIN
SWEP.AttackAnimLoopLoop  = ACT_VM_IIDLE
SWEP.AttackAnimLoopEnd   = ACT_VM_IOUT

SWEP.BackDoubleDamage = false
SWEP.BackBleed = false
SWEP.BackConcuss = false
SWEP.BackDismember = false
SWEP.BackBifurcate = false
SWEP.BackKill = false

SWEP.DashGrace = 1
SWEP.DoViewPunch = false

SWEP.LastAttack = 0
SWEP.LockOnTime = 0.3

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 0, "MMBase_MeleeSwing")
    self:NetworkVar("Float", 1, "MMBase_MeleeChargeExtra")
    self:NetworkVar("Float", 2, "MMBase_MeleeSwingHold")
end

function SWEP:HandleHoldTypes()
    if self.Owner:MissingBothArms() && self:GetClass() != "weapon_mm_headbutt" then
        if SERVER then
            local owner = self.Owner
            owner:DropWeapon(self)
            owner:StripWeapons()
            owner:Give("weapon_mm_headbutt")
        end
    elseif self.Owner:MissingLeftArm() then
        if (IsValid(self.Owner:GetHands())) then
            self.Owner:GetHands():SetBodygroup(1,1)
        end
    elseif self.Owner:MissingRightArm() then
        self:SetHoldType("fist")
        self.ViewModelFlip = true
        if (IsValid(self.Owner:GetHands())) then
            self.Owner:GetHands():SetBodygroup(1,1)
        end
    else
        self.ViewModelFlip = false
        if (IsValid(self.Owner:GetHands())) then
            self.Owner:GetHands():SetBodygroup(1,0)
        end
    end
end

function SWEP:PrimaryAttack()
    if self.Owner:GetMoveType() == MOVETYPE_LADDER then return end
    if self.Primary.SwingHold && (self:GetMMBase_MeleeSwingHold()-CurTime() > -0.2 && self.Owner:KeyDown(IN_ATTACK)) then return end 
    if self:GetMMBase_ShootTimer() != 0 then return end
    if (self.Primary.SpecialCooldown != 0 && self.Owner:GetWeaponCooldown(self) > 0) then return end
    if self.Owner:HasStatusEffect(STATUS_SPAWNPROTECTED) then self.Owner:RemoveStatusEffect(STATUS_SPAWNPROTECTED) end
    self:SetMMBase_MeleeSwing(CurTime()+self.SwingTime)
    self:SetHoldType(self.HoldTypeAttack)
    self:SendWeaponAnim(self.AttackAnim)
    self:SetMMBase_ShootTimer(CurTime() + self.Primary.Delay)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetMMBase_MeleeSwingHold(0)
    self.LastAttack = CurTime() + self.LockOnTime
    if type(self.Primary.SwingSound) == "table" then
        local snd = table.Random(self.Primary.SwingSound)
        self:EmitSound(snd)
    else
        self:EmitSound(self.Primary.SwingSound)
    end
    self:EmitSound("empty.wav", 75, 100, 1, CHAN_VOICE2)
    self:SetMMBase_LoopSoundRepeat(CurTime()+1.5)
    timer.Simple(0.3, function() if !IsValid(self) then return end self:SetHoldType( self.HoldType ) end)
    
end 

function SWEP:PrimaryAttackLoop()
    if self:GetMMBase_MeleeSwing() == 0 then
        self:SetMMBase_MeleeSwing(CurTime()+self.SwingTime)
        self:SendWeaponAnim(self.AttackAnimLoopStart)
        self.Owner:SetAnimation(PLAYER_ATTACK1)
        self:EmitSound(self.Primary.LoopSound)
        self:EmitSound("empty.wav", 75, 100, 1, CHAN_VOICE2)
        self:SetMMBase_LoopSoundRepeat(CurTime()+1.5)
    elseif self:GetMMBase_MeleeSwing() < CurTime() then
        local vm = self.Owner:GetViewModel()
        self.Owner:SetAnimation(PLAYER_ATTACK1)
        vm:SetSequence(vm:SelectWeightedSequence(self.AttackAnimLoopLoop))
        self:DoDamage(true)
        self:SetMMBase_MeleeSwing(CurTime() + self.Secondary.Delay)
        self:SetMMBase_LoopSoundRepeat(CurTime()+self.Secondary.Delay*2)
        self.LastAttack = CurTime() + self.LockOnTime
    end
end 

function SWEP:SecondaryAttack()
    if self.Owner:MissingALeg() then return end
    if self.Owner:CanUseAbility() then
        if self.Owner:HasStatusEffect(STATUS_SPAWNPROTECTED) then self.Owner:RemoveStatusEffect(STATUS_SPAWNPROTECTED) end
        self.Owner:MeleeCharge()
    end
end

hook.Add("CreateMove", "MM_MeleeChargeCreateMove", function(cmd)
    if LocalPlayer():IsMeleeCharging() && LocalPlayer():GetActiveWeapon().Base == "weapon_mm_basemelee" then
        cmd:SetForwardMove( LocalPlayer():GetActiveWeapon().ChargeSpeed )
        cmd:SetSideMove( 0 )
    end
end)

function SWEP:AdjustMouseSensitivity()
    if (self.Owner:IsMeleeCharging()) then
        return 0.2
    else
        return 1
    end
end

function SWEP:Reload()
end

function SWEP:Think()
    BaseClass.Think(self)
    if (self.Primary.SwingHold) then
        if (self:GetMMBase_MeleeSwingHold() == 0 && self:GetMMBase_ShootTimer() == 0 && self.Owner:KeyDown(IN_ATTACK)) then
            self:SetMMBase_MeleeSwingHold(CurTime())
        elseif self:GetMMBase_MeleeSwingHold() != 0 then
            if self:GetMMBase_MeleeSwingHold()-CurTime() > -0.2 && self.Owner:KeyReleased(IN_ATTACK) then
                self:PrimaryAttack()
            elseif self:GetMMBase_MeleeSwingHold()-CurTime() <= -0.2 then
                self:PrimaryAttackLoop()
                if !self.Owner:KeyDown(IN_ATTACK) then
                    self:SetMMBase_MeleeSwingHold(0)
                    self:SetMMBase_MeleeSwing(0)
                    self:SetMMBase_ShootTimer( CurTime() + 1 )
                    self:SendWeaponAnim(self.AttackAnimLoopEnd)
                    self:EmitSound("weapons/chainsaw/sawtoidle.wav")
                    self:SetMMBase_LoopSoundRepeat(CurTime()+1)
                end
            end
        end
    end
    
    if (self.Primary.SpecialCooldown != 0) then
        if self.Owner:GetWeaponCooldown(self) > 0 then
            self:SendWeaponAnim( ACT_VM_DRAW )
            self.Owner:GetViewModel():SetPlaybackRate( 0 )
            self.ViewModelFOV = 1
            self:SetClip1(0)
            return
        elseif self:Clip1() == 0 then
            self.Owner:SetWeaponCooldown(self, 0)
            self.ViewModelFOV = 54
            self.Owner:GetViewModel():SetPlaybackRate( 1 )
            self:SendWeaponAnim( ACT_VM_DRAW )
            self:SetNextPrimaryFire(CurTime()+0.5)
            self:SetClip1(1)
        end
    end
    
    if self:GetMMBase_MeleeSwing() != 0 && self:GetMMBase_MeleeSwing() < CurTime() then
        if (self.Primary.SpecialCooldown == 0 || self.Owner:GetWeaponCooldown(self) == 0) then
            self:DoDamage()
        end
    end
    
    if IsValid(self.Owner) then
        if self.Owner:IsMeleeCharging() then
            local tr = util.TraceHull( {
                start = self.Owner:GetShootPos(),
                endpos = self.Owner:GetShootPos() + ( Vector(self.Owner:GetAimVector().x, self.Owner:GetAimVector().y, 0) * 64 ),
                filter = self.Owner,
                mins = Vector( -10, -10, -10 ),
                maxs = Vector( 10, 10, 10 ),
                mask = MASK_SHOT_HULL
            } )
            
            if tr && tr.Hit && tr.Entity:IsPlayer() then
                self.Owner:RemoveStatusEffect(STATUS_MELEECHARGE)
                self.Owner:SetStatusEffect(STATUS_MELEECHARGEEXTRA, nil, self.DashGrace)
                self:SetMMBase_MeleeChargeExtra(CurTime()+self.DashGrace)
                self.Owner:SetVelocity(self.Owner:GetAimVector(), 0)
                if SERVER then
                    self.Owner:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(80, 100), math.Rand(90, 120)) 
                    tr.Entity:TakeDamage( 5, self.Owner, self )
                    local shake = ents.Create( "env_shake" )
                    shake:SetOwner(self.Owner)
                    shake:SetPos( tr.HitPos )
                    shake:SetKeyValue( "amplitude", "2500" )
                    shake:SetKeyValue( "radius", "100" )
                    shake:SetKeyValue( "duration", "0.5" )
                    shake:SetKeyValue( "frequency", "255" )
                    shake:SetKeyValue( "spawnflags", "4" )	
                    shake:Spawn()
                    shake:Activate()
                    shake:Fire( "StartShake", "", 0 )
                end
            end
        end
    end
end

function SWEP:DoDamage(secondary)
    local mode = self.Primary
    if secondary then
        mode = self.Secondary
    end
    self:SetMMBase_MeleeSwing(0)
    
    local tr = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Reach,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    } )
 
    if ( !IsValid( tr.Entity ) ) then
        tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Reach,
            filter = self.Owner,
            mins = Vector( -self.BoxSize, -self.BoxSize, -self.BoxSize ),
            maxs = Vector( self.BoxSize, self.BoxSize, self.BoxSize ),
            mask = MASK_SHOT_HULL
        } )
    end
    
    if tr.Hit then
        if type(self.Primary.SwingHitSound) == "table" then
            local snd = table.Random(self.Primary.SwingHitSound)
            self:EmitSound(snd)
        else
            if self.Primary.SwingHitSound != nil then
                self:EmitSound(self.Primary.SwingHitSound)
            end
        end
        
        if SERVER then
            local dmginfo = DamageInfo()
            local attacker = self.Owner
            local damage = mode.Damage
            local addedkillflag1 = false
            local addedkillflag2 = false
            if ( !IsValid( attacker ) ) then attacker = self end
            dmginfo:SetAttacker( attacker )
            dmginfo:SetInflictor( self )
            if self:Backstab() && self.BackKill then
                dmginfo:SetDamage( 9001 )
                addedkillflag1 = true
                self.KillFlags = bit.bor(self.KillFlags, KILL_BACKSTAB)
            elseif self:Backstab() && self.BackDoubleDamage then
                dmginfo:SetDamage( damage*2 )
                addedkillflag1 = true
                self.KillFlags = bit.bor(self.KillFlags, KILL_BACKSTAB)
            elseif self.Owner:IsMeleeCharging() || self:GetMMBase_MeleeChargeExtra() > CurTime() then
                dmginfo:SetDamage( damage*1.2 )
            else
                dmginfo:SetDamage( damage )
            end
            if self:Backstab() && self.BackBifurcate then
                self.KillFlags = bit.bor(self.KillFlags, KILL_BIFURCATE)
                self.KillFlags = bit.bor(self.KillFlags, KILL_BACKSTAB)
                addedkillflag1 = true
                addedkillflag2 = true
            end
            if !secondary then
                dmginfo:SetDamageType( DMG_SLASH )
            else
                dmginfo:SetDamageType( DMG_DIRECT )
            end
            if (!secondary) then
                if (self.DismemberChance >= math.random(1, 100) || (self:Backstab() && self.BackDismember)) then
                    dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_MISSINGLIMB))
                end
                if (self.ConcussChance >= math.random(1, 100) || (self:Backstab() && self.BackConcuss)) then
                    dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_CONCUSS))
                end
                if (self.BleedChance >= math.random(1, 100) || (self:Backstab() && self.BackBleed)) then
                    dmginfo:SetDamageCustom(bit.bor(dmginfo:GetDamageCustom(), STATUS_BLEED))
                end
                if tr.Entity:IsPlayer() && self.BurnChance > math.random(0, 100) then
                    tr.Entity:SetStatusEffect(STATUS_ONFIRE, dmginfo, 6)
                end
            end
            tr.Entity:TakeDamageInfo( dmginfo )
            
            timer.Simple(0, function() 
                if !IsValid(self) then return end
                if addedkillflag1 then
                    self.KillFlags = bit.band(self.KillFlags, bit.bnot(KILL_BACKSTAB))
                end
                if addedkillflag2 then
                    self.KillFlags = bit.band(self.KillFlags, bit.bnot(KILL_BIFURCATE))
                end
            end)
            if (self.Primary.SpecialCooldown != 0) && tr.Entity:IsPlayer() then
                self.Owner:SetWeaponCooldown(self, self.Primary.SpecialCooldown)
            end
        end
        
        // Push the physics object around
        local phys = tr.Entity:GetPhysicsObject()
        if ( IsValid( phys ) ) then
            phys:ApplyForceOffset( self.Owner:GetAimVector()*80*phys:GetMass(), tr.HitPos )
        end
    end
    
    if self.DoViewPunch then
        self.Owner:ViewPunch(self.Primary.Recoil)
    end
    self:DoMeleeDecal()
end

function SWEP:Backstab()
    local tr = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    } )

    if ( !IsValid( tr.Entity ) ) then 
        tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
            filter = self.Owner,
            mins = Vector( -20, -20, -16 ),
            maxs = Vector( 20, 20, 16 ),
            mask = MASK_SHOT_HULL
        } )
    end
	
    if tr.Hit && IsValid( tr.Entity ) && (tr.Entity:IsPlayer() && (math.abs(math.AngleDifference(tr.Entity:GetAngles().y,self.Owner:GetAngles().y)) <= 50)) then
		//self.Owner:SetVelocity(Vector( self.Owner:GetAimVector(), self.Owner:GetAimVector(), 0 )*500)
        return true
    else
        return false
    end
end

hook.Add("StartCommand", "MM_MeleeChargeDisableCrouch", function( ply, cmd )

    if IsValid(ply) && ply:Alive() && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon() != nil && ply:GetActiveWeapon().IsMMGun then
        
        if ply:IsMeleeCharging() then
            cmd:RemoveKey(IN_DUCK)
        end
    end

end)

function SWEP:DoMeleeDecal()
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.Reach+10.7) )
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    
    local trace = util.TraceLine( tr )
    for i=0, self.DecalCount-1 do
        if ( trace.Hit ) then
            bullet = {}
            bullet.Num    = 1
            bullet.Src    = self.Owner:GetShootPos()
			local direc = self.Owner:GetAimVector()
			direc = direc + self.Owner:GetForward() * 0
			direc = direc + self.Owner:GetRight() * -(i*0.05)
			direc = direc + self.Owner:GetUp() * 0
			bullet.Dir    = direc
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force  = 1
            bullet.Damage = 0
            if self.DecalLeaveBullethole == true || (self.DecalMakeBlood == true && trace.Entity:IsPlayer()) then
                self.Owner:FireBullets(bullet) 
            end
            if self.DecalUse == true then
                for loop = 1,self.DecalAmount do 
                    timer.Simple( self.DecalSpeed*loop, function() 
                        if !IsValid(self) || !IsValid(self.Owner) then return end 
                        local increment = (self.DecalSpread - (((2*self.DecalSpread)/self.DecalAmount)*loop))*self.DecalDirection
                        tr.endpos = tr.endpos + self.Owner:EyeAngles():Forward()*5 
                        local tr2 = {} 
                        tr2.start = trace.HitPos + trace.HitNormal*2 + self.Owner:EyeAngles():Right()*increment 
                        tr2.endpos = tr2.start - trace.HitNormal*5 
                        tr2.mask = MASK_PLAYERSOLID 
                        tr2.filter = self.Owner 
                        local trace2 = util.TraceLine(tr2) 
                        if trace2.HitWorld then 
                            util.Decal( self.DecalMaterial, trace2.HitPos+trace2.HitNormal, trace2.HitPos-trace2.HitNormal  ) 
                        end 
                    end) 
                end 
            end
        end
    end
end

/*
function SWEP:ViewModelDrawn()    
    self:DrawDebugBox(64/2, 128)
end

function SWEP:DrawWorldModel()    
    self:DrawDebugBox()
end
*/
function SWEP:DrawDebugBox(size, dist)
    // Draw the hitbox
    local ang = Angle(0,0,0)
    local color = Color(255, 255, 255, 255)
    local mins = Vector(-size, -size, -size)
    local maxs = Vector(size, size, size)
    local tr = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    } )
    if ( !IsValid( tr.Entity ) ) then
        tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
            filter = self.Owner,
            mins = mins,
            maxs = maxs,
            mask = MASK_SHOT_HULL
        } )
    end
    if tr.Entity:IsPlayer() then
        color = Color(255, 0, 0, 255)
    end
    render.DrawWireframeBox(tr.HitPos, ang, mins, maxs, color)
end

function SWEP:DoImpactEffect( tr, nDamageType )

    if tr.Entity:IsPlayer() then
        local ply = tr.Entity
        local effectdata = EffectData()
        effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
        effectdata:SetNormal( tr.HitNormal )
        effectdata:SetStart( tr.HitPos + tr.HitNormal )
        effectdata:SetScale( 0.75 )
        
        if self.ImpactEffectOnPlayers then
            local effectdata = EffectData()
            effectdata:SetOrigin( tr.HitPos )
            effectdata:SetNormal( tr.HitNormal )
            util.Effect( self.ImpactEffect, effectdata )
        end
        
        if (ply:GetCharacter().bloodtype == BLOODTYPE_NONE) then
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
        elseif (ply:GetCharacter().bloodtype == BLOODTYPE_HAY) then
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
            util.Effect( "WheelDust", effectdata )
        elseif (ply:GetCharacter().bloodtype == BLOODTYPE_GREEN) then
            util.Effect( "AntlionGib", effectdata )
        else
            util.Effect( "BloodImpact", effectdata )
        end
        return true
    end
end

hook.Add( "CreateMove", "MM_MeleeBase_AimAssist", function( cmd )
    local ply = LocalPlayer()
    local speed = 10
    local bone = "ValveBiped.Bip01_Neck1"
    if ply:GetActiveWeapon().Base == "weapon_mm_basemelee" && ply:GetActiveWeapon().LastAttack > CurTime() then
        local size = 64
        local dist = 128
        local attacktime = (ply:GetActiveWeapon().LastAttack - CurTime())/ply:GetActiveWeapon().LockOnTime
        speed = speed*attacktime
        
        for k, v in pairs(player.GetAll()) do
            local target = v
            if (v:Team() != TEAM_SPECT && v:Team() != TEAM_COOPDEAD && !v:HasStatusEffect(STATUS_INVISIBLE)) then
                local targetbody = target:LookupBone(bone)
                local targetpos, targetang = target:GetBonePosition(targetbody)
                if (target != ply && targetpos:Distance(ply:EyePos()) < dist) then
                    local targetpos, targetang = target:GetBonePosition(targetbody)
                    local norm = (targetpos-LocalPlayer():EyePos()):GetNormalized()
                    local ang = norm:Dot(LocalPlayer():EyeAngles():Forward())
                    local tricker = (12-math.sqrt(targetpos:Distance(ply:EyePos())))/60
                    if ang > 0.75-tricker then
                        local viewangles = ply:EyeAngles()
                        local targetbody = target:LookupBone(bone)
                        
                        local tr = util.TraceLine( {
                            mask = MASK_SHOT,
                            start = LocalPlayer():EyePos(),
                            endpos = targetpos,
                            filter = {LocalPlayer()}
                        } )

                        if tr.Entity != v then return end
                        
                        local targetpos, targetang = target:GetBonePosition(targetbody)
                        local aimto = (targetpos-ply:GetShootPos()):Angle()
                        local thing = LerpAngle(FrameTime()*speed, ply:EyeAngles(), aimto)
                        cmd:SetViewAngles(Angle(thing.p, thing.y, 0))
                    end
                end
            end
        end
    end
end )