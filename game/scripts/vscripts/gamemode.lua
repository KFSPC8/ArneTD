
--DEBUG_SPEW = 1

function MyGameMode:InitGameMode()

	--GameRules:GetGameModeEntity():SetHUDVisible(6, false)              -- Get Rid of Shop button - Change the UI Layout if you want a shop button
	--GameRules:GetGameModeEntity():SetHUDVisible(8, false)              --Quickbuy
  --GameRules:GetGameModeEntity():SetHUDVisible(9, false)              --Courier
  --GameRules:GetGameModeEntity():SetHUDVisible(10, false)             --Glyph
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1600)
	GameRules:SetHeroSelectionTime(30.0)                               -- How long should we let people select their hero?
  GameRules:SetPreGameTime(30.0)                                     -- How long after people select their heroes should the horn blow and the game start?
  --GameRules:GetGameModeEntity():SetUseCustomHeroLevels (true)        -- Should we allow heroes to have custom levels?
  --GameRules:GetGameModeEntity():SetCustomHeroMaxLevel (1)            -- What level should we let heroes get to?
  GameRules:SetGoldTickTime(30)                                      -- How long should we wait in seconds between gold ticks?
  GameRules:SetGoldPerTick(0)                                        -- How much gold should players get per tick?
  GameRules:SetHeroRespawnEnabled(false)                             -- Should we allow the hero to respawn automatically?
  GameRules:SetSameHeroSelectionEnabled(true)                        -- Should the players be able to pick the same hero multiple times?
  GameRules:GetGameModeEntity():SetBuybackEnabled(false)             -- Should we allow the hero to buyback?
  GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)           -- Should we have the fog disabled?
  GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)

	-- DebugPrint
	-- Convars:RegisterConvar('debug_spew', tostring(DEBUG_SPEW), 'Set to 1 to start spewing debug info. Set to 0 to disable.', 0)

	-- Event Hooks
	ListenToGameEvent('entity_killed', Dynamic_Wrap(MyGameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(MyGameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(MyGameMode, 'OnGameRulesStateChange'), self)

	-- Filters
  GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(MyGameMode, "FilterExecuteOrder" ), self )

  -- Register Listener
  CustomGameEventManager:RegisterListener( "update_selected_entities", Dynamic_Wrap(MyGameMode, 'OnPlayerSelectedEntities'))
  CustomGameEventManager:RegisterListener( "repair_order", Dynamic_Wrap(MyGameMode, "RepairOrder"))  	
	
	-- Full units file to get the custom values
	GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
  GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")

  -- Store and update selected units of each pID
	GameRules.SELECTED_UNITS = {}

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))

	-- Keeps the blighted gridnav positions
	GameRules.Blight = {}

  -- Set 4 players
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

  -- Set Initial Monster count and determine round number
	monstercount = 0.00
	round_finished = 0.00
  life_tower_number_killed = 0
  arne_goldtowers_gold = 0
  
  --Set initial wave number
  self.TEAM_KILLS_TO_WIN = 1

end

function clearUnitAbilities(unit)
  for i = 0, unit:GetAbilityCount()-1 do
    local a = unit:GetAbilityByIndex(i)

    if a ~= nil then
      unit:RemoveAbility(a:GetAbilityName())
    end
  end
end

function lvlUpUnitAbilities(unit)
  for i = 0, unit:GetAbilityCount()-1 do
    local a = unit:GetAbilityByIndex(i)

    if a ~= nil then
      a:SetLevel(1)
    end
  end
end

