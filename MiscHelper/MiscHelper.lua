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
	local groupNumber = getSubGroupNumber()
	local order = {} -- list of names in run in order
	local playerClass = UnitClass("player")
	local playerName = UnitName("player")

	-- self explanatory
	local function isHealer(class)
		if class == "Druid" or class == "Priest" or class == "Paladin" then
			return true
		else
			return false
		end
	end

	-- self explanatory
	local function isMelee(class)
		if class == "Warrior" or class == "Rogue" then
			return true
		else
			return false
		end
	end

	-- add target
	if UnitInParty("target") then
		local name = UnitName("target")
		table.insert(order, name)
	else
		sysout("You need to target the melee in your party.")
		return
	end

	-- add the healers
	for i=1,GetNumPartyMembers() do
		local class = UnitClass("party"..i)
		local name = UnitName("party"..i)
		if name ~= UnitName("target") then 
			if isHealer(class) then
				table.insert(order, name)
			end
		end
	end

	-- add yourself if non-melee
	if isMelee(playerClass) ~= true and UnitIsUnit("player", "target") ~= true then
		table.insert(order, playerName)
	end

	-- add the non-melee/non-healers
	for i=1,GetNumPartyMembers() do
		local class = UnitClass("party"..i)
		local name = UnitName("party"..i)
		if name ~= UnitName("target") then
			if isHealer(class) ~= true and isMelee(class) ~= true then
				table.insert(order, name)
			end
		end
	end

	-- add yourself if you're melee
	if isMelee(playerClass) and UnitIsUnit("player", "target") ~= true then
		table.insert(order, playerName)
	end

	-- add the melee last
	for i=1,GetNumPartyMembers() do
		local class = UnitClass("party"..i)
		local name = UnitName("party"..i)
		if name ~= UnitName("target") then
			if isHealer(class) == false and isMelee(class) == true then
				table.insert(order, name)
			end
		end
	end

	-- fill empty spots
	for i=table.getn(order), 5 do
		table.insert(order, "Empty Spot")
	end

	-- send to chat
	-- SendChatMessage("----- C'Thun run in order -----", "PARTY")

	SendChatMessage("--------------- (1) "..order[1].." ---------------", "PARTY")

	if mod(groupNumber, 2) == 0 then
		SendChatMessage("(3) "..order[3].." ----- (2) "..order[2], "PARTY")
		SendChatMessage("(5) "..order[5].." ----- (4) "..order[4], "PARTY")
	else
		SendChatMessage("(2) "..order[2].." ----- (3) "..order[3], "PARTY")
		SendChatMessage("(4) "..order[4].." ----- (5) "..order[5], "PARTY")
	end
end

function sysout(msg, r, g, b)
	r = r or 0.7
	g = g or 0.6
	b = b or 1
	if msg then		
		DEFAULT_CHAT_FRAME:AddMessage("[PaladinHelper] " .. tostring(msg), r, g, b)		
	end
end

function getSubGroupNumber()
	if UnitInRaid("player") then
		for i = 1 , GetNumRaidMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if (name == UnitName("player")) then
				return subgroup
			end
		end
	end
end

SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()	
	ReloadUI()
end