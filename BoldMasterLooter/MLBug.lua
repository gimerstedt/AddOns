function MasterLootBug()
	if not UnitInRaid("target") and UnitName("target") ~= nil then
		return
	end
	if BMLB.groupSet == true then
		if BMLB.kicked == false and UnitName("target") ~= nil then -- no group set, have target -> set group, kick and move.
			BMLB.kicked = true
			local s = "Kicking "
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				else
					if subgroup == BMLB.group and name ~= UnitName("target") then
						table.insert(BMLB.victims, name)
						s = s..name..", "
						UninviteByName(name)
					end
					if name == UnitName("target") then
						table.insert(BMLB.winners, {name, subgroup})
					end
				end
			end
			s = string.sub(s,1,-3).." to avoid ML bug, re-invites will come after loot is done."
			if table.getn(BMLB.victims) > 0 then
				BC.y(s, BMLB.prep)
			end
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				elseif name == BMLB.winners[1][1] then
					SetRaidSubgroup(i, BMLB.group)
				end
			end
		elseif BMLB.kicked == true and UnitName("target") ~= nil then -- group set, has target -> move back and move in target.
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				elseif name == UnitName("target") then
					SetRaidSubgroup(i, BMLB.group)
					if name ~= BMLB.winners[1][1] then
						table.insert(BMLB.winners, {name, subgroup})
					else
						table.insert(BMLB.winners, {name, BMLB.winners[1][2]})
					end
				elseif name == BMLB.winners[1][1] then
					SetRaidSubgroup(i, BMLB.winners[1][2])
				end
			end
			BMLB.winners[1] = BMLB.winners[2]
			table.remove(BMLB.winners, 2)
		elseif UnitName("target") == nil then -- group set, no target -> move back, re-invite, reset vars.
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				else
					if table.getn(BMLB.winners) > 0 and name == BMLB.winners[1][1] then
						SetRaidSubgroup(i, BMLB.winners[1][2])
					end
				end
			end
			for i=1, table.getn(BMLB.victims), 1 do
				InviteByName(BMLB.victims[i])
			end
			BMLB.victims = {}
			BMLB.winners = {}
			BMLB.groupSet = false
			BMLB.kicked = false
			BMLB.group = 0
			BC.m("ML session ended.", BMLB.prep)
		else
			BC.m(BMLB.help1, BMLB.prep)
			BC.c(BMLB.help2, BMLB.prep)
			BC.m(BMLB.help3, BMLB.prep)
			BC.c(BMLB.help4, BMLB.prep)
		end
	else
		local checkGroups = {0,0,0,0,0,0,0,0}
		for i=1, MAX_RAID_MEMBERS, 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
			if name == nil then
				break
			elseif name == UnitName("target") then
				BMLB.group = subgroup
				BMLB.groupSet = true
			end
			checkGroups[subgroup] = checkGroups[subgroup] + 1
		end
		for i=1, 8, 1 do
			if checkGroups[i] == 0 then
				BMLB.group = i
				BMLB.groupSet = true
			end
		end
		if BMLB.groupSet then
			BC.m("ML session started, group "..BMLB.group.." chosen.", BMLB.prep)
		end
	end
end