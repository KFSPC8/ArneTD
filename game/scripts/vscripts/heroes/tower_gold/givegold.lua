--[[Author: Pizzalol
	Date: 04.03.2015.
	Awards the bonus gold to the modifier owner only if the modifier owner is alive]]
function DevourGold( keys )
	local target = MyHero
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability_level)

	-- Give the gold only if the target is alive
	if target:IsAlive() then
		target:ModifyGold(bonus_gold, false, 0)
		Increment(bonus_gold)
		UpdateGoldTower(PlayerResource:GetPlayer(MyPlayerID), arne_goldtowers_gold)
	end
end

-- Function for updating gold gained from gold towers panorama UI
function UpdateGoldTower(playerID, amount)
    if MyHero:GetHealth() >= 1 then 
      CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(MyPlayerID), "etd_update_goldgained", { lumber = arne_goldtowers_gold } )
    end
end

function Increment(bonus_gold)
	arne_goldtowers_gold = arne_goldtowers_gold + bonus_gold
end