-- only load if paladin.
if UnitClass("player") ~= "Paladin" then return end

-- prepend for chat print.
BP = {}
BP.prep = "[BoldPaladin] "

-- info command.
SLASH_BOLDPALADIN1, SLASH_BOLDPALADIN2 = '/boldpaladin', '/bp'
function SlashCmdList.BOLDPALADIN()	
	BC.m("Notifies you if no aura is active.", BP.prep)
	BC.c("/safebop", BP.prep)
	BC.m("Casts Blessing of Protection on your target if your target is NOT a warrior and targetTarget if target is hostile and targetTarget is not a warrior.", BP.prep)
	BC.c("/t1", BP.prep)
	BC.m("Targets, attacks and keeps SotC up.", BP.prep)
end

-- cast bop on target if target is not warrior or on targettarget if target is hostile and targettarget is not warrior.
SLASH_BOP1 = '/safebop'
function SlashCmdList.BOP(msg)
	if UnitIsFriend("player", "target") and UnitClass("target") ~= "Warrior" and not BC.HasBuff("target", "Holy_DivineIntervention") then
		CastSpellByName("Blessing of Protection")
		return
	end
	if UnitIsEnemy("player", "target") and UnitIsFriend("player", "targettarget") and UnitClass("targettarget") ~= "Warrior" and not BC.HasBuff("targettarget", "Holy_DivineIntervention") then
		TargetUnit("targetTarget")
		CastSpellByName("Blessing of Protection")
		TargetLastTarget()
	end
end

-- rotation for 8/8 t1.
SLASH_T11 = '/t1'
function SlashCmdList.T1(msg)
	TargetNearestEnemy()
	BC.EnableAttack()
	if UnitExists("target") and not BC.HasBuff("player", "Holy_HolySmite") then
		CastSpellByName("Seal of the Crusader")
	end
end

-- check if aura is active.
function BP.IsAuraActive()
	local i, auraActive, auras = 1, false, {"DevotionAura", "Holy_AuraOfLight", "Holy_MindSooth", "Shadow_SealOfKings", "Frost_WizardMark", "Fire_SealOfFire"}
	while UnitBuff("player", i) do
		for k, aura in pairs(auras) do
			if BC.HasBuff("player", aura) then
				return true
			end
		end
		i = i + 1
	end
	return false
end

-- notify if no aura active.
local function notifyIfAuraMissing()
	if not BP.IsAuraActive() then
		BC.m("No aura active!", BP.prep)
	end
end

-- event handler.
local function onEvent()
	if event == "PLAYER_AURAS_CHANGED" then
		notifyIfAuraMissing()
	end
end

-- TODO: change to xml frame with onload/onevent.
-- register event and handler.
local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:SetScript("OnEvent", onEvent)