-- A player picked a hero
function MyGameMode:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()

  MyHero = hero
  MyPlayerID = playerID

	-- Initialize Variables for Tracking
	player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
	player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
	player.buildings = {} -- This keeps the name and quantity of each building
	player.upgrades = {} -- This kees the name of all the upgrades researched
	player.lumber = 0 -- Secondary resource of the player

  -- Add the hero to the player units list
	table.insert(player.units, hero)
	hero.state = "idle" --Builder state

	-- Give Initial Resources
	hero:SetGold(150, false)
	ModifyLumber2(player, 1)
  local item = CreateItem("item_fire_orb", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_water_orb", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_nature_orb", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_earth_orb", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_light_orb", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_dark_orb", hero, hero)
  hero:AddItem(item)

  -- Display Timer
  --CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Game starts in", duration=20, mode=0, endfade=false, position=0, warning=2, paused=false, sound=false} )

	-- Lumber tick
	--[[Timers:CreateTimer(1, function()
		ModifyLumber(player, 0)
		return 10
	end)]]--

	-- Learn all abilities (this isn't necessary on creatures)
	for i=0,15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then ability:SetLevel(ability:GetMaxLevel()) end
	end
	hero:SetAbilityPoints(0)

end

-- An entity died
function MyGameMode:OnEntityKilled( event )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	-- The Killing entity
	local killerEntity
	if event.entindex_attacker then
		killerEntity = EntIndexToHScript(event.entindex_attacker)
	end

	-- Player owner of the unit
	local player = killedUnit:GetPlayerOwner()

	-- Building Killed
	if IsCustomBuilding(killedUnit) then

		-- Check units for downgrades
		local building_name = killedUnit:GetUnitName()
				
		-- Substract 1 to the player building tracking table for that name
		if player.buildings[building_name] then
			player.buildings[building_name] = player.buildings[building_name] - 1
		end

		--[[ possible unit downgrades
		for k,units in pairs(player.units) do
		    CheckAbilityRequirements( units, player )
		end

		-- possible structure downgrades
		for k,structure in pairs(player.structures) do
			CheckAbilityRequirements( structure, player )
		end ]]
	end

	-- Table cleanup
	if player then
		-- Remake the tables
		local table_structures = {}
		for _,building in pairs(player.structures) do
			if building and IsValidEntity(building) and building:IsAlive() then
				--print("Valid building: "..building:GetUnitName())
				table.insert(table_structures, building)
			end
		end
		player.structures = table_structures
		
		local table_units = {}
		for _,unit in pairs(player.units) do
			if unit and IsValidEntity(unit) then
				table.insert(table_units, unit)
			end
		end
		player.units = table_units		
	end

    --[[ For Quest Update
	local killedUnit = EntIndexToHScript( event.entindex_killed )
    local creepname_table = {}
    for i = 1,20 do
    	creepname_table[i] = "creep_wave" .. i
    end

    --[[for i,line in ipairs(creepname_table) do
    	print(line)
    end]]--

    local creepname_integers = {}
    for i = 1,40 do
    	creepname_integers[i] = i
    end

    for i,line in ipairs(creepname_integers) do
    if killedUnit and (killedUnit:GetUnitName() == "creep_wave" .. line) then
        -- Fill the quest bar and substract one from the quest remaining text
        GameRules.Quest.UnitsKilled = GameRules.Quest.UnitsKilled + 1
        GameRules.Quest:SetTextReplaceValue(QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.Quest.UnitsKilled)
        GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.Quest.UnitsKilled )

        -- Check if quest completed 
        if GameRules.Quest.UnitsKilled >= GameRules.Quest.KillLimit then
        	EmitGlobalSound("Tutorial.Quest.complete_01")
            Timers:CreateTimer({
            endTime = 7, 
            callback = function()
              GameRules.Quest:CompleteQuest()
              GameRules.Quest.UnitsKilled = 0
            end
            })
        end
    end 
    end  

    --Count how many monsters have been released to determine the round number
    local creepname_integers = {}
    for i = 1,40 do
    	creepname_integers[i] = i
    end

    for i,line in ipairs(creepname_integers) do
    if killedUnit and (killedUnit:GetUnitName() == "creep_wave" .. line) then
        monstercount = monstercount + 1.00
        print("Monster count is " .. monstercount)
        round_finished = math.abs(monstercount/30)
        print("Just finished round " .. round_finished)
    end
    end

    -- For spawning creeps after wave 1
    local round_integers = {}
    for i =1,40 do
    	round_integers[i] = i
    end

    -- For counting number of Vaal kills
    vaal_kills = 0

    -- For FINAL BOSS ROUND
    if killedUnit and (killedUnit:GetUnitName() == "creep_wave" .. 40) and round_finished == 40 then

      GameRules:SendCustomMessage("<font color='#ff0000'>Congratulations! You have cleared 40 waves, lets start the final round!</font>", 0, 0)
      EmitGlobalSound("dsadowski_01.stinger.radiant_win")

      Timers:CreateTimer({
      endTime = 8,
      callback = function()
          Timers:CreateTimer("timer_spawn_vaal", {
          useGameTime = true,
          endTime = 0,
          callback = function()
            if vaal_kills < 50 then
              local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
              CreateUnitByName( "creep_wave50", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
            end
            return 0.8
          end
          })
      end
      })

    end

    for i,line_2 in ipairs(round_integers) do
    if killedUnit and (killedUnit:GetUnitName() == "creep_wave" .. line_2) and round_finished == line_2 and (MyHero:GetHealth() >= 1) then

      CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next wave in", duration=7, mode=0, endfade=false, position=0, warning=2, paused=false, sound=true} )

    	Timers:CreateTimer({
        endTime = 8,
        callback = function()
    	    local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          self.TEAM_KILLS_TO_WIN = math.floor(line_2 + 1)
          CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
    	    for i =1,30 do
    		   CreateUnitByName( "creep_wave" .. (round_finished+1), SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
    	    end

            --Create Quest every wave 
            if line_2 ~= 40 then
    	      GameRules.Quest = SpawnEntityFromTableSynchronous( "quest", {
              name = "QuestName",
              title = "#QuestKill" .. math.floor(line_2 + 1)
              })

              GameRules.subQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
              show_progress_bar = true,
              progress_bar_hue_shift = -119
              } )

              GameRules.Quest.UnitsKilled = 0
              GameRules.Quest.KillLimit = 30
              GameRules.Quest:AddSubquest( GameRules.subQuest )

              -- text on the quest timer at start
              GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
              GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.Quest.KillLimit )

              -- value on the bar
              GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
              GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.Quest.KillLimit )     
            end     
        end
        })
    end
  end

  --Create Elemental Gods at upon clearing wave 5
  if killedUnit and (killedUnit:GetUnitName() == "creep_wave" .. 5) and round_finished == 5 then
    -- Initialize Upgrade buildings
    local position_f = Entities:FindByName( nil,"arnetd_fire_shop") 
    local position_w = Entities:FindByName( nil,"arnetd_water_shop") 
    local position_n = Entities:FindByName( nil,"arnetd_nature_shop") 
    local position_e = Entities:FindByName( nil,"arnetd_earth_shop") 
    local position_l = Entities:FindByName( nil,"arnetd_light_shop") 
    local position_d = Entities:FindByName( nil,"arnetd_dark_shop") 

    local fire_god = CreateUnitByName( "fire_shop", position_f:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    fire_god:SetOwner(MyHero)
    fire_god:SetControllableByPlayer(MyPlayerID, true)

    local water_god = CreateUnitByName( "water_shop", position_w:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    water_god:SetOwner(MyHero)
    water_god:SetControllableByPlayer(MyPlayerID, true)

    local nature_god = CreateUnitByName( "nature_shop", position_n:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    nature_god:SetOwner(MyHero)
    nature_god:SetControllableByPlayer(MyPlayerID, true)

    local earth_god = CreateUnitByName( "earth_shop", position_e:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    earth_god:SetOwner(MyHero)
    earth_god:SetControllableByPlayer(MyPlayerID, true)

    local light_god = CreateUnitByName( "light_shop", position_l:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    light_god:SetOwner(MyHero)
    light_god:SetControllableByPlayer(MyPlayerID, true)

    local dark_god = CreateUnitByName( "dark_shop", position_d:GetAbsOrigin(), true, MyHero, MyHero, DOTA_TEAM_GOODGUYS )
    dark_god:SetOwner(MyHero)
    dark_god:SetControllableByPlayer(MyPlayerID, true)

    print("[ARNE] SHOP CREATED!" .. ", Team Number is: " .. MyHero:GetTeamNumber())
    GameRules:SendCustomMessage("<font color='#ff8000'>You can now upgrade your elemental orbs!</font>", 0, 0)
  end

  for i =50,59 do
  if killedUnit and (killedUnit:GetUnitName() == ("creep_wave" .. i)) and (killerEntity:IsOwnedByAnyPlayer()) then
    MyHero:IncrementKills(1)
    vaal_kills = MyHero:GetKills()
    print("[ARNE] Number of kills is :" .. MyHero:GetKills() )
    -- print("[ARNE] Vaal kills value is :" .. vaal_kills)
    -- GameRules:SendCustomMessage("<font color='#ff0000'>You have killed </font>" .. MyHero:GetKills() .. "<font color='#ff0000'> Vaals</font>", 0, 0)
    ModifyLumber(PlayerResource:GetPlayer(MyPlayerID),vaal_kills)
  else
    if killedUnit and (killedUnit:GetUnitName() == "npc_dota_hero_kunkka") then
      GameRules:SendCustomMessage("<font color='#ff0000'>You lost!</font>", 0, 0)
    else
      if (killedUnit:GetUnitName() == "npc_dota_hero_antimage") then
        GameRules:SendCustomMessage("<font color='#ff0000'>You lost!</font>", 0, 0)
      end
    end
  end
  end

  -- Remove timer when 50 vaals are killed
  if vaal_kills == 50 then
    print("[ARNE] Removing 1st timer")
    Timers:RemoveTimer("timer_spawn_vaal")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_2", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave51", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 150 vaals are killed
  if vaal_kills == 150 then
    print("[ARNE] Removing 2nd timer")
    Timers:RemoveTimer("timer_spawn_vaal_2")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_3", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave52", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 250 vaals are killed
  if vaal_kills == 250 then
    print("[ARNE] Removing 3rd timer")
    Timers:RemoveTimer("timer_spawn_vaal_3")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_4", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave53", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 350 vaals are killed
  if vaal_kills == 350 then
    print("[ARNE] Removing 4th timer")
    Timers:RemoveTimer("timer_spawn_vaal_4")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_5", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave54", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 450 vaals are killed
  if vaal_kills == 450 then
    print("[ARNE] Removing 5th timer")
    Timers:RemoveTimer("timer_spawn_vaal_5")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_6", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave55", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 550 vaals are killed
  if vaal_kills == 550 then
    print("[ARNE] Removing 6th timer")
    Timers:RemoveTimer("timer_spawn_vaal_6")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_7", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave56", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 650 vaals are killed
  if vaal_kills == 650 then
    print("[ARNE] Removing 7th timer")
    Timers:RemoveTimer("timer_spawn_vaal_7")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_8", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave57", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 800 vaals are killed
  if vaal_kills == 800 then
    print("[ARNE] Removing 8th timer")
    Timers:RemoveTimer("timer_spawn_vaal_8")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_9", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave58", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Remove timer when 1000 vaals are killed
  if vaal_kills == 1000 then
    print("[ARNE] Removing 9th timer")
    Timers:RemoveTimer("timer_spawn_vaal_9")

    GameRules:SendCustomMessage("<font color='#ff8000'>Vaal just received increased stats!</font>", 0, 0)

      Timers:CreateTimer("timer_spawn_vaal_10", {
      useGameTime = true,
      endTime = 0,
      callback = function()
          local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
          CreateUnitByName( "creep_wave59", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        return 0.8
      end
      })
  end

  -- Transition to Phase 3 when 1200 vaals are killed
  if vaal_kills == 1200 then
    print("[ARNE] Removing 10th timer")
    Timers:RemoveTimer("timer_spawn_vaal_10")

    GameRules:SendCustomMessage("<font color='#ff0000'>Well done! Let's move on to the damage test!</font>", 0, 0)
    EmitGlobalSound("dsadowski_01.stinger.radiant_win")

    CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Damage test in", duration=29, mode=0, endfade=false, position=0, warning=2, paused=false, sound=true} )

    -- 30 second delayed, run once using gametime (respect pauses)
    Timers:CreateTimer({
      endTime = 30,
      callback = function()
        print("[ARNE] Spawn damage test")
        local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
        CreateUnitByName( "creep_wave_damage_test", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
      end
    })
  end

  -- Stop all vaal spawns when builder is dead
  if (MyHero:GetHealth() <= 0) then
    Timers:RemoveTimer("timer_spawn_vaal")
    Timers:RemoveTimer("timer_spawn_vaal_2")
    Timers:RemoveTimer("timer_spawn_vaal_3")
    Timers:RemoveTimer("timer_spawn_vaal_4")
    Timers:RemoveTimer("timer_spawn_vaal_5")
    Timers:RemoveTimer("timer_spawn_vaal_6")
    Timers:RemoveTimer("timer_spawn_vaal_7")
    Timers:RemoveTimer("timer_spawn_vaal_8")
    Timers:RemoveTimer("timer_spawn_vaal_9")
    Timers:RemoveTimer("timer_spawn_vaal_10")
  end 

  -- Sets post game if damage test is killed
  if killedUnit and (killedUnit:GetUnitName() == "creep_wave_damage_test") then
    GameRules:SetGameWinner(2)
    EmitGlobalSound("dsadowski_01.stinger.dire_win")
    print("[ARNE] Game ends now:" .. GameRules:State_Get())
  end

  -- Function for updating vaal kills panorama UI
  function ModifyLumber(playerID, amount)
    if MyHero:GetHealth() >= 1 and vaal_kills <= 1200 then 
      CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(MyPlayerID), "etd_update_lumber", { lumber = vaal_kills } )
    end
  end

end

-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function MyGameMode:OnPlayerSelectedEntities( event )
	local pID = event.pID

	GameRules.SELECTED_UNITS[pID] = event.selected_entities

	-- This is for Building Helper to know which is the currently active builder
	local mainSelected = GetMainSelectedEntity(pID)
	if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
		local player = PlayerResource:GetPlayer(pID)
		player.activeBuilder = mainSelected
	end
end

function MyGameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--self.CustomRule:HeroSelect()
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		--self.CustomRule:PreGame()
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        MyGameMode:OnGameInProgress()
	end
end

function MyGameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  local SpawnLocation = Entities:FindByName( nil,"creep_spawn_point")
  local total_monster_inthiswave = 30

  for i = 1,total_monster_inthiswave do
  	Timers:CreateTimer({
    endTime = 0.5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
        CreateUnitByName( "creep_wave1", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
    end
    })
  end

  -- Shows notification at top
  --Notifications:TopToAll({text="Wave - 1", duration=5.0})

  local questkill_table = {}
  for i =1,40 do 
  	questkill_table[i] = i 
  end

  -- 0 second delayed, run once using gametime (respect pauses)
  Timers:CreateTimer({
    endTime = 0.5, 
    callback = function()
      GameRules.Quest = SpawnEntityFromTableSynchronous( "quest", {
      name = "QuestName",
      title = "#QuestKill" .. 1
    })
      GameRules.subQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
      show_progress_bar = true,
      progress_bar_hue_shift = -119
    } )
    GameRules.Quest.UnitsKilled = 0
    GameRules.Quest.KillLimit = total_monster_inthiswave
    GameRules.Quest:AddSubquest( GameRules.subQuest )

    -- text on the quest timer at start
    GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
    GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.Quest.KillLimit )

    -- value on the bar
    GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
    GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.Quest.KillLimit )
    end
  })

   --Quest that shows lives

   GameRules.QuestLives = SpawnEntityFromTableSynchronous( "quest", {
   name = "QuestNameLives",
   title = "#QuestLives"
   })

  GameRules.subQuestLives = SpawnEntityFromTableSynchronous( "subquest_base", {
      show_progress_bar = true,
      progress_bar_hue_shift = -119
  } )

  GameRules.QuestLives:AddSubquest( GameRules.subQuestLives )

  GameRules.QuestLives:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 50 )

  -- value on the bar
  GameRules.subQuestLives:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 50 )
  GameRules.subQuestLives:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 50 )

  --Show Wave number
  CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
  
end
