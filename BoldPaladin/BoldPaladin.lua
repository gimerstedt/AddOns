-- only load if paladin
if UnitClass("player") ~= "Paladin" then return end

-- prepend for chat print
BP_PREP = "[BoldPaladin] "

-- info command
SLASH_BOLDPALADIN1, SLASH_BOLDPALADIN2 = '/boldpaladin', '/bp'
function SlashCmdList.PALADINHELPER()	
	BL.m("Notifies you if no aura is active.", BP_PREP)
	BL.m("/safebop", BP_PREP, 1, 1, 0.3)
	BL.m("Casts Blessing of Protection on your target if your target is NOT a warrior and targetTarget if target is hostile and targetTarget is not a warrior.", BP_PREP)
	BL.m("/t1", BP_PREP, 1, 1, 0.3)
	BL.m("Targets, attacks and keeps SotC up.", BP_PREP)
end

-- cast bop on target if target is not warrior or on targettarget if target is hostile and targettarget is not warrior
SLASH_BOP1 = '/safebop'
function SlashCmdList.BOP(msg)
	if UnitIsFriend("player", "target") and Zorlen_isClass("warrior", "target") ~= true and Zorlen_checkBuffByName("Invulnerability", "target") == false then
		Zorlen_castSpellByName("Blessing of Protection", 3)
	end
	if Zorlen_canAttack("target") then
		if Zorlen_isClass("warrior", "targetTarget") ~= true and Zorlen_checkBuffByName("Invulnerability", "target") == false then
			TargetUnit("targetTarget")
			Zorlen_castSpellByName("Blessing of Protection", 3)
			TargetLastTarget()
		end
	end
end

-- rotation for 8/8 t1
SLASH_T11 = '/t1'
function SlashCmdList.T1(msg)
	Zorlen_TargetFirstEnemy()
	if Zorlen_canAttack("target") then castSealOfTheCrusader() castAttack() end
end

-- notify if no aura active
local function notifyIfAuraMissing()
	if isPaladinAuraActive() ~= true then
		BL.m("No aura active!", BP_PREP)
	end
end

-- event handler
local function onEvent()
	if event == "PLAYER_AURAS_CHANGED" then
		notifyIfAuraMissing()
	end
end

-- register event and handler
local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:SetScript("OnEvent", onEvent)