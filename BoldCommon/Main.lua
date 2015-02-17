BC = {}
BC.debug = false
BC.prep = "[BoldCommon] "

BINDING_HEADER_BC = "BoldCommon"
BINDING_NAME_BC_MOUNT = "Mount up"
BINDING_NAME_BC_TEABAG = "Teabag"
BINDING_NAME_BC_CTRI = "Generate C'Thun run in order"
BINDING_NAME_BC_CDB = "Report missing debuffs on target"
BINDING_NAME_BC_RMIC = "Report raid members in combat"
BINDING_NAME_BC_UNSTUCK = "Unstuck"
BINDING_NAME_BC_RELOADUI = "Reload UI"

function BC.OnLoad()
	this:RegisterEvent("MERCHANT_SHOW")

	SlashCmdList["BOLDCOMMON"] = BC.SlashCommand
	SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = "/bc", "/boldcommon"

	SlashCmdList["BPRELOADUI"] = ReloadUI
	SLASH_BPRELOADUI = "/rl"
	SlashCmdList["RESETINSTANCES"] = ResetInstances
	SLASH_RESETINSTANCES1, SLASH_RESETINSTANCES2 = "/ri", "/resetinstances"
	SlashCmdList["BCHOME"] = Stuck
	SLASH_BCHOME1 = "/home"

	SlashCmdList["BCUSE"] = BC.UseItemByName
	SLASH_BCUSE1 = "/use"
	SlashCmdList["BCUNBUFF"] = BC.RemoveBuffByName
	SLASH_BCUNBUFF1 = "/unbuff"
end

function BC.OnEvent()
	if event == "MERCHANT_SHOW" then
		BC.Repair()
	end
end

function BC.SlashCommand(msg)
	local _, _, c, options = string.find(msg, "([%w%p]+)%s*(.*)$");
	if c then
		c = string.lower(c);
	end
	if c == nil or c == "" or c == "help" or c == "help1" then
		BC.Help()
	elseif c == "2" or c == "help2" then
		BC.Help2()
	elseif c == "cthun" or c == "ctri" or c == "cthunrunin" then
		BC.GenerateCthunRunInOrder()
	elseif c == "gpa" or c == "gothik" then
		BC.GothikPriestAssigns()
	elseif c == "cdb" or c == "missingdebuffs" then
		BC.ReportMissingDebuffsOnTarget()
	elseif c == "rmic" or c == "raidmembersincombat" then
		BC.ReportPlayersInCombat()
	elseif c == "cc" or c == "critcap" then
		BC.ReportCritCap(options)
	elseif c == "cbot" or c == "checkbuffsontarget" then
		BC.ReportBuffsOnTarget(options)
	elseif c == "ss" then
		BC.TeaBag()
	elseif c == "mount" then
		BC.Mount()
	end
end

function BC.Help()
	BC.my("BoldCommon serves as both a library and an assortment of useful commands.", BC.prep)
	BC.m("Passive: Automatically repairs your equipment at vendor.", BC.prep)
	BC.mb("/rl", BC.prep)
	BC.m("Reload UI.", BC.prep)
	BC.mb("/ri", BC.prep)
	BC.m("Reset instances.", BC.prep)
	BC.mb("/home", BC.prep)
	local home = GetBindLocation()
	BC.m("Unstuck (go to "..home..")", BC.prep)
	BC.mb("/use", BC.prep)
	BC.m("Use item by name.", BC.prep)
	BC.mb("/unbuff (name of buff)", BC.prep)
	BC.m("Removes buff.", BC.prep)
	BC.my("/bc help2", BC.prep)
	BC.my("More BoldCommon commands.", BC.prep)

end

function BC.Help2()
	BC.mb("/bc cthun - /bc ctri", BC.prep)
	BC.m("Generates a run in order and writes it in /party.", BC.prep)
	BC.mb("/bc gpa - /bc gothik", BC.prep)
	BC.m("Generates priest assigns for Gothik.", BC.prep)
	BC.mb("/bc cdb - /bc missingdebuffs", BC.prep)
	BC.m("Reports missing debuffs on target to /raid.", BC.prep)
	BC.mb("/bc rmic - /bc raidmembersincombat", BC.prep)
	BC.m("Reports raid members in combat in /raid.", BC.prep)
	BC.mb("/bc cc (hitRate) - /bc critcap (hitRate)", BC.prep)
	BC.m("Reports your crit cap based on the hitRate input.", BC.prep)
	BC.mb("/bc cbot (textures, true/false) - /bc checkbuffsontarget", BC.prep)
	BC.m("Reports all buffs on target.", BC.prep)
	BC.mb("/cb ss", BC.prep)
	BC.m("Sit/stand up repeatedly for no good reason.", BC.prep)
	BC.mb("/cb mount", BC.prep)
	BC.m("Mount up.", BC.prep)
end