-- only load if warlock
if UnitClass("player") ~= "Warlock" then return end

-- check if ds-specced
_, _, _, _, rank, _= GetTalentInfo(2,13)
if rank ~= 1 then return end

-- prepend for chat print
BWLOCK_PREP = "[BoldWarlock] "
BWLSPELLS = {"Touch of Shadow", "Fel Energy", "Burning Wish", "Fel Stamina"}

-- check if sacrifice buff up
local function hasSacrificed()
	local found = false
	for k,v in pairs(BWLSPELLS) do
		if(BC.BuffIndexByName(v)) then
			found = true
		end
	end
	return found
end

-- notify if no aura active
local function notifyIfAuraMissing()
	if hasSacrificed() ~= true then
		BC.m("You should consider sacrificing a pet.", BWLOCK_PREP)
	end
end

-- event handler
local function onEvent()
	if event == "PLAYER_AURAS_CHANGED" then
		notifyIfAuraMissing()
	end
end

-- register event and handler
local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
f:SetScript("OnEvent", onEvent)
