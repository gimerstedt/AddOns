BP = {}

BP.prep = "[BoldPaladin] "

function BP.OnLoad()
	if UnitClass("player") ~= "Paladin" then return end
	BoldPaladinFrame:RegisterEvent("PLAYER_AURAS_CHANGED")

	SlashCmdList["BPHELP"] = BP.Help
	SLASH_BPHELP1 = "/bp"
	SlashCmdList["SAFEBOP"] = BP.Safebop
	SLASH_SAFEBOP1 = "/safebop"
	SlashCmdList["T1"] = BP.T1
	SLASH_T11 = "/t1"
end

if UnitClass("player") ~= "Paladin" then return end

function BP.OnEvent()
	BP.NotifyIfAuraMissing()
end

function BP.Help()
	BC.my("BoldPaladin is a collection of useful commands for paladins.", BP.prep)
	BC.m("Passive: Notifies you if no aura is active.", BP.prep)
	BC.mb("/safebop", BP.prep)
	BC.m("Casts Blessing of Protection on your target if your target is NOT a warrior and targetTarget if target is hostile and targetTarget is not a warrior.", BP.prep)
	BC.mb("/t1", BP.prep)
	BC.m("Targets, attacks and keeps SotC up.", BP.prep)
end

function BP.Safebop()
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
function BP.T1()
	if not UnitExists("target") then TargetNearestEnemy() end
	BC.EnableAttack()
	if UnitExists("target") and not BC.HasBuff("player", "Holy_HolySmite") then
		CastSpellByName("Seal of the Crusader")
	end
end

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

function BP.NotifyIfAuraMissing()
	if not BP.IsAuraActive() then
		BC.m("No aura active!", BP.prep)
	end
end