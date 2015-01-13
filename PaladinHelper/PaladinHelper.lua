-- only load if paladin
if not Zorlen_isCurrentClassPaladin then return end

-- info command
SLASH_PALADINHELPER1 = '/paladinhelper'
function SlashCmdList.PALADINHELPER()	
	sysout("====== PaladinHelper ======", 1, 1, 0.3)
	sysout("Notifies you if no aura is active.")
	sysout("/safebop", 1, 1, 0.3)
	sysout("Casts Blessing of Protection on your target if your target is NOT a warrior and targetTarget if target is hostile and targetTarget is not a warrior.")
	sysout("/t1", 1, 1, 0.3)
	sysout("Targets, attacks and keeps SotC up.")
end

-- cast bop on target if target is not warrior or on targettarget if target is hostile and targettarget is not warrior
SLASH_BOP1 = '/safebop'
function SlashCmdList.BOP(msg)	
	if UnitIsFriend("player", "target") and Zorlen_isClass("warrior", target) ~= true then
		Zorlen_castSpellByName("Blessing of Protection", 3)
	end
	if Zorlen_canAttack("target") then
		if Zorlen_isClass("warrior", "targetTarget") ~= true then
			TargetUnit("targetTarget")
			Zorlen_castSpellByName("Blessing of Protection", 3)
			TargetLastTarget()
		end
	end
end

-- rotation for 8/8 t1
SLASH_T11 = '/t1'
function SlashCmdList.T1(msg)	
	Zorlen_TargetFirstEnemy()
	if Zorlen_canAttack("target") then castSealOfTheCrusader() castAttack() end
end

-- notify if no aura active
local function notifyIfAuraMissing()
	if isPaladinAuraActive() ~= true then
		sysout("No aura active!")
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

-- print message
function sysout(msg, r, g, b)
	r = r or 0.7
	g = g or 0.6
	b = b or 1
	if msg then		
		DEFAULT_CHAT_FRAME:AddMessage("[PaladinHelper] " .. tostring(msg), r, g, b)		
	end
end