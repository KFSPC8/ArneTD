--[[
	Replaces the building to the upgraded unit name
]]--
function UpgradeBuilding( event )
	local caster = event.caster
	local new_unit = event.UnitName
	local position = caster:GetAbsOrigin()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local playerID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(playerID)
	local currentHealthPercentage = caster:GetHealthPercent() * 0.01
	local ability = event.ability

	-- Keep the gridnav blockers and orientation
	local blockers = caster.blockers
	local angle = caster:GetAngles()

    -- New building
	local building = BuildingHelper:PlaceBuilding(player, new_unit, position, false, 0)
	building.blockers = blockers
	building:SetAngles(0, -angle.y, 0)

	-- Set building's mana to be back to 0 after upgrade
	--building:SetMana(0)

	-- If the building to upgrade is selected, change the selection to the new one
	if IsCurrentlySelected(caster) then
		AddUnitToSelection(building)
	end

	-- Remove the old building from the structures list
	if IsValidEntity(caster) then
		local buildingIndex = getIndex(player.structures, caster)
        table.remove(player.structures, buildingIndex)
		
		-- Remove old building entity
		caster:RemoveSelf()
    end

	local newRelativeHP = building:GetMaxHealth() * currentHealthPercentage
	if newRelativeHP == 0 then newRelativeHP = 1 end --just incase rounding goes wrong
	building:SetHealth(newRelativeHP)

	-- Add 1 to the buildings list for that name. The old name still remains
	if not player.buildings[new_unit] then
		player.buildings[new_unit] = 1
	else
		player.buildings[new_unit] = player.buildings[new_unit] + 1
	end

	-- Add the new building to the structures list
	table.insert(player.structures, building)

	-- Update the abilities of the units and structures
	for k,unit in pairs(player.units) do
		CheckAbilityRequirements( unit, player )
	end

	for k,structure in pairs(player.structures) do
		CheckAbilityRequirements( structure, player )
	end
end

--[[
	Disable any queue-able ability that the building could have, because the caster will be removed when the channel ends
	A modifier from the ability can also be passed here to attach particle effects
]]--
function StartUpgrade( event )	
	local caster = event.caster
	local ability = event.ability
	local modifier_name = event.ModifierName
	local abilities = {}

	-- Check to not disable when the queue was full
	if #caster.queue < 5 then

		-- Iterate through abilities marking those to disable
		for i=0,15 do
			local abil = caster:GetAbilityByIndex(i)
			if abil then
				local ability_name = abil:GetName()

				-- Abilities to hide can be filtered to include the strings train_ and research_, and keep the rest available
				if ability_name ~= "ability_building_queue" and ability_name ~= "ability_building" then
					table.insert(abilities, abil)
				end
			end
		end

		-- Keep the references to enable if the upgrade gets canceled
		caster.disabled_abilities = abilities

		for k,disable_ability in pairs(abilities) do
			disable_ability:SetHidden(true)		
		end

		-- Pass a modifier with particle(s) of choice to show that the building is upgrading. Remove it on CancelUpgrade
		if modifier_name then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_name, {})
			caster.upgrade_modifier = modifier_name
		end

	end

	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local playerID = hero:GetPlayerID()
	FireGameEvent( 'ability_values_force_check', { player_ID = playerID })

end

--[[
	Replaces the building to the upgraded unit name
]]--
function CancelUpgrade( event )
	
	local caster = event.caster
	local abilities = caster.disabled_abilities

	for k,ability in pairs(abilities) do
		ability:SetHidden(false)		
	end

	local upgrade_modifier = caster.upgrade_modifier
	if upgrade_modifier and caster:HasModifier(upgrade_modifier) then
		caster:RemoveModifierByName(upgrade_modifier)
	end

	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local playerID = hero:GetPlayerID()
	FireGameEvent( 'ability_values_force_check', { player_ID = playerID })

end

-- Forces an ability to level 0
function SetLevel0( event )
	local ability = event.ability
	if ability:GetLevel() == 1 then
		ability:SetLevel(0)	
	end
end

