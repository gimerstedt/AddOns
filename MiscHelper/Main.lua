-- misc helper
MH = {}
MH_PREP = "[MiscHelper] "

-- info command
SLASH_MISCHELPER1, SLASH_MISCHELPER2 = '/mischelper', '/mh'
function SlashCmdList.MISCHELPER()	
	MH.m("/ctri - /cthunrunin", MH_PREP, 1, 1, 0.3)
	MH.m("Generates a run in order and writes it in /party.", MH_PREP)
	MH.m("/ri - /resetinstances", MH_PREP, 1,1,0,3)
	MH.m("Resets instances.", MH_PREP)
	MH.m("/cdb - /checkdebuffs", MH_PREP, 1,1,0,3)
	MH.m("Reports missing debuffs on target to /raid.", MH_PREP)
	MH.m("/rmic - /raidmembersincombat", MH_PREP, 1,1,0,3)
	MH.m("Reports raid members in combat in /raid.", MH_PREP)
	MH.m("/cc (hitRate) - /critcap (hitRate)", MH_PREP, 1,1,0,3)
	MH.m("Reports your crit cap based on the hitRate input.", MH_PREP)
	MH.m("/cbot - /checkbuffsontarget", MH_PREP, 1,1,0,3)
	MH.m("Reports all buffs on target.", MH_PREP)
	MH.m("/grn - /getraidmembernames", MH_PREP, 1,1,0,3)
	MH.m("List all raid members in a frame for copy/paste.", MH_PREP)
	MH.m("/ss", MH_PREP, 1,1,0,3)
	MH.m("Sit/stand up repeatedly for no good reason.", MH_PREP)
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