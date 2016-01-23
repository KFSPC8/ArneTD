function Spawn( entityKeyValues )

	local mydecrepifysplash = thisEntity:FindAbilityByName("tower_decrepify")

  Timers:CreateTimer(1, function() return AI_Pugna_Think(thisEntity) end)

end

function AI_Pugna_Think(thisEnt)

	if thisEnt:IsNull() or not thisEnt:IsAlive() then
    return nil
  end

  local mydecrepifysplash = thisEnt:FindAbilityByName("tower_decrepify")

  if mydecrepifysplash:IsFullyCastable() then

    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, thisEnt:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )

  	if units ~= nil then
  		if #units >= 1 then
  			local target = units[1]

  			thisEnt:CastAbilityOnTarget(target, mydecrepifysplash, -1)

  			return 1
  		end
  	end

	end

	return 1
end