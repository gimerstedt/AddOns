function BC.GothikPriestAssigns()
	if not UnitInRaid("player") then return end
	local priests, left, right, raidMarks = {}, {}, {}, {"Star", "Circle", "Diamond", "Triangle", "Moon", "Square", "Cross", "Skull"}
	for i = 1 , GetNumRaidMembers() do
		local name, _, _, _, class = GetRaidRosterInfo(i)
		if class == "Priest" then
			if table.getn(priests) < 8 then
				table.insert(priests, name)
			end
		end
	end
	for k,v in pairs(priests) do
		if mod(k, 2) == 0 then
			right[raidMarks[k]] = v
		else
			left[raidMarks[k]] = v
		end
	end
	local leftString, rightString = "Left side: ", "Right side: "
	for k,v in pairs(left) do
		leftString = leftString.."("..k.." = "..v..")"..", "
	end
	for k,v in pairs(right) do
		rightString = rightString.."("..k.." = "..v..")"..", "
	end
	leftString = string.sub(leftString, 0,-3)
	rightString = string.sub(rightString, 0,-3)
	BC.r(leftString, BC.prep)
	BC.r(rightString, BC.prep)
end