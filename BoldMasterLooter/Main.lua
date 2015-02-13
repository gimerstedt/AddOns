BMLB = {}
BMLB.debug = true
BMLB.prep = "[BoldMasterLooter] "
BMLB.victims = {}
BMLB.winners = {}
BMLB.groupSet = false
BMLB.kicked = false
BMLB.group = 0
BMLB.help1 = "1st /meep selects a group (empty if possible, target's if not)."
BMLB.help2 = "2nd /meep kicks selected group's members and moves current target to the now empty group."
BMLB.help3 = "3rd and consecutive /meep moves back old target to original group and moves current target to empty group."
BMLB.help4 = "End ML-session with /meep without someone targeted (will move back to original positions and re-invite)."

SLASH_BMLB1, SLASH_BMLB2 = '/meep', '/bmlb'
function SlashCmdList.BMLB(msg)
	if msg == "help" then
		BC.c("/meep - /mlb", BMLB.prep)
		BC.m(BMLB.help1, BMLB.prep)
		BC.c(BMLB.help2, BMLB.prep)
		BC.m(BMLB.help3, BMLB.prep)
		BC.c(BMLB.help4, BMLB.prep)
	else
		MasterLootBug()
	end
end

SLASH_BMLBRAIDNAMES1, SLASH_BMLBRAIDNAMES2 = '/grn', '/getraidnames'
function SlashCmdList.BMLBRAIDNAMES()
	BMLB.ReportRaidMemberNames()
end