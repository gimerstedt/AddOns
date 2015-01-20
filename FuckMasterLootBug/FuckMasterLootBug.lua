--test
-- On load function
function FMLBOnLoad()
	Victims = {};
	Winners = {};
	GroupSet = false;
	Kicked = false;
	Group = 0;
end

-- On load event
CreateFrame("Frame", "FMLB_ADDON_LOADED");
FMLB_ADDON_LOADED:SetScript("OnEvent", function()
	if (arg1 == "FuckMasterLootBug") then
		FMLB_ADDON_LOADED:UnregisterEvent("ADDON_LOADED");
		FMLBOnLoad();
	end
end);
FMLB_ADDON_LOADED:RegisterEvent("ADDON_LOADED");


-- Slash commands
SlashCmdList["FMLBCOMMANDS"] = function(Flag)
	if UnitInRaid("target") == nil and UnitName("target") ~= nil then
		return;
	end
	if GroupSet == true then
		if Kicked == false and UnitName("target") ~= nil then -- no group set, have target -> set group, kick and move
			Kicked = true;
			local s = "Kicking ";
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if name == nil then
					break;
				else
					if subgroup == Group and name ~= UnitName("target") then
						table.insert(Victims, name);
						s = s..name..", ";
						UninviteByName(name);
					end
					if name == UnitName("target") then
						table.insert(Winners, {name, subgroup});
					end
				end
			end
			s = string.sub(s,1,-3).." to avoid ML bug, re-invites will come after loot is done.";
			if table.getn(Victims) > 0 then
				SendChatMessage(s, "YELL");
			end
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if name == nil then
					break;
				elseif name == Winners[1][1] then
					SetRaidSubgroup(i, Group);
				end
			end
		elseif Kicked == true and UnitName("target") ~= nil then -- group set, has target -> move back and move in target
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if name == nil then
					break;
				elseif name == UnitName("target") then
					SetRaidSubgroup(i, Group);
					if name ~= Winners[1][1] then
						table.insert(Winners, {name, subgroup});
					else
						table.insert(Winners, {name, Winners[1][2]});
					end
				elseif name == Winners[1][1] then
					SetRaidSubgroup(i, Winners[1][2]);
				end
			end
			Winners[1] = Winners[2];
			table.remove(Winners, 2);
		elseif UnitName("target") == nil then -- group set, no target -> move back, re-invite, reset vars
			for i=1, MAX_RAID_MEMBERS, 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if name == nil then
					break;
				else
					if table.getn(Winners) > 0 and name == Winners[1][1] then
						SetRaidSubgroup(i, Winners[1][2]);
					end
				end
			end
			for i=1, table.getn(Victims), 1 do
				InviteByName(Victims[i]);
			end
			FMLBOnLoad();
			Print("ML session ended.");
		else
			Print("Usage:\n1st /meep selects a group (empty group if possible, your target if not).\n2nd /meep kicks the selected group and moves your target into that group.\n3+th /meep moves back old target to original group and moves current target to empty group or moves back to original position and reinvites everyone if you have no target.");
		end
	else
		local checkGroups = {0,0,0,0,0,0,0,0};
		for i=1, MAX_RAID_MEMBERS, 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if name == nil then
				break;
			elseif name == UnitName("target") then
				Group = subgroup;
				GroupSet = true;
			end
			checkGroups[subgroup] = checkGroups[subgroup] + 1;
		end
		for i=1, 8, 1 do
			if checkGroups[i] == 0 then
				Group = i;
				GroupSet = true;
			end
		end
		if GroupSet then
			Print("ML session started, group "..Group.." chosen.");
		end
	end
end

SLASH_FMLBCOMMANDS1 = "/meep";

function Print(String)
	DEFAULT_CHAT_FRAME:AddMessage(String, 1.0, 1.0, 0.0);
end
