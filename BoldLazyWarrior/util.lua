BLW = {}

-- enable auto attack
function BLW.EnableAttack()
	if not BLW.AttackAction then
		for i = 1, 120 do
			if IsAttackAction(i) then
				BLW.AttackAction = i
			end
		end
	end
	if BLW.AttackAction then
		if not IsCurrentAction(BLW.AttackAction)
			then UseAction(BLW.AttackAction)
		end
	else
		BC.m("You need to put your attack ability on one of your action bars!")
	end
end

-- hp of target in percent
function BLW.HP(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

-- boolean if has buff
function BLW.HasBuff(unit, textureName)
	local i = 1
	while UnitBuff(unit, i) do
		local texture = UnitBuff(unit, i)
		if string.find(texture, textureName) then
			return true
		end
		i = i + 1
	end
	return false
end

-- boolean if has buff
function BLW.HasDebuff(unit, textureName)
	local i = 1
	while UnitDebuff(unit, i) do
		local texture, applications = UnitDebuff(unit, i)
		if string.find(texture, textureName) then
			return applications
		end
		i = i + 1
	end
	return 0
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
	if BLW.HP() < hp and not BLW.HasBuff("player", "BattleShout") then
		CastSpellByName("Battle Shout")
	end
end

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

-- get spell id from spell book
function BLW.GetSpellId(SpellName, SpellRank)
	local B = "spell"
	local SpellID = nil
	if SpellName then
		local SpellCount = 0
		local ReturnName = nil
		local ReturnRank = nil
		while SpellName ~= ReturnName do
			SpellCount = SpellCount + 1
			ReturnName, ReturnRank = GetSpellName(SpellCount, B)
			if not ReturnName then
				break
			end
		end
		while SpellName == ReturnName do
			if SpellRank then
				if SpellRank == 0 then
					return SpellCount
				elseif ReturnRank and ReturnRank ~= "" then
					local found, _, Rank = string.find(ReturnRank, "(%d+)")
					if found then
						ReturnRank = tonumber(Rank)
					else
						ReturnRank = 1
					end
				else
					ReturnRank = 1
				end
				if SpellRank == ReturnRank then
					return SpellCount
				end
			else
				SpellID = SpellCount
			end
			SpellCount = SpellCount + 1
			ReturnName, ReturnRank = GetSpellName(SpellCount, B)
		end
	end
	return SpellID
end

-- get bools for stances
function BLW.GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end