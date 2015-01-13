-- info command
SLASH_MISCHELPER1 = '/mischelper'
function SlashCmdList.MISCHELPER()	
	sysout("====== MiscHhelper ======", 1, 1, 0.3)
	sysout("Notifies you if no aura is active.")
	sysout("/safebop", 1, 1, 0.3)
	sysout("Casts Blessing of Protection on your target if your target is NOT a warrior and targetTarget if target is hostile and targetTarget is not a warrior.")
	sysout("/t1", 1, 1, 0.3)
	sysout("Targets, attacks and keeps SotC up.")
end

-- automatic cthun run in order
SLASH_CTHUNRUNIN1 = '/cthun'
function SlashCmdList.CTHUNRUNIN()
	-- return if you're not targeting the melee
	if UnitInParty("target") == nil then
		sysout("You must target the melee in your group.")
		return
	end

	-- declaring some variables
	local party = {
		player = UnitClass("player"),
		party1 = UnitClass("party1"),
		party2 = UnitClass("party2"),
		party3 = UnitClass("party3"),
		party4 = UnitClass("party4")
	}
	local orderedWithGaps = {}
	local ordered = {}
	local orderedWithNames = {}

	-- put target first, sort rest according to class
	for k,v in pairs(party) do
		if UnitName(k) == UnitName("target") then
			table.insert(orderedWithGaps, 1, k)
		elseif v == "Priest" then
			table.insert(orderedWithGaps, 10, k)
		elseif v == "Paladin" then
			table.insert(orderedWithGaps, 10, k)
		elseif v == "Shaman" then
			table.insert(orderedWithGaps, 10, k)
		elseif v == "Druid" then
			table.insert(orderedWithGaps, 10, k)

		elseif v == "Mage" then
			table.insert(orderedWithGaps, 20, k)
		elseif v == "Warlock" then
			table.insert(orderedWithGaps, 20, k)

		elseif v == "Hunter" then
			table.insert(orderedWithGaps, 80, k)
		elseif v == "Rogue" then
			table.insert(orderedWithGaps, 90, k)
		elseif v == "Warrior" then
			table.insert(orderedWithGaps, 90, k)
		end
	end

	-- put names into new table, ready for use
	for i=1, table.getn(orderedWithGaps) do
		if orderedWithGaps[i] ~= nil then
			table.insert(ordered, orderedWithGaps[i])
		end
	end

	-- fill empty spots
	for i=1, 5 do
		if ordered[i] ~= nil then
			local name = UnitName(ordered[i])
			table.insert(orderedWithNames, name)
		else
			table.insert(orderedWithNames, "Empty Spot")
		end
	end

	local function getSubGroupNumber()
		if UnitInRaid("player") then
			for i = 1 , GetNumRaidMembers() do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if (name == UnitName("player")) then
					return subgroup
				end
			end
		end
	end
	local groupNumber = getSubGroupNumber()

	-- send to chat
	SendChatMessage("--------------- (1) "..UnitName(ordered[1]).." ---------------", "PARTY")
	if mod(groupNumber, 2) == 0 then
		SendChatMessage("(3) "..orderedWithNames[3].." ----- (2) "..orderedWithNames[2], "PARTY")
		SendChatMessage("(5) "..orderedWithNames[5].." ----- (4) "..orderedWithNames[4], "PARTY")
	else
		SendChatMessage("(2) "..orderedWithNames[2].." ----- (3) "..orderedWithNames[3], "PARTY")
		SendChatMessage("(4) "..orderedWithNames[4].." ----- (5) "..orderedWithNames[5], "PARTY")
	end
end

function sysout(msg, r, g, b)
	r = r or 0.7
	g = g or 0.6
	b = b or 1
	if msg then		
		DEFAULT_CHAT_FRAME:AddMessage("[MiscHelper] " .. tostring(msg), r, g, b)		
	end
end


SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()	
	ReloadUI()
end