function MyUpgradeBuilding( event )

	local caster = event.caster
	local new_unit = event.UnitName
	local position = caster:GetAbsOrigin()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local playerID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(playerID)
	local currentHealthPercentage = caster:GetHealthPercent() * 0.01
	local ability = event.ability

	-- Keep the gridnav blockers and orientation
	local blockers = caster.blockers
	local angle = caster:GetAngles()

	caster:RemoveSelf()

    -- New building
	local building = BuildingHelper:PlaceBuilding(player, new_unit, position, 2, 2, 0)
    building.blockers = blockers
	building:SetAngles(0, -angle.y, 0)

	-- Set the unit's movement to none to prevent towers from stopping their attack 
    building:SetMoveCapability(0)
    
    -- Toggle Impetus Tower autocast
    if new_unit == "tower_light_dark_impetus" then
    	print("[ARNE] START AUTO CAST")
    	local impetus_ability = building:FindAbilityByName("enchantress_impetus_custom")
    	if impetus_ability:GetAutoCastState() == true then
    		print("[ARNE] AutoCast is on")
    	else
    		print("[ARNE] AutoCast is off")
    	end
    	impetus_ability:ToggleAutoCast()
    end

    if new_unit == "tower_fire_light_lightning" then
    	--print("[ARNE] Add zeus tower")
    	local item = CreateItem("item_fire2_light2_zeustower", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_water_light_speedaura" then
    	local item = CreateItem("item_water2_light2_speedauratower2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_dark_nature_multishot" then
    	local item = CreateItem("item_dark2_nature2_multishot2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_fire_dark_nevermore" then
    	local item = CreateItem("item_fire2_dark2_nevermore2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_earth_light_damageaura" then
    	local item = CreateItem("item_earth2_light2_damageaura2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_earth_dark_bash" then
    	local item = CreateItem("item_earth2_dark2_bash2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_water_dark_poison" then
    	local item = CreateItem("item_water2_dark2_poison2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_fire_nature_sniper" then
    	local item = CreateItem("item_fire2_nature2_sniper2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_water_earth_glaive" then
    	local item = CreateItem("item_water2_earth2_glaive2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_fire_earth_gold" then
    	local item = CreateItem("item_fire2_earth2_gold2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_earth_nature_critical" then
    	local item = CreateItem("item_earth2_nature2_critical2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_water_nature_frost" then
    	local item = CreateItem("item_water2_nature2_frost2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_light_dark_impetus" then
    	local item = CreateItem("item_light2_dark2_impetus2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_fire_water_decrepify" then
    	local item = CreateItem("item_fire2_water2_decrepify2", playersHero, playersHero)
    	building:AddItem(item)
    end

    if new_unit == "tower_light_nature_life" then
    	local item = CreateItem("item_light2_nature2_life2", playersHero, playersHero)
    	building:AddItem(item)
    end
end

function MyUpgradeSecondaryBuilding( event )

	local caster = event.caster
	local new_unit = event.UnitName
	local position = caster:GetAbsOrigin()
	local hero = caster:GetPlayerOwner():GetAssignedHero() 
	local playerID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(playerID)
	local currentHealthPercentage = caster:GetHealthPercent() * 0.01
	local ability = event.ability

	-- Keep the gridnav blockers and orientation
	local blockers = caster.blockers
	local angle = caster:GetAngles()

	local ability_gold_cost = ability:GetGoldCost(1)

    -- Check if player has correct orbs
    if new_unit == "tower_fire2_light2_zeus" then
    	print("[ARNE] Checking for orbs")
    	if MyHero:HasItemInInventory("item_fire_orb_2") and MyHero:HasItemInInventory("item_light_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
			print("[ARNE] Upgrade succeeded!")
		else
			print("[ARNE] Player do not have the right orbs!")
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_water2_light2_speedaura2" then
    	if MyHero:HasItemInInventory("item_water_orb_2") and MyHero:HasItemInInventory("item_light_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_dark2_nature2_multishot2" then
    	if MyHero:HasItemInInventory("item_dark_orb_2") and MyHero:HasItemInInventory("item_nature_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_fire2_dark2_nevermore2" then
    	if MyHero:HasItemInInventory("item_fire_orb_2") and MyHero:HasItemInInventory("item_dark_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_earth2_light2_damageaura2" then
    	if MyHero:HasItemInInventory("item_earth_orb_2") and MyHero:HasItemInInventory("item_light_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_earth2_dark2_bash2" then
    	if MyHero:HasItemInInventory("item_earth_orb_2") and MyHero:HasItemInInventory("item_dark_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_water2_dark2_poison2" then
    	if MyHero:HasItemInInventory("item_water_orb_2") and MyHero:HasItemInInventory("item_dark_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_fire2_nature2_sniper2" then
    	if MyHero:HasItemInInventory("item_fire_orb_2") and MyHero:HasItemInInventory("item_nature_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_water2_earth2_glaive2" then
    	if MyHero:HasItemInInventory("item_water_orb_2") and MyHero:HasItemInInventory("item_earth_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_fire2_earth2_gold2" then
    	if MyHero:HasItemInInventory("item_fire_orb_2") and MyHero:HasItemInInventory("item_earth_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_earth2_nature2_critical2" then
    	if MyHero:HasItemInInventory("item_earth_orb_2") and MyHero:HasItemInInventory("item_nature_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_water2_nature2_frost2" then
    	if MyHero:HasItemInInventory("item_water_orb_2") and MyHero:HasItemInInventory("item_nature_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_light2_dark2_impetus2" then
    	if MyHero:HasItemInInventory("item_light_orb_2") and MyHero:HasItemInInventory("item_dark_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_fire2_water2_decrepify2" then
    	if MyHero:HasItemInInventory("item_fire_orb_2") and MyHero:HasItemInInventory("item_water_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

	if new_unit == "tower_light2_nature2_life2" then
    	if MyHero:HasItemInInventory("item_light_orb_2") and MyHero:HasItemInInventory("item_nature_orb_2") then
			PlaceUpgradedBuilding(building,player,new_unit,position,caster,angle,blockers)
		else
			FailUpgradeError(hero,caster,ability_gold_cost)
		end
	end

end

function PlaceUpgradedBuilding(building, player, new_unit, position, caster, angle, blockers)

    caster:RemoveSelf()

	local building = BuildingHelper:PlaceBuilding(player, new_unit, position, 2, 2, 0)

	building.blockers = blockers
    building:SetAngles(0, -angle.y, 0)

    -- Toggle Super Impetus Tower autocast
    if new_unit == "tower_light2_dark2_impetus2" then
    	local impetus_ability2 = building:FindAbilityByName("enchantress_impetus_custom2")
    	impetus_ability2:ToggleAutoCast()
    end

    -- Set the unit's movement to none to prevent towers from stopping their attack 
    building:SetMoveCapability(0)

end

function FailUpgradeError(hero, caster, ability_gold_cost)

	hero:ModifyGold(ability_gold_cost,false,0)
	SendErrorMessage(caster:GetPlayerOwnerID(), "#error_no_orbs")

end