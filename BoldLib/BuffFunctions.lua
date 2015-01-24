-- pretty sure this one isn't working, need to test
function ReportMissingDebuffsOnTarget()
	if not UnitInRaid("player") or not isEnemy("target") then
		BL.m("You are either in not in a raid or your target is not an enemy or you do not have a target.", BL_PREP)
		return
	end
	local debuffsMissing = {}
	for i=1, 16 do
		db = UnitDebuff("target", i)
		if db == nil then 
			BL.r(UnitName("target").." has no debuffs!", BL_PREP)
			break
		end
		if not string.find(db, "Spell_Shadow_CurseOfAchimonde") then table.insert(debuffsMissing, "Curse of Shadows") end
		if not string.find(db, "Spell_Shadow_ChillTouch") then table.insert(debuffsMissing, "Curse of Elements") end
		if not string.find(db, "Spell_Shadow_UnholyStrength") then table.insert(debuffsMissing, "Curse of Recklessness") end
		if not string.find(db, "Spell_Nature_FaerieFire") then table.insert(debuffsMissing, "Faerie Fire") end
		if not string.find(db, "Spell_Shadow_BlackPlague") then table.insert(debuffsMissing, "Shadow Weaving") end
		if not string.find(db, "Ability_Warrior_Sunder") then table.insert(debuffsMissing, "Sunder Armor") end
		if not string.find(db, "Spell_Holy_Holysmite") then table.insert(debuffsMissing, "SotC") end
	end
	if table.getn(debuffsMissing) > 0 then
		local outputString = UnitName("target").." is missing"
		for i = 1, table.getn(debuffsMissing) do
			outputString = outputString.." "..debuffsMissing[i].."!"
		end
		BL.r(outputString)
	end
end

function ReportBuffsOnTarget()
	if not UnitExists("target") then
		u = "player"
	else
		u = "target"
	end
	if UnitName(u) then
		if not UnitBuff(u, 1) then
			BL.m("Target has no visible buffs.", BL_PREP)
			return
		end
		local counter = 1
		while (UnitBuff(u, counter)) do
			ZORLEN_Buff_Tooltip:SetUnitBuff(u, counter)
			local name = ZORLEN_Buff_TooltipTextLeft1:GetText()
			BL.m(counter..": "..name, BL_PREP)
			BL.m(counter..": ("..UnitBuff(u, counter)..")", BL_PREP)
			counter = counter + 1
		end
	end
end