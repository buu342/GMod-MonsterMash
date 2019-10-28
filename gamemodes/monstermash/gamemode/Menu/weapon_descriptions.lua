MonsterMash_Weapons = {}

MonsterMash_Weapons["melee"] = {}
MonsterMash_Weapons["handgun"] = {}
MonsterMash_Weapons["primary"] = {}
MonsterMash_Weapons["throwable"] = {}
MonsterMash_Weapons["buff"] = {}

function AddWeaponList(list, info)
    table.insert(MonsterMash_Weapons[list], info)
end

AddWeaponList("buff", {name = "None"})
function ImplementWeapons()

    table.Empty( MonsterMash_Weapons["melee"] )
    table.Empty( MonsterMash_Weapons["handgun"] )
    table.Empty( MonsterMash_Weapons["primary"] )
    table.Empty( MonsterMash_Weapons["throwable"] )
    table.Empty( MonsterMash_Weapons["buff"] )

    /*-------------------------------------------------
                          Melee
    -------------------------------------------------*/
    //{
    AddWeaponList("melee", 
        {
            entity          = "",
            name            = "None",
            description     = "",
            points          = 0,
            cost            = 0,
            icon            = "nothing",
            damage          = -1,
            concusschance   = -1,
            bleedchance     = -1,
            dismemberchance = -1,
            range           = -1,
        }
    )

    wep = "mm_boner"
    AddWeaponList("melee", 
        {
            entity          = wep,
            description     = "Killing an opponent with this spawns a medkit.",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            name            = weapons.Get(wep).PrintName, 
            icon            = weapons.Get(wep).SelectIcon,
            damage          = weapons.Get(wep).Primary.Damage,
            concusschance   = weapons.Get(wep).ConcussChance,
            bleedchance     = weapons.Get(wep).BleedChance,
            dismemberchance = weapons.Get(wep).DismemberChance,
            range           = weapons.Get(wep).Reach,
        }
    )

    wep = "mm_knife"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_shovel"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_hook" 
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_hacksaw"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_fencepost"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_pitchfork"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_axe"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_mace"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_sword"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )

    wep = "mm_stake"
    AddWeaponList("melee", 
        {
            entity          = wep,
            description     = "This weapon is a one-hit-kill, but is consumed upon usage and must recharge before being equipped again.",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            name            = weapons.Get(wep).PrintName,
            icon            = weapons.Get(wep).SelectIcon,
            damage          = weapons.Get(wep).Primary.Damage,
            concusschance   = weapons.Get(wep).ConcussChance,
            bleedchance     = weapons.Get(wep).BleedChance,
            dismemberchance = weapons.Get(wep).DismemberChance,
            range           = weapons.Get(wep).Reach,
        }
    )

    wep = "mm_scythe"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )
    
    wep = "mm_chainsaw"
    AddWeaponList("melee", 
        {
            entity          = wep,
            description     = "This weapon deals double damage if swung while dashing and can bifurcate opponents in one swing from behind. Though they’ll probably hear you coming...",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            name            = weapons.Get(wep).PrintName,
            icon            = weapons.Get(wep).SelectIcon,
            damage          = weapons.Get(wep).Primary.Damage,
            concusschance   = weapons.Get(wep).ConcussChance,
            bleedchance     = weapons.Get(wep).BleedChance,
            dismemberchance = weapons.Get(wep).DismemberChance,
            range           = weapons.Get(wep).Reach,
        }
    )

    wep = "mm_battleaxe"
    AddWeaponList("melee", 
        {
            entity          = wep,
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
        }
    )
    //}


    /*-------------------------------------------------
                          Handguns
    -------------------------------------------------*/
    //{
    AddWeaponList("handgun", 
        {
            entity          = "",
            description     = "",
            points          = 0,
            firemode        = "",
            cost            = 0,
            icon            = "Nothing",
            name            = "None",
            damage          = -1,
            clipsize        = -1,
            range           = -1,
        }
    )

    wep = "mm_revolver"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "A trusty sidearm that packs a punch with decent range.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_shield"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "Hold secondary attack to raise the shield in front of you. The shield will protect your from bullets, melee, and projectiles only.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_colt"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "A fast-firing handgun good for quickly dealing damage to enemies at close range.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )


    wep = "mm_sawedoff"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "A sidearm as powerful as it is short-ranged.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_flaregun"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "Fires an explosive flare which ignites enemies caught in the blast. Gibs on the killing blow as well. Not for use with dogs.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_musketpistol"
    AddWeaponList("handgun", 
        {
            entity          = wep,
            description     = "Hold primary attack to charge this weapon for tremendous damage, doing so will hold you still in place. This weapon must recharge after being fired before it may be used again.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    //}


    /*-------------------------------------------------
                      Primary Weapons
    -------------------------------------------------*/
    //{
    AddWeaponList("primary", 
        {
            entity          = "",
            cost            = 0,
            points          = 0,
            description     = "",
            firemode        = "",
            icon            = "Nothing",
            name            = "None",
            damage          = -1,
            clipsize        = -1,
            range           = -1,
        }
    )

    wep = "mm_crossbow"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Secondary attack launches a flaming arrow that must recharge.",
            firemode        = "Semi automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_undertaker"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Press secondary attack to fire 16 rounds from the magazine in a close-range blast of nails.",
            firemode        = "Full-Auto",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_pumpshotgun"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Hold secondary attack to slam-fire multiple weakened rounds in quick succession at the cost of 100% more ammo consumption.",
            firemode        = "Pump-Action",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_repeater"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Hold secondary attack to hold still and zoom in. Releasing will fire a charged round which deals up to double damage, but consumes 3 rounds per shot.",
            firemode        = "Lever-Action",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_flamethrower"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Hold secondary attack to launch a fireball for 75 fuel. This weapon reloads in increments of 40 fuel.",
            firemode        = "Full-Auto",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_battlerifle"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Secondary attack fires a grenade which emits hallucinogenic gas, disorienting those caught within it.",
            firemode        = "3-Round Burst",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_electricrifle"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "CAUTION: This weapon will explode if overheated!\nPress secondary attack to fire an electrical blast which arcs between multiple opponents and stuns them.",
            firemode        = "Semi-Automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_sawblade"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "This weapon fires sawblades which have a 100% dismember chance.",
            firemode        = "Semi-Automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_coachgun"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "This weapon fires both barrels which will blow limbs off your opponents if at least 40 damage is dealt.",
            firemode        = "Semi-Automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    
    wep = "mm_minigun"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "The weapon takes 1 second to rev up before firing. Hold secondary fire to rev up prematurely. This weapon slowly regenerates spent ammunition.\n\nGreat for use against helicopters while riding atop a train.",
            firemode        = "Fully fucking automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,   
        }
    )

    wep = "mm_wand"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Primary attack lobs a fireball which can be charged to fly greater distances. Secondary attack uses twice as much magic to blast nearby enemies away as well as disintegrate inbound projectiles (excluding enemy magic fireballs).",
            firemode        = "Swish and Flick",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,   
        }
    )

    wep = "mm_cannon"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Hold primary attack to charge the range of this weapon, release to fire.",
            firemode        = "Semi-Automatic",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )

    wep = "mm_deanimator"
    AddWeaponList("primary", 
        {
            entity          = wep,
            description     = "Hold primary fire to shoot electric blasts fully automatic.\n\nHold secondary attack to charge the damage of this weapon at the cost of battery power, then release to fire.\n\nCAUTION: this weapon will shock you and will explode if overcharged!",
            firemode        = "Full-Auto",
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
            clipsize        = weapons.Get(wep).Primary.ClipSize,
            range           = weapons.Get(wep).ShootDistance,
        }
    )
    //}


    /*-------------------------------------------------
                          Throwable
    -------------------------------------------------*/
    //{
    AddWeaponList("throwable", 
        {
            entity          = "",
            cost            = 0, 
            points          = 0,
            description     = "",
            chargeup        = false,
            icon            = "Nothing",
            name            = "None",
            damage          = -1,
        }
    )

    wep = "mm_toiletpaper"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "This weapon is useless.",
            chargeup        = false,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_cleaver"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "This weapon has a 100% bleed chance, and is consumed upon throwing. It must recharge before it can be used again.",
            chargeup        = false,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_skull"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "This weapon has a 100% concuss chance and is consumed upon throwing. It must recharge before it can be used again, or it can be retrieved from the ground by pressing the USE key.",
            chargeup        = false,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_gorejar"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "Throwing this weapon at enemies will partially blind them as well as slow them to a walk whilst jamming their guns. This weapon is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_spidernade"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "Throwing this weapon creates a spider web on the ground which coats enemies in a web, immobilizing them while spiders chew on them. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = false,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_urn"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "Throwing this weapon at enemies will temporarily paralyze them with fear, leaving them entirely vulnerable. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_acidflask"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "Throwing this weapon creates a pool of acid on the ground which will deal damage over time to anyone who steps into it. It is consumed when thrown and must recharge before it can be used again. Deals more damage if the flask strikes the target directly.",
            chargeup        = true,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost, 
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )

    wep = "mm_pumpkinnade"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            description     = "This weapon instantly explodes on contact with any surface, dealing high damage. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
            points          = weapons.Get(wep).Points,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )
    
    //}
    
    /*-------------------------------------------------
                          Buff
    -------------------------------------------------*/
    //{
    wep = ""
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 0,
            description     = "",
            icon            = "Nothing",
            name            = "None",
            
        }
    )
    
    wep = "broom"
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 4,
            description     = "Activate to temporarily fly away. Uses stamina.",
            icon            = "vgui/hud/buffs/broom.png",
            name            = "Broom",
        }
    )
    
    wep = "kamikaze"
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 5,
            description     = "Activate to explode into a spooky cloud of bloodthirsty bats for a quick escape.",
            icon            = "vgui/hud/buffs/bats.png",
            name            = "Bat Storm",
        }
    )
    
    wep = "invisible"
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 6,
            description     = "Activate to become temporarily invisible. Uses stamina.",
            icon            = "vgui/hud/buffs/invisible.png",
            name            = "Invisibility",
        }
    )
    
    
    wep = "armor"
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 7,
            description     = "Activate to obtain 50% damage reduction from bullets and no dismemberment for the duration of your life.",
            icon            = "vgui/hud/buffs/armor.png",
            name            = "Armor",
        }
    )
    
    wep = "skeleton_army"
    AddWeaponList("buff", 
        {
            entity          = wep,
            cost            = 10,
            description     = "Activate to summon a horde of skeletons to distract your enemies for one minute.",
            icon            = "vgui/hud/buffs/skeleton_army.png",
            name            = "Necromancer",
        }
    )
    
    //}
    print("Weapons setup. Count = "..(#MonsterMash_Weapons["melee"]+#MonsterMash_Weapons["handgun"]+#MonsterMash_Weapons["primary"]+#MonsterMash_Weapons["throwable"]+#MonsterMash_Weapons["buff"]))
end