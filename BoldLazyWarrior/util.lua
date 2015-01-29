-- enable auto attack
function BLW_EnableAttack()
	if not BLW_AttackAction then
		for i = 1, 120 do
			if IsAttackAction(i) then
				BLW_AttackAction = i
			end
		end
	end
	if BLW_AttackAction then
		if not IsCurrentAction(BLW_AttackAction)
			then UseAction(BLW_AttackAction)
		end
	else
		BC.m("You need to put your attack ability on one of your action bars!")
	end
end

-- hp of target in percent
function BLW_HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

-- boolean if has buff
function BLW_HasBuff(unit, textureName)
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
function BLW_HasDebuff(unit, textureName)
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

-- 	local i = 1
-- 	local hasDebuff = false;
-- 	while UnitDebuff(unit, i) do
-- 		local texture = UnitDebuff(unit, i)
-- 		if string.find(texture, textureName) then
-- 			hasDebuff = true
-- 		end
-- 		i = i + 1
-- 	end
-- 	return hasDebuff
-- /run local a, b = UnitDebuff("player", 1) BC.m("a: "..a.."b: "..b)
-- function Zorlen_GetDebuffStack(debuff, unit, dispelable, SpellName, SpellToolTipLineTwo)
-- 	local u = unit or "target"
-- 	local index = Zorlen_GiveDebuffIndex(debuff, u, dispelable, SpellName, SpellToolTipLineTwo)
-- 	if index then
-- 		local texture, applications = UnitDebuff(u, index)
-- 		return applications
-- 	end
-- 	return 0
-- end
-- end

-- return time since last BT
function BLW_TimeSinceBT()
	return GetTime() - BLW.lastBT
end

-- return time since last BT
function BLW_TimeSinceSS()
	return GetTime() - BLW.lastSS
end

-- is BT on CD?
function BLW_OnCD(spellId)
	if GetSpellCooldown(spellId, "spell") == 0 then
		return false
	end
	return true
end

-- get spell id from spell book
function BLW_GetSpellId(SpellName, SpellRank)
	local B = "spell"
	local SpellID = nil
	if SpellName then
		local SpellCount = 0
		local ReturnName = nil
		local ReturnRank = nil
		while SpellName ~= ReturnName do
			SpellCount = SpellCount + 1
			ReturnName, ReturnRank = GetSpellName(SpellCount, B)
			if not ReturnName then
				break
			end
		end
		while SpellName == ReturnName do
			if SpellRank then
				if SpellRank == 0 then
					return SpellCount
				elseif ReturnRank and ReturnRank ~= "" then
					local found, _, Rank = string.find(ReturnRank, "(%d+)")
					if found then
						ReturnRank = tonumber(Rank)
					else
						ReturnRank = 1
					end
				else
					ReturnRank = 1
				end
				if SpellRank == ReturnRank then
					return SpellCount
				end
			else
				SpellID = SpellCount
			end
			SpellCount = SpellCount + 1
			ReturnName, ReturnRank = GetSpellName(SpellCount, B)
		end
	end
	return SpellID
end

-- get bools for stances
function BLW_GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end