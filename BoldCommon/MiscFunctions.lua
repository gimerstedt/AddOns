-- not that useful..
function ReportPlayersInCombat()
	if not UnitInRaid("player") then
		return
	end
	local i, t = 1, ""
	while GetRaidRosterInfo(i) do
		local n = GetRaidRosterInfo(i)
		if UnitAffectingCombat("raid"..i) then
			t = t..n..", "
		end
		i = i + 1
	end
	if t ~= "" then
		t = string.sub(t, 0,-3)
		BC.r("Players in combat: "..t..".", BC.prep)
	else
		BC.m("No players within range in combat.", BC.prep)
	end
end

-- math lel.
function ReportCritCap(hit)
	if hit == "" then
		BC.m("You must specify your current hit rate.", BC.prep)
		return
	end
	local missRate = 27
	local hitRate = hit
	local dodgeRate = 5.6
	local glancingRate = 40
	local critCap = 100 - (missRate - hitRate) - dodgeRate - glancingRate

	BC.m("Your crit cap with "..hitRate.."% hit is "..critCap.."%.", BC.prep)
end

-- bag it!
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

-- get spell id from spell book.
function BC.GetSpellId(SpellName, SpellRank)
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

-- enable auto attack.
function BC.EnableAttack()
	if not BC.AttackAction then
		for i = 1, 120 do
			if IsAttackAction(i) then
				BC.AttackAction = i
			end
		end
	end
	if BC.AttackAction then
		if not IsCurrentAction(BC.AttackAction)
			then UseAction(BC.AttackAction)
		end
	else
		BC.m("You need to put your attack ability on one of your action bars!")
	end
end

-- printers.
function BC.m(msg, prepend, r, g, b)
	prepend = prepend or ""
	r = r or 1
	g = g or 0.6
	b = b or 0.9
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage(tostring(prepend)..tostring(msg), r, g, b)		
	end
end

function BC.c(msg, prepend)
	prepend = prepend or ""
	BC.m(msg, prepend, 0.7, 0.7, 1)
end

function BC.p(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "PARTY")
	end
end

function BC.r(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "RAID")
	end
end

function BC.y(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "YELL")
	end
end

function BC.s(msg, prepend)
	prepend = prepend or ""
	if msg then
		SendChatMessage(tostring(prepend)..tostring(msg), "SAY")
	end
end
