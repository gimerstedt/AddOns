-- only load for warriors.
if UnitClass("player") ~= "Warrior" then return end

-- consts.
BW = {}
BW.announce = "---> "
BW.prep = "[BoldWarrior] "
BW.removableBuffs = {
	"Spell_Nature_Thorns", -- thorns
	"Spell_Nature_AbolishMagic", -- dampen magic
	"Spell_Holy_FlashHeal", -- amplify magic
	"Spell_Nature_NullifyDisease", -- abolish disease
	"GreaterBlessingofSanctuary", -- sanct
	"Spell_Shadow_AntiShadow", -- shadow prot
	"PrayerOfHealing02", -- bol 5m
	"Spell_Fire_FireArmor", -- gfpp/fire shield
	"Spell_Magic_MageArmor", -- 5m kings/priest t3 4pc
	"Spell_Nature_ResistNature", -- regrowth
	"Spell_Nature_Rejuvenation", -- rejuv
	"Spell_Holy_Renew", -- renew
	"GreaterBlessingofLight", -- bol
	"Spell_Holy_PowerWordShield", -- pws
	"INV_Drink_03", -- gordok green grog
	"INV_Potion_44", -- elixir of fortitude
	"INV_Potion_86", -- elixir of defense
	"Spell_Misc_Food", -- food buff
	"INV_Shield_06", -- inspiration/prot scroll
}

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

-- on load.
function BW.OnLoad()
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
	this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
end

-- event handler
function BW.OnEvent()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1, BW_TAUNT_LOG) then
			BC.y(BW_TAUNT_TXT, BW.announce)
		elseif string.find(arg1, BW_MB_LOG) then
			local mbHit = string.find(arg1, BW_MB_LOG2)
			if not mbHit then
				BC.r(BW_MB_TXT, BW.announce)
			end
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		if string.find(arg1, BW_SW) then
			BC.y(BW_SW_TXT, BW.announce)
		elseif string.find(arg1, BW_LS) then
			BC.y(BW_LS_TXT, BW.announce)
		elseif string.find(arg1, BW_LG) then
			BC.y(BW_LG_TXT, BW.announce)
		end
	end
end

-- announce challenging shout with a command instead...to cut down on code
SLASH_BWHELP1 = '/bwhelp'
function SlashCmdList.BWHELP()
	BC.c("/aoetaunt", BW.prep)
	BC.m("Uses and announces Challenging Shout if player has enough rage and it is not on cooldown.", BW.prep)
	BC.c("/safesw", BW.prep)
	BC.m("Safely uses Shield Wall.", BW.prep)
	BC.c("/safels", BW.prep)
	BC.m("Safely uses Last Stand.", BW.prep)
	BC.c("/safelgg", BW.prep)
	BC.m("Safely uses Lifegiving Gem.", BW.prep)
end

-- announce challenging shout with a command instead...to cut down on code
SLASH_CHALLSHOUT1 = '/aoetaunt'
function SlashCmdList.CHALLSHOUT()
	if UnitMana("player") > 9 and GetSpellCooldown(BC.GetSpellId("Challenging Shout", 1), BOOKTYPE_SPELL) == 0 then
		CastSpellByName("Challenging Shout", 1)
		BC.y(BW_CS_TXT, BW.announce)
	end
end

-- safely sw.
SLASH_SHIELDWALL1 = '/safesw'
function SlashCmdList.SHIELDWALL()
	-- do nothing if on cd.
	if GetSpellCooldown(BC.GetSpellId("Shield Wall"), 1, BOOKTYPE_SPELL) > 0 then
		BC.m("Shield Wall is on cooldown.", BW.prep)
		return
	end
	-- notify if in wrong stance.
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	if not defensive then
		BC.m("You need to be in defensive stance to Shield Wall", BW.prep)
		return
	end
	-- if below 24 buffs, sw.
	if not UnitBuff("player", 24) then
		CastSpellByName("Shield Wall")
		return
	end
	-- meni buffs, need to remove one.
	if not BW.RemoveABuff() then
		BC.m("Could not find a buff to remove, using Shield Wall anyway.", BW.prep)
	end
	CastSpellByName("Shield Wall")
end

-- safely ls.
SLASH_LASTSTAND1 = '/safels'
function SlashCmdList.LASTSTAND()
	-- do nothing if on cd.
	local LSId = BC.GetSpellId("Last Stand")
	if LSId then	
		if GetSpellCooldown(LSId, 1, BOOKTYPE_SPELL) > 0 then
			BC.m("Last stand is on cooldown.", BW.prep)
			return
		end
	else
		BC.m("You do not have Last Stand.", BW.prep)
	end
	-- if below 24 buffs, ls.
	if not UnitBuff("player", 24) then
		CastSpellByName("Last Stand")
		return
	end
	-- meni buffs, need to remove one.
	if not BW.RemoveABuff() then
		BC.m("Could not find a buff to remove, using Last Stand anyway.", BW.prep)
	end
	CastSpellByName("Last Stand")
end

-- safely ls.
SLASH_LIFEGIVING1 = '/safelgg'
function SlashCmdList.LIFEGIVING()
	local trink1 = GetInventoryItemTexture("player", 13)
	local trink2 = GetInventoryItemTexture("player", 14)
	trink1 = string.find(trink1, "Misc_Gem_Pearl_05")
	trink2 = string.find(trink2, "Misc_Gem_Pearl_05")
	start1, _, _ = GetInventoryItemCooldown("player", 13)
	start2, _, _ = GetInventoryItemCooldown("player", 14)
	if not trink1 and not trink2 then
		BC.m("Lifegiving Gem not equipped.", BW.prep)
		return
	end
	if trink1 and start1 > 0 then
		BC.m("Lifegiving Gem on cooldown.", BW.prep)
		return
	end
	if trink2 and start2 > 0 then
		BC.m("Lifegiving Gem on cooldown.", BW.prep)
		return
	end
	-- if 24 buffs, remove one.
	if not UnitBuff("player", 24) then
		BC.UseItemByName("Lifegiving Gem", BW.prep)
		return
	end
	-- meni buffs, need to remove one.
	if not BW.RemoveABuff() then
		BC.m("Could not find a buff to remove, using Lifegiving Gem anyway.", BW.prep)
	end
	BC.UseItemByName("Lifegiving Gem")
end

function BW.RemoveABuff()
	for k,buff in pairs(BW.removableBuffs) do
		local i = 0
		while GetPlayerBuffTexture(i) do
			if string.find(GetPlayerBuffTexture(i), buff) then
				BC.m("removing: "..buff)
				BC.m(i)
				CancelPlayerBuff(i)
				return true
			end
			i = i + 1
		end
	end
	return false
end