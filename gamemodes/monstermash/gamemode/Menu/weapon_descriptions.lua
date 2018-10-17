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
            classification  = "",
            description     = "",
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
            classification  = "Low tier",
            description     = "Killing an opponent with this spawns a medkit.",
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
            classification  = "Low tier",
            description     = "Attacking an opponent from behind has a 100% bleed chance.",
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
            classification  = "Low tier",
            description     = "Attacking an opponent from behind has a 100% concuss chance.",
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
            classification  = "Low tier",
            description     = "Attacking an opponent from behind deals double damage.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind has a 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind has a 100% bleed chance.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind has a 100% bleed chance.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind has a 100% concuss chance and 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind has a 100% concuss chance and 100% bleed chance.",
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
            classification  = "Mid tier",
            description     = "Attacking an opponent from behind deals double damage and has a 100% bleed chance. This weapon can decapitate with a well-placed fatal headshot.",
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
            classification  = "Heavy tier",
            description     = "This weapon is a one-hit-kill, but is consumed upon usage and must recharge before being equipped again.",
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
            classification  = "Heavy tier",
            description     = "Attacking an opponent from behind deals double damage and has a 100% bleed chance.",
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
            classification  = "Heavy tier",
            description     = "This weapon deals tremendous damage and grants the owner +25 to their health.",
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
            classification  = "",
            description     = "",
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
            classification  = "Low tier",
            description     = "N/A.",
            firemode        = "Semi automatic",
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
            classification  = "Pistol tier",
            description     = "N/A.",
            firemode        = "Semi automatic",
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
            classification  = "Pistol tier",
            description     = "Hold secondary attack to raise the shield in front of you. The shield will protect your from bullets, melee, and projectiles only.",
            firemode        = "Semi automatic",
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
            classification  = "Pistol tier",
            description     = "N/A.",
            firemode        = "Semi automatic",
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
            classification  = "Pistol tier",
            description     = "Hold primary attack to charge this weapon for tremendous damage, doing so will hold you still in place. This weapon must recharge after being fired before it may be used again.",
            firemode        = "Semi automatic",
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
            classification  = "",
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
            classification  = "Mid tier",
            description     = "N/A.",
            firemode        = "Semi automatic",
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
            classification  = "Mid tier",
            description     = "Hold secondary attack to slam-fire multiple weakened rounds in quick succession at the cost of 100% more ammo consumption.",
            firemode        = "Pump-Action",
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
            classification  = "Mid tier",
            description     = "Press secondary attack to fire 16 rounds from the magazine in a close-range blast of nails.",
            firemode        = "Full-Auto",
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
            classification  = "Mid tier",
            description     = "Hold secondary attack to hold still and zoom in. Releasing will fire a charged round which deals up to double damage, but consumes 3 rounds per shot.",
            firemode        = "Lever-Action",
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
            classification  = "Mid tier",
            description     = "Press secondary attack to launch a poisonous smoke grenade.",
            firemode        = "3-Round Burst",
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
            classification  = "Mid tier",
            description     = "Hold secondary attack to launch a fireball for 75 fuel. This weapon reloads in increments of 35 fuel.",
            firemode        = "Full-Auto",
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
            classification  = "Heavy tier",
            description     = "This weapon fires sawblades which have a 100% dismember chance.",
            firemode        = "Semi-Automatic",
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
            classification  = "Heavy tier",
            description     = "This weapon fires both barrels which will blow limbs off your opponents if at least 40 damage is dealt.",
            firemode        = "Semi-Automatic",
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
            classification  = "Heavy tier",
            description     = "Hold primary attack to charge the range of this weapon, release to fire.",
            firemode        = "Semi-Automatic",
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
            classification  = "Heavy tier",
            description     = "Hold primary attack to charge the damage of this weapon at the cost of battery power, then release to fire. CAUTION: this weapon will shock you and will explode if overcharged!",
            firemode        = "Semi-Automatic",
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
            classification  = "",
            description     = "",
            chargeup        = false,
            icon            = "Nothing",
            name            = "None",
            damage          = -1,
        }
    )

    wep = "mm_cleaver"
    AddWeaponList("throwable", 
        {
            entity          = wep,
            classification  = "Low tier",
            description     = "This weapon has a 100% bleed chance, and is consumed upon throwing. It must recharge before it can be used again.",
            chargeup        = false,
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
            classification  = "Low tier",
            description     = "This weapons has a 100% concuss chance and is consumed upon throwing. It must recharge before it can be used again, or it can be retrieved from the ground by pressing the USE key.",
            chargeup        = false,
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
            classification  = "Low tier",
            description     = "Throwing this weapon at enemies will partially blind them as well as slow them to a walk whilst jamming their guns. This weapon is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
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
            classification  = "Low tier",
            description     = "Throwing this weapon creates a spider web on the ground which coats enemies in a web, immobilizing them while spiders chew on them. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = false,
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
            classification  = "Low tier",
            description     = "Throwing this weapon at enemies will temporarily paralyze them with fear, leaving them entirely vulnerable. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
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
            classification  = "Low tier",
            description     = "Throwing this weapon creates a pool of acid on the ground which will deal damage over time to anyone who steps into it. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
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
            classification  = "Heavy tier",
            description     = "This weapon instantly explodes on contact with any surface, dealing high damage. It is consumed when thrown and must recharge before it can be used again.",
            chargeup        = true,
            cost            = weapons.Get(wep).Cost,
            icon            = weapons.Get(wep).SelectIcon,
            name            = weapons.Get(wep).PrintName,
            damage          = weapons.Get(wep).Primary.Damage,
        }
    )
    
    //}
    print("Weapons setup. Count = "..(#MonsterMash_Weapons["melee"]+#MonsterMash_Weapons["handgun"]+#MonsterMash_Weapons["primary"]+#MonsterMash_Weapons["throwable"]+#MonsterMash_Weapons["buff"]))
end