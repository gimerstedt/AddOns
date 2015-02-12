-- bub.
BUB = {}
BUB.debug = true
BUB.prep = "[BoldUnBuffer] "

-- on load.
function BUB.OnLoad()
	BUB.InitBuffTables()
	this:RegisterEvent("PLAYER_AURAS_CHANGED")
	this:RegisterEvent("UNIT_INVENTORY_CHANGED")
end

-- event handler.
function BUB.OnEvent(event)
	if UnitName("target") == "Garr" then return end -- keep buffs for garr in case of dispel :(

	-- if equip shield
	if event == "UNIT_INVENTORY_CHANGED" then
		BUB.InitBuffTables()
	end

	-- remove buffs.
	for k, buff in pairs(BUB.buffs) do
		BC.RemoveBuffByName(buff)
	end
end

function BUB.InitBuffTables()
	BUB.buffs = {
		"Cozy Fire",
	}
	BUB.warrior = {
		"Blessing of Wisdom",
		"Greater Blessing of Wisdom",
		"Arcane Intellect",
		"Arcane Brilliance",
		"Divine Spirit",
		"Prayer of Spirit",
		"Intellect", -- int scroll.
		"Spirit", -- spi scroll.
		-- "Fury of Forgewright", -- ironfoe, might fuck the proc up?
		"Bloodthirst",
	}
	BUB.paladin = {
		"Battle Shout",
	}

	local class = UnitClass("player")

	-- warrior stuffs. add another section like this with corresponding buff table for your class.
	if class == "Warrior" then
		if BC.IsShieldEquipped() then
			BC.m("adding salv to table")
			table.insert(BUB.warrior, "Blessing of Salvation")
			table.insert(BUB.warrior, "Greater Blessing of Salvation")
		else
			-- fury warrior specific things? remove inspiration etc?
		end
		for k, buff in pairs(BUB.warrior) do table.insert(BUB.buffs, 1, buff) end
	end
	-- end of warrior stuffs.

	-- paladin stuffs.
	if class == "Paladin" then
		for k, buff in pairs(BUB.paladin) do BUB.buffs[k] = buff end
	end
	-- end of paladin stuffs.
end