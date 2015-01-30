-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- vars
BLW.prep = "[BLW] "
BLW.lastBT = 0
BLW.lastSS = 0
BLW.lastSSBT = 0
BLW.BTId = BLW.GetSpellId("Bloodthirst", 4)
BLW.SSId = BLW.GetSpellId("Shield Slam", 4)
BLW.targetCastedAt = 0
BLW.targetDodgedAt = 0

SLASH_BLW_ROTATION1 = '/blw'
function SlashCmdList.BLW_ROTATION(rotation)
	if rotation == "fbr" then
		BLW.BattleRotation(false)
	elseif rotation == "fbro" then
		BLW.BattleRotation(true)
	elseif rotation == "pt" then
		BLW.DefaultTankRotation("prot")
	elseif rotation == "ft" then
		BLW.DefaultTankRotation("fury")
	elseif rotation == "nf" then
		BLW.NightfallRotation()
	else
		BC.m("BoldLazyWarrior", BLW.prep)
		BC.m("/blw fbr", BLW.prep, 1, 1, 0.3)
		BC.m("A fury rotation in battle stance.", BLW.prep)
		BC.m("/blw fbro", BLW.prep, 1, 1, 0.3)
		BC.m("A fury rotation in battle stance only.", BLW.prep)
		BC.m("/blw pt", BLW.prep, 1, 1, 0.3)
		BC.m("A protection tanking rotation.", BLW.prep)
		BC.m("/blw ft", BLW.prep, 1, 1, 0.3)
		BC.m("A fury tanking rotation.", BLW.prep)
		BC.m("/blw nf", BLW.prep, 1, 1, 0.3)
		BC.m("A Nightfall rotation.", BLW.prep)
	end
end

-- TODO: test bool arg
function BLW.BattleRotation(battleOnly)
	-- target something if nothing is targeted.
	if not UnitExists("target") then
		TargetNearestEnemy()
	end

	-- attack!
	BLW.EnableAttack()
	-- bools for stances.
	local battle, _, berserk = BLW.GetStances()

	-- keep battle shout up.
	BLW.BattleShout()

	-- main if
	if battle then
		if BLW.HP() < 20 then
			if not battleOnly and UnitMana("player") > 10 and UnitIsDead("target") ~= 1 then
				CastSpellByName("Berserker Stance")
			else
				if battleOnly then
					CastSpellByName("Overpower")
				end
				CastSpellByName("Execute")
			end
		end
		if UnitMana("player") > 30 and not BLW.OnCD(BLW.BTId) then
			BLW.lastBT = GetTime()
			CastSpellByName("Bloodthirst")
		end
		if UnitMana("player") < 30 or BLW.TimeSinceBT() < 5 then
			CastSpellByName("Overpower")
		end
		if UnitMana("player") > 20 and BLW.TimeSinceBT() < 3 then
			CastSpellByName("Heroic Strike")
		end
		if UnitMana("player") > 42 then
			CastSpellByName("Heroic Strike")
			if UnitMana("player") > 52 and BLW.TimeSinceBT() < 5 then
				CastSpellByName("Hamstring")
			end
		end
	elseif berserk then
		if BLW.HP() < 20 then
			CastSpellByName("Execute")
		else
			CastSpellByName("Battle Stance")
		end
	else
		CastSpellByName("Battle Stance")
	end
end

-- TODO: test with fury spec
function BLW.DefaultTankRotation(spec)
	local timeSinceSSBT = 0
	if spec == "fury" then
		timeSinceSSBT = BLW.TimeSinceBT()
		SSBTCost = 30
		SSBTId = BLW.BTId
		SSBT = "Bloodthirst"
	else
		timeSinceSSBT = BLW.TimeSinceSS()
		SSBTCost = 20
		SSBTId = BLW.SSId
		SSBT = "Shield Slam"
		BC.m(SSBTId.." "..BLW.SSId)
	end

	-- target something if nothing is targeted.
	if not UnitExists("target") then
		TargetNearestEnemy()
	end

	-- attack!
	BLW.EnableAttack()
	-- bools for stances.
	local _, defensive, _ = BLW.GetStances()

	-- keep battle shout up.
	BLW.BattleShout()

	if defensive then
		-- pop trinkets if target is boss and targeting you and you are in combat and in range of boss and SS/BT is not on CD.
		if UnitClassification("target") == "worldboss" and UnitIsUnit("player", "targettarget") and UnitAffectingCombat("player") and CheckInteractDistance("target", 3) and timeSinceSSBT > 6 then
			UseInventoryItem(13)
			UseInventoryItem(14)
		end
		-- TODO: not sure it's working all that well.
		if UnitClassification("target") ~= "worldboss" and (GetTime() - BLW.targetCastedAt) < 3 then
			CastSpellByName("Shield Bash")
		end
		-- taunt if target is targeting something and it's not a warrior.
		if UnitExists("targettarget") and UnitClass("targettarget") ~= "Warrior" then
			CastSpellByName("Taunt")
		end
		-- revenge if you can't afford SS or BT or if SS or BT is on CD
		if UnitMana("player") < SSBTCost or timeSinceSSBT < 5 then
			CastSpellByName("Revenge")
		end
		-- SS or BT if not on CD and has the rage, set time.
		if UnitMana("player") > SSBTCost and not BLW.OnCD(SSBTId) then
			BLW.lastSSBT = GetTime()
			CastSpellByName(SSBT)
		end
		-- sunder if not fully sundered and not interrupting SS or BT CD, leaving enough rage for revenge.
		if BLW.HasDebuff("target", "Sunder") < 5 and UnitMana("player") > 19 and timeSinceSSBT < 4.5 then
			CastSpellByName("Sunder Armor")
		end
		-- targeting self, has rage, in combat, in ~melee range, no sb up.
		if UnitIsUnit("player", "targettarget") and UnitMana("player") > (SSBTCost + 15) and UnitAffectingCombat("player") and CheckInteractDistance("target", 3) and not BLW.HasBuff("player", "Ability_Defend") then
			CastSpellByName("Shield Block")
		end
		-- hs leaving enough rage to SS or BT.
		if UnitMana("player") > (SSBTCost + 15) then
			CastSpellByName("Heroic Strike")
		end
		-- sunder if over 60 rage, making sure not to delay SS/BT cd.
		if UnitMana("player") > 60 and timeSinceSSBT < 4.5 then
			CastSpellByName("Sunder Armor")
		end
	else
		CastSpellByName("Defensive Stance")
	end
end

-- nightfall
function BLW.NightfallRotation()
	if not UnitExists("target") then
		TargetNearestEnemy()
	end
	BLW.EnableAttack()
	local battle, _, _ = BLW.GetStances()

	-- keep battle shout up.
	BLW.BattleShout()

	if battle then
		if BLW.HasDebuff("target", "Sunder") < 5 then
			CastSpellByName("Sunder Armor")
		end
		CastSpellByName("Overpower")
		CastSpellByName("Hamstring")
	else
		CastSpellByName("Battle Stance")
	end
end

-- prot DEEEPS
function BLW.ProtDPSRotation()
	if not UnitExists("target") then
		TargetNearestEnemy()
	end
	BLW.EnableAttack()
	local battle, _, berserk = BLW.GetStances()

	-- keep battle shout up.
	BLW.BattleShout()

end

-- event handler.
local function onEvent()
	if (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" or
		event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" or
		event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" or
		event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF") then
		BLW.CheckCasting(arg1)
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" then
		BLW.CheckDodge()
	end
end

-- register event and handler.
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
f:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
f:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
f:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
f:SetScript("OnEvent", onEvent)
