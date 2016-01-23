
--  Goes to elemental page
function goToPage(keys)
  MyGameMode:goToPage(keys)
end

function MyGameMode:goToPage(keys)
  local caster = keys.caster
  local ability = keys.ability

  local ability_name = ability:GetAbilityName()

  caster:RemoveAbility("build_tower")
  caster:RemoveAbility("build_cannontower")
  caster:RemoveAbility("open_page_elemental")
  caster:RemoveAbility("queenofpain_blink_datadriven")
  caster:RemoveAbility("builder_guardian_angel_passive")
  caster:RemoveAbility("return_to_start_page2")
  caster:RemoveAbility("build_earthtower")
  caster:RemoveAbility("build_lighttower")
  caster:RemoveAbility("build_darktower")

  caster:AddAbility("return_to_start_page")
  caster:AddAbility("build_firetower")
  caster:AddAbility("build_watertower")
  caster:AddAbility("build_naturetower")
  caster:AddAbility("open_page_elemental2")

  if ability_name == "open_page_one" then
    
    --caster:AddAbility("build_tower_basic")

  end

  lvlUpUnitAbilities(caster)
end

--  Goes to elemental page 2
function goToPage2(keys)
  MyGameMode:goToPage2(keys)
end

function MyGameMode:goToPage2(keys)
  local caster = keys.caster
  local ability = keys.ability

  local ability_name = ability:GetAbilityName()

  caster:RemoveAbility("build_tower")
  caster:RemoveAbility("build_cannontower")
  caster:RemoveAbility("open_page_elemental")
  caster:RemoveAbility("queenofpain_blink_datadriven")
  caster:RemoveAbility("builder_guardian_angel_passive")
  caster:RemoveAbility("return_to_start_page")
  caster:RemoveAbility("build_firetower")
  caster:RemoveAbility("build_watertower")
  caster:RemoveAbility("build_naturetower")
  caster:RemoveAbility("build_earthtower")
  caster:RemoveAbility("build_lighttower")
  caster:RemoveAbility("build_darktower")
  caster:RemoveAbility("open_page_elemental2")

  caster:AddAbility("return_to_start_page2")
  caster:AddAbility("build_earthtower")
  caster:AddAbility("build_lighttower")
  caster:AddAbility("build_darktower")

  if ability_name == "open_page_one" then
    
    --caster:AddAbility("build_tower_basic")

  end

  lvlUpUnitAbilities(caster)
end

-- Goes back to start page
function returnToStartPage(keys)
  MyGameMode:returnToStartPage(keys)
end

function MyGameMode:returnToStartPage(keys)
  local caster = keys.caster
  local ability = keys.ability

  local ability_name = ability:GetAbilityName()

  caster:RemoveAbility("return_to_start_page")
  caster:RemoveAbility("build_tower")
  caster:RemoveAbility("build_cannontower")
  caster:RemoveAbility("open_page_elemental")
  caster:RemoveAbility("queenofpain_blink_datadriven")
  caster:RemoveAbility("builder_guardian_angel_passive")
  caster:RemoveAbility("build_firetower")
  caster:RemoveAbility("build_watertower")
  caster:RemoveAbility("build_naturetower")
  caster:RemoveAbility("build_earthtower")
  caster:RemoveAbility("build_lighttower")
  caster:RemoveAbility("build_darktower")
  caster:RemoveAbility("open_page_elemental2")

  caster:AddAbility("build_tower")
  caster:AddAbility("build_cannontower")
  caster:AddAbility("queenofpain_blink_datadriven")
  caster:AddAbility("builder_guardian_angel_passive")
  caster:AddAbility("open_page_elemental")

  lvlUpUnitAbilities(caster)
end