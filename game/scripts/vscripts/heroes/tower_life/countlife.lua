-- For counting lives
function CountKills(event) 
	print("[ARNE] Number of units killed by life tower:" .. life_tower_number_killed)
	AddLives()
end

-- For adding kills to counter
function AddKills(event)
	local killerEntity = event.attacker

	if life_tower_number_killed <= 14  and (killerEntity:GetUnitName() == "tower_light_nature_life") then
	  life_tower_number_killed = life_tower_number_killed + 1 
	  --print("[ARNE] Adding to number killed")
	else
		if life_tower_number_killed <= 14  and (killerEntity:GetUnitName() == "tower_light2_nature2_life2") then
			life_tower_number_killed = life_tower_number_killed + 1 
		end 
	end
	CountKills()
end

-- For adding lives
function AddLives(event) 
	print("[ARNE] Builder's health is:" .. MyHero:GetHealth())
	if MyHero:GetHealth() >= 1 and (life_tower_number_killed == 15) and (MyHero:GetHealth() <= 49) then
		local builder_health_added = MyHero:GetHealth() + 1
		MyHero:SetHealth(builder_health_added)
		EmitGlobalSound("Greevil.Purification")
		life_tower_number_killed = 0

		--Update lives quest
	    GameRules.QuestLives:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, MyHero:GetHealth() )
	    GameRules.subQuestLives:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, MyHero:GetHealth() )
	end
end

