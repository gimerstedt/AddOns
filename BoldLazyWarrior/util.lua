BLW = {}
BLW.doNotTarget = {
	"Qiraji Scorpion",
	"Qiraji Scarab",
}

-- hp of target in percent.
function BLW.HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

-- return time since last BT.
function BLW.TimeSinceBT()
	return GetTime() - BLW.lastBT
end

-- return time since last BT.
function BLW.TimeSinceSS()
	return GetTime() - BLW.lastSS
end

-- return time since last SS or BT.
function BLW.TimeSinceSS()
	return GetTime() - BLW.lastSSBT
end

-- is BT on CD?
function BLW.OnCD(spellId)
	if GetSpellCooldown(spellId, "spell") == 0 then
		return false
	end
	return true
end

-- target and attack.
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

-- check if the target is in the unwanted list.
function BLW.unwantedTarget()
	for k,v in pairs(BLW.doNotTarget) do
		if UnitName("target") == v then
			return true
		end
	end
	return false
end

-- cast battle shout.
function BLW.BattleShout(hp)
	if hp == nil then
		hp = 80
	end
	if BLW.HP() < hp and not BC.HasBuff("player", "BattleShout") then
		CastSpellByName("Battle Shout")
	end
end

-- parse log for spells cast by target.
function BLW.CheckCasting(arg1)
	local tName = UnitName("target")
	local spellCastOtherStart = "(.+) begins to cast (.+)."
	local spellPerformOtherStart = "(.+) begins to perform (.+)."
	if (tName) then
		for idx, pat in ipairs({ spellCastOtherStart, spellPerformOtherStart }) do
			for mob, spell in string.gfind(arg1, pat) do
				if (mob == tName) then
					if BLW.debug then
						BC.m("Target started casting!")
					end
					BLW.targetCastedAt = GetTime()
				end
			end
		end
	end
end

-- "You attack%. .+ dodges%." 
function BLW.CheckDodge(arg1)
	local tName = UnitName("target")
	local targetDodgedString = "You attack%. (.+) dodges%."
	local targetDodgedString2 = "Your .+ was dodged by (.+)%."
	if (tName) then
		local _,_,dodgeTarget = string.find(arg1, targetDodgedString)
		local _,_,dodgeTarget2 = string.find(arg1, targetDodgedString2)
		if dodgeTarget == tName or dodgeTarget2 == tName then
			if BLW.debug then
				BC.m("Target dodged!")
			end
			BLW.targetDodgedAt = GetTime()
		end
	end
end

-- get bools for stances.
function BLW.GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end