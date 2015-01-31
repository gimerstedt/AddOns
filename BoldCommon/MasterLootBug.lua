BC.ML = {}
BC.ML.Victims = {}
BC.ML.Winners = {}
BC.ML.GroupSet = false
BC.ML.Kicked = false
BC.ML.Group = 0

-- kicks n stuff.
function MasterLootBug()
	if not UnitInRaid("target") and UnitName("target") ~= nil then
		return
	end
	if BC.ML.GroupSet == true then
		if BC.ML.Kicked == false and UnitName("target") ~= nil then -- no group set, have target -> set group, kick and move.
			BC.ML.Kicked = true
			local s = "Kicking "
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				else
					if subgroup == BC.ML.Group and name ~= UnitName("target") then
						table.insert(BC.ML.Victims, name)
						s = s..name..", "
						UninviteByName(name)
					end
					if name == UnitName("target") then
						table.insert(BC.ML.Winners, {name, subgroup})
					end
				end
			end
			s = string.sub(s,1,-3).." to avoid ML bug, re-invites will come after loot is done."
			if table.getn(BC.ML.Victims) > 0 then
				BC.y(s, BC.prep)
			end
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				elseif name == BC.ML.Winners[1][1] then
					SetRaidSubgroup(i, BC.ML.Group)
				end
			end
		elseif BC.ML.Kicked == true and UnitName("target") ~= nil then -- group set, has target -> move back and move in target.
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				elseif name == UnitName("target") then
					SetRaidSubgroup(i, BC.ML.Group)
					if name ~= BC.ML.Winners[1][1] then
						table.insert(BC.ML.Winners, {name, subgroup})
					else
						table.insert(BC.ML.Winners, {name, BC.ML.Winners[1][2]})
					end
				elseif name == BC.ML.Winners[1][1] then
					SetRaidSubgroup(i, BC.ML.Winners[1][2])
				end
			end
			BC.ML.Winners[1] = BC.ML.Winners[2]
			table.remove(BC.ML.Winners, 2)
		elseif UnitName("target") == nil then -- group set, no target -> move back, re-invite, reset vars.
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
				if name == nil then
					break
				else
					if table.getn(BC.ML.Winners) > 0 and name == BC.ML.Winners[1][1] then
						SetRaidSubgroup(i, BC.ML.Winners[1][2])
					end
				end
			end
			for i=1, table.getn(BC.ML.Victims), 1 do
				InviteByName(BC.ML.Victims[i])
			end
			BC.ML.Victims = {}
			BC.ML.Winners = {}
			BC.ML.GroupSet = false
			BC.ML.Kicked = false
			BC.ML.Group = 0
			BC.m("ML session ended.", BC.prep)
		else
			BC.m("Usage:\n1st /meep selects a group (empty group if possible, your target if not).\n2nd /meep kicks the selected group and moves your target into that group.\n3+th /meep moves back old target to original group and moves current target to empty group or moves back to original position and reinvites everyone if you have no target.", BC.prep)
		end
	else
		local checkGroups = {0,0,0,0,0,0,0,0}
		for i=1, MAX_RAID_MEMBERS, 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
			if name == nil then
				break
			elseif name == UnitName("target") then
				BC.ML.Group = subgroup
				BC.ML.GroupSet = true
			end
			checkGroups[subgroup] = checkGroups[subgroup] + 1
		end
		for i=1, 8, 1 do
			if checkGroups[i] == 0 then
				BC.ML.Group = i
				BC.ML.GroupSet = true
			end
		end
		if BC.ML.GroupSet then
			BC.m("ML session started, group "..BC.ML.Group.." chosen.", BC.prep)
		end
	end
end