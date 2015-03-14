BLR = {}
if UnitClass("player") ~= "Rogue" then return end

BLR.debug = false
BLR.prep = "[BLR] "

function BLR.OnLoad()
	if UnitClass("player") ~= "Rogue" then return end
	-- for target casting.
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
	-- for Overpower.
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
	-- for loading vars.
	this:RegisterEvent("PLAYER_LOGIN")
	-- misc.
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
	-- for Revenge.
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES")
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
end

function BLR.OnEvent()
	if event == "PLAYER_LOGIN" then
		BLR.InitVariables()
	elseif (event == "CHAT_MSG_COMBAT_SELF_MISSES" and string.find(arg1, BLR_OVERPOWER1)) then
		BLR.targetDodged = GetTime()
	elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" and (string.find(arg1, BLR_OVERPOWER3) or string.find(arg1, BLR_OVERPOWER4) or string.find(arg1, BLR_OVERPOWER5))) then
		BLR.targetDodged = nil
	elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF") then
		for mob, spell in string.gfind(arg1, BLR_CAST) do
			if (mob == UnitName("target") and UnitCanAttack("player", "target") and mob ~= spell) then
				BLR.targetCasting = GetTime()
			end
			return
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		BLR.targetDodged = nil
		BLR.targetCasting = nil
	end
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES" or event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
		BLR.CheckDodgeParryBlockResist(arg1)
	end
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1, BLR_OVERPOWER2) then
			BLR.targetDodged = GetTime()
		elseif string.find(arg1, BLR_INTERRUPT1) or string.find(arg1, BLR_INTERRUPT2) or string.find(arg1, BLR_INTERRUPT3) or string.find(arg1, BLR_INTERRUPT4) or string.find(arg1, BLR_INTERRUPT5) then
			BLR.targetCasting = nil
		elseif string.find(arg1, BLR_REVENGE1) or string.find(arg1, BLR_REVENGE2) or string.find(arg1, BLR_REVENGE3) then
			BLR.revengeTimer = nil
		end
		if string.find(arg1, BLR_REVENGE4) then
			BLR.revengeTimer = nil
		end
	end

end

SLASH_BLR_CMD1 = '/blr'
function SlashCmdList.BLR_CMD(cmd)
	if cmd == "combatswords" or cmd == "cs" then
		BLR.CombatSwords()
	elseif cmd == "lvl" then
		BLR.Lvl()
	elseif cmd == "mm" then
		BLR.MakeMacros()
	else
		BC.my("~~~~~ BoldLazyRogue ~~~~~", BLR.prep)
		BC.mb("/blr cs", BLR.prep)
		BC.m("A combat swords rotation.", BLR.prep)
		BC.mb("/blr lvl", BLR.prep)
		BC.m("A leveling rotation.", BLR.prep)
		BC.mb("/blr mm", BLR.prep)
		BC.m("Make macros for the rotations.", BLR.prep)
	end
end

function BLR.InitVariables()
	BLR.lastStanceChange = 0
	BLR.targetCasting = 0
	BLR.targetDodged = 0

	BLR.lastAbility = 0
	BLR.lastMainAbility = 0

	BINDING_HEADER_BLR = "BoldLazyRogue"
	BINDING_NAME_BLR_COMBAT_SWORDS = "Combat Swords rotation"
	BINDING_NAME_BLR_LVL = "Leveling rotation"

	BLR_CAST = "(.+) begins to cast (.+)."
	BLR_OVERPOWER1 = "You attack.(.+) dodges."
	BLR_OVERPOWER2 = "Your (.+) was dodged by (.+)."
	BLR_OVERPOWER3 = "Your Overpower crits (.+) for (%d+)."
	BLR_OVERPOWER4 = "Your Overpower hits (.+) for (%d+)."
	BLR_OVERPOWER5 = "Your Overpower missed (.+)."
	BLR_INTERRUPT1 = "You interrupt (.+)."
	BLR_INTERRUPT2 = "Your Pummel was (.+) by (.+)."
	BLR_INTERRUPT3 = "Your Shield Bash was (.+) by (.+)."
	BLR_INTERRUPT4 = "Your Pummel missed (.+)."
	BLR_INTERRUPT5 = "Your Shield Bash missed (.+)."

	BLR_REVENGE1 = "Your Revenge crits (.+) for (%d+)."
	BLR_REVENGE2 = "Your Revenge hits (.+) for (%d+)."
	BLR_REVENGE3 = "Your Revenge missed (.+)."
	BLR_REVENGE4 = "Your Revenge was dodged by (.+)."
end

function BLR.CombatSwords()
	if not BLR.TargetAndAttack() then return end
end

function BLR.Lvl()
	if BLR.Stealth() then
		CastSpellByName("Cheap Shot")
		return
	end
	BLR.TargetAndAttack()
	CastSpellByName("Riposte")
	if BLR.CP() == 5 then
		CastSpellByName("Eviscerate")
	end
	CastSpellByName("Sinister Strike")
end
