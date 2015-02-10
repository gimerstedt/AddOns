-- BoldCommon
BC = {}
BC.debug = true
BC.prep = "[BoldCommon] "

BINDING_HEADER_BC = "BoldCommon"
BINDING_NAME_BC_MOUNT = "Mount up"
BINDING_NAME_BC_TEABAG = "Teabag"
BINDING_NAME_BC_CTRI = "Generate C'Thun run in order"
BINDING_NAME_BC_CDB = "Report missing debuffs on target"
BINDING_NAME_BC_RMIC = "Report raid members in combat"
BINDING_NAME_BC_UNSTUCK = "Unstuck"
BINDING_NAME_BC_RELOADUI = "Reload UI"

-- on load.
function BC.OnLoad()
	this:RegisterEvent("MERCHANT_SHOW")

	SlashCmdList["BOLDCOMMON"] = BC.Help
	SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = "/bc", "/boldcommon"

	SlashCmdList["BPRELOADUI"] = ReloadUI
	SLASH_BPRELOADUI = "/rl"
	SlashCmdList["RESETINSTANCES"] = ResetInstances
	SLASH_RESETINSTANCES1, SLASH_RESETINSTANCES2 = "/ri", "/resetinstances"
	SlashCmdList["BCHOME"] = Stuck
	SLASH_BCHOME1 = "/home"

	SlashCmdList["CTHUNRUNIN"] = BC.GenerateCthunRunInOrder
	SLASH_CTHUNRUNIN1, SLASH_CTHUNRUNIN2 = "/ctri", "/cthunrunin"
	SlashCmdList["MISSINGDEBUFFS"] = BC.ReportMissingDebuffsOnTarget
	SLASH_MISSINGDEBUFFS1 =  "/cdb"
	SlashCmdList["RAIDMEMBERSINCOMBAT"] = BC.ReportPlayersInCombat
	SLASH_RAIDMEMBERSINCOMBAT1, SLASH_RAIDMEMBERSINCOMBAT2 = "/rmic", "/raidmembersincombat"
	SlashCmdList["CRITCAP"] = BC.ReportCritCap
	SLASH_CRITCAP1, SLASH_CRITCAP2 = "/cc", "/critcap"
	SlashCmdList["BUFFSONTARGET"] = BC.ReportBuffsOnTarget
	SLASH_BUFFSONTARGET1, SLASH_BUFFSONTARGET2 = "/cbot", "/checkbuffsontarget"
	SlashCmdList["TEABAG"] = BC.TeaBag
	SLASH_TEABAG1 = "/ss"
	SlashCmdList["BCUSE"] = BC.UseItemByName
	SLASH_BCUSE1 = "/use"
	SlashCmdList["BCMOUNT"] = BC.Mount
	SLASH_BCMOUNT1 = "/mount"
	SlashCmdList["BCUNBUFF"] = BC.RemoveBuffByName
	SLASH_BCUNBUFF1 = "/unbuff"
end

-- event handler.
function BC.OnEvent()
	if event == "MERCHANT_SHOW" then
		BC.Repair()
	end
end

-- info command.
function BC.Help()
	BC.m("Automatically repairs your equipment at vendor.", BC.prep)
	BC.c("/ctri - /cthunrunin", BC.prep)
	BC.m("Generates a run in order and writes it in /party.", BC.prep)
	BC.c("/ri - /resetinstances", BC.prep)
	BC.m("Resets instances.", BC.prep)
	BC.c("/cdb - /checkdebuffs", BC.prep)
	BC.m("Reports missing debuffs on target to /raid.", BC.prep)
	BC.c("/rmic - /raidmembersincombat", BC.prep)
	BC.m("Reports raid members in combat in /raid.", BC.prep)
	BC.c("/cc (hitRate) - /critcap (hitRate)", BC.prep)
	BC.m("Reports your crit cap based on the hitRate input.", BC.prep)
	BC.c("/cbot (textures, true/false) - /checkbuffsontarget", BC.prep)
	BC.m("Reports all buffs on target.", BC.prep)
	BC.c("/ss", BC.prep)
	BC.m("Sit/stand up repeatedly for no good reason.", BC.prep)
	BC.c("/home", BC.prep)
	BC.m("Unstuck.", BC.prep)
	BC.c("/use", BC.prep)
	BC.m("Use item by name.", BC.prep)
	BC.c("/mount", BC.prep)
	BC.m("Mount up.", BC.prep)
	BC.c("/unbuff (name of buff)", BC.prep)
	BC.m("Removes buff.", BC.prep)
end