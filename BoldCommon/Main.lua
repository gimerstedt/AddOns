-- BoldCommon
BC = {}
BC.debug = true
BC.prep = "[BoldCommon] "

BINDING_HEADER_BC = "BoldCommon"
BINDING_NAME_BC_MOUNT = "Mount up"
BINDING_NAME_BC_TEABAG = "Teabag"

-- info command.
SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = '/boldcommon', '/bc'
function SlashCmdList.BOLDCOMMON()	
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
end

-- automatic cthun run in order.
SLASH_CTHUNRUNIN1, SLASH_CTHUNRUNIN2 = '/ctri', '/cthunrunin'
function SlashCmdList.CTHUNRUNIN()
	GenerateCthunRunInOrder()
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
	ReportMissingDebuffsOnTarget()
end

-- check raid for members in combat.
SLASH_RAIDMEMBERSINCOMBAT1, SLASH_RAIDMEMBERSINCOMBAT2 = '/rmic', '/raidmembersincombat'
function SlashCmdList.RAIDMEMBERSINCOMBAT()
	ReportPlayersInCombat()
end

-- only relevant for DW melee.
SLASH_CRITCAP1, SLASH_CRITCAP2 = '/cc', '/critcap'
function SlashCmdList.CRITCAP(msg)
	ReportCritCap(msg)
end

-- check buffs on target.
SLASH_CHECKBUFFSONTARGET1, SLASH_CHECKBUFFSONTARGET2 = '/cbot', '/checkbuffsontarget'
function SlashCmdList.CHECKBUFFSONTARGET(showTextureNames)
	ReportBuffsOnTarget(showTextureNames)
end

-- put raid members in a list for copy/paste.
SLASH_GETRAIDMEMBERNAMES1, SLASH_GETRAIDMEMBERNAMES2 = '/grn', '/getraidmembernames'
function SlashCmdList.GETRAIDMEMBERNAMES()
	ReportRaidMemberNames()
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
