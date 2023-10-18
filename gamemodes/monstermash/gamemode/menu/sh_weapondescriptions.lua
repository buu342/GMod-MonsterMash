if GM.Weapons then return end // Prevent autorefresh

GM.Weapons = {}

GM.Weapons["Melee"] = {}
GM.Weapons["Handgun"] = {}
GM.Weapons["Primary"] = {}
GM.Weapons["Throwable"] = {}
GM.Weapons["Trick"] = {} 
GM.Weapons["Random"] = {} 

GM.WeaponOrder = {"Melee", "Handgun", "Primary", "Throwable", "Trick", "Random"}

local cindex = 0
local function increment()
    cindex = cindex+1
    return cindex-1
end

timer.Simple(0, function()

local GM = GAMEMODE

/*-------------------------------------------------
                       Melee
-------------------------------------------------*/
//{
    GM.Weapons["Melee"]["None"] = {
        name            = "None",
        description     = "",
        points          = 0,
        cost            = 0,
        icon            = -1,
        damage          = -1,
        concusschance   = -1,
        bleedchance     = -1,
        dismemberchance = -1,
        range           = -1,
        index           = increment()
    }

    wep = "weapon_mm_boner"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a guaranteed concuss chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName, 
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }
    
    wep = "weapon_mm_knife"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind deals double damage and has a 100% bleed chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_fencepost"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% bleed chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_hacksaw"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }
    
    wep = "weapon_mm_hook" 
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind deals double damage.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_shovel"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% concuss chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_rake"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind deals double damage and has a 100% concuss chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_sickle"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_pitchfork"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% bleed chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_axe"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% concuss chance and 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_mace"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind has a 100% concuss chance and 100% bleed chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_sword"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind deals double damage and has a 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_stake"
    GM.Weapons["Melee"][wep] = {
        description     = "This weapon is a one-hit-kill, but is spent upon usage and must recharge before being equipped again.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_scythe"
    GM.Weapons["Melee"][wep] = {
        description     = "Attacking an opponent from behind deals double damage and has a 100% bleed chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_chainsaw"
    GM.Weapons["Melee"][wep] = {
        description     = "This weapon can be swung at opponents by clicking primary attack, or stabbed into them to deal high damage per second by holding primary attack. This weapon bifurcates opponents from behind.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_battleaxe"
    GM.Weapons["Melee"][wep] = {
        description     = "This weapon deals tremendous damage and grants the owner +25 to their health.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        name            = weapons.Get(wep).PrintName,
        icon            = weapons.Get(wep).SelectIcon,
        damage          = weapons.Get(wep).Primary.Damage,
        concusschance   = weapons.Get(wep).ConcussChance,
        bleedchance     = weapons.Get(wep).BleedChance,
        dismemberchance = weapons.Get(wep).DismemberChance,
        range           = weapons.Get(wep).Reach,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }
    
    GM.Weapons["Melee"]["Random"] = {
        name            = "?",
        description     = "",
        points          = 0,
        cost            = 0,
        icon            = -1,
        damage          = -1,
        concusschance   = -1,
        bleedchance     = -1,
        dismemberchance = -1,
        range           = -1,
        index           = increment()
    }
//}

/*-------------------------------------------------
                     Handguns
-------------------------------------------------*/
//{
    cindex = 0
    GM.Weapons["Handgun"]["None"] = {
        description     = "",
        points          = 0,
        firemode        = "",
        cost            = 0,
        icon            = -1,
        name            = "None",
        damage          = -1,
        clipsize        = -1,
        range           = -1,
        index           = increment()
    }

    wep = "weapon_mm_revolver"
    GM.Weapons["Handgun"][wep] = {
        description     = "A trusty sidearm that packs a punch with decent range.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_shield"
    GM.Weapons["Handgun"][wep] = {
        description     = "Hold secondary attack to raise the shield in front of you. The shield will protect your from bullets, melee, and projectiles only.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_colt"
    GM.Weapons["Handgun"][wep] = {
        description     = "A fast-firing handgun good for quickly dealing damage to enemies at close range.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }
    
    wep = "weapon_mm_sawedoff"
    GM.Weapons["Handgun"][wep] = {
        description     = "A sidearm that is as powerful as it is short-ranged.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_flaregun"
    GM.Weapons["Handgun"][wep] = {
        description     = "Fires an explosive flare which ignites enemies caught in the blast. Gibs on the killing blow as well. Not for use with dogs.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_musketpistol"
    GM.Weapons["Handgun"][wep] = {
        description     = "Hold primary attack to charge this weapon for tremendous damage, doing so will hold you still in place. This weapon must recharge after being fired before it may be used again.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }
    
    GM.Weapons["Handgun"]["Random"] = {
        name            = "?",
        description     = "",
        points          = 0,
        cost            = 0,
        icon            = -1,
        damage          = -1,
        concusschance   = -1,
        bleedchance     = -1,
        dismemberchance = -1,
        range           = -1,
        index           = increment()
    }
//}

/*-------------------------------------------------
                      Primary
-------------------------------------------------*/
//{
    cindex = 0
    GM.Weapons["Primary"]["None"] = {
        cost            = 0,
        points          = 0,
        description     = "",
        firemode        = "",
        icon            = -1,
        name            = "None",
        damage          = -1,
        clipsize        = -1,
        range           = -1,
        index           = increment()
    }

    wep = "weapon_mm_crossbow"
    GM.Weapons["Primary"][wep] = {
        description     = "Secondary attack launches a flaming arrow that must recharge.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_undertaker"
    GM.Weapons["Primary"][wep] = {
        description     = "Press secondary attack to fire 16 rounds from the magazine in a close-range blast of nails.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Full-Auto",
        index           = increment()
    }

    wep = "weapon_mm_pumpshotgun"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold secondary attack to slam-fire multiple weakened rounds in quick succession at the cost of 100% more ammo consumption.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_repeater"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold secondary attack to hold still and zoom in. Releasing will fire a charged round which deals up to double damage, but consumes 4 rounds per shot.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_flamethrower"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold secondary attack to launch a fireball for 75 fuel. This weapon reloads in increments of 40 fuel and deals extra damage at close range.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Full-Auto",
        index           = increment()
    }

    wep = "weapon_mm_melter"
    GM.Weapons["Primary"][wep] = {
        description     = "This weapon deals "..weapons.Get(wep).Primary.Damage.." damage on impact, followed by 15 afterburn damage.\n\nSecondary attack unloads the magazine in a short-ranged spray of liquid death.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_battlerifle"
    GM.Weapons["Primary"][wep] = {
        description     = "Secondary attack fires a grenade which emits hallucinogenic gas, disorienting those caught within it.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Three Round Burst",
        index           = increment()
    }

    wep = "weapon_mm_graverifle"
    GM.Weapons["Primary"][wep] = {
        description     = "Primary attack releases ghosts which then close in on nearby enemies, dealing incremental damage. Secondary attack stabs with the bayonet, causing bleed damage.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Slow-Auto",
        index           = increment()
    }

    wep = "weapon_mm_bloodletter"
    GM.Weapons["Primary"][wep] = {
        description     = "Primary attack fires darts, which can then be detonated to deal damage which is returned to the weilder as health, as well as cause bleeding to the afflicted.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }
    
    wep = "weapon_mm_shockrifle"
    GM.Weapons["Primary"][wep] = {
        description     = "This weapon arcs electricity between opponents in close proximity. Secondary fire expends the entire battery with a scatter-blast which shocks opponents and launches them back.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_sawblade"
    GM.Weapons["Primary"][wep] = {
        description     = "This weapon fires sawblades which have a 100% dismember chance.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_coachgun"
    GM.Weapons["Primary"][wep] = {
        description     = "This weapon fires both barrels which will blow limbs off your opponents if at least 40 damage is dealt.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_minigun"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold secondary fire to rev up prematurely. This weapon deals extra damage at close range and slowly regenerates spent ammunition.\n\nGreat for use against helicopters while riding atop a train.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,   
        points          = weapons.Get(wep).Points,
        firemode        = "Full-Fucking-Auto",
        index           = increment()
    }

    wep = "weapon_mm_wand"
    GM.Weapons["Primary"][wep] = {
        description     = "Primary attack lobs a fireball which can be charged to fly greater distances. Secondary attack uses twice as much magic to blast nearby enemies away as well as disintegrate inbound projectiles (excluding enemy magic fireballs).",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Swish and Flick",
        index           = increment()
    }

    wep = "weapon_mm_cannon"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold primary attack to charge the range of this weapon, release to fire.",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Semi-Auto",
        index           = increment()
    }

    wep = "weapon_mm_deanimator"
    GM.Weapons["Primary"][wep] = {
        description     = "Hold secondary attack to charge the damage of this weapon at the cost of battery power, then release to fire.\n\nCAUTION: this weapon will shock you and will explode if overcharged!",
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        clipsize        = weapons.Get(wep).Primary.ClipSize,
        range           = weapons.Get(wep).Primary.Range,
        points          = weapons.Get(wep).Points,
        firemode        = "Full-Auto",
        index           = increment()
    }
    
    GM.Weapons["Primary"]["Random"] = {
        name            = "?",
        description     = "",
        points          = 0,
        cost            = 0,
        icon            = -1,
        damage          = -1,
        concusschance   = -1,
        bleedchance     = -1,
        dismemberchance = -1,
        range           = -1,
        index           = increment()
    }
//}

/*-------------------------------------------------
                     Throwable
-------------------------------------------------*/
//{
    cindex = 0
    GM.Weapons["Throwable"]["None"] = {
        cost            = 0, 
        points          = 0,
        description     = "",
        chargeup        = false,
        icon            = -1,
        name            = "None",
        damage          = -1,
        index           = increment()
    }

    wep = "weapon_mm_toiletpaper"
    GM.Weapons["Throwable"][wep] = {
        description     = "This weapon deals no damage at all, but earns you a treat for TP-ing opponents.",
        chargeup        = false,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_cleaver"
    GM.Weapons["Throwable"][wep] = {
        description     = "This weapon has a 100% bleed chance, and is consumed upon throwing. It must recharge before it can be used again.",
        chargeup        = false,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_skull"
    GM.Weapons["Throwable"][wep] = {
        description     = "This weapon has a 100% concuss chance and is consumed upon throwing. It must recharge before it can be used again, or it can be retrieved from the ground by pressing the USE key.",
        chargeup        = false,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_gorejar"
    GM.Weapons["Throwable"][wep] = {
        description     = "Throwing this weapon at enemies will partially blind them as well as slow them to a walk whilst jamming their guns. This weapon is consumed when thrown and must recharge before it can be used again.",
        chargeup        = true,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_spidernade"
    GM.Weapons["Throwable"][wep] = {
        description     = "Throwing this weapon creates a spider web on the ground which coats enemies in a web, immobilizing them while spiders chew on them. It is consumed when thrown and must recharge before it can be used again.",
        chargeup        = false,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_urn"
    GM.Weapons["Throwable"][wep] = {
        description     = "Throwing this weapon at enemies will temporarily paralyze them with fear, leaving them entirely vulnerable. It is consumed when thrown and must recharge before it can be used again.",
        chargeup        = true,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_acidflask"
    GM.Weapons["Throwable"][wep] = {
        description     = "Throwing this weapon creates a pool of acid on the ground which will deal damage over time to anyone who steps into it. It is consumed when thrown and must recharge before it can be used again. It deals more damage if the flask strikes the target directly.",
        chargeup        = true,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost, 
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }

    wep = "weapon_mm_pumpkinnade"
    GM.Weapons["Throwable"][wep] = {
        description     = "This weapon instantly explodes on contact with any surface, dealing high damage. It is consumed when thrown and must recharge before it can be used again.",
        chargeup        = true,
        points          = weapons.Get(wep).Points,
        cost            = weapons.Get(wep).Cost,
        icon            = weapons.Get(wep).SelectIcon,
        name            = weapons.Get(wep).PrintName,
        damage          = weapons.Get(wep).Primary.Damage,
        points          = weapons.Get(wep).Points,
        index           = increment()
    }
    
    GM.Weapons["Throwable"]["Random"] = {
        name            = "?",
        description     = "",
        points          = 0,
        cost            = 0,
        icon            = -1,
        damage          = -1,
        concusschance   = -1,
        bleedchance     = -1,
        dismemberchance = -1,
        range           = -1,
        index           = increment()
    }
//}

/*-------------------------------------------------
                       Tricks
-------------------------------------------------*/
//{
    cindex = 0
    GM.Weapons["Trick"]["None"] = {
        cost            = 0,
        description     = "",
        icon            = -1,
        name            = "None",
        index           = increment()
    }

    wep = "sight"
    GM.Weapons["Trick"][wep] = {
        cost            = 3,
        description     = "Activate to see where all of your opponents are for 30 seconds.",
        icon            = Material("vgui/hud/tricks/sight"),
        name            = "The Sight",
        index           = increment()
    }

    wep = "broom"
    GM.Weapons["Trick"][wep] = {
        cost            = 4,
        description     = "Activate to temporarily fly away.",
        icon            = Material("vgui/hud/tricks/broom"),
        name            = "Broom",
        index           = increment()
    }

    wep = "kamikaze"
    GM.Weapons["Trick"][wep] = {
        cost            = 5,
        description     = "Activate to explode into a spooky cloud of bloodthirsty bats for a quick escape.",
        icon            = Material("vgui/hud/tricks/bats"),
        name            = "Bat Storm",
        points          = 10,
        index           = increment()
    }

    wep = "invisible"
    GM.Weapons["Trick"][wep] = {
        cost            = 6,
        description     = "Activate to become temporarily invisible for 15 seconds.",
        icon            = Material("vgui/hud/tricks/invisible"),
        name            = "Invisibility",
        index           = increment()
    }

    wep = "armor"
    GM.Weapons["Trick"][wep] = {
        cost            = 7,
        description     = "Activate to obtain 50% damage reduction from bullets and no dismemberment for the duration of your life.",
        icon            = Material("vgui/hud/tricks/armor"),
        name            = "Armor",
        index           = increment()
    }
    
    wep = "fury"
    GM.Weapons["Trick"][wep] = {
        cost            = 8,
        description     = "Erupt into a ball of flame that ignites and repels nearby enemies, rejuvenates lost health and limbs as well.",
        icon            = Material("vgui/hud/tricks/fury"),
        name            = "Fury",
        points          = 10,
        index           = increment()
    }

    wep = "skeleton_army"
    GM.Weapons["Trick"][wep] = {
        cost            = 10,
        description     = "Activate to summon a horde of skeletons to distract your enemies for one minute.",
        icon            = Material("vgui/hud/tricks/skeleton_army"),
        name            = "Necromancer",
        points          = 10,
        index           = increment()
    }
    
    /*
    wep = "werewolf"
    GM.Weapons["Trick"][wep] = {
        cost            = 1,//25,
        description     = "Become a werewolf for the duration of your life.",
        icon            = Material("vgui/hud/tricks/werewolf"),
        name            = "Werewolf",
        index           = increment()
    }
    */
    
    GM.Weapons["Trick"]["Random"] = {
        cost            = 0,
        description     = "",
        icon            = -1,
        name            = "?",
        index           = increment()
    }
//}

print("/****************************")
print("Finished adding weapons. Total: "..(#table.GetKeys(GM.Weapons["Handgun"]) + #table.GetKeys(GM.Weapons["Throwable"]) + #table.GetKeys(GM.Weapons["Melee"]) + #table.GetKeys(GM.Weapons["Primary"])+#table.GetKeys(GM.Weapons["Trick"])))
print(#table.GetKeys(GM.Weapons["Melee"]).." Melee")
print(#table.GetKeys(GM.Weapons["Handgun"]).." Handguns")
print(#table.GetKeys(GM.Weapons["Primary"]).." Primaries")
print(#table.GetKeys(GM.Weapons["Throwable"]).." Throwables")
print(#table.GetKeys(GM.Weapons["Trick"]).." Tricks")
print("****************************/")

end)