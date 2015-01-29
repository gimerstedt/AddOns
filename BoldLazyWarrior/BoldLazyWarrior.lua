-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- vars
BLW = {}
BLW.lastBT = 0
BLW.BTId = BLW_GetSpellId("Bloodthirst", 4)

SLASH_FURY_BATTLE_ROTATION1 = '/fbr'
function SlashCmdList.FURY_BATTLE_ROTATION()
	-- target something if nothing is targeted.
	if not UnitExists("target") then
		TargetNearestEnemy()
	end

	-- attack!
	BLW_EnableAttack()
	-- bools for stances.
	local battle, _, berserk = BLW_GetStances()

	-- keep battle shout up.
	if not BLW_HasBuff("BattleShout") then
		CastSpellByName("Battle Shout")
	end

	-- main if
	if battle then
		if BLW_HP() < 20 then
			if UnitMana("player") > 10 and UnitIsDead("target") ~= 1 then
				CastSpellByName("Berserker Stance")
			else
				CastSpellByName("Execute")
			end
		end
		if UnitMana("player") > 30 and not BLW_OnCD(BLW.BTId) then
			BLW.lastBT = GetTime()
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

-- event handler
-- local function onEvent()
	-- future use
-- end

-- register event and handler
-- local f = CreateFrame("frame")
-- f:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
-- f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
-- f:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
-- --f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
-- f:SetScript("OnEvent", onEvent)
