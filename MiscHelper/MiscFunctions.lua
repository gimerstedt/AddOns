function ReportPlayersInCombat()
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

function ReportCritCap(hit)
	if hit == "" then
		MH.m("You must specify your current hit rate.", MH_PREP)
		return
	end
	local missRate = 27
	local hitRate = hit
	local dodgeRate = 5.6
	local glancingRate = 40
	local critCap = 100 - (missRate - hitRate) - dodgeRate - glancingRate

	MH.m("Your crit cap with "..hitRate.."% hit is "..critCap.."%.", MH_PREP)
end

function TeaBag()
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

function MH.y(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "YELL")
	end
end