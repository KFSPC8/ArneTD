function fire_god_attempt_upgrade(keys)
	--print("[ARNE] Attempting fire upgrade")
	if MyHero:HasItemInInventory("item_fire_orb") == true then
	  GameRules:SendCustomMessage("<font color='#ff0000'>The fire god upgraded your fire orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(0))
	  local item = CreateItem("item_fire_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_flames01.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_fire_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#ff0000'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function water_god_attempt_upgrade(keys)
	if MyHero:HasItemInInventory("item_water_orb") == true then
	  GameRules:SendCustomMessage("<font color='#007fff'>The water god upgraded your water orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(1))
	  local item = CreateItem("item_water_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water11.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_water_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#007fff'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function nature_god_attempt_upgrade(keys)
	if MyHero:HasItemInInventory("item_nature_orb") == true then
	  GameRules:SendCustomMessage("<font color='#00ff00'>The nature god upgraded your nature orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(2))
	  local item = CreateItem("item_nature_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast_tree.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_nature_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#00ff00'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function earth_god_attempt_upgrade(keys)
	if MyHero:HasItemInInventory("item_earth_orb") == true then
	  GameRules:SendCustomMessage("<font color='#ff9900'>The earth god upgraded your earth orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(3))
	  local item = CreateItem("item_earth_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/temp_eruption_rocks.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_earth_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#ff9900'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function light_god_attempt_upgrade(keys)
	if MyHero:HasItemInInventory("item_light_orb") == true then
	  GameRules:SendCustomMessage("<font color='#FFFF00'>The light god upgraded your light orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(4))
	  local item = CreateItem("item_light_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_light_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#FFFF00'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function dark_god_attempt_upgrade(keys)
	if MyHero:HasItemInInventory("item_dark_orb") == true then
	  GameRules:SendCustomMessage("<font color='#5900b3'>The dark god upgraded your dark orb!</font>", 0, 0)
	  MyHero:RemoveItem(MyHero:GetItemInSlot(5))
	  local item = CreateItem("item_dark_orb_2", MyHero, MyHero)
      MyHero:AddItem(item)
      EmitGlobalSound("DOTAMusic_Stinger.003")
      ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_flash_black.vpcf", PATTACH_POINT_FOLLOW, MyHero)
	else
		if MyHero:HasItemInInventory("item_dark_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#5900b3'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end

end

function upgrade_failed_fire(keys)
	if MyHero:HasItemInInventory("item_fire_orb") == true then
	  GameRules:SendCustomMessage("<font color='#ff0000'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_fire_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#ff0000'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end

function upgrade_failed_water(keys)
	if MyHero:HasItemInInventory("item_water_orb") == true then
	  GameRules:SendCustomMessage("<font color='#007fff'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_water_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#007fff'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end

function upgrade_failed_nature(keys)
	if MyHero:HasItemInInventory("item_nature_orb") == true then
	  GameRules:SendCustomMessage("<font color='#00ff00'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_nature_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#00ff00'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end

function upgrade_failed_earth(keys)
	if MyHero:HasItemInInventory("item_earth_orb") == true then
	  GameRules:SendCustomMessage("<font color='#ff9900'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_earth_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#ff9900'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end

function upgrade_failed_light(keys)
	if MyHero:HasItemInInventory("item_light_orb") == true then
	  GameRules:SendCustomMessage("<font color='#FFFF00'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_light_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#FFFF00'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end

function upgrade_failed_dark(keys)
	if MyHero:HasItemInInventory("item_dark_orb") == true then
	  GameRules:SendCustomMessage("<font color='#5900b3'>Your prayers are refused!</font>", 0, 0)
	else
		if MyHero:HasItemInInventory("item_dark_orb_2") == true then
			GameRules:SendCustomMessage("<font color='#5900b3'>Your orb has already been upgraded!</font>", 0, 0)
			MyHero:ModifyGold(20,false,0)
		end
	end
end
