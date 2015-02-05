-- seems to be working.
function BC.ReportMissingDebuffsOnTarget()
	if not UnitInRaid("player") or not UnitIsEnemy("player", "target") then
		BC.m("You are either not in a raid or your target is not an enemy or you do not have a target.", BC.prep)
		return
	end
	if not UnitDebuff("target", 1) then
		BC.r(UnitName("target").." has no debuffs!", BC.prep)
		return
	end

	local cos, coe, cor, ff, sw, sa = false, false, false, false, false, 0
	local i = 1

	while UnitDebuff("target", i) do
		local texture, applications = UnitDebuff("target", i)
		if string.find(texture, "Spell_Shadow_CurseOfAchimonde") then cos = true end
		if string.find(texture, "Spell_Shadow_ChillTouch") then coe = true end
		if string.find(texture, "Spell_Shadow_UnholyStrength") then cor = true end
		if string.find(texture, "Spell_Nature_FaerieFire") then ff = true end
		if string.find(texture, "Spell_Shadow_BlackPlague") then sw = true end
		if string.find(texture, "Ability_Warrior_Sunder") then _, sa = true, applications end
		i = i + 1
	end
	if cos and coe and cor and ff and sw and sa then return end

	local out = "Target is missing "
	if not cos then out = out.."CoS! " end
	if not coe then out = out.." CoE! " end
	if not cor then out = out.."CoR! " end
	if not ff then out = out.."FF! " end
	if not sw then out = out.."Shadow Weaving! " end
	if sa < 5 then out = out.."Sunders! " end

	BC.r(out, BC.prep)
end

-- buuuuuuuuuffffffffs.
function BC.ReportBuffsOnTarget(showTextureNames)
	if showTextureNames ~= "true" then showTextureNames = false else showTextureNames = true end
	if not UnitExists("target") then
		u = "player"
	else
		u = "target"
	end
	if UnitName(u) then
		if not UnitBuff(u, 1) then
			BC.m("Target has no visible buffs.", BC.prep)
			return
		end
		local counter = 1
		while (UnitBuff(u, counter)) do
			BC_Buff_Tooltip:SetUnitBuff(u, counter)
			local name = BC_Buff_TooltipTextLeft1:GetText()
			BC.m(counter..": "..name, BC.prep)
			if showTextureNames then
				BC.c(counter..": ("..UnitBuff(u, counter)..")", BC.prep)
			end
			counter = counter + 1
		end
	end
end

-- boolean if has buff
function BC.HasBuff(unit, textureName)
	local i = 1
	while UnitBuff(unit, i) do
		local texture = UnitBuff(unit, i)
		if string.find(texture, textureName) then
			return true
		end
		i = i + 1
	end
	return false
end

-- boolean if has buff
function BC.HasDebuff(unit, textureName)
	local i = 1
	while UnitDebuff(unit, i) do
		local texture, applications = UnitDebuff(unit, i)
		if string.find(texture, textureName) then
			return applications
		end
		i = i + 1
	end
	return 0
end

-- return index of buff by name.
function BC.BuffIndexByName(buffName)
	local i = 0
	while GetPlayerBuff(i) >= 0 do
		BC_Buff_Tooltip:SetPlayerBuff(i)
		local name = BC_Buff_TooltipTextLeft1:GetText()
		if buffName == name then
			return i
		end
		i = i + 1
	end
	return nil
end

-- remove buff by name.
function BC.RemoveBuffByName(buffName)
	local i = BC.BuffIndexByName(buffName)
	if i then
		CancelPlayerBuff(i)
		return true
	end
	return false
end