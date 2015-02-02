-- bub.
BUB = {}
BUB.debug = true
BUB.warrior = {
	"Spell_Fire_Fire", -- cozy fire
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

-- on load.
function BUB.OnLoad()
	this:RegisterEvent("PLAYER_AURAS_CHANGED")
	this:RegisterEvent("UNIT_INVENTORY_CHANGED")
end

-- event handler.
function BUB.OnEvent(event)
	if UnitName("target") == "Garr" then return end -- keep buffs for garr in case of dispel :(
	if not UnitBuff("player", 1) then return end -- do nothing unless buffs.

	-- warrior stuffs. add another section like this with corresponding buff table for your class.
	if UnitClass("player") == "Warrior" then
		if BUB.IsShieldEquipped() then
			table.insert(BUB.warrior, "fSalvation")
		else
			-- fury warrior specific things? remove inspiration etc?
		end
		BUB.buffs = BUB.warrior
	end
	-- end of warrior stuffs.

	BUB.RemoveBuffs(BUB.buffs)
end

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

-- for future safe LS/SW/LGG stuffs
-- Rejuvenation - Spell_Nature_Rejuvenation
-- Regrowth - Spell_Nature_ResistNature
-- Blessing of the Claw - Spell_Holy_BlessingOfAgility (same as agi scroll :()