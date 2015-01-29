-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- timers
lastBT = 0

-- event handler
local function onEvent()
	-- future use
end

SLASH_FURY_BATTLE_ROTATION1 = '/fbr'
function SlashCmdList.FURY_BATTLE_ROTATION()
	if not UnitExists("target") then
		return
	end

	-- if not IsCurrentAction(61) then -- TODO need to enable auto attack
	-- 	UseAction(61)
	-- end

	_,_,battle,_ = GetShapeshiftFormInfo(1)
	_,_,berserk, _ = GetShapeshiftFormInfo(3)

	if not BLW_HasBuff("BattleShout") then
		CastSpellByName("Battle Shout")
	end

	if battle then
		if BLW_HP() < 20 then
			if UnitMana("player") > 10 and UnitIsDead("target") ~= 1 then
				CastSpellByName("Berserker Stance")
			else
				CastSpellByName("Execute")
			end
		end
		if UnitMana("player") > 30 and not BLW_BloodthirstCD() then
			lastBT = GetTime()
			CastSpellByName("Bloodthirst")
		end
		if UnitMana("player") < 30 or BLW_TimeSinceBT() < 5 then
			CastSpellByName("Overpower")
		end
		if UnitMana("player") > 20 and BLW_TimeSinceBT() < 3 then
			CastSpellByName("Heroic Strike")
		end
		if UnitMana("player") > 42 then
			CastSpellByName("Heroic Strike")
			if UnitMana("player") > 52 and BLW_TimeSinceBT() < 5 then
				CastSpellByName("Hamstring")
			end
		end
	elseif berserk then
		if BLW_HP() < 20 then
			CastSpellByName("Execute")
		else
			CastSpellByName("Battle Stance")
		end
	else
		CastSpellByName("Battle Stance")
	end
end

function BLW_HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

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

function BLW_TimeSinceBT()
	return GetTime() - lastBT
end

function BLW_BloodthirstCD()
	if GetSpellCooldown(BLW_GetSpellId("Bloodthirst", 1), "spell") == 0 then
		return false
	end
	return true
end

-- register event and handler
-- local f = CreateFrame("frame")
-- f:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
-- f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
-- f:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
-- --f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
-- f:SetScript("OnEvent", onEvent)

-- future use
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