BLW = {}
if UnitClass("player") ~= "Warrior" then return end

BLW.debug = false
BLW.prep = "[BLW] "
BLW.lastAbility = 0
BLW.lastMainAbility = 0
BLW.lastStanceChange = 0
BLW.targetCasting = 0
BLW.targetDodged = 0

BINDING_HEADER_BLW = "BoldLazyWarrior"
BINDING_NAME_BLW_DPS = "DPS rotation"
BINDING_NAME_BLW_TANK = "Tank rotation"
BINDING_NAME_BLW_NIGHTFALL = "Nightfall Rotation"
BINDING_NAME_BLW_AOE = "Multi-target rotation"

BLW_CAST = "(.+) begins to cast (.+)."
BLW_OVERPOWER1 = "You attack.(.+) dodges."
BLW_OVERPOWER2 = "Your (.+) was dodged by (.+)."
BLW_OVERPOWER3 = "Your Overpower crits (.+) for (%d+)."
BLW_OVERPOWER4 = "Your Overpower hits (.+) for (%d+)."
BLW_OVERPOWER5 = "Your Overpower missed (.+)."
BLW_INTERRUPT1 = "You interrupt (.+)."
BLW_INTERRUPT2 = "Your Pummel was (.+) by (.+)."
BLW_INTERRUPT3 = "Your Shield Bash was (.+) by (.+)."
BLW_INTERRUPT4 = "Your Pummel missed (.+)."
BLW_INTERRUPT5 = "Your Shield Bash missed (.+)."

function BLW.OnLoad()
	if UnitClass("player") ~= "Warrior" then return end
	-- for target casting.
	BLWFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	BLWFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	BLWFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
	BLWFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
	-- for overpower.
	BLWFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	BLWFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
	-- for loading vars
	BLWFrame:RegisterEvent("PLAYER_LOGIN")
	-- misc
	BLWFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function BLW.OnEvent()
	if event == "PLAYER_LOGIN" then
		if BC.GetSpellId("Shield Slam") then
			BLW.prot = true
		else
			BLW.prot = false
		end
		BLW.mainAbility, BLW.mainAbilityCost = "Shield Slam", 20
		if not BLW.prot then 
			BLW.mainAbility, BLW.mainAbilityCost = "Bloodthirst", 30
		end
	elseif (event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLW_OVERPOWER1) or event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, BLW_OVERPOWER2)) then
		BLW.targetDodged = GetTime()
	elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" and (string.find(arg1, BLW_OVERPOWER3) or string.find(arg1, BLW_OVERPOWER4) or string.find(arg1, BLW_OVERPOWER5))) then
		BLW.targetDodged = nil
	elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF") then
		for mob, spell in string.gfind(arg1, BLW_CAST) do
			if (mob == UnitName("target") and UnitCanAttack("player", "target") and mob ~= spell) then
				BLW.targetCasting = GetTime()
			end
			return
		end
	elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, BLW_INTERRUPT1) or event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLW_INTERRUPT2) or event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLW_INTERRUPT3) or event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLW_INTERRUPT4) or event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLW_INTERRUPT5)) then
		BLW.targetCasting = nil
	elseif (event == "PLAYER_TARGET_CHANGED") then
		BLW.targetDodged = nil
		BLW.targetCasting = nil
	end
end

-- function BC.MakeMacro(name, macro, perCharacter, macroIconTexture, iconIndex, replace, show, noCreate, replaceMacroIndex, replaceMacroName)
function BLW.MakeMacros()
	-- BC.MakeMacro("FuryBattleRotation", "/blw fbr", 0, "Ability_Warrior_OffensiveStance", nil, 1, 1)
	BC.MakeMacro("Tank", "/blw tank", 0, "Ability_Warrior_DefensiveStance", nil, 1, 1)
	BC.MakeMacro("DPS", "/blw dps", 0, "Spell_Nature_BloodLust", nil, 1, 1)
	BC.MakeMacro("NF", "/blw nf", 0, "Spell_Holy_ElunesGrace", nil, 1, 1)
end

SLASH_BLW_ROTATION1 = '/blw'
function SlashCmdList.BLW_ROTATION(rotation)
	if rotation == "dps" then
		BLW.DPS()
	elseif rotation == "tank" then
		BLW.Tank()
	elseif rotation == "nf" then
		BLW.Nightfall()
	elseif rotation == "aoe" then
		BLW.AoE()
	elseif rotation == "mm" then
		BLW.MakeMacros()
	else
		BC.c("/blw dps", BLW.prep)
		BC.m("A dps rotation.", BLW.prep)
		BC.c("/blw tank", BLW.prep)
		BC.m("A tank rotation.", BLW.prep)
		BC.c("/blw nf", BLW.prep)
		BC.m("A Nightfall rotation.", BLW.prep)
		BC.c("/blw aoe", BLW.prep)
		BC.m("A multi-target rotation.", BLW.prep)
	end
end

