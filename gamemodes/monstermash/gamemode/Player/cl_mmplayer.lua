hook.Add("CalcMainActivity", "MM_Animations_DodgeRoll", function(ply, velocity)
    if ply.CurrentDodgeCycle == nil then
        ply.CurrentDodgeCycle = -1
    end
    if ply:IsDodgeRolling() then
        // Lie to the client
        if ply.CurrentDodgeCycle == -1 then
            ply.CurrentDodgeCycle = 0
        end
        ply.CurrentDodgeCycle = ply.CurrentDodgeCycle + FrameTime()
        ply:SetCycle(ply.CurrentDodgeCycle)
        
        // Do the animation
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
        ply.CalcSeqOverride = -1
        if ply:HasStatusEffect(STATUS_ROLLLEFT) then
            ply.CalcSeqOverride = ply:LookupSequence( "FlipLeft" )
        else
            ply.CalcSeqOverride = ply:LookupSequence( "FlipRIght" )
        end
        return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:HasStatusEffect(STATUS_BROOM) then
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
        ply.CalcSeqOverride = -1
        local effectdata = EffectData()
        effectdata:SetOrigin( ply:GetPos() )
        util.Effect( "mm_broom", effectdata )
        if ply:GetActiveWeapon().Base == "weapon_mm_basemelee" then
            ply.CalcSeqOverride = ply:LookupSequence( "sit_fist" )
        else
            ply.CalcSeqOverride = ply:LookupSequence( "sit_ar2" )
        end
        return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:IsMeleeCharging() then
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
		ply.CalcSeqOverride = -1
        ply.CalcSeqOverride = ply:LookupSequence( "run_all_charging" )
		return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:HasStatusEffect(STATUS_SELFELECTROCUTED) || ply:HasStatusEffect(STATUS_ELECTROCUTED) then
        if ply.CurrentDodgeCycle == -1 then
            ply.CurrentDodgeCycle = 0
        end
        ply.CurrentDodgeCycle = ply.CurrentDodgeCycle + FrameTime()
        if (ply.CurrentDodgeCycle > 1) then
            ply.CurrentDodgeCycle = 0
        end
        ply:SetCycle(ply.CurrentDodgeCycle)
        
        if ply:GetVelocity():Length() > 0 then
            ply.CalcIdeal = ACT_MP_WALK
        else
            ply.CalcIdeal = ACT_MP_STAND_IDLE
        end
		ply.CalcSeqOverride = -1
        ply.CalcSeqOverride = ply:LookupSequence( "electrocution" )
		return ply.CalcIdeal, ply.CalcSeqOverride
    elseif ply:HasStatusEffect(STATUS_TAUNT) then
        local taunt = ply:GetCharacter().taunt[GetConVar("mm_wackytaunts"):GetInt()+1]
        if ply.CurrentDodgeCycle == -1 || velocity:Length() > 50 then
            ply.CurrentDodgeCycle = 0
            ply:SetCycle(0)
        end
        ply:SetPlaybackRate( 1 )
        ply.CalcIdeal = ACT_MP_STAND_IDLE
        ply.CalcSeqOverride = -1
        ply.CalcSeqOverride = ply:LookupSequence( taunt )
        return ply.CalcIdeal, ply.CalcSeqOverride
    else
        ply.CurrentDodgeCycle = -1
    end

end)