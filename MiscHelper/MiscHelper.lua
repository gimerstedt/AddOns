-- misc helper
MH = {}
MH_PREP = "[MiscHelper] "

-- info command
SLASH_MISCHELPER1, SLASH_MISCHELPER2 = '/mischelper', '/mh'
function SlashCmdList.MISCHELPER()	
	MH.m("/ctri - /cthunrunin", MH_PREP, 1, 1, 0.3)
	MH.m("Generates a run in order and writes it in /party.", MH_PREP)
	MH.m("/ri - /resetinstances", MH_PREP, 1,1,0,3)
	MH.m("Resets instances.", MH_PREP)
	MH.m("/ress", MH_PREP, 1,1,0,3)
	MH.m("Resurrects the target if in range and notifies in /s (announces on cd if druid).", MH_PREP)
	MH.m("/cdb - /checkdebuffs", MH_PREP, 1,1,0,3)
	MH.m("Reports missing debuffs on target to /raid.", MH_PREP)
	MH.m("/rmic - /raidmembersincombat", MH_PREP, 1,1,0,3)
	MH.m("Reports raid members in combat in /raid.", MH_PREP)
	MH.m("/cc (hitRate) - /critcap (hitRate)", MH_PREP, 1,1,0,3)
	MH.m("Reports your crit cap based on the hitRate input.", MH_PREP)
	MH.m("/cbot - /checkbuffsontarget", MH_PREP, 1,1,0,3)
	MH.m("Reports all buffs on target.", MH_PREP)
	MH.m("/grn - /getraidmembernames", MH_PREP, 1,1,0,3)
	MH.m("List all raid members in a frame for copy/paste.", MH_PREP)
	MH.m("/ss", MH_PREP, 1,1,0,3)
	MH.m("Sit/stand up repeatedly for no good reason.", MH_PREP)
end

-- automatic cthun run in order
SLASH_CTHUNRUNIN1, SLASH_CTHUNRUNIN2 = '/ctri', '/cthunrunin'
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
			table.insert(orderedWithGaps, 9, k)

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

-- reload ui
SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()
	ReloadUI()
end

-- reset instances
SLASH_RESETINSTANCES1, SLASH_RESETINSTANCES2 = '/ri', '/resetinstances'
function SlashCmdList.RESETINSTANCES()
	ResetInstances()
end

-- resurrect target
SLASH_RESS1 = '/ress'
function SlashCmdList.RESS()
	if UnitIsDead("target") == nil then
		MH.m("Target is not dead", MH_PREP)
		return
	end
	local spellName = ''
	if UnitClass("player") == "Paladin" then
		spellName = "Redemption"
	elseif UnitClass("player") == "Priest" then
		spellName = "Resurrection"
	elseif UnitClass("player") == "Druid" then
		spellName = "Rebirth"
		if Zorlen_checkCooldownByName(spellName) == false then
			MH.s(spellName.." on cooldown.")
			return
		end
	else
		return
	end

	if CheckInteractDistance("target", 4) then
		CastSpellByName(spellName)
		MH.s("Resurrecting "..UnitName("target")..".")
	else
		MH.m("Target is out of range.", MH_PREP)
	end
end

SLASH_TEST1 = '/test'
function SlashCmdList.TEST(msg)
end

-- report missing debuffs on target
SLASH_CHECKDEBUFFS1, SLASH_CHECKDEBUFFS2 = '/cdb', '/checkdebuffs'
function SlashCmdList.CHECKDEBUFFS()
	if UnitInRaid("player") ~= true or isEnemy("target") ~= true then
		MH.m("You are either in not in a raid or your target is not an enemy or you do not have a target.", MH_PREP)
		return
	end
	local debuffsMissing = {}
	for i=1, 16 do
		db = UnitDebuff("target", i)
		if db == nil then 
			MH.r(UnitName("target").." has no debuffs!", MH_PREP)
			break
		end
		if string.find(db,"Spell_Shadow_CurseOfAchimonde") then table.insert(debuffsMissing, "Curse of Shadows") end
		if string.find(db, "Spell_Shadow_ChillTouch") then table.insert(debuffsMissing, "Curse of Elements") end
		if string.find(db, "Spell_Shadow_UnholyStrength") then table.insert(debuffsMissing, "Curse of Recklessness") end
		if string.find(db, "Spell_Nature_FaerieFire") then table.insert(debuffsMissing, "Faerie Fire") end
		if string.find(db, "Spell_Shadow_BlackPlague") then table.insert(debuffsMissing, "Shadow Weaving") end
		if string.find(db, "Ability_Warrior_Sunder") then table.insert(debuffsMissing, "Sunder Armor") end
	end
	if table.getn(debuffsMissing) > 0 then
		local outputString = UnitName("target").." is missing"
		for i = 1, table.getn(debuffsMissing) do
			outputString = outputString.." "..debuffsMissing[i].."!"
		end
		MH.r(outputString)
	end
