--For killing creeps when they end

function OnStartTouch(key)

    print(key.activator) --The entity that triggered the event to happen
    print(key.caller) -- The entity that called for the event to happen

    killEntity(key.activator)

end

function killEntity(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    mybuildervictim = Entities:FindAllByClassname("npc_dota_hero_kunkka")

    print("Unit '" .. unitName .. "' has entered the killbox")
    EmitGlobalSound("DOTAMusic_Stinger.004")

    if unitName == "creep_wave_damage_test" then
        local damage_test_current_health = key:GetHealthDeficit()
        local damage_test_current_healthp = key:GetHealthPercent()
        GameRules:SendCustomMessage("Thank you for playing! Your Damage dealt is: <font color='#ff0000'>" .. damage_test_current_health .. " (" .. damage_test_current_healthp.."%)" .. "</font>", 0, 0)
    end

    if (key:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
        print("Is player owned - Ignore")
    else
        key:ForceKill(true) -- Kills the unit

    --Reduce lives of builder
    local damageTable = {
        victim = mybuildervictim[1],
        attacker = mybuildervictim[1],
        damage = 1,
        damage_type = DAMAGE_TYPE_PURE,
    }
 
    ApplyDamage(damageTable)
    
    --Update lives quest
    GameRules.QuestLives:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, mybuildervictim[1]:GetHealth() )
    GameRules.subQuestLives:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, mybuildervictim[1]:GetHealth() )

    if mybuildervictim[1]:GetHealth() < 1 then
        GameRules:SetGameWinner(3)
        print("[ARNE] Game ends now:" .. GameRules:State_Get())
        EmitGlobalSound("dsadowski_01.stinger.dire_lose")
    end

    end

end