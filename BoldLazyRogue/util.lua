BLR.doNotTarget = {
	"Qiraji Scorpion",
	"Qiraji Scarab",
}

-- function BC.MakeMacro(name, macro, perCharacter, macroIconTexture, iconIndex, replace, show, noCreate, replaceMacroIndex, replaceMacroName)
function BLR.MakeMacros()
	BC.MakeMacro("Combat Swords", "/blr cs", 0, "Ability_Warrior_DefensiveStance", nil, 1, 1)
	BC.MakeMacro("Level", "/blr lvl", 0, "Spell_Nature_BloodLust", nil, 1, 1)
	-- BC.MakeMacro("DPS2", "/blw dps2", 0, "Ability_Warrior_OffensiveStance", nil, 1, 1)
	-- BC.MakeMacro("NF", "/blw nf", 0, "Spell_Holy_ElunesGrace", nil, 1, 1)
	-- BC.MakeMacro("AoE", "/blw aoe", 0, "Ability_Creature_Cursed_04", nil, 1, 1)
end

function BLR.HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

function BLR.Energy()
	return UnitMana("player")
end

function BLR.SpellOnCD(spellName)
	local id = BC.GetSpellId(spellName)
	if id then
		local start, duration = GetSpellCooldown(id, 0)
		if start == 0 and duration == 0 then
			return nil
		end
	end
	return true
end

function BLR.TargetAndAttack()
	if UnitExists("target") then
		BC.EnableAttack()
		return true
	end
	TargetNearestEnemy()
	local counter = 0
	while counter < 10 and BLR.UnwantedTarget() do
		TargetNearestEnemy()
		counter = counter + 1
	end
	if BLR.UnwantedTarget() then
		ClearTarget()
		return false
	else
		BC.EnableAttack()
		return true
	end
end

function BLR.CheckDodgeParryBlockResist(arg1)
	local dodged = ".+ attacks%. You dodge%."
	local dodgedSpell = ".+'s? .+ was dodged%."
	local parried = ".+ attacks%. You parry%."
	local parriedSpell = ".+'s? .+ was parried%."
	local blocked = ".+ attacks%. You block%."
	local blockedSpell = ".+'s? .+ was blocked%."
	local resistedSpell = ".+'s? .+ was resisted%."
	local now = GetTime()

	if string.find(arg1, dodged) or string.find(arg1, dodgedSpell) or string.find(arg1, parried) or string.find(arg1, parriedSpell) or string.find(arg1, blocked) or string.find(arg1, blockedSpell) or string.find(arg1, resistedSpell) then
		BLR.revengeTimer = now
	end
end

function BLR.UnwantedTarget()
	for k,v in pairs(BLR.doNotTarget) do
		if UnitName("target") == v then
			return true
		end
	end
	return false
end

function BLR.Stealth()
	local _,_,stealth,_ = GetShapeshiftFormInfo(1)
	return stealth
end

function BLR.CP()
	return GetComboPoints("player", "target")
end

function BLR.ApplyPoison(name, oh)
	BC.UseItemByName(name)
	if oh then slot = 17 else slot = 16 end
	PickupInventoryItem(slot)
end