end

-- check raid for members in combat
SLASH_RAIDMEMBERSINCOMBAT1, SLASH_RAIDMEMBERSINCOMBAT2 = '/rmic', '/raidmembersincombat'
function SlashCmdList.RAIDMEMBERSINCOMBAT()
	if UnitInRaid("player") ~= true then
		return
	end
	local t = ""
	for i = 1, 40 do
		if GetRaidRosterInfo(i) ~= nil then
			local n = GetRaidRosterInfo(i)
			if UnitAffectingCombat("raid"..i) then
				t = t..n..", "
			end
		end
	end
	if t ~= "" then
		t = string.sub(t, 0,-3)
		MH.r("Players in combat: "..t..".", MH_PREP)
	else
		MH.m("No players within range in combat.", MH_PREP)
	end
end

-- only relevant for DW melee
SLASH_CRITCAP1, SLASH_CRITCAP2 = '/cc', '/critcap'
function SlashCmdList.CRITCAP(msg)
	if msg == "" then
		MH.m("You must specify your current hit rate.", MH_PREP)
		return
	end
	local missRate = 27
	local hitRate = msg
	local dodgeRate = 5.6
	local glancingRate = 40
	local critCap = 100 - (missRate - hitRate) - dodgeRate - glancingRate

	MH.m("Your crit cap with "..hitRate.."% hit is "..critCap.."%.", MH_PREP)
end

-- check buffs on target
SLASH_CHECKBUFFSONTARGET1, SLASH_CHECKBUFFSONTARGET2 = '/cbot', '/checkbuffsontarget'
function SlashCmdList.CHECKBUFFSONTARGET()
	local u = unit or "target"
	if not unit and not UnitExists("target") then
		u = "player"
	end
	if UnitName(u) then
		if not UnitBuff(u, 1) then
			return
		end
		local counter = 1
		while (UnitBuff(u, counter)) do
			ZORLEN_Buff_Tooltip:SetUnitBuff(u, counter)
			local name = ZORLEN_Buff_TooltipTextLeft1:GetText()
			MH.m(counter..": "..name)
			counter = counter + 1
		end
	end
end

-- put raid members in a list for copy/paste
SLASH_GETRAIDMEMBERNAMES1, SLASH_GETRAIDMEMBERNAMES2 = '/grn', '/getraidmembernames'
function SlashCmdList.GETRAIDMEMBERNAMES()
	local m = GetNumRaidMembers();
	local names = {}
	for i = 1, m do
		local name = GetRaidRosterInfo(i);
		table.insert(names, name)
	end

	e = CreateFrame("Frame", "GRNHolder", UIParent)
	e:SetBackdrop(StaticPopup1:GetBackdrop())
	e:SetHeight(60+10*table.getn(names))
	e:SetWidth(200)
	e:SetPoint("CENTER", 0,0)
		
	f = CreateFrame("EditBox", "GRNFrame", e)
	f:SetMultiLine(true)
	f:SetFont("Fonts\\FRIZQT__.TTF", 12)
	f:SetPoint("TOPLEFT", e, "TOPLEFT", 25, -25)
	f:SetPoint("TOPRIGHT", e, "TOPRIGHT", -30, -25)
	f:SetText(table.concat(names, "\n"))
	
	c = CreateFrame("Button", nil, e, "UIPanelCloseButton")
	c:SetPoint("TOPRIGHT", e, "TOPRIGHT", 0,0)
end

-- sitstand
SLASH_SITSTAND1 = '/ss'
function SlashCmdList.SITSTAND()
	if sitFrame == nil then
		sitFrame = CreateFrame("frame")
	end
	local function sos() SitOrStand() end
	if breakSit == nil then
		breakSit = 1
		sitFrame:SetScript("OnUpdate", sos)
	else
		breakSit = nil
		sitFrame:SetScript("OnUpdate", nil)
	end
end

function MH.m(msg, prepend, r, g, b)
	prepend = prepend or ""
	r = r or 0.7
	g = g or 0.6
	b = b or 1
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage(tostring(prepend)..tostring(msg), r, g, b)		
	end
end

function MH.s(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "SAY")
	end
end

function MH.p(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "PARTY")
	end
end

function MH.r(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "RAID")
	end
end