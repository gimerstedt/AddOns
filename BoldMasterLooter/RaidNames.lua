function BMLB.ReportRaidMemberNames()
	if not UnitInRaid("player") then
		return
	end
	local m = GetNumRaidMembers()
	local names = {}
	for i = 1, m do
		local name = GetRaidRosterInfo(i)
		table.insert(names, name)
	end

	e = CreateFrame("Frame", "GRNHolder", UIParent)
	e:SetBackdrop(StaticPopup1:GetBackdrop())
	e:SetHeight(60+10*table.getn(names))
	e:SetWidth(200)
	e:SetPoint("CENTER", 0,0)
	e:EnableKeyboard(true)
	e:EnableMouse(true)
		
	f = CreateFrame("EditBox", "GRNFrame", e)
	f:SetMultiLine(true)
	f:SetFont("Fonts\\FRIZQT__.TTF", 12)
	f:SetPoint("TOPLEFT", e, "TOPLEFT", 25, -25)
	f:SetPoint("TOPRIGHT", e, "TOPRIGHT", -30, -25)
	f:SetText(table.concat(names, "\n"))
	f:EnableKeyboard(true)
	f:SetScript("OnEscapePressed", BMLB.CloseGRNFrame)

	c = CreateFrame("Button", nil, e, "UIPanelCloseButton")
	c:SetPoint("TOPRIGHT", e, "TOPRIGHT", 0,0)
end

function BMLB.CloseGRNFrame()
	e:Hide()
	e:SetParent(nil)
end