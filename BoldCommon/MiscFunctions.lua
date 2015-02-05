-- not that useful..
function BC.ReportPlayersInCombat()
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

-- repair
function BC.Repair()
	if not CanMerchantRepair() then return end
	local cost = GetRepairAllCost()
	cost = floor(cost / 10000)
	if cost > 100 then BC.m("You're poor, i'm not going to repair your gear.", BC.prep) return end
	RepairAllItems()
	BC.m("Repair costs: ~"..cost.." gold.", BC.prep)
end

-- math lel.
function BC.ReportCritCap(hit)
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
function BC.TeaBag()
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

-- get spell id from spell book?
function BC.GetSpellId(spellname)
	local id = 1;
	for i = 1, GetNumSpellTabs() do
		local _, _, _, numSpells = GetSpellTabInfo(i);
		for j = 1, numSpells do
			local spellName = GetSpellName(id, BOOKTYPE_SPELL);
			if (spellName == spellname) then
				return id;
			end
			id = id + 1;
		end
	end
	return nil;
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

-- stolen from supermacro TODO: cleanup
function BC.UseItemByName(item)
	local bag,slot = BC.FindItem(item)
	if ( not bag ) then return end
	if ( slot ) then
		UseContainerItem(bag,slot) -- use, equip item in bag
		return bag, slot
	else
		UseInventoryItem(bag) -- unequip from body
		return bag
	end
end

-- stolen from supermacro TODO: cleanup
function BC.FindItem(item)
	if ( not item ) then return end
	item = string.lower(BC.ItemLinkToName(item))
	local link
	for i = 1,23 do
		link = GetInventoryItemLink("player",i)
		if ( link ) then
			if ( item == string.lower(BC.ItemLinkToName(link)) ) then
				return i, nil, GetInventoryItemTexture('player', i), GetInventoryItemCount('player', i)
			end
		end
	end
	local count, bag, slot, texture
	local totalcount = 0
	for i = 0,NUM_BAG_FRAMES do
		for j = 1,MAX_CONTAINER_ITEMS do
			link = GetContainerItemLink(i, j)
			if ( link ) then
				if ( item == string.lower(BC.ItemLinkToName(link))) then
					bag, slot = i, j
					texture, count = GetContainerItemInfo(i,j)
					totalcount = totalcount + count
				end
			end
		end
	end
	return bag, slot, texture, totalcount
end

-- stolen from supermacro TODO: cleanup
function BC.ItemLinkToName(link)
	if ( link ) then
   	return gsub(link,"^.*%[(.*)%].*$","%1")
	end
end

-- stolen from supermacro TODO: cleanup
function BC.ListToTable(text)
	local t={}
	-- if comma is part of item, put % before it
	-- eg, Sulfuras%, Hand of Ragnaros
	text=gsub(text, "%%,", "%%044")
	-- convert link to name, commas ok
	text=gsub(text, "|c.-%[(.+)%]|h|r", function(x)
		return gsub(x, ",", "%%044")
	end )

	gsub(text, "[^,]+", function(a) -- list separated by comma
		a = BC.TrimSpaces(a)
		if ( a~="" ) then
			a=gsub(a, "%%044", ",")
			tinsert(t,a)
		end
	end)
	return t
end

-- remove?
function BC.TrimSpaces(str)
	if ( str ) then
		return gsub(str,"^%s*(.-)%s*$","%1")
	end
end

-- check if shield is equipped.
function BC.IsShieldEquipped()
	if (GetInventoryItemLink("player", 17)) then
		local _, _, itemCode = strfind(GetInventoryItemLink("player", 17), "(%d+):")
		local _, _, _, _, _, itemType = GetItemInfo(itemCode)
		if (itemType == "Shields" and not GetInventoryItemBroken("player", 17)) then
			return true;
		end
	end
	return nil;
end