-- event handler
local function onEvent()
	if not UnitBuff("player", 1) then return end -- do nothing unless 20 buffs
	local buffs = {}

	-- warrior buffs, just copy paste for new classes and swap names...
	local warrior = {
		"MagicalSentry", -- AI/int scroll
		"ArcaneIntellect", -- AB
		"PrayerofSpirit",
		"DivineSpirit",
		"DetectLesserInvisibility",
		"DetectInvisibility", 
		"BurningSpirit", -- spi scroll
		"MonsterScales_13", -- juju guile
		"BloodLust", -- bloodthirst
		"SealOfWisdom", -- 5 min
		"BlessingofWisdom", -- 15 min
		"Spell_Fire_Incinerate" -- ironfoe
	}
	if UnitClass("player") == "Warrior" then
		if BUB_isShieldEquipped() then
			table.insert(warrior, "fSalvation")
		else
			-- fury warrior specific things? remove inspiration etc?
		end
		buffs = warrior
	end
	-- end of warrior stuffs

	-- if event == "PLAYER_AURAS_CHANGED" or event == "UNIT_INVENTORY_CHANGED" then
		BUB_removeBuffs(buffs)
	-- end
end

-- register event and handler
local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", onEvent)

-- check if shield is equipped
function BUB_isShieldEquipped()
	local slot = GetInventorySlotInfo("SecondaryHandSlot")
	local link = GetInventoryItemLink("player", slot)
	if(link) then
		local found, _, id, name = string.find(link, "item:(%d+):.*%[(.*)%]")
		if found then
			local _,_,_,_,_,itemType = GetItemInfo(tonumber(id))
			if(itemType == "Shields") then
				return true
			end
		end
	end
	return false
end

function BUB_removeBuffs(buffs)
	local i = 0
	while (GetPlayerBuffTexture(i)) do
		for n, buff in pairs(buffs) do
			if (string.find(GetPlayerBuffTexture(i), buff)) then
				CancelPlayerBuff(i)
				return
			end
		end
		i = i + 1;
	end
end