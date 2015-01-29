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
function BLW_HasBuff(textureName)
	local i = 1
	local hasBuff = false;
	while UnitBuff("player", i) do
		local texture = UnitBuff("player", i)
		if string.find(texture, textureName) then
			hasBuff = true
		end
		i = i + 1
	end
	return hasBuff
end

-- return time since last BT
function BLW_TimeSinceBT()
	return GetTime() - BLW.lastBT
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
