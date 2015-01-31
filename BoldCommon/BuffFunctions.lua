-- pretty sure this one isn't working, need to test
function ReportMissingDebuffsOnTarget()
	if not UnitInRaid("player") or not isEnemy("target") then
		BC.m("You are either in not in a raid or your target is not an enemy or you do not have a target.", BC_PREP)
		return
	end
	if not UnitDebuff("target", 1) then
		BC.r(UnitName("target").." has no debuffs!", BC_PREP)
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

	BC.r(out, BC_PREP)
end

function ReportBuffsOnTarget()
	if not UnitExists("target") then
		u = "player"
	else
		u = "target"
	end
	if UnitName(u) then
		if not UnitBuff(u, 1) then
			BC.m("Target has no visible buffs.", BC_PREP)
			return
		end
		local counter = 1
		while (UnitBuff(u, counter)) do
			ZORLEN_Buff_Tooltip:SetUnitBuff(u, counter)
			local name = ZORLEN_Buff_TooltipTextLeft1:GetText()
			BC.m(counter..": "..name, BC_PREP)
			BC.m(counter..": ("..UnitBuff(u, counter)..")", BC_PREP)
			counter = counter + 1
		end
	end
end