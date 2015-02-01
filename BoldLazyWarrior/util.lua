BLW = {}

-- hp of target in percent
function BLW.HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

-- return time since last BT
function BLW.TimeSinceBT()
	return GetTime() - BLW.lastBT
end

-- return time since last BT
function BLW.TimeSinceSS()
	return GetTime() - BLW.lastSS
end

-- return time since last SS or BT
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

-- cast battle shout
function BLW.BattleShout(hp)
	if hp == nil then
		hp = 80
	end
	if BLW.HP() < hp and not BC.HasBuff("player", "BattleShout") then
		CastSpellByName("Battle Shout")
	end
end

-- gcd
-- function BLW.GCD(slot)
	-- if GetActionCooldown(slot) > 0 then
	-- 	BC.m("cd over 0")
	-- else
	-- 	BC.m("cd under 0")
	-- end
-- end

-- parse log for spells cast by target
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

-- /run a, b, c = string.find("You attack. Black Dragonspawn dodges.", "You attack%. (.+) dodges%.") BC.m(c)
-- /run a, b, c = string.find("Your Hamstring was dodged by Firegut Ogre Mage.", "Your .+ was dodged by (.+)%.") BC.m(c)
-- /run if string.find("You attack. Black Dragonspawn dodges.", "You attack%. .+ dodges%.") then BC.m(s) end

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

-- get bools for stances
function BLW.GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end