-- TODO: update it.
function BLW.BattleRotation(battleOnly)
	if not BLW.TargetAndAttack() then return end

	-- bools for stances.
	local battle, _, berserk = BLW.GetStances()
	local rage = UnitMana("player")

	-- keep battle shout up.
	BLW.BattleShout()

	-- main if
	if battle then
		if BLW.HP() < 20 then
			if not battleOnly and rage < 10 and UnitIsDead("target") ~= 1 then
				CastSpellByName("Berserker Stance")
			else
				if battleOnly then
					CastSpellByName("Overpower")
				end
				CastSpellByName("Execute")
			end
		end
		if rage > 30 and not BLW.OnCD(BLW.BTId) then
			BLW.lastBT = GetTime()
			CastSpellByName("Bloodthirst")
		end
		if rage < 30 or BLW.TimeSinceBT() < 5 then
			CastSpellByName("Overpower")
		end
		if rage > 20 and BLW.TimeSinceBT() < 3 then
			CastSpellByName("Heroic Strike")
		end
		if rage > 42 then
			CastSpellByName("Heroic Strike")
			if rage > 52 and BLW.TimeSinceBT() < 5 then
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

function BLW.Tank()
	if not BLW.TargetAndAttack() then return end
	local _, defensive, _ = BLW.GetStances()
	local rage = UnitMana("player")
	BLW.BattleShout(80)

	if defensive then
		if UnitClassification("target") ~= "worldboss" and BLW.targetCasting and BLW.SpellReady("Shield Bash") then
			CastSpellByName("Shield Bash")
			BLW.lastAbility = GetTime()
			if BLW.debug then
				BC.m("Casting Shield Bash at "..BLW.lastAbility, BLW.prep)
			end
		end
		if UnitExists("targettarget") and UnitClass("targettarget") ~= "Warrior" then
			CastSpellByName("Taunt")
			if BLW.debug then
				BC.m("Casting taunt!", BLW.prep)
			end
		end	
		if rage >= 5 and rage < BLW.mainAbilityCost and BLW.SpellReady("Revenge") then
			CastSpellByName("Revenge")
			BLW.lastAbility = GetTime()
			if BLW.debug then
				BC.m("Casting Revenge at "..BLW.lastAbility, BLW.prep)
			end
		end
		if rage >= BLW.mainAbilityCost and BLW.SpellReady(BLW.mainAbility) then
			CastSpellByName(BLW.mainAbility)
			BLW.lastAbility = GetTime()
			BLW.lastMainAbility = BLW.lastAbility
			if BLW.debug then
				BC.m("Casting "..BLW.mainAbility.." at "..BLW.lastMainAbility, BLW.prep)
			end
		end
		if rage >= 5 and BLW.SpellReady("Revenge") then
			CastSpellByName("Revenge")
			BLW.lastAbility = GetTime()
			if BLW.debug then
				BC.m("Casting Revenge at "..BLW.lastAbility, BLW.prep)
			end
		end
		if BC.HasDebuff("target", "Sunder") < 5 and rage > 19 and (GetTime() - BLW.lastMainAbility) < 4.5 and BLW.SpellReady("Sunder Armor") then
			CastSpellByName("Sunder Armor")
			BLW.lastAbility = GetTime()
			if BLW.debug then
				BC.m("Casting Sunder Armor at "..BLW.lastAbility, BLW.prep)
			end
		end
		if UnitIsUnit("player", "targettarget") and rage > (BLW.mainAbilityCost + 15) and UnitAffectingCombat("player") and BLW.SpellReady("Shield Block") and CheckInteractDistance("target", 3) and not BC.BuffIndexByName("Shield Block") then
			CastSpellByName("Shield Block")
			if BLW.debug then
				BC.m("Casting Shield Block.", BLW.prep)
			end
		end
		if rage > (BLW.mainAbilityCost + 15) then
			CastSpellByName("Heroic Strike")
			if BLW.debug then
				BC.m("Casting Heroic Strike.", BLW.prep)
			end
		end
		if rage > 60 and (GetTime() - BLW.lastMainAbility) < 4.5 and BLW.SpellReady("Sunder Armor") then
			CastSpellByName("Sunder Armor")
			BLW.lastAbility = GetTime()
			if BLW.debug then
				BC.m("Casting Sunder Armor at "..BLW.lastAbility, BLW.prep)
			end
		end
	else
		CastSpellByName("Defensive Stance")
	end
end

function BLW.Nightfall()
	if not BLW.TargetAndAttack() then return end
	local battle, _, _ = BLW.GetStances()
	BLW.BattleShout()

	if battle then
		if BC.HasDebuff("target", "Sunder") < 5 then
			CastSpellByName("Sunder Armor")
		end
		CastSpellByName("Overpower")
		CastSpellByName("Hamstring")
	else
		CastSpellByName("Battle Stance")
	end
end

function BLW.DPS()
	if BLW.prot then
		BLW.ProtDPSRotation()
	else
		BLW.FuryDPSRotation()
	end
end

