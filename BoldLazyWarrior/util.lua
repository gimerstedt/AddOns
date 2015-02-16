BLW.doNotTarget = {
	"Qiraji Scorpion",
	"Qiraji Scarab",
}

function BLW.HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

function BLW.SpellReady(spellname)
	local id = BC.GetSpellId(spellname)
	if (id) then
		local start, duration = GetSpellCooldown(id, 0)
		if (start == 0 and duration == 0 and BLW.lastAbility + 1 <= GetTime()) then
			return true
		end
	end
	return nil
end

function BLW.TargetAndAttack()
	if UnitExists("target") then
		BC.EnableAttack()
		return true
	end
	TargetNearestEnemy()
	local counter = 0
	while counter < 10 and BLW.unwantedTarget() do
		TargetNearestEnemy()
		counter = counter + 1
	end
	if BLW.unwantedTarget() then
		ClearTarget()
		return false
	else
		BC.EnableAttack()
		return true
	end
end

function BLW.unwantedTarget()
	for k,v in pairs(BLW.doNotTarget) do
		if UnitName("target") == v then
			return true
		end
	end
	return false
end

function BLW.BattleShout(hp)
	if hp == nil then
		hp = 99
	end
	if UnitMana("player") >= 10 and BLW.HP() <= hp and not BC.HasBuff("player", "BattleShout") then
		CastSpellByName("Battle Shout")
	end
end

function BLW.GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end