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
BINDING_NAME_BC_GRN = "Get a list of raid member names to copy/paste"
BINDING_NAME_BC_UNSTUCK = "Unstuck"
BINDING_NAME_BC_RELOADUI = "Reload UI"

-- on load.
function BC.OnLoad()
	this:RegisterEvent("MERCHANT_SHOW")
end

-- event handler.
function BC.OnEvent()
	if event == "MERCHANT_SHOW" then
		BC.Repair()
	end
end

-- info command.
SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = '/boldcommon', '/bc'
function SlashCmdList.BOLDCOMMON()	
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
	BC.c("/grn - /getraidmembernames", BC.prep)
	BC.m("List all raid members in a frame for copy/paste.", BC.prep)
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

-- automatic cthun run in order.
SLASH_CTHUNRUNIN1, SLASH_CTHUNRUNIN2 = '/ctri', '/cthunrunin'
function SlashCmdList.CTHUNRUNIN()
	BC.GenerateCthunRunInOrder()
end

-- reload ui.
SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()
	ReloadUI()
end

-- reset instances.
SLASH_RESETINSTANCES1, SLASH_RESETINSTANCES2 = '/ri', '/resetinstances'
function SlashCmdList.RESETINSTANCES()
	ResetInstances()
end

-- report missing debuffs on target.
SLASH_CHECKDEBUFFS1, SLASH_CHECKDEBUFFS2 = '/cdb', '/checkdebuffs'
function SlashCmdList.CHECKDEBUFFS()
	BC.ReportMissingDebuffsOnTarget()
end

-- check raid for members in combat.
SLASH_RAIDMEMBERSINCOMBAT1, SLASH_RAIDMEMBERSINCOMBAT2 = '/rmic', '/raidmembersincombat'
function SlashCmdList.RAIDMEMBERSINCOMBAT()
	BC.ReportPlayersInCombat()
end

-- only relevant for DW melee.
SLASH_CRITCAP1, SLASH_CRITCAP2 = '/cc', '/critcap'
function SlashCmdList.CRITCAP(msg)
	BC.ReportCritCap(msg)
end

-- check buffs on target.
SLASH_CHECKBUFFSONTARGET1, SLASH_CHECKBUFFSONTARGET2 = '/cbot', '/checkbuffsontarget'
function SlashCmdList.CHECKBUFFSONTARGET(showTextureNames)
	BC.ReportBuffsOnTarget(showTextureNames)
end

-- put raid members in a list for copy/paste.
SLASH_GETRAIDMEMBERNAMES1, SLASH_GETRAIDMEMBERNAMES2 = '/grn', '/getraidmembernames'
function SlashCmdList.GETRAIDMEMBERNAMES()
	BC.ReportRaidMemberNames()
end

-- sitstand.
SLASH_SITSTAND1 = '/ss'
function SlashCmdList.SITSTAND()
	BC.TeaBag()
end

-- unstuck.
SLASH_UNSTUCK1 = '/home'
function SlashCmdList.UNSTUCK()
	Stuck()
end

-- use item by name.
SLASH_BCUSE1 = '/use'
function SlashCmdList.BCUSE(msg)
	BC.UseItemByName(unpack(BC.ListToTable(msg)))
end

-- mount up.
SLASH_BCMOUNT1 = '/mount'
function SlashCmdList.BCMOUNT()
	BC.Mount()
end

-- removes buff.
SLASH_BCUNBUFF1 = '/unbuff'
function SlashCmdList.BCUNBUFF(buffName)
	BC.RemoveBuffByName(buffName)
end