function BLW.ProtDPSRotation(prioHamstring)
	if not BLW.TargetAndAttack() then return end
	local battle, _, berserk = BLW.GetStances()
	local rage = UnitMana("player")
	BLW.BattleShout()

	if battle then
		if BLW.HP() <= 20 and not UnitIsDead("target") then
			if rage < 15 then
				CastSpellByName("Berserker Stance")
				BLW.lastStanceChange = GetTime()
			else
				if BLW.SpellReady("Execute") then
					CastSpellByName("Execute")
					BLW.lastAbility = GetTime()
				end
			end
		end
		if BLW.SpellReady("Overpower") and BLW.targetDodged then
			CastSpellByName("Overpower")
			BLW.lastAbility = GetTime()
		else
			CastSpellByName("Berserker Stance")
			BLW.lastStanceChange = GetTime()
		end
	elseif berserk then
		-- TODO: not sure it's working all that well.
		if UnitClassification("target") ~= "worldboss" and BLW.targetCasting then
			CastSpellByName("Pummel")
		end
		if BLW.HP() <= 20 then
			CastSpellByName("Execute")
		end
		CastSpellByName("Whirlwind")
		if BLW.targetDodged and (GetTime() - BLW.targetDodged) > 4 then
			BLW.targetDodged = nil
		end
		if (not BLW.SpellReady("Whirlwind") or rage < 25) and BLW.targetDodged and BLW.SpellReady("Overpower") then
			CastSpellByName("Battle Stance")
			BLW.lastStanceChange = GetTime()
		end
		local hamstringRage, HSRage = 52, 42
		if prioHamstring then
			hamstringRage, HSRage = 42, 52
		end
		if rage > hamstringRage then
			CastSpellByName("Hamstring")
		end
		if rage > HSRage then
			CastSpellByName("Heroic Strike")
		end
	else
		CastSpellByName("Berserker Stance")
		BLW.lastStanceChange = GetTime()
	end
end

function BLW.FuryDPSRotation(prioHamstring)
	if not BLW.TargetAndAttack() then return end
	local battle, _, berserk = BLW.GetStances()
	local rage = UnitMana("player")
	BLW.BattleShout()

	if battle then
		if BLW.HP() <= 20 and not UnitIsDead("target") then
			if rage < 10 then
				CastSpellByName("Berserker Stance")
				BLW.lastStanceChange = GetTime()
			else
				if BLW.SpellReady("Execute") then
					CastSpellByName("Execute")
					BLW.lastAbility = GetTime()
				end
			end
		end
		if BLW.SpellReady("Overpower") and BLW.targetDodged then
			CastSpellByName("Overpower")
			BLW.lastAbility = GetTime()
		else
			CastSpellByName("Berserker Stance")
			BLW.lastStanceChange = GetTime()
		end
	elseif berserk then
		-- TODO: not sure it's working all that well.
		if UnitClassification("target") ~= "worldboss" and BLW.targetCasting and BLW.SpellReady("Pummel") then
			CastSpellByName("Pummel")
			BLW.lastAbility = GetTime()
		end
		if BLW.HP() <= 20 and BLW.SpellReady("Execute") then
			CastSpellByName("Execute")
			BLW.lastAbility = GetTime()
		end
		if rage > 29 and SpellReady("Bloodthirst") then
			CastSpellByName("Bloodthirst")
			BLW.lastAbility = GetTime()
			BLW.lastMainAbility = BLW.lastAbility
		end
		if BLW.SpellReady("Whirlwind") and CheckInteractDistance("target", 3) then
			if rage > 29 and (GetTime() - BLW.lastMainAbility) < 2 then
				CastSpellByName("Whirlwind")
				BLW.lastAbility = GetTime()
			end
			if rage > 39 and (GetTime() - BLW.lastMainAbility) < 3 then
				CastSpellByName("Whirlwind")
				BLW.lastAbility = GetTime()
			end
			if rage > 54 and (GetTime() - BLW.lastMainAbility) < 4 then
				CastSpellByName("Whirlwind")
				BLW.lastAbility = GetTime()
			end
		end
		if BLW.targetDodged then
			if (GetTime() - BLW.targetDodged) < 4 then
				if not BLW.SpellReady("Bloodthirst") or rage <= 25 then
					if not BLW.SpellReady("Whirlwind") or rage <= 25 then
						if BLW.debug then
							BC.m("OP not on cd, casting battle stance!", BLW.prep)
						end
						CastSpellByName("Battle Stance")
						BLW.lastStanceChange = GetTime()
					end
				end
			else
				BLW.targetDodged = nil
			end
		end

		rage = UnitMana("player")
		if rage > 55 then
			if BC.BuffIndexByName("Flurry") then
				CastSpellByName("Heroic Strike")
			else
				if (GetTime() - BLW.lastMainAbility) < 4 and BLW.SpellReady("Hamstring") then
					CastSpellByName("Hamstring")
				end
			end
		end
	else
		CastSpellByName("Berserker Stance")
	end
end

function BLW.AoE()
	if not BLW.TargetAndAttack() then return end
	local _, _, berserk = BLW.GetStances()
	local rage = UnitMana("player")
	BLW.BattleShout()

	if berserk then
		if CheckInteractDistance("target", 3) then
			CastSpellByName("Whirlwind")
		end
		if rage > 45 then
			CastSpellByName("Cleave")
		end
	else
		CastSpellByName("Berserker Stance")
	end
end