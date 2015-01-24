-- BoldCommon
BC = {}
BC_PREP = "[BoldCommon] "

-- info command
SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = '/boldcommon', '/bc'
function SlashCmdList.BOLDCOMMON()	
	BC.m("/ctri - /cthunrunin", BC_PREP, 1, 1, 0.3)
	BC.m("Generates a run in order and writes it in /party.", BC_PREP)
	BC.m("/ri - /resetinstances", BC_PREP, 1,1,0,3)
	BC.m("Resets instances.", BC_PREP)
	BC.m("/cdb - /checkdebuffs", BC_PREP, 1,1,0,3)
	BC.m("Reports missing debuffs on target to /raid.", BC_PREP)
	BC.m("/rmic - /raidmembersincombat", BC_PREP, 1,1,0,3)
	BC.m("Reports raid members in combat in /raid.", BC_PREP)
	BC.m("/cc (hitRate) - /critcap (hitRate)", BC_PREP, 1,1,0,3)
	BC.m("Reports your crit cap based on the hitRate input.", BC_PREP)
	BC.m("/cbot - /checkbuffsontarget", BC_PREP, 1,1,0,3)
	BC.m("Reports all buffs on target.", BC_PREP)
	BC.m("/grn - /getraidmembernames", BC_PREP, 1,1,0,3)
	BC.m("List all raid members in a frame for copy/paste.", BC_PREP)
	BC.m("/ss", BC_PREP, 1,1,0,3)
	BC.m("Sit/stand up repeatedly for no good reason.", BC_PREP)
end

-- automatic cthun run in order
SLASH_CTHUNRUNIN1, SLASH_CTHUNRUNIN2 = '/ctri', '/cthunrunin'
function SlashCmdList.CTHUNRUNIN()
	GenerateCthunRunInOrder()
end

-- reload ui
SLASH_RLUI1 = '/rl'
function SlashCmdList.RLUI()
	ReloadUI()
end

-- reset instances
SLASH_RESETINSTANCES1, SLASH_RESETINSTANCES2 = '/ri', '/resetinstances'
function SlashCmdList.RESETINSTANCES()
	ResetInstances()
end

-- report missing debuffs on target
SLASH_CHECKDEBUFFS1, SLASH_CHECKDEBUFFS2 = '/cdb', '/checkdebuffs'
function SlashCmdList.CHECKDEBUFFS()
	ReportMissingDebuffsOnTarget()
end

-- check raid for members in combat
SLASH_RAIDMEMBERSINCOMBAT1, SLASH_RAIDMEMBERSINCOMBAT2 = '/rmic', '/raidmembersincombat'
function SlashCmdList.RAIDMEMBERSINCOMBAT()
	ReportPlayersInCombat()
end

-- only relevant for DW melee
SLASH_CRITCAP1, SLASH_CRITCAP2 = '/cc', '/critcap'
function SlashCmdList.CRITCAP(msg)
	ReportCritCap(msg)
end

-- check buffs on target
SLASH_CHECKBUFFSONTARGET1, SLASH_CHECKBUFFSONTARGET2 = '/cbot', '/checkbuffsontarget'
function SlashCmdList.CHECKBUFFSONTARGET()
	ReportBuffsOnTarget()
end

-- put raid members in a list for copy/paste
SLASH_GETRAIDMEMBERNAMES1, SLASH_GETRAIDMEMBERNAMES2 = '/grn', '/getraidmembernames'
function SlashCmdList.GETRAIDMEMBERNAMES()
	ReportRaidMemberNames()
end

-- sitstand
SLASH_SITSTAND1 = '/ss'
function SlashCmdList.SITSTAND()
	TeaBag()
end