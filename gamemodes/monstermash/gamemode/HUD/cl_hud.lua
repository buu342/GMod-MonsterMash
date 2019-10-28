surface.CreateFont( "TheDefaultSettings", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings2", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 96,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings3", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "TheDefaultSettings4", {
	font = "Chiller", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13-big", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "Friday13-small", {
	font = "Friday13", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 7,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )


local Tex_white = surface.GetTextureID( "vgui/white" )
local medaly = {0,0,0}
local function DrawPercentageCircle( x, y, radius, seg, progression )
	local cir = { [1] = { x = x, y = y } }
	local cir2 = { [1] = { x = x, y = y } }

	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		cir[#cir+1] = { x = x - math.sin( a ) * radius, y = y - math.cos( a ) * radius }
	end

	for i = 0, progression do
		table.insert( cir2, cir[next(cir)+1] )
		table.remove( cir, next(cir)+1 )
	end

	surface.SetTexture( Tex_white )
	surface.SetDrawColor( 255, 0, 0, 100 )
	surface.DrawPoly( cir )
	//surface.SetDrawColor( 0, 0, 0, 255 )
	//surface.DrawPoly( cir2 )
end

local function IsSlotEmpty( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then return false end 
	end

	return true

end

local function SelectWep( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			net.Start("MM_SelectWeapon")
			net.WriteString(v:GetClass())
			net.SendToServer()
		end
	end

end

local function CheckWep( ply, slot )

	slot = slot - 1 

	local weptbl = ply:GetWeapons()

	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			return v
		end
	end
	
end

local function SelectWepIcon( ply, slot )
	slot = slot - 1 
	if not ply:Alive() then return end
	local weptbl = ply:GetWeapons()
	for k, v in pairs( weptbl ) do 
		if v:GetSlot() == slot then
			ply:SetNWString("lastselecticon",v.SelectIcon)
		end
	end
end

local function SelectWeapon1()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),1))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 1 )
	SelectWepIcon(LocalPlayer(), 1)
end

local function SelectWeapon2()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),2))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 2 )
	SelectWepIcon(LocalPlayer(), 2)
end

local function SelectWeapon3()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),3))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 3 )
	SelectWepIcon(LocalPlayer(), 3)
end

