-- only load if not paladin.
if UnitClass("player") == "Paladin" then return end

BNP = {}
BNP.prep = "[BoldNotPaladin] "
PP_PREFIX = "PLPWR"

BNP.Assignments = {}
BNP.Paladins = {}

PP_BlessingID = {}
PP_BlessingID[0] = "Wisdom"
PP_BlessingID[1] = "Might"
PP_BlessingID[2] = "Salvation"
PP_BlessingID[3] = "Light"
PP_BlessingID[4] = "Kings"
PP_BlessingID[5] = "Sanctuary"
PP_ClassID = {}
PP_ClassID[0] = "Warrior"
PP_ClassID[1] = "Rogue"
PP_ClassID[2] = "Priest"
PP_ClassID[3] = "Druid"
PP_ClassID[4] = "Paladin"
PP_ClassID[5] = "Hunter"
PP_ClassID[6] = "Mage"
PP_ClassID[7] = "Warlock"

function BNP.OnLoad()
	this:RegisterEvent("CHAT_MSG_ADDON")

	SlashCmdList["BOLDNOTPALADIN"] = BNP.Help
	SLASH_BOLDNOTPALADIN1, SLASH_BOLDNOTPALADIN2 = "/bnp", "/boldnotpaladin"
	SlashCmdList["PRINTPPSETTINGS"] = BNP.PrintPPSettings
	SLASH_PRINTPPSETTINGS1 = "/pp"
end

function BNP.OnEvent()
	if event=="CHAT_MSG_ADDON" and arg1==PP_PREFIX and (arg3=="PARTY" or arg3=="RAID")  then
		BNP.ParseMessage(arg4, arg2)
	end
end

-- help command.
function BNP.Help()
	BC.c("/pp", BNP.prep)
	BC.m("Lists current Pally Power assignments.", BNP.prep)
	BC.c("/pp u", BNP.prep)
	BC.m("Updates assignment information.", BNP.prep)
end

function BNP.PrintPPSettings(msg)
	if msg == "u" then
		BNP.Refresh("REQ")
		return
	end
	local class, _ = UnitClass("player")
	local class = BNP.GetClassID(class)
	for k,v in pairs(BNP.Assignments) do
		local blessing = PP_BlessingID[v[class]]
		local rank, talent, symbols = 0,0,0
		if BNP.Paladins[k] and BNP.Paladins[k][v[class]] then
			rank = BNP.Paladins[k][v[class]]["rank"]
			talent = BNP.Paladins[k][v[class]]["talent"]
		else
			rank, talent = 0, 0
		end
		if BNP.Paladins[k] and BNP.Paladins[k]["symbols"] then
			symbols = BNP.Paladins[k]["symbols"]
		else
			symbols = 0
		end
		local paladin = k

		local output = ""
		if blessing then
			output = output..blessing
		else
			output = output.."Nothing"
		end
		if v[class] == 0 or v[class] == 1 then
			output = output.." "..rank.."+"..talent
		end
		if paladin then
			output = output..": "..paladin
			if symbols then
				output = output.." ("..symbols..")"
			end
			BC.m(output, BNP.prep)
		end
	end
end

function BNP.Refresh(msg)
	if GetNumRaidMembers() == 0 then
		SendAddonMessage(PP_PREFIX, msg, "PARTY", UnitName("player"))
	else
		SendAddonMessage(PP_PREFIX, msg, "RAID", UnitName("player"))
	end
end

function BNP.GetClassID(class)
	for id, name in PP_ClassID do
		if (name==class) then
			return id
		end
	end
	return -1
end

function BNP.ParseMessage(sender, msg)
	if string.find(msg, "^SELF") then
		BNP.Assignments[sender] = {}
		BNP.Paladins[sender] = {}
		_, _, numbers, assign = string.find(msg, "SELF ([0-9n]*)@?([0-9n]*)")
		for id = 0,5 do
			rank = string.sub(numbers, id*2 + 1, id*2 + 1)
			talent = string.sub(numbers, id*2 + 2, id * 2 + 2)
			if not (rank == "n") then
				BNP.Paladins[sender][id] = { }
				BNP.Paladins[sender][id]["rank"] = rank
				BNP.Paladins[sender][id]["talent"] = talent
			end
		end
		if assign then 
			for id = 0,7 do
				tmp = string.sub(assign, id+1, id+1)
				if (tmp == "n" or tmp == "") then tmp = -1 end
				BNP.Assignments[sender][id] = tmp + 0
			end
		end
	end
	if string.find(msg, "^ASSIGN") then
		_, _, name, class, skill = string.find(msg, "^ASSIGN (.*) (.*) (.*)") 
		if (not(name==sender)) and (not BNP.CheckRaidLeader(sender)) then return false end
		if (not BNP.Assignments[name]) then BNP.Assignments[name] = {} end
		class=class+0
		skill=skill+0
		BNP.Assignments[name][class] = skill
	end
	if string.find(msg, "^MASSIGN") then
		_, _, name, skill = string.find(msg, "^MASSIGN (.*) (.*)") 
		if (not(name==sender)) and (not BNP.CheckRaidLeader(sender)) then return false end
		if (not BNP.Assignments[name]) then BNP.Assignments[name] = {} end
		skill=skill+0
		for class=0, 7 do
			BNP.Assignments[name][class] = skill
		end
	end
	if string.find(msg, "^SYMCOUNT ([0-9]*)") then
		_, _, count = string.find(msg, "^SYMCOUNT ([0-9]*)")
		if BNP.Paladins[sender] then
			BNP.Paladins[sender]["symbols"] = count
		end
	end
end

function BNP.CheckRaidLeader(nick)
	if GetNumRaidMembers() == 0 then
		for i= 1, GetNumPartyMembers(), 1 do
			if nick==UnitName("party"..i) and UnitIsPartyLeader("party"..i) then 
				return true 
			end
		end
		return false
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
		if ( rank >= 1 and name == nick ) then
			return true
		end
	end
	return false
end