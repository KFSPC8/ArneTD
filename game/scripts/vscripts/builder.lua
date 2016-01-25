-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local AbilityKV = BuildingHelper.AbilityKV
    local UnitKV = BuildingHelper.UnitKV

    if caster:IsIdle() then
        caster:Interrupt()
    end

    -- Handle the name for item-ability build
    local building_name
    if event.ItemUnitName then
        building_name = event.ItemUnitName --Directly passed through the runscript
    else
        building_name = AbilityKV[ability_name].UnitName --Building Helper value
    end

    local construction_size = BuildingHelper:GetConstructionSize(building_name)
    local construction_radius = construction_size * 64 - 32

    -- Checks if there is enough custom resources to start the building, else stop.
    local unit_table = UnitKV[building_name]
    local gold_cost = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost") --Custom resource

    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerID()
    local player = PlayerResource:GetPlayer(playerID)    
    local teamNumber = hero:GetTeamNumber()

    -- If the ability has an AbilityGoldCost, it's impossible to not have enough gold the first time it's cast
    -- Always refund the gold here, as the building hasn't been placed yet
    hero:ModifyGold(gold_cost, false, 0)

    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)
 
    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)
        return true
    end)
  
    --[[ Disbled height check
    event:OnPreConstruction(function(vPos)
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "#error_invalid_build_position")
            return false
        end

        return true
    end) ]]

    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)

        -- Spend resources
        hero:ModifyGold(-gold_cost, false, 0)

        -- Play a sound
        EmitSoundOnClient("DOTA_Item.ObserverWard.Activate", player)

    end)

    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        local playerTable = BuildingHelper:GetPlayerTable(playerID)
        local name = playerTable.activeBuilding

        BuildingHelper:print("Failed placement of " .. name)
    end)

    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)

        -- Refund resources for this cancelled work
        if work.refund then
            hero:ModifyGold(gold_cost, false, 0)
        end
    end)

    -- A building unit was created
    event:OnConstructionStarted(function(unit)
        BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        -- Play construction sound

        -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
        if ability.GetCurrentCharges and not ability:IsPermanent() then
            local charges = ability:GetCurrentCharges()
            charges = charges-1
            if charges == 0 then
                ability:RemoveSelf()
            else
                ability:SetCurrentCharges(charges)
            end
        end

        -- Units can't attack while building
        unit.original_attack = unit:GetAttackCapability()
        unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)

        -- Give item to cancel
        local item = CreateItem("item_building_cancel", playersHero, playersHero)
        unit:AddItem(item)

        -- FindClearSpace for the builder
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
        caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})

        -- Remove invulnerability on npc_dota_building baseclass
        unit:RemoveModifierByName("modifier_invulnerable")
    end)

    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        
        -- Play construction complete sound

        -- Remove item_building_cancel
        for i=0,5 do
            local item = unit:GetItemInSlot(i)
            if item then
                if item:GetAbilityName() == "item_building_cancel" then
                    item:RemoveSelf()
                end
            end
        end

        -- Give the unit their original attack capability
        unit:SetAttackCapability(unit.original_attack)

        -- Add Arrow Tower 2 for tower
        if building_name == "tower" then
        local item = CreateItem("item_upgrade_arrowtower2", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Cannon Tower 2 for cannon tower
        if building_name == "tower_cannon" then
        local item = CreateItem("item_upgrade_cannontower2", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Lightning tower for fire/light tower
        if building_name == "tower_fire" or building_name == "tower_light" then
        local item = CreateItem("item_fire_light_lightningtower", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Speed Aura Tower for water/light tower
        if building_name == "tower_water" or building_name == "tower_light" then
        local item = CreateItem("item_water_light_speedauratower", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Multi-Shot Tower for dark/nature tower
        if building_name == "tower_dark" or building_name == "tower_nature" then
        local item = CreateItem("item_dark_nature_multishot", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Nevermore Tower for fire/dark tower
        if building_name == "tower_fire" or building_name == "tower_dark" then
        local item = CreateItem("item_fire_dark_nevermore", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Damage Aura Tower for earth/light tower
        if building_name == "tower_earth" or building_name == "tower_light" then
        local item = CreateItem("item_earth_light_damageaura", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Bash Tower for earth/dark tower
        if building_name == "tower_earth" or building_name == "tower_dark" then
        local item = CreateItem("item_earth_dark_bash", playersHero, playersHero)
        unit:AddItem(item)
        end

       -- Add Poison Tower for water/dark tower
        if building_name == "tower_water" or building_name == "tower_dark" then
        local item = CreateItem("item_water_dark_poison", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Sniper Tower for fire/nature tower
        if building_name == "tower_fire" or building_name == "tower_nature" then
        local item = CreateItem("item_fire_nature_sniper", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Glaive Tower for water/earth tower
        if building_name == "tower_water" or building_name == "tower_earth" then
        local item = CreateItem("item_water_earth_glaive", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Gold Tower for fire/earth tower
        if building_name == "tower_fire" or building_name == "tower_earth" then
        local item = CreateItem("item_fire_earth_gold", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Critical Tower for earth/nature tower
        if building_name == "tower_earth" or building_name == "tower_nature" then
        local item = CreateItem("item_earth_nature_critical", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Frost Tower for water/nature tower
        if building_name == "tower_water" or building_name == "tower_nature" then
        local item = CreateItem("item_water_nature_frost", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Impetus Tower for light/dark tower
        if building_name == "tower_light" or building_name == "tower_dark" then
        local item = CreateItem("item_light_dark_impetus", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Decrepify Tower for fire/water tower
        if building_name == "tower_fire" or building_name == "tower_water" then
        local item = CreateItem("item_fire_water_decrepify", playersHero, playersHero)
        unit:AddItem(item)
        end

        -- Add Life Tower for light/nature tower
        if building_name == "tower_light" or building_name == "tower_nature" then
        local item = CreateItem("item_light_nature_life", playersHero, playersHero)
        unit:AddItem(item)
        end

    end)

    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)

    event:OnAboveHalfHealth(function(unit)
        BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    local building = keys.unit
    local hero = building:GetOwner()
    local playerID = hero:GetPlayerID()

    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())

    -- Refund here
    local refund_factor = 1.00
    local gold_cost = math.floor(building:GetMaximumGoldBounty() * refund_factor)

    hero:ModifyGold(gold_cost, true, 0)
    print("[ARNE] Refunding gold, amount:" .. gold_cost)

    -- Eject builder
    local builder = building.builder_inside
    if builder then   
        builder:SetAbsOrigin(building:GetAbsOrigin())
    end

    building.state = "canceled"
    Timers:CreateTimer(1/5, function() 
        BuildingHelper:RemoveBuilding(building, true)
    end)
end

-- Requires notifications library from bmddota/barebones
function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end

-- Called when the sell building-item is used
function SellBuilding( keys )
    BuildingHelper:SellBuilding(keys)
end
