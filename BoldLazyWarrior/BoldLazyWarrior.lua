-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- vars
BLW = {}
BLW.lastBT = 0
BLW.lastSS = 0
BLW.BTId = BLW_GetSpellId("Bloodthirst", 4)
BLW.SSId = BLW_GetSpellId("Shield Slam", 4)

SLASH_BLW_ROTATION1 = '/blw'
function SlashCmdList.BLW_ROTATION(rotation)
	if rotation == "fbr" then
		Fury_Battle_Rotation()
	elseif rotation == "pt" then
		Prot_Default_Tank()
	end
end

function Fury_Battle_Rotation()
	-- target something if nothing is targeted.
	if not UnitExists("target") then
		TargetNearestEnemy()
	end

	-- attack!
	BLW_EnableAttack()
	-- bools for stances.
	local battle, _, berserk = BLW_GetStances()

	-- keep battle shout up.
	if not BLW_HasBuff("player", "BattleShout") then
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

function Prot_Default_Tank()
	-- target something if nothing is targeted.
	if not UnitExists("target") then
		TargetNearestEnemy()
	end

	-- attack!
	BLW_EnableAttack()
	-- bools for stances.
	local _, prot, _ = BLW_GetStances()

	-- keep battle shout up.
	if BLW_HP() < 80 and not BLW_HasBuff("player", "BattleShout") then
		CastSpellByName("Battle Shout")
	end

	if prot then
		-- use trinkets
		-- shield bash / concussive blow
		if UnitClass("targettarget") ~= "Warrior" then
			CastSpellByName("Taunt")
		end
		if UnitMana("player") > 20 and not BLW_OnCD(BLW.SSId) then
			BLW.lastSS = GetTime()
			CastSpellByName("Shield Slam")
		end
		if UnitMana("player") <20 or BLW_TimeSinceSS() < 5 then
			CastSpellByName("Revenge")
		end
		if BLW_HasDebuff("target", "Sunder") < 5 and UnitMana("player") > 18 and BLW_TimeSinceSS() < 4.5 then
			CastSpellByName("Sunder Armor")
		end
		-- targeting self, has rage, in combat, in ~melee range, no sb up
		if UnitIsUnit("player", "targettarget") and UnitMana("player") > 35 and UnitAffectingCombat("player") and CheckInteractDistance("target", 3) and not BLW_HasBuff("player", "Ability_Defend") then
			CastSpellByName("Shield Block")
		end
		if UnitMana("player") > 35 then
			CastSpellByName("Heroic Strike")
		end
		if UnitMana("player") > 60 and BLW_TimeSinceSS < 4.5 then
			CastSpellByName("Sunder Armor")
		end
	else
		CastSpellByName("Defensive Stance")
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