local function SelectWeapon4()
	LocalPlayer():SetNWFloat("WeaponSelectOpen",CurTime()+1)
	LocalPlayer():SetNWFloat("LastKeyDown4",CurTime()+1.12)
	LocalPlayer():SetNWFloat("LastKeyDown2",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown3",CurTime())
	LocalPlayer():SetNWFloat("LastKeyDown1",CurTime())
	net.Start("MM_SelectWeaponOpen")
	net.WriteEntity(CheckWep(LocalPlayer(),4))
	net.SendToServer()
	LocalPlayer():ConCommand("Play gameplay/switch.wav")
	SelectWep(LocalPlayer(), 4 )
	SelectWepIcon(LocalPlayer(), 4)
end

if CLIENT then // Not my code. Thank you gmod wiki
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
end

local NormalRT = GetRenderTarget( "NormalMaterial", ScrW(), ScrH(), false )
local MirrorRT = GetRenderTarget( "MirrorTexture", ScrW(), ScrH(), false )

local view = {} 

local NormalMaterial = CreateMaterial(
    "NormalMaterial",
    "UnlitGeneric",
    {
        [ '$basetexture' ] = NormalRT,
        [ '$basetexturetransform' ] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
    }
)

local MirroredMaterial = CreateMaterial(
    "MirroredMaterial",
    "UnlitGeneric",
    {
        [ '$basetexture' ] = MirrorRT,
        [ '$basetexturetransform' ] = "center .5 .5 scale -1 1 rotate 0 translate 0 0",
    }
)
	 
     
hook.Add("RenderScene", "Mirror.RenderScene", function( Origin, Angles )

	if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
		view.x = 0
		view.y = 0
		view.w = ScrW()
		view.h = ScrH()
		view.origin = Origin
		view.angles = Angles
		view.drawhud = true
	 
		// get the old rendertarget
		local oldrt = render.GetRenderTarget()
	 
		// set the rendertarget
		render.SetRenderTarget( MirrorRT )
		 
			// clear
			render.Clear( 0, 0, 0, 255, true )
			render.ClearDepth()
			render.ClearStencil()
			render.RenderView( view )
			
	 
		// restore
		render.SetRenderTarget( oldrt )
		MirroredMaterial:SetTexture( "$basetexture", MirrorRT )
		render.SetMaterial( MirroredMaterial )
		render.DrawScreenQuad()
		
		
		if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
			local alpha
			alpha = ((LocalPlayer():GetNWFloat("MM_Concussion") - CurTime())/8)*270
			surface.SetDrawColor(0,0,0,alpha)
			surface.DrawRect( -1, -1, 2, 2 )
		end
		
		DrawMotionBlur( 0.2, 0.8, 0.01 )
		render.RenderHUD( 0,0,ScrW(), ScrH() )
		return true
    elseif LocalPlayer():GetNWFloat("MM_Hallucinate") > CurTime() then
		view.x = 0
		view.y = 0
		view.w = ScrW()
		view.h = ScrH()
		view.origin = Origin
		view.angles = Angles
		view.drawhud = true

		// get the old rendertarget
		local oldrt = render.GetRenderTarget()
	 
		// set the rendertarget
		render.SetRenderTarget( NormalRT )
		 
			// clear
			render.Clear( 0, 0, 0, 255, true )
			render.ClearDepth()
			render.ClearStencil()
			render.RenderView( view )
			
	 
		// restore
		render.SetRenderTarget( oldrt )
		NormalMaterial:SetTexture( "$basetexture", NormalRT )
		render.SetMaterial( NormalMaterial )
		render.DrawScreenQuad()
		
		
		if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
			local alpha
			alpha = ((LocalPlayer():GetNWFloat("MM_Concussion") - CurTime())/8)*270
			surface.SetDrawColor(0,0,0,alpha)
			surface.DrawRect( -1, -1, 2, 2 )
		end
		
		DrawMotionBlur( 0.2, 0.8, 0.01 )
		render.RenderHUD( 0,0,ScrW(), ScrH() )
		return true
    end
end )

hook.Add( "InputMouseApply", "flipmouse", function( cmd, x, y, angle )
 
	if LocalPlayer():GetNWFloat("MM_Concussion") > CurTime() then
		local pitchchange = y * GetConVar( "m_pitch" ):GetFloat()
		local yawchange = x * -GetConVar( "m_yaw" ):GetFloat()
		 
		angle.p = angle.p + pitchchange * ( 1 )
		angle.y = angle.y + yawchange * ( -1 )
		 
		cmd:SetViewAngles( angle )
		 
		return true
	end
end )

function bool_to_number(value)
    if value == true then
        return 2
    else
        return 0
    end
end


local mat_hud_back      = Material( "vgui/hud/hud_back.png" )
local mat_heart_dark    = Material( "vgui/hud/heart_dark.png" )
local mat_heart_light   = Material( "vgui/hud/heart_light.png" )
local mat_leg_left      = Material( "vgui/hud/leg_left.png" )
local mat_leg_right     = Material( "vgui/hud/leg_right.png" )
local mat_arm_left      = Material( "vgui/hud/arm_left.png" )
local mat_arm_right     = Material( "vgui/hud/arm_right.png" )
local mat_corn_empty2   = Material( "vgui/hud/candy_corn_empty2.png" )
local mat_corn_full     = Material( "vgui/hud/candy_corn_full.png" )
local mat_hud_base      = Material( "vgui/hud/base.png" )
local mat_hud_front     = Material( "vgui/hud/hud_front.png" )
local mat_gravestone    = Material( "vgui/hud/gravestone.png" )
local mat_screamy3      = Material( "vgui/hud/screamy3" )
local mat_screamy2      = Material( "vgui/hud/screamy2" )
local mat_screamy       = Material( "vgui/hud/screamy" )
local mat_spooky_fella  = Material( "vgui/hud/spooky_fella.png" )
local mat_spooky_madam  = Material( "vgui/hud/spooky_madam.png" )
local mat_bleedout      = Material( "vgui/hud/bleedout" )
local mat_webbing       = Material( "vgui/hud/webbing" )

local deathhints = {
    "Looking for a budget-friendly way to earn medals? Try pelting the toilet paper roll at opponents, it’s a free item.",
    "Less effective weapons will grant more points per kill than their bigger, more grandiose counterparts.",
    "While some weapons may earn more or fewer base points, certain weapons can earn certain situational medals much easier for extra points.",
    "Missing an arm will make most guns 1/3rd as accurate and take 3x longer to reload.",
    "Players who are missing a leg can only hop, and they will not be able to reload unless they are standing still.",
    "Remember to eat your candy corn for partial health restoration whenever you have a moment away from danger.",
    "Get creative with your loadout. You might find fun, bizarre weapon combinations that work for you.",
    "The biggest, most expensive weapons aren’t necessarily the best fit for all battles. Consider a loadout that exploits the weaknesses of your opponent’s loadouts.",
    "Severed limbs don’t come back, but you will earn extra points by fighting to the death honorably in battle.",
    "Didn’t bring a melee weapon? There’s always your candle!",
    "Smacking opponents with your candle has a chance to engulf them in flames.",
    "Being concussed will reverse your left/right controls and remove your crosshair until you recover.",
    "Players who successfully earn kills while concussed, bleeding, or missing a limb, will earn medals and extra points.",
    "All melee weapons are extra effective when attacking from behind.",
    "Bleeding starts harsh but gradually dampens out, however you may want to heal as soon as it starts.",
    "Lose both your arms? Headbutt them!",
    "Someone outgunning you at every turn? Try jamming their guns with the gore jar to tip the odds in your favor.",
    "Need to handicap an enemy sharpshooter? Fight back with the sawblade launcher.",
    "Though it may not deal much damage, the fence post has the longest reach of all the melee weapons. Use it to strike opponents from beyond the reach of their own melee weapons.",
    "The spider ‘nade splatters a sticky web on the floor which can trap foes in place. Throw it where opponents are walking towards to stop them in their tracks.",
    "The axe is a jack of all trades; it deals moderate damage, is the only melee weapon which can deal all three status effects, and can decapitate foes as well.",
    "The wacky round is always around the corner, there’s no telling what it may be!",
    "Look out for opponents weilding the battle axe, it grants the owner +25 health and can slice you clean in half with one swing.",
    "When an enemy projectile is heading towards you, dodgeroll out of the way to avoid all direct damage.",
    "If you are easily spooked by screamers, you can disable the haunted urn’s ghastliness in your options.",
    "Gmod has terrible hit regristration, there’s no shame in enabling aim-assist in your options to help bypass this problem.",
    "If you get motion sick easily, you can disable the De-Animator’s electrocution effect and the dodge rolling view effect in options.",
    "Having difficulty swinging your melee weapon at moving targets? Try enabling Melee Hard Lock.",
    "Melee dashes are best used for bridging the gap between you and an opponent, or making a quick escape.",
    "Buffs are abilities that can give you an edge in or out of combat, but they must be earned with medals before you can use them.",
    "Be sure to kill the person who had killed you last to earn a medal and extra points.",
    "Remember, a well-rounded loadout will give you more options for handling combat than a loadout invested in fewer weapons.",
    "It’s not about how many kills you get, it’s about how many points you earn. Try using lower-tier weapons and getting situational medals to earn the highest score.",
    "Although it’s best suited for close-range combat, the Cremator’s secondary attack blasts out a powerful fireball for striking targets at a distance.",
    "Striking someone with a melee weapon during a dash will deal 20% additional damage.",
    "When choosing a melee weapon, decide what you’re trying to optimize your loadout for. Extra points, bleeding, dismembering, concussing, or perhaps a little bit of everything.",
    "Although they have no alternate attacks, the Coach Gun and Sawblade Launcher are the only primary weapons that can remove limbs.",
    "Finishing a melee dash will render you unable to dodgeroll out of harm’s way until your stamina has recharged!",
    "Using a fully randomized loadout will earn you +5 extra points per kill.",
    "If your gun’s crosshairs aren’t red, you’re not close enough to your opponent for your shots to reach them.",
    "Scoring a kill while barely clinging to life will give you a medal and extra points.",
    "Have a melee weapon that can dismember? Aim for the head to decapitate your opponent for extra points!",
    "The stake kills opponents with a single stab, but is left in their body after usage. Consider how many foes you’ll be taking on before deciding if you can risk losing your melee weapon in the middle of a fight.",
    "Some guns can explode heads with a fatal headshot, granting extra points.",
    "Honor melee weapon fights. Use your own melee weapon to kill a melee-weilding opponent for extra points.",
    "Though lacking in stealth, the chainsaw is the most viscious melee weapon of them all.",
    "The Shock Rifle and De-Animator can be equally dangerous to their users as they can be to their enemies. Overcharging will explode them right in your own hands!",
    "The De-Animator can fire a devestating electrical blast to obliterate opponents, though bear in mind the user will be vulnerable for a moment afterwards as they’re electrocuted by the aftermath.",
    "Most primary weapons have an alternate attack which you may find useful for certain situations.",
    "The Dueling Pistol will hold its weilder in place as they charge it for damage, making it more optimized for defensive situations.",
    "Though it doesn’t deal any direct damage, the Haunted Urn can allow you to freeze opponents in place, giving you a moment to capitalize on their vulnerability.",
    "If a foe is hiding out of sight, most throwables or weapons with splash damage can flush them out by hitting near their cover.",
    "The minigun is a devestating weapon which can mow players down with ease, but the weilder can easily be handicapped with a gorejar or the removal of a limb.",
    "While universally considered a bad weapon, the Boner does score a sizable amount of points and drop a medkit upon dealing the killing blow.",
    "Be sure to read the description and stats of your selected weapon on the loadout menu to get an idea of how your weapon works."
}

local deathhintnum = 1
local lowtimewarn = false

local skellies = {}
local bats = {}
local skeletonfly = {
    Material( "animated/skeleton1.png" ),
    Material( "animated/skeleton2.png" ),
    Material( "animated/skeleton3.png" ),
    Material( "animated/skeleton4.png" ),
    Material( "animated/skeleton5.png" ),
    Material( "animated/skeleton6.png" ),
    Material( "animated/skeleton7.png" ),
    Material( "animated/skeleton8.png" )
}
local batstext = Material( "animated/bat" )

function hud()
    local scale_width 	= 1600
	local scale_height 	= 900
	local MultW 		= ScrW() / scale_width
	local MultH 		= ScrH() / scale_height

	/*--------------------------------------------
					Crosshairs
	--------------------------------------------*/
	//{
	
	if IsValid(LocalPlayer()) && ( LocalPlayer():Alive()) && IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():GetClass() != nil then
		if LocalPlayer():GetNWFloat("MM_Concussion") < CurTime() then
            local weapon = LocalPlayer():GetActiveWeapon()
            if weapon:GetClass() == "mm_battlerifle" || weapon:GetClass() == "mm_cannon" then
                local charge = 0
                local chargetype = 0
                local recharge = 0
                local rechargetype = 0
                local extraypos = 0
                
                if      weapon:GetClass() == "mm_battlerifle"   then    recharge = (LocalPlayer():GetNWFloat("Battlerifle_alt")-CurTime()) rechargetype = 0
                elseif  weapon:GetClass() == "mm_cannon"        then    charge = (LocalPlayer():GetActiveWeapon():GetGun_Charge())/5000 chargetype = 0 extraypos = weapon.CrosshairChargeSize/2
                end
                
                if recharge+CurTime() > CurTime() then
                    surface.SetDrawColor( 255, 255, 255, 255 )
                    surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
                    local size = weapon.CrosshairRechargeSize*((recharge)/3)
                    surface.DrawTexturedRect( (ScrW()/2) - (size/2)-16, (ScrH()/2)-(size/2)-16, 33+size,33+size )
                end
                if charge != 0 then
                    local size = weapon.CrosshairChargeSize
                    surface.SetDrawColor( 255, 0, 0, 100 )
                    surface.SetMaterial( weapon.CrosshairChargeMaterial )
                    local iheight = (size * charge)
                    local icharge = (1-charge)
                    surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
                end
                if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
                    surface.SetDrawColor( 255, 0, 0, 255 )
                else
                    surface.SetDrawColor( 255, 255, 255, 255 )
                end
                surface.SetMaterial( weapon.CrosshairMaterial ) local size = weapon.CrosshairSize*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
                surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2) + extraypos, size,size )
            end

			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_coachgun" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer()) && ((weapon.UseDistance && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= weapon.ShootDistance)) || !weapon.UseDistance) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 88
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_colt" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer()) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance)  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end

				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 40*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end		
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_crossbow" || LocalPlayer():GetActiveWeapon():GetClass() == "mm_sawblade" || LocalPlayer():GetActiveWeapon():GetClass() == "mm_flaregun" then

				local size = 48
                surface.SetMaterial( weapon.CrosshairChargeMaterial )
                surface.SetDrawColor( 0, 255, 0, 100 )
				local charge
				if LocalPlayer():GetNWFloat("MM_FlamingArrow") > CurTime() && LocalPlayer():GetActiveWeapon():GetClass() == "mm_crossbow" then
					charge = 1-(LocalPlayer():GetNWFloat("MM_FlamingArrow") - CurTime())/20
				else
                    charge = 0
                end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge))-3, size,iheight, 0, 1-charge, 1, 1 )
                
                if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington"  && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
                surface.SetMaterial( weapon.CrosshairMaterial )
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2)+20, size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_musketpistol" then
			
				local charge = LocalPlayer():GetNWFloat("mm_musketpistol_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
                DrawPercentageCircle((ScrW()/2), (ScrH()/2),9,115,115-LocalPlayer():GetActiveWeapon():GetDuelGun_Charge())
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility"))|| (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_deanimator" then
                local cooldown = LocalPlayer():GetActiveWeapon():GetGun_Cooldown2()-CurTime()
                if cooldown+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairMaterial2 ) 
					local size = 64*(cooldown)*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-32, (ScrH()/2)-(size/2)-32, 64+size,64+size )
				end
                local size = 64
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
                surface.SetDrawColor( 255, 255, 0, 100 )
                charge = (LocalPlayer():GetActiveWeapon():GetGun_Charge())/100
                if charge > 1 then
                    charge = 1
                end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge))-size/2, size,iheight, 0, 1-charge, 1, 1 )
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-size/2, size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_wand" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge

                surface.SetDrawColor( 255, 0, 0, 100 )
                charge = (LocalPlayer():GetActiveWeapon():GetGun_Charge())/100

				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end			

            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_pumpkinnade" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_pumpkinnade_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_electricrifle" then
				local size = 64
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
                surface.SetDrawColor( 255, 255, 0, 100 )
                charge = (LocalPlayer():GetActiveWeapon():GetElectricRifleHeat())/20
                if charge > 1 then
                    charge = 1
                end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge))-size/2, size,iheight, 0, 1-charge, 1, 1 )
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-size/2, size,size )
			end
            
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_cleaver" then
			
				local charge = LocalPlayer():GetNWFloat("mm_cleaver_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial )
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_spidernade" then
			
				local charge = LocalPlayer():GetNWFloat("mm_web_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_skull" then
			
				local charge = LocalPlayer():GetNWFloat("mm_skull_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_toiletpaper" then
			
				local charge = LocalPlayer():GetNWFloat("mm_tp_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
				
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_pumpshotgun" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				local x = LocalPlayer():GetActiveWeapon().Primary.Spread
				local size = x*100
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_repeater" then
                DrawPercentageCircle((ScrW()/2), (ScrH()/2),14,100,100-LocalPlayer():GetActiveWeapon():GetGun_Charge()*100/8)

				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 46*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
                
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_revolver" || LocalPlayer():GetActiveWeapon():GetClass() == "mm_shield" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 40*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_sawedoff" then
				if (LocalPlayer():GetEyeTrace().Entity:IsPlayer() || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 128
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_flamethrower" then
            
				DrawPercentageCircle((ScrW()/2), (ScrH()/2),45,100,100-LocalPlayer():GetActiveWeapon():GetGun_Charge())
                
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 88
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )

			end
            
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_undertaker" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 80*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_minigun" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().ShootDistance then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 128*(1+bool_to_number(LocalPlayer():GetActiveWeapon():GetGun_MessWithArmStuff()))
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_urn" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_urn_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_acidflask" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_acid_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_gorejar" then
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				local size = 96
				surface.SetMaterial( weapon.CrosshairChargeMaterial )
				local charge
				if LocalPlayer():GetActiveWeapon():Clip1() < 1 then
					surface.SetDrawColor( 0, 255, 0, 100 )
					charge = 1-(LocalPlayer():GetNWFloat("mm_gorejar_recharge") - CurTime())/20
				else
					surface.SetDrawColor( 255, 0, 0, 100 )
					charge = (LocalPlayer():GetActiveWeapon():GetMM_PrimeTime())/825
				end
				local iheight = (size * charge)
				local icharge = (1-charge)
				surface.DrawTexturedRectUV( (ScrW()/2) - (size/2), ((ScrH()/2)+(size*icharge)), size,iheight, 0, 1-charge, 1, 1 )
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( weapon.CrosshairMaterial ) 
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2), size,size )
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "mm_stake" then
			
				local charge = LocalPlayer():GetNWFloat("mm_stake_recharge")-CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
                
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().Reach  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
            if LocalPlayer():GetActiveWeapon():GetClass() == "mm_stick" then
			
				local charge = LocalPlayer():GetActiveWeapon():GetFaketimer3() - CurTime()
				if charge+CurTime() > CurTime() then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( weapon.CrosshairRechargeMaterial ) 
					local size = 16*((charge)/3)
					surface.DrawTexturedRect( (ScrW()/2) - (size/2)-8, (ScrH()/2)-(size/2)-8, 18+size,18+size )
				end
			
				if ((LocalPlayer():GetEyeTrace().Entity:IsPlayer() && !LocalPlayer():GetEyeTrace().Entity:GetNWBool("MM_UsingInvisibility")) || (LocalPlayer():GetEyeTrace().Entity:GetClass() == "sent_skellington" && LocalPlayer():GetEyeTrace().Entity:GetMaster() != LocalPlayer())) && LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():GetShootPos()) <= LocalPlayer():GetActiveWeapon().Reach  then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 255, 255 )
				end
				
				surface.SetMaterial( weapon.CrosshairMaterial ) local size = 18
				surface.DrawTexturedRect( (ScrW()/2) - (size/2), (ScrH()/2)-(size/2), size,size )
			end
		end
	end
	//}
    
	
	/*--------------------------------------------
                Screen Text and HUD
	--------------------------------------------*/
    
	//{
    
	if LocalPlayer():Team() != 2 && LocalPlayer():Team() != 5 then 
    
        local tr = util.TraceHull( {
            start = LocalPlayer():GetShootPos(),
            endpos = LocalPlayer():GetShootPos() + ( LocalPlayer():GetAimVector() * 100 ),
            filter = LocalPlayer(),
            mins = Vector( -10, -10, -10 ),
            maxs = Vector( 10, 10, 10 ),
            mask = MASK_SHOT_HULL
        } )
        
        if IsValid(LocalPlayer()) && ( LocalPlayer():Alive() && tr.Hit && tr.Entity:IsWeapon() && !LocalPlayer():HasWeapon(tr.Entity:GetClass())) || (LocalPlayer():Alive() && tr.Hit && ((tr.Entity:GetClass() == "ent_skull" && tr.Entity:GetNetworkedBool("HitAlready") == true) || tr.Entity:GetClass() == "ent_tp")) then
            halo.Add( {tr.Entity}, Color(255,105,0,255), 2, 2, 1, true, false )
            draw.SimpleTextOutlined( "Press E to pick up "..tr.Entity.PrintName, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
            
        if LocalPlayer():Alive() then
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( mat_hud_back )
            surface.DrawTexturedRect( 23+16, ScrH()-131-16+4, 229, 128 )
            
            if LocalPlayer():GetNWInt("LegMissing") != 3 then
                surface.SetDrawColor( 255, 105, 0, 255 )
                surface.DrawRect( 32+14, ScrH()-131+86, 220*(LocalPlayer():GetNWFloat("DiveCooldown"))/5, 21 )
            end
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            
            surface.SetMaterial( mat_heart_dark )
            surface.DrawTexturedRect( 32+12+16, ScrH()-131-16+10, 53, 80 )
            surface.SetMaterial( mat_heart_light )
            local hp = LocalPlayer():Health()/LocalPlayer():GetMaxHealth()
            local col = Color(255,255,255,255)
            if LocalPlayer():GetNWInt("MM_BleedDamage") >= 1 then
                col = Color(255,0,0,255)
            end
            surface.DrawTexturedRectUV( 32+12+16, math.floor(ScrH()-136+80*(1-hp)), 53, math.ceil(80*hp), 0, 1-hp, 1, 1 )
            draw.SimpleTextOutlined( LocalPlayer():Health(), "TheDefaultSettings", 68+16, ScrH()-88, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            
            if LocalPlayer():GetNWInt("LegMissing") != 3 then
                if LocalPlayer():GetNWInt("LegMissing") != 1 then
                    surface.SetMaterial( mat_leg_left )
                    surface.DrawTexturedRect( 32+12+64+16+16, ScrH()-131+31, 17/1.4, 62/1.4 )
                end
                
                if LocalPlayer():GetNWInt("LegMissing") != 2 then
                    surface.SetMaterial( mat_leg_right )
                    surface.DrawTexturedRect( 32+12+64+36+16, ScrH()-131+31, 31/1.4, 65/1.4 )
                end
            end
            
            if LocalPlayer():GetNWInt("ArmMissing") != 3 then
                if LocalPlayer():GetNWInt("ArmMissing") != 1 then
                    surface.SetMaterial( mat_arm_left )
                    surface.DrawTexturedRect( 32+12+60+16, ScrH()-126, 33/1.4, 29/1.4 )
                end
                
                if LocalPlayer():GetNWInt("ArmMissing") != 2 then
                    surface.SetMaterial( mat_arm_right )
                    surface.DrawTexturedRect( 32+12+96+16, ScrH()-131-6, 31/1.4, 27/1.4 )
                end
            end
            
            surface.SetMaterial( mat_hud_base )
            surface.DrawTexturedRect( 32+12+64+16+16, ScrH()-131-16+10, 34/1.4, 61/1.4 )
            
            surface.SetMaterial( mat_corn_empty2 )
            surface.DrawTexturedRect( 32+140+6+16, ScrH()-136, 58, 80 )
            if LocalPlayer():GetNWInt("ArmMissing") != 3 then
                surface.SetMaterial( mat_corn_full )
                local time = 1-math.Clamp((LocalPlayer():GetNWFloat("HealTime")-CurTime())/20,0,20)
                surface.DrawTexturedRectUV( 32+140+6+16, math.floor(ScrH()-136+80*(1-time)), 58, math.ceil(80*time), 0, 1-time, 1, 1 )
                if LocalPlayer():GetNWFloat("HealTime") > CurTime() then
                    draw.SimpleTextOutlined( math.ceil(LocalPlayer():GetNWFloat("HealTime")-CurTime()), "TheDefaultSettings", 32+140+6+30+16, ScrH()-131+42, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
            
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( mat_hud_front )
            surface.DrawTexturedRect( 0, ScrH()-131-53, 311, 182 )
            
            // Right side
            
            if LocalPlayer():GetNWInt("NumberShowingMedals") > 0 then
                for i=3, 1, -1 do
                    if LocalPlayer():GetNWFloat("ShowMedal"..i) > CurTime() && i <= LocalPlayer():GetNWInt("NumberShowingMedals") then
                        local ymax = 72*(LocalPlayer():GetNWInt("NumberShowingMedals")+1-i)
                        medaly[i] = math.ceil(medaly[i]*0.9 + ymax*0.1)
                        
                        if LocalPlayer():GetNWFloat("ShowMedal"..i) < CurTime()+0.5 then
                            surface.SetDrawColor( 255, 255, 255, 255*(LocalPlayer():GetNWFloat("ShowMedal"..i)-CurTime())/0.5)
                        else
                            surface.SetDrawColor( 255, 255, 255, 255)
                        end
                        local type = v:GetNWString("ShowMedalType"..i)
                        local mat = "vgui/hud/medals/"..type..".png"
                        surface.SetMaterial( Material( mat ) )
                        surface.DrawTexturedRect( ScrW()-120+24, ScrH()-131-48-medaly[i]+24, 72, 72 )
                    else
                        if LocalPlayer():GetNWInt("NumberShowingMedals") == 2 && medaly[3] != 0 then
                            medaly[1] = medaly[2]
                            medaly[2] = medaly[3]
                            medaly[3] = 0
                        elseif LocalPlayer():GetNWInt("NumberShowingMedals") == 1 && medaly[2] != 0 then
                            medaly[1] = medaly[2]
                            medaly[2] = 0
                            medaly[3] = 0
                        end
                    end
                end
            else
                medaly[1] = 0
                medaly[2] = 0
                medaly[3] = 0
            end
                    
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( mat_gravestone )
            surface.DrawTexturedRect( ScrW()-100, ScrH()-131-16, 85, 131 )
            if LocalPlayer():GetNWString("buff_ready") != "" then
                local tblpos
                for i=1, #MonsterMash_Weapons["buff"] do
                    if MonsterMash_Weapons["buff"][i].entity == LocalPlayer():GetNWString("buff_ready") then
                        tblpos = i
                        break
                    end
                end
                surface.SetMaterial( Material(MonsterMash_Weapons["buff"][tblpos].icon) )
                surface.DrawTexturedRect( ScrW()-100+20, ScrH()-131-12, 48, 48 )
            end
            draw.SimpleTextOutlined( LocalPlayer():GetNWInt("killcounter"), "TheDefaultSettings", ScrW()-16-40, ScrH()-76, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            if LocalPlayer():GetNWString("Buff") != "" then
                draw.SimpleTextOutlined( LocalPlayer():GetNWInt("buffcost").."/"..LocalPlayer():GetNWInt("buffcost"), "TheDefaultSettings", ScrW()-16-40, ScrH()-86+50, Color(96,96,96,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            else
                local sin = 255
                if (LocalPlayer():GetNWInt("MM_MedalsEarned") == LocalPlayer():GetNWInt("buffcost")) && LocalPlayer():GetNWInt("buffcost") != 0 then
                    sin = math.abs(math.sin(CurTime()*2))*255
                end
                local color = Color(sin, 255, sin, 255)
                draw.SimpleTextOutlined( LocalPlayer():GetNWInt("MM_MedalsEarned").."/"..LocalPlayer():GetNWInt("buffcost"), "TheDefaultSettings", ScrW()-16-40, ScrH()-86+50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            if IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():Clip1() != -1 then
                local wep = LocalPlayer():GetActiveWeapon():GetClass()
                draw.SimpleTextOutlined( LocalPlayer():GetActiveWeapon():Clip1(), "TheDefaultSettings2", ScrW()-150, ScrH()-60, Color(255,105,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            
            if LocalPlayer():GetNWFloat("LastScoreTime") > CurTime() then
                local time = LocalPlayer():GetNWFloat("LastScoreTime") - CurTime()
                draw.SimpleTextOutlined( "+"..LocalPlayer():GetNWInt("LastScore"), "TheDefaultSettings", ScrW()-16-40, ScrH()-72-(1-time)*100, Color(255,255,255,255*time), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255*time))
            end
        end
    end
	
	//}
    
	/*--------------------------------------------
				 Round Start/Stop
	--------------------------------------------*/
	
	//{
	
    if GetGlobalVariable("Game_Over") == true then
        draw.SimpleTextOutlined( "Round Over", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		if GetGlobalVariable("Winner") == "MonsterTeam" then
            draw.SimpleTextOutlined( "Monsters Win!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("Winner") == "OtherTeam" then
            draw.SimpleTextOutlined( "Skeletons win!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("Winner") && GetGlobalVariable("Winner") == LocalPlayer():GetName() then
            draw.SimpleTextOutlined( "You're Winner!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		elseif GetGlobalVariable("Winner") then
            draw.SimpleTextOutlined( GetGlobalVariable("Winner").." is the Gravekeeper!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		end
	end
	if GetGlobalVariable("RoundStartTimer") > CurTime() then
        if GetGlobalVariable("RoundsToWacky") == 0 then
            draw.SimpleTextOutlined( "Wacky round is here", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        elseif GetGlobalVariable("RoundsToWacky") == 1 then
            draw.SimpleTextOutlined( "Wacky round next round", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		else
            draw.SimpleTextOutlined( "Wacky round in "..GetGlobalVariable("RoundsToWacky").." rounds", "TheDefaultSettings", ScrW()/2, 24, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        end
        draw.SimpleTextOutlined( "Round Starting in: "..(math.ceil(GetGlobalVariable("RoundStartTimer")-CurTime(),0)).." seconds", "TheDefaultSettings", ScrW()/2, 64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
        if GetGlobalVariable("RoundsToWacky") == 0 then
            if GetGlobalVariable("WackyRound_Event") == 0 then
                if GetGlobalVariable("WackyRound_COOPOther") == LocalPlayer() then
                    draw.SimpleTextOutlined( "Show everyone the cool stick you found at the park (Leave no survivors)", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    draw.SimpleTextOutlined( "Primary Attack to clang, Secondary Attack to dash", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                else
                    draw.SimpleTextOutlined( "Kirito from the Chinese TV show Goblin Slayer is on the loose!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                    draw.SimpleTextOutlined( "Work together to put a stop to him!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                end
            end
            if GetGlobalVariable("WackyRound_Event") == 1 then
                draw.SimpleTextOutlined( "Crappy skeleton sprites are invading!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Work together to fight the horde!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end            
            if GetGlobalVariable("WackyRound_Event") == 2 then
                draw.SimpleTextOutlined( "It's dodgeball time!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Get the most points!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end            
            if GetGlobalVariable("WackyRound_Event") == 3 then
                draw.SimpleTextOutlined( "Ludicrous Gibs Mode!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "All kills gib!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            if GetGlobalVariable("WackyRound_Event") == 4 then
                draw.SimpleTextOutlined( "And then a skeleton popped out!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Players leave skeletons behind when killed!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            if GetGlobalVariable("WackyRound_Event") == 5 then
                draw.SimpleTextOutlined( "Bullet Time!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Time will slow to a crawl, but when?!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
            if GetGlobalVariable("WackyRound_Event") == 6 then
                draw.SimpleTextOutlined( "Random loadouts!", "TheDefaultSettings", ScrW()/2, ScrH()/2-12, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
                draw.SimpleTextOutlined( "Don't get too attached to your gear!", "TheDefaultSettings", ScrW()/2, ScrH()/2+32, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        end
    else
        local time = math.floor(GetGlobalVariable("RoundTime")-CurTime())
        if time < 0 then
            time = 0
        end
        local mins = math.floor(time/60)
        local secs = math.floor(time%60)
        if mins < 10 then
            mins = "0"..tostring(mins)
        else
            mins = tostring(mins)
        end
        
        if secs < 10 then
            secs = "0"..tostring(secs)
        else
            secs = tostring(secs)
        end
        local col = Color(255,105,0,255)
        if math.floor(time/60) == 0 && time%60 < 30 then
            col = Color(255,0,0,255)
        end
        
        if math.floor(time/60) == 0 && time%60 == 29 && lowtimewarn == false then
            lowtimewarn = true
            LocalPlayer():ConCommand("Play ui/time_ending.wav")
        elseif !(math.floor(time/60) == 0 && time%60 == 29) then
            lowtimewarn = false
        end
        draw.SimpleTextOutlined( mins..":"..secs, "TheDefaultSettings", ScrW()/2, 24, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
    end
	
    if GetGlobalVariable("Game_Over") == false && GetGlobalVariable("RoundsToWacky") == 0 && GetGlobalVariable("WackyRound_Event") == 1 && GetGlobalVariable("RoundStartTimer") < CurTime() then
        local skeleton_count = 0
        for k, v in pairs( ents.FindByClass("sent_skellington")) do
            skeleton_count = skeleton_count + 1
        end
        draw.SimpleTextOutlined( "Skeletons roaming: "..skeleton_count, "TheDefaultSettings", ScrW()/2, 72, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
	end
	//}
	
    
	/*--------------------------------------------
					 Screamer
	--------------------------------------------*/
	
	//{
	
	if LocalPlayer():GetNWFloat("Spooked") > CurTime() && LocalPlayer():GetNWFloat("Spooked_Bats") > CurTime() then
        local numbats = 6
        local size = 1024
        local size2 = size/2
        local actvel = 2
        local framespeed = 0.1
        
        if table.Count( bats ) != numbats then
            table.Empty(bats)
            for i=1, numbats do
                local skelly = {
                    x = math.random(0, ScrW()),
                    y = math.random(0, ScrH()),
                    vel = Vector(math.Rand(-7, 7), math.Rand(-7, 7), 0),
                    col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                }
                table.insert(bats, skelly)
            end
        end
        
        for i=1, numbats do            
            bats[i].x = bats[i].x + bats[i].vel.x*actvel
            bats[i].y = bats[i].y + bats[i].vel.y*actvel
            
            surface.SetDrawColor( bats[i].col.r, bats[i].col.g, bats[i].col.b, math.abs(math.sin(CurTime()+(bats[i].col.a/255)*6.28318))*255 )
            surface.SetMaterial( batstext )
            surface.DrawTexturedRect( bats[i].x-size2, bats[i].y-size2, size, size )
            
            if bats[i].x-size2/4 < 0 then
                bats[i].x = size2/4
                bats[i].vel.x = -bats[i].vel.x
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].x+size2/4 > ScrW() then
                bats[i].x = ScrW()-size2/4
                bats[i].vel.x = -bats[i].vel.x
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].y-size2/4 < 0 then
                bats[i].y = size2/4
                bats[i].vel.y = -bats[i].vel.y
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if bats[i].y+size2/4 > ScrH() then
                bats[i].y = ScrH()-size2/4
                bats[i].vel.y = -bats[i].vel.y
                bats[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
        end
	elseif LocalPlayer():GetNWFloat("Spooked") > CurTime() then
        surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("Spooked") - CurTime())*255 )
		if GetConVar("mm_pussymode"):GetInt() == 1 then
			surface.SetMaterial( mat_screamy3 )
		elseif LocalPlayer():GetNWInt("SpookType") == 1 then
			surface.SetMaterial( mat_screamy )
		elseif LocalPlayer():GetNWInt("SpookType") == 2 then
			surface.SetMaterial( mat_screamy2 )
		elseif LocalPlayer():GetNWInt("SpookType") == 3 then
			surface.SetMaterial( mat_spooky_fella )
		elseif LocalPlayer():GetNWInt("SpookType") == 4 then
			surface.SetMaterial( mat_spooky_madam )
		end
		
		size = ScrH()
		local moveup = math.min(ScrH(),(2.5 - (LocalPlayer():GetNWFloat("Spooked")-CurTime()))*ScrH()*4)
		surface.DrawTexturedRect( (ScrW()/2)-(size/2), ScrH()-moveup, size, size )
	end
	
	//}
    
    
    /*--------------------------------------------
					 Hallucinate
	--------------------------------------------*/
    
    //{
    
    if LocalPlayer():GetNWFloat("MM_Hallucinate") > CurTime() then 
        local numskels = 10
        local size = 256
        local size2 = size/2
        local actvel = 2
        local framespeed = 0.1
        
        if table.Count( skellies ) != numskels then
            table.Empty(skellies)
            for i=1, numskels do
                local skelly = {
                    x = math.random(0, ScrW()),
                    y = math.random(0, ScrH()),
                    vel = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0),
                    frame = 1,
                    col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                }
                table.insert(skellies, skelly)
            end
        end
        
        for i=1, numskels do            
            skellies[i].x = skellies[i].x + skellies[i].vel.x*actvel
            skellies[i].y = skellies[i].y + skellies[i].vel.y*actvel
            
            surface.SetDrawColor( skellies[i].col.r, skellies[i].col.g, skellies[i].col.b, math.abs(math.sin(CurTime()+(skellies[i].col.a/255)*6.28318))*255 )
            surface.SetMaterial( skeletonfly[1+math.floor(skellies[i].frame)] )
            surface.DrawTexturedRect( skellies[i].x-size2, skellies[i].y-size2, size, size )
            
            skellies[i].frame = (skellies[i].frame + framespeed)%8
            
            if skellies[i].x-size2 < 0 then
                skellies[i].x = size2
                skellies[i].vel.x = -skellies[i].vel.x
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].x+size2 > ScrW() then
                skellies[i].x = ScrW()-size2
                skellies[i].vel.x = -skellies[i].vel.x
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].y-size2 < 0 then
                skellies[i].y = size2
                skellies[i].vel.y = -skellies[i].vel.y
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
            if skellies[i].y+size2 > ScrH() then
                skellies[i].y = ScrH()-size2
                skellies[i].vel.y = -skellies[i].vel.y
                skellies[i].col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
            end
        end
    end
    
    //}
	
	/*--------------------------------------------
				Screen Blood / Death
	--------------------------------------------*/
	
	//{
	
	if LocalPlayer():GetNWFloat("RecentlyTookDamage") > CurTime() then
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("RecentlyTookDamage") - CurTime())*255 )
		surface.SetMaterial( mat_bleedout )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end
	if !LocalPlayer():Alive() && LocalPlayer():GetNWBool("DisplayKilla") == true && ((LocalPlayer():GetNWBool("killa"):IsPlayer() && IsValid(LocalPlayer():GetNWBool("killa")) && LocalPlayer():GetNWBool("killa"):Alive()) || IsValid(LocalPlayer():GetNWBool("killa"))) then
		if LocalPlayer():GetNWBool("killa") == LocalPlayer() then
			draw.SimpleTextOutlined( "You killed yourself to death.", "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		else
			if LocalPlayer():GetNWBool("killa"):GetClass() == "sent_skellington" then 
				draw.SimpleTextOutlined( "Clickity clack, get into my sack."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_creeper" then 
				draw.SimpleTextOutlined( "You were creeped up on by the Creeper."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_jitterskull" then 
				draw.SimpleTextOutlined( "You were eaten by the Jitterskull."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_sjas" then 
				draw.SimpleTextOutlined( "You were screamed at by Sjas."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif LocalPlayer():GetNWBool("killa"):GetClass() == "sent_yurei" then 
				draw.SimpleTextOutlined( "You stood in awe of the Yurei."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			elseif IsValid(LocalPlayer():GetNWBool("killa")) && LocalPlayer():GetNWBool("killa"):GetName() != nil then
				draw.SimpleTextOutlined( LocalPlayer():GetNWBool("killa"):GetName().." sent you back to the grave."	, "TheDefaultSettings", ScrW()/2, ScrH()/2-64, Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
			end
		end
        if GetConVar("mm_deathtips"):GetInt() == 1 then
            local text = { deathhints[deathhintnum] }
            local text_w = select( 1, surface.GetTextSize( text[1] ))
            
            local k = 1
            local done = false
            if text_w > ScrW() then
                while true do
                    if text_w > ScrW() then
                        local str = ""
                        local i = 1
                        for i=1, string.len(text[k]) do
                            if select( 1, surface.GetTextSize( str )) < ScrW() then
                                str = string.sub(text[k], 1, i)
                            else
                                for j=i, 1, -1 do
                                    if str[j] == " " then
                                        text[k+1] = string.sub(text[k], j+1)
                                        text[k] = string.sub(text[k], 1, j)
                                        k = k+1
                                        break
                                    end
                                end
                                break
                            end
                        end
                        text_w = select (1, surface.GetTextSize( text[k] ))
                    else
                        break
                    end
                end
            end
            for i=1, #text do
                draw.SimpleTextOutlined( text[i], "TheDefaultSettings", ScrW()/2, ScrH()-48-48*(#text-i), Color(255,105,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
            end
        end
	elseif LocalPlayer():Alive() then
        deathhintnum = math.random(1,#deathhints)
    end
    
	if LocalPlayer():GetNWFloat("Sticky") > CurTime() then
        local ymax = 6*6*8
        local y = (LocalPlayer():GetNWFloat("Sticky") - CurTime())*8*6
        if (LocalPlayer():GetNWFloat("Sticky") - CurTime() > 1) then
            surface.SetDrawColor( 255, 255, 255, 20 )
        else
            surface.SetDrawColor( 255, 255, 255, 20*((LocalPlayer():GetNWFloat("Sticky")-CurTime())) )
        end
		surface.SetMaterial( mat_webbing )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH()+(ymax-y) )
	end
	
	//}

	/*--------------------------------------------
				   Weapon Selection 
	--------------------------------------------*/
	
	//{
	
	if !LocalPlayer():Alive() then return end

	if input.IsKeyDown( KEY_1 ) then 
		if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
			SelectWeapon1()
		end
	elseif input.IsKeyDown( KEY_2 ) then
		if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
			SelectWeapon2()
		end
	elseif input.IsKeyDown( KEY_3 ) then
		if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
			SelectWeapon3()
		end
	elseif input.IsKeyDown( KEY_4 ) then
		if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
			SelectWeapon4()
		end
	end
	
	if input.IsKeyDown( KEY_Z ) && !(LocalPlayer():IsPlayingTaunt() || LocalPlayer():GetNWBool("DoingTauntCamera")) then
        if LocalPlayer():GetModel() == "models/monstermash/scarecrow_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/nosferatu_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/guest_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/invisible_man_final.mdl" || GetConVar( "mm_wackytaunts" ):GetInt()  == 1 then
			LocalPlayer():SetCycle(0)
			LocalPlayer():SetNWBool("DoingTauntCamera", true)
			net.Start("ServerDoingTauntCamera")
			net.SendToServer()
		elseif LocalPlayer():GetModel() == "models/monstermash/zombie_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/deer_haunter_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/mummy_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/banshee_final.mdl"  then
			LocalPlayer():ConCommand("act zombie")
		elseif LocalPlayer():GetModel() == "models/monstermash/stein_final.mdl" then
			LocalPlayer():ConCommand("act robot")
		elseif LocalPlayer():GetModel() == "models/monstermash/headless_horseman_final.mdl" then
			LocalPlayer():ConCommand("act salute")
		elseif LocalPlayer():GetModel() == "models/monstermash/skeleton_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/bloody_mary_final.mdl" || LocalPlayer():GetModel() == "models/monstermash/mad_scientist_final.mdl" then
			LocalPlayer():ConCommand("act laugh")
		elseif LocalPlayer():GetModel() == "models/monstermash/vampire_final.mdl" then
			LocalPlayer():ConCommand("act bow")
		elseif LocalPlayer():GetModel() == "models/monstermash/witch_final.mdl" then
			LocalPlayer():ConCommand("act disagree")		
        elseif LocalPlayer():GetModel() == "models/monstermash/bride_final.mdl" then
			LocalPlayer():ConCommand("act pers")
		end
	end
	
	local width = 128
	local height = 128
	local startx = ScrW()/2 - width*2
	local starty = ScrH()-height
	if LocalPlayer():GetNWFloat("LastKeyDown1") > CurTime() then
		local x = startx + width*0
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Melee", "TheDefaultSettings", x+width/2-2, y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown1")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown2") > CurTime() then
		local x = startx + width
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Side Arm", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown2")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown3") > CurTime() then
		local x = startx + width*2
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255 )
		surface.SetMaterial( Material(LocalPlayer():GetNWString("lastselecticon")) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Primary", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown3")-CurTime())*255))
	end
	if LocalPlayer():GetNWFloat("LastKeyDown4") > CurTime() then
		local x = startx + width*3
		local y = starty -16
		draw.RoundedBox( 16, x, y, width, height, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*105) )
		draw.RoundedBox( 16, x+2, y+2, width-4, height-4, Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*105) )
		surface.SetDrawColor( 255, 255, 255, (LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255 )
		surface.SetMaterial( Material( LocalPlayer():GetNWString("lastselecticon") ) )
		surface.DrawTexturedRect( x+2, y+2, width-4, height-4 )
		draw.SimpleTextOutlined( "Throwable", "TheDefaultSettings", x+width/2 , y+height-26 , Color(255,105,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,(LocalPlayer():GetNWFloat("LastKeyDown4")-CurTime())*255))
	end
	
	//}

end
hook.Add("HUDPaint", "MyHudName", hud)

hook.Add("StartCommand","DetectMouseWheelWeapon",function( ply, cmd )
	if !ply:Alive() then return end
	if cmd:GetMouseWheel() > 0 then
		if ply:GetActiveWeapon().Slot == 0 || (ply:HasWeapon("mm_candlestick") && ply:GetActiveWeapon():GetClass() == "mm_candlestick")  then
			if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			end
		elseif ply:GetActiveWeapon().Slot == 1 then
			if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			end
		elseif ply:GetActiveWeapon().Slot == 2 then
			if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			end
		elseif ply:GetActiveWeapon().Slot == 3 then
			if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			end
		end
	end
	if cmd:GetMouseWheel() < 0 then
		if ply:GetActiveWeapon().Slot == 0 || (ply:HasWeapon("mm_candlestick") && ply:GetActiveWeapon():GetClass() == "mm_candlestick") then
			if !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			end
		elseif ply:GetActiveWeapon().Slot == 1 then
			if !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			end
		elseif ply:GetActiveWeapon().Slot == 2 then
			if !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			elseif !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			end
		elseif ply:GetActiveWeapon().Slot == 3 then
			if !IsSlotEmpty(LocalPlayer(), 3 ) && LocalPlayer():GetNWFloat("LastKeyDown3") < CurTime() then
				SelectWeapon3()
			elseif !IsSlotEmpty(LocalPlayer(), 2 ) && LocalPlayer():GetNWFloat("LastKeyDown2") < CurTime() then
				SelectWeapon2()
			elseif !IsSlotEmpty(LocalPlayer(), 1 ) && LocalPlayer():GetNWFloat("LastKeyDown1") < CurTime() then
				SelectWeapon1()
			elseif !IsSlotEmpty(LocalPlayer(), 4 ) && LocalPlayer():GetNWFloat("LastKeyDown4") < CurTime() then
				SelectWeapon4()
			end
		end
	end
	
end)

function hidehud(name)
	if ( name == "CHudHealth" ) then return false end
    if ( name == "CHudAmmo" ) then return false end
    if ( name == "CHudSecondaryAmmo" ) then return false end
	if ( name == "CHudDamageIndicator" ) then return false end
	if ( name == "CHudWeaponSelection" ) then return false end
    return true;
end
hook.Add("HUDShouldDraw", "HideMyHud", hidehud)


function GM:HUDDrawTargetID()
end

local SwirlyTexture = surface.GetTextureID( "animated/tripping_swirly" );
function DrawName( ply )
    local tr = util.GetPlayerTrace( LocalPlayer() )
    local trace = util.TraceLine( tr )
    local hallucinatepos = 0
    
	if trace.Hit && trace.HitNonWorld && ply == trace.Entity && !ply:GetNWBool("MM_UsingInvisibility") then 
        local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
        pos.z = pos.z + 30
        local ang = ply:EyeAngles()
        local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
        
        cam.Start3D2D( pos, EyeAngles():Right():Angle() + Angle(0,0,90), 0.25 )
            draw.SimpleTextOutlined( ply:Nick(),"TheDefaultSettings", 0,2, team.GetColor( ply:Team() ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
            draw.SimpleTextOutlined( ply:Health(),"TheDefaultSettings", 0,42, team.GetColor( ply:Team() ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
            hallucinatepos = -64
        cam.End3D2D()
    end
    
    for k, v in pairs( player.GetAll() ) do
        if v:GetNWFloat("MM_Hallucinate") < CurTime() then return end
        local pos = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
        pos.z = pos.z + 30
        local ang = v:EyeAngles()
        local dist = LocalPlayer():GetPos():Distance( v:GetPos() )
        cam.Start3D2D( pos, EyeAngles():Right():Angle() + Angle(0,0,90), 0.25 );
            surface.SetDrawColor( 255, 255, 255, 255 );
            surface.SetTexture( SwirlyTexture );
            surface.DrawTexturedRect( -32, hallucinatepos, 64, 64 );
        cam.End3D2D()
    end
end
hook.Add( "PostPlayerDraw", "DrawName", DrawName )

local Shot1 = surface.GetTextureID("screendecals/shot1")
local Shot2 = surface.GetTextureID("screendecals/shot2")
local Shot3 = surface.GetTextureID("screendecals/shot3")
local Shot4 = surface.GetTextureID("screendecals/shot4")
local Shot5 = surface.GetTextureID("screendecals/shot5")
local Shot6 = surface.GetTextureID("screendecals/shot6")

local GShot1 = surface.GetTextureID("screendecals/greenshot1")
local GShot2 = surface.GetTextureID("screendecals/greenshot2")
local GShot3 = surface.GetTextureID("screendecals/greenshot3")
local GShot4 = surface.GetTextureID("screendecals/greenshot4")
local GShot5 = surface.GetTextureID("screendecals/greenshot5")
local GShot6 = surface.GetTextureID("screendecals/greenshot6")

net.Receive( "RedScreenBlood", function()
    if GetConVar("mm_screenblood"):GetInt() == 0 then return end
    local c = 255
    local hookid = math.random(0,9999)
    local Bloodmath = math.random(1,6)
    local Sizemath = math.random(320,375)
    local rotation = math.random(0,360)
    
    local x = math.random(ScrW()*0.2,ScrW()*0.8)
    local y = math.random(ScrH()*0.2,ScrH()*0.9)
    
    hook.Add("HUDPaint","RedScreenBloodMir_"..hookid,function()
        if c > 0 then
        c = c - RealFrameTime()*60
        end
        surface.SetDrawColor(255,0,0,math.Clamp(c, 0, 255))
        if Bloodmath == 1 then
        surface.SetTexture( Shot1 )
        elseif Bloodmath == 2 then
        surface.SetTexture( Shot2 )
        elseif Bloodmath == 3 then
        surface.SetTexture( Shot3 )
        elseif Bloodmath == 4 then
        surface.SetTexture( Shot4 )
        elseif Bloodmath == 5 then
        surface.SetTexture( Shot5 )
        elseif Bloodmath == 6 then
        surface.SetTexture( Shot6 )
        end
        surface.DrawTexturedRectRotated(x,y,Sizemath,Sizemath,rotation)
        if c <= 0 then
            c = 0
            hook.Remove("HUDPaint","RedScreenBloodMir_"..hookid)
        end
    end )
end)

net.Receive( "YellowScreenBlood", function()
    if GetConVar("mm_screenblood"):GetInt() == 0 then return end
    local c = 255
    local hookid = math.random(0,9999)
    local Bloodmath = math.random(1,6)
    local Sizemath = math.random(320,375)
    local rotation = math.random(0,360)
    
    local x = math.random(ScrW()*0.2,ScrW()*0.8)
    local y = math.random(ScrH()*0.2,ScrH()*0.9)
    
    hook.Add("HUDPaint","YellowScreenBloodMir_"..hookid,function()
        if c > 0 then
        c = c - RealFrameTime()*60
        end
        surface.SetDrawColor(100,150,0,math.Clamp(c, 0, 255))
        if Bloodmath == 1 then
        surface.SetTexture( GShot1 )
        elseif Bloodmath == 2 then
        surface.SetTexture( GShot2 )
        elseif Bloodmath == 3 then
        surface.SetTexture( GShot3 )
        elseif Bloodmath == 4 then
        surface.SetTexture( GShot4 )
        elseif Bloodmath == 5 then
        surface.SetTexture( GShot5 )
        elseif Bloodmath == 6 then
        surface.SetTexture( GShot6 )
        end
        surface.DrawTexturedRectRotated(x,y,Sizemath,Sizemath,rotation)
        if c <= 0 then
            c = 0
            hook.Remove("HUDPaint","YellowScreenBloodMir_"..hookid)
        end
    end )
end)