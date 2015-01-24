-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- consts
TK_PREP = "---> "

TK_TAUNT_LOG = "Your Taunt was resisted by (.+)"
TK_TAUNT_TXT = "Taunt resisted!"

TK_MB_LOG = "(.*)Mocking Blow(.*)"
TK_MB_LOG2 = "Your Mocking Blow (.+) for (.+)"
TK_MB_TXT = "Mocking Blow resisted!"

TK_SW = "You gain Shield Wall."
TK_SW_TXT = "Used Shield Wall!"
TK_LS = "You gain Last Stand."
TK_LS_TXT = "Used Last Stand!"
TK_LG = "You gain Gift of Life."
TK_LG_TXT = "Used Lifegiving Gem!"
TK_CS_TXT = "Used Mass Taunt!"

-- event handler
local function onEvent()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1, TK_TAUNT_LOG) then
			MH.y(TK_TAUNT_TXT, TK_PREP)
		elseif string.find(arg1, TK_MB_LOG) then
			local mbHit = string.find(arg1, TK_MB_LOG2)
			if not mbHit then
				MH.r(TK_MB_TXT, TK_PREP)
			end
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		if string.find(arg1, TK_SW) then
			MH.y(TK_SW_TXT, TK_PREP)
		elseif string.find(arg1, TK_LS) then
			MH.y(TK_LS_TXT, TK_PREP)
		elseif string.find(arg1, TK_LG) then
			MH.y(TK_LG_TXT, TK_PREP)
		end
	end
end

-- announce challenging shout with a command instead...to cut down on code
SLASH_CHALLSHOUT1 = '/tkshout'
function SlashCmdList.CHALLSHOUT()
	if GetSpellCooldown(TK_GetSpellId("Challenging Shout", 1), BOOKTYPE_SPELL) == 0 then
		MH.y(TK_CS_TXT, TK_PREP)
		CastSpellByName("Challenging Shout", 1)
	end
end

-- register event and handler
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
f:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
--f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
f:SetScript("OnEvent", onEvent)

function TK_GetSpellId(SpellName, SpellRank)
	local B = BOOKTYPE_SPELL
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