-- only load for warriors
if UnitClass("player") ~= "Warrior" then return end

-- consts
BW_PREP = "---> "

BW_TAUNT_LOG = "Your Taunt was resisted by (.+)"
BW_TAUNT_TXT = "Taunt resisted!"

BW_MB_LOG = "(.*)Mocking Blow(.*)"
BW_MB_LOG2 = "Your Mocking Blow (.+) for (.+)"
BW_MB_TXT = "Mocking Blow resisted!"

BW_SW = "You gain Shield Wall."
BW_SW_TXT = "Used Shield Wall!"
BW_LS = "You gain Last Stand."
BW_LS_TXT = "Used Last Stand!"
BW_LG = "You gain Gift of Life."
BW_LG_TXT = "Used Lifegiving Gem!"
BW_CS_TXT = "Used Mass Taunt!"

-- event handler
local function onEvent()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1, BW_TAUNT_LOG) then
			BC.y(BW_TAUNT_TXT, BW_PREP)
		elseif string.find(arg1, BW_MB_LOG) then
			local mbHit = string.find(arg1, BW_MB_LOG2)
			if not mbHit then
				BC.r(BW_MB_TXT, BW_PREP)
			end
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		if string.find(arg1, BW_SW) then
			BC.y(BW_SW_TXT, BW_PREP)
		elseif string.find(arg1, BW_LS) then
			BC.y(BW_LS_TXT, BW_PREP)
		elseif string.find(arg1, BW_LG) then
			BC.y(BW_LG_TXT, BW_PREP)
		end
	end
end

-- announce challenging shout with a command instead...to cut down on code
SLASH_CHALLSHOUT1 = '/aoetaunt'
function SlashCmdList.CHALLSHOUT()
	if UnitMana("player") > 9 and GetSpellCooldown(BW_GetSpellId("Challenging Shout", 1), BOOKTYPE_SPELL) == 0 then
		CastSpellByName("Challenging Shout", 1)
		BC.y(BW_CS_TXT, BW_PREP)
	end
end

-- register event and handler
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
f:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
--f:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
f:SetScript("OnEvent", onEvent)

function BW_GetSpellId(SpellName, SpellRank)
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