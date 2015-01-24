-- BoldLib
BL = {}
BL_PREP = "[BoldLib] "

-- info command
SLASH_BOLDLIB1, SLASH_BOLDLIB2 = '/boldlib', '/bl'
function SlashCmdList.BOLDLIB()	
	BL.m("/ctri - /cthunrunin", BL_PREP, 1, 1, 0.3)
	BL.m("Generates a run in order and writes it in /party.", BL_PREP)
	BL.m("/ri - /resetinstances", BL_PREP, 1,1,0,3)
	BL.m("Resets instances.", BL_PREP)
	BL.m("/cdb - /checkdebuffs", BL_PREP, 1,1,0,3)
	BL.m("Reports missing debuffs on target to /raid.", BL_PREP)
	BL.m("/rmic - /raidmembersincombat", BL_PREP, 1,1,0,3)
	BL.m("Reports raid members in combat in /raid.", BL_PREP)
	BL.m("/cc (hitRate) - /critcap (hitRate)", BL_PREP, 1,1,0,3)
	BL.m("Reports your crit cap based on the hitRate input.", BL_PREP)
	BL.m("/cbot - /checkbuffsontarget", BL_PREP, 1,1,0,3)
	BL.m("Reports all buffs on target.", BL_PREP)
	BL.m("/grn - /getraidmembernames", BL_PREP, 1,1,0,3)
	BL.m("List all raid members in a frame for copy/paste.", BL_PREP)
	BL.m("/ss", BL_PREP, 1,1,0,3)
	BL.m("Sit/stand up repeatedly for no good reason.", BL_PREP)
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