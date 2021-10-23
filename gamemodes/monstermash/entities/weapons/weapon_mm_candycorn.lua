AddCSLuaFile()
DEFINE_BASECLASS( "weapon_mm_basebase" )

SWEP.Author = "Buu342"
SWEP.Contact = "buu342@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Monster Mash Remake"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/monstermash/c_candycorn.mdl" 
SWEP.WorldModel = "models/weapons/monstermash/w_candycorn.mdl" 
SWEP.ViewModelFlip = false

SWEP.Primary.ClipSize = -1

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false

SWEP.Slot = 5
SWEP.UseHands = true
SWEP.Base = "weapon_mm_basebase"
SWEP.HoldType = "slam" 

SWEP.RunSpeed = 80

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Int", 0, "MMBase_State")
    self:NetworkVar("Float", 0, "MMBase_StateTimer")
end

function SWEP:Deploy()
    BaseClass.Deploy(self)
	self.Owner:GetViewModel( ):SetPlaybackRate( 1 )
	self.Owner:GetViewModel():SetSequence( "Draw" )
    self:SetMMBase_State(0)
    self:SetMMBase_StateTimer(CurTime()+0.75)
end

function SWEP:Holster()
    if (self:GetMMBase_State() == 5) then
        return true
    else
        return false
    end
end

function SWEP:Think()
    BaseClass.Think(self)
    
    if (self:GetMMBase_StateTimer() < CurTime()) then
        self:SetMMBase_State(self:GetMMBase_State()+1)
        
        if (self:GetMMBase_State() == 1) then
            self.Owner:GetViewModel( ):SetPlaybackRate( 1.5 )
            self.Owner:GetViewModel():SetSequence( "Pills" )
            self:SetMMBase_StateTimer(CurTime()+0.4)
            self.Owner:ViewPunch(Angle(0,-2,0))
        elseif (self:GetMMBase_State() == 2) then
            self:SetMMBase_StateTimer(CurTime()+0.5)
            self.Owner:ViewPunch(Angle(0,-2,0))
        elseif (self:GetMMBase_State() == 3) then
            self:SetMMBase_StateTimer(CurTime()+0.2)
            self.Owner:ViewPunch(Angle(2,2,0))
        elseif (self:GetMMBase_State() == 4) then
            self:SetMMBase_StateTimer(CurTime()+0.5)
            self.Owner:ViewPunch(Angle(2,2,0))
        elseif (self:GetMMBase_State() == 5) then
            self:SetMMBase_StateTimer(CurTime()+0.5)
            self.Owner:ViewPunch(Angle(-5,0,0))
            if CLIENT && IsFirstTimePredicted() then
                self.Owner:EmitSound("weapons/healing/nom.wav", 75, 100, 0.5, CHAN_VOICE2)
            end
            self.Owner:SetHealth(math.Clamp(self.Owner:Health() + 35, 0, self.Owner:GetMaxHealth()))
            if SERVER then
                if (IsValid(self.Owner.PrevWeapon)) then
                    self.Owner:SelectWeapon(self.Owner.PrevWeapon)
                end
                self:Remove()
            end
        end
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:OnDrop()
	self:Remove()
end