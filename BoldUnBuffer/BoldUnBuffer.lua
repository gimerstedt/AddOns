-- bub.
BUB = {}
BUB.debug = true
BUB.buffs = {}
BUB.warrior = {
	"Spell_Fire_Fire",
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

-- event handler.
local function onEvent()
	if not UnitBuff("player", 1) then return end -- do nothing unless buffs.

	if UnitClass("player") == "Warrior" then
		if BUB.IsShieldEquipped() then
			table.insert(warrior, "fSalvation")
		else
			-- fury warrior specific things? remove inspiration etc?
		end
		BUB.buffs = BUB.warrior
	end
	-- end of warrior stuffs.

	BUB.RemoveBuffs(BUB.buffs)
end

-- register event and handler.
local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", onEvent)

-- check if shield is equipped.
function BUB.IsShieldEquipped()
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

-- remove the buffs.
function BUB.RemoveBuffs(buffs)
	local i = 0
	while (GetPlayerBuffTexture(i)) do
		for n, buff in pairs(buffs) do
			if (string.find(GetPlayerBuffTexture(i), buff)) then
				if BUB.debug then
					BC.m("Removed "..buff..".")
				end
				CancelPlayerBuff(i)
				return
			end
		end
		i = i + 1
	end
end