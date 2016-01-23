--For moving creeps when they enter

function OnTrigger(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity(key.activator)

end

function MoveEntity(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox")

    local checkpoint1location = Entities:FindByName( nil,"checkpoint_1")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		-- TargetIndex = entToAttack:entindex(), --Optional.  Only used when targeting units
 		--AbilityIndex = 0, --Optional.  Only used when casting abilities
 		Position = checkpoint1location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch1(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity1(key.activator)

end

function MoveEntity1(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox1")

    local checkpoint2location = Entities:FindByName( nil,"checkpoint_2")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint2location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch2(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity2(key.activator)

end

function MoveEntity2(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox2")

    local checkpoint3location = Entities:FindByName( nil,"checkpoint_3")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint3location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch3(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity3(key.activator)

end

function MoveEntity3(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox3")

    local checkpoint4location = Entities:FindByName( nil,"checkpoint_4")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint4location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch4(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity4(key.activator)

end

function MoveEntity4(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox4")

    local checkpoint5location = Entities:FindByName( nil,"checkpoint_5")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint5location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch5(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity5(key.activator)

end

function MoveEntity5(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox5")

    local checkpoint6location = Entities:FindByName( nil,"checkpoint_6")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint6location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch6(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity6(key.activator)

end

function MoveEntity6(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox6")

    local checkpoint7location = Entities:FindByName( nil,"checkpoint_7")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint7location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch7(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity7(key.activator)

end

function MoveEntity7(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox7")

    local checkpoint8location = Entities:FindByName( nil,"checkpoint_8")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint8location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch8(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity8(key.activator)

end

function MoveEntity8(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox8")

    local checkpoint9location = Entities:FindByName( nil,"checkpoint_9")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint9location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch9(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity9(key.activator)

end

function MoveEntity9(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox9")

    local checkpoint10location = Entities:FindByName( nil,"checkpoint_10")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint10location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch10(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity10(key.activator)

end

function MoveEntity10(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox10")

    local checkpoint11location = Entities:FindByName( nil,"checkpoint_11")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint11location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch11(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity11(key.activator)

end

function MoveEntity11(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox11")

    local checkpoint12location = Entities:FindByName( nil,"checkpoint_12")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint12location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end

function OnStartTouch12(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    MoveEntity12(key.activator)

end

function MoveEntity12(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    --print("Unit '" .. unitName .. "' has entered the movebox12")

    local checkpoint13location = Entities:FindByName( nil,"checkpoint_13")
    local newOrder = {
 		UnitIndex = key:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
 		Position = checkpoint13location:GetAbsOrigin(), --Optional.  Only used when targeting the ground
 	}
 
ExecuteOrderFromTable(newOrder)

end