function BC.Mount()
	local isMounted = BC.IsMounted()
	local bag, slot
	if isMounted then
		CancelPlayerBuff(isMounted)
	else
		local location = GetRealZoneText()
		if location == "Ahn'Qiraj" then
			bag, slot = BC.GetMount(BCM.bugs)
		else
			bag, slot = BC.GetMount(BCM.mounts)
		end
		if not bag then
			-- extract method for spell mounts
			if BC.GetSpellId("Summon Dreadsteed") then
				CloseMerchant()
				CastSpellByName("Summon Dreadsteed")
				return
			elseif
				BC.GetSpellId("Summon Felsteed") then
				CloseMerchant()
				CastSpellByName("Summon Felsteed")
				return
			else
				BC.m("Get a mount!", BC.prep)
				return
			end
		else
			CloseMerchant()
			UseContainerItem(bag, slot)
		end
	end
end

function BC.GetMount(all)
	for k, v in ipairs(all) do
		local bag, slot, texture, totalcount = BC.FindItem(v)
		if bag then
			return bag, slot
		end
	end
end

function BC.IsMounted()
	local count = 0
	while (GetPlayerBuff(count , "HELPFUL|HARMFUL|PASSIVE") ~= -1) do
		local index = GetPlayerBuff(count , "HELPFUL|HARMFUL|PASSIVE")
		BC_Buff_Tooltip:SetPlayerBuff(index)
		if string.find(BC_Buff_TooltipTextLeft2:GetText() or "", "Increases speed by") then return index end
		count = count + 1
	end
end

BCM = {}
BCM.bugs = {
	"Blue Qiraji Resonating Crystal",
	"Green Qiraji Resonating Crystal",
	"Red Qiraji Resonating Crystal",
	"Yellow Qiraji Resonating Crystal",
	"Black Qiraji Resonating Crystal",
}
BCM.mounts = {
	"Swift Gray Ram",
	"Swift Brown Ram",
	"Swift White Ram",
	"Black War Ram",
	"Black Ram",
	"Frost Ram",
	"Swift Green Mechanostrider",
	"Swift White Mechanostrider",
	"Swift Yellow Mechanostrider",
	"Black Battlestrider",
	"Icy Blue Mechanostrider Mod A",
	"White Mechanostrider Mod A",
	"Swift Brown Steed",
	"Swift Palomino",
	"Swift White Steed",
	"Black War Steed Bridle",
	"Palomino Bridle",
	"White Stallion Bridle",
	"Reins of the Swift Frostsaber",
	"Reins of the Swift Mistsaber",
	"Reins of the Swift Stormsaber",
	"Reins of the Black War Tiger",
	"Reins of the Frostsaber",
	"Reins of the Nightsaber",
	"Deathcharger's Reins",
	"Reins of the Winterspring Frostsaber",
	"Horn of the Frostwolf Howler",
	"Stormpike Battle Charger",
	"Swift Razzashi Raptor",
	"Swift Zulian Tiger",
	"Black Qiraji Resonating Crystal",

	"Brown Ram",
	"Gray Ram",
	"White Ram",
	"Blue Mechanostrider",
	"Green Mechanostrider",
	"Red Mechanostrider",
	"Unpainted Mechanostrider",
	"Chestnut Mare Bridle",
	"Black Stallion Bridle",
	"Brown Horse Bridle",
	"Pinto Bridle",
	"Reins of the Spotted Frostsaber",
	"Reins of the Striped Frostsaber",
	"Reins of the Striped Nightsaber",
}
