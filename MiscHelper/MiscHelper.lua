-- misc helper
MH = {}
MH_PREP = "[MiscHelper]"

-- info command
SLASH_MISCHELPER1, SLASH_MISCHELPER2 = '/mischelper', '/mh'
function SlashCmdList.MISCHELPER()	
	MH.m("/ctri", MH_PREP, 1, 1, 0.3)
	MH.m("Generates a run in order and writes it in /p", MH_PREP)
end

-- automatic cthun run in order
SLASH_CTHUNRUNIN1 = '/ctri'
function SlashCmdList.CTHUNRUNIN()
	-- return if you're not targeting the melee
	if UnitInParty("target") == nil then
		MH.m("You must target the melee in your group.", MH_PREP)
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
	MH.p("--------------- (1) "..UnitName(ordered[1]).." ---------------")
	if mod(groupNumber, 2) == 0 then
		MH.p("(3) "..orderedWithNames[3].." ----- (2) "..orderedWithNames[2])
		MH.p("(5) "..orderedWithNames[5].." ----- (4) "..orderedWithNames[4])
	else
		MH.p("(2) "..orderedWithNames[2].." ----- (3) "..orderedWithNames[3])
		MH.p("(4) "..orderedWithNames[4].." ----- (5) "..orderedWithNames[5])
	end
end

function MH.m(msg, prepend, r, g, b)
	prepend = prepend or ""
	r = r or 0.7
	g = g or 0.6
	b = b or 1
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage(tostring(prepend).." "..tostring(msg), r, g, b)		
	end
end

function MH.p(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend).." "..tostring(msg), "PARTY")
	end
end

SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()
	ReloadUI()
end

SLASH_TEST1 = '/test'
function SlashCmdList.TEST()
	MH.m("testar MH.m", "[prepend]", 0.4, 0.2, 0.9)
	MH.p("testar MH.p", "[prepend]")
end