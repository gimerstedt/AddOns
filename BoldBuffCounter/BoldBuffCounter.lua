BBC = {}
BBCConfig = {}
BBCConfig.sound = 1
BBCConfig.scale = 2
BBCConfig.locked = 0
BBCConfig.active = 1
BBCConfig.cap = 24
BBC.prep = "[BoldBuffCounter] "

function BBC.OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("PLAYER_AURAS_CHANGED")
	SlashCmdList["BBC"] = BBC.SlashHandler
	SLASH_BBC1 = "/bbc"
end

function BBC.SlashHandler(arg1)
	local _, _, command, args = string.find(arg1, "(%w+)%s?(.*)")
	if(command) then
		command = strlower(command)
	else
		command = ""
	end
	if(command == "sound") then
		if(args == "on") then
			BBCConfig.sound = 1
			BC.m("Sound enabled.", BBC.prep)
		elseif(args == "off") then
			BBCConfig.sound = 0
			BC.m("Sound disabled.", BBC.prep)
		end
	elseif(command == "lock") then
		if BBCConfig.locked == 1 then
			BBCConfig.locked = 0
			BoldBuffCounterFrameAnchor:Show()
			BoldBuffCounterFrame:EnableMouse("true")
			BC.m("Position unlocked.", BBC.prep)
		else
			BBCConfig.locked = 1
			BoldBuffCounterFrameAnchor:Hide()
			BoldBuffCounterFrame:EnableMouse("false")
			BC.m("Position locked.", BBC.prep)
		end
	elseif(command == "reset") then
		BBCConfig.locked = 0
		BoldBuffCounterFrame:SetScale(2)
		BBCConfig.scale = 2
		BoldBuffCounterFrame:ClearAllPoints()
		BoldBuffCounterFrame:SetPoint("CENTER", "UIParent")
		BC.m("Position reset.", BBC.prep)
	elseif(command == "scale") then
		if(tonumber(args)) then
			local newscale = tonumber(args)
			BBCConfig.locked = 0
			BoldBuffCounterFrame:SetScale(newscale)
			BBCConfig.scale = newscale
			BoldBuffCounterFrame:ClearAllPoints()
			BoldBuffCounterFrame:SetPoint("CENTER", "UIParent")
			BC.m("Scale set to: "..newscale, BBC.prep)
		end
	elseif(command == "cap") then
		if(tonumber(args)) then
			local newcap = tonumber(args)
			BBCConfig.cap = newcap
			BC.m("Buff cap set to: "..newcap, BBC.prep)
		end
	elseif(command == "help") then
		BC.m("Command list:", BBC.prep)
		BC.c("/bbc on/off", BBC.prep)
		BC.m("/bbc sound on/off", BBC.prep)
		BC.c("/bbc scale 1-3", BBC.prep)
		BC.m("/bbc reset", BBC.prep)
		BC.c("/bbc lock", BBC.prep)
		BC.m("/bbc cap 1-32", BBC.prep)
	elseif(command == "on") then
		BoldBuffCounterFrame:Show()
		BBCConfig.active = 1
		BoldBuffCounterFrame:ClearAllPoints()
		BC.m("BoldBuffCounter enabled.", BBC.prep)
	elseif(command == "off") then
		BoldBuffCounterFrame:Hide()
		BBCConfig.active = 0
		BC.m("BoldBuffCounter disabled.", BBC.prep)
	elseif(command == "") then
		if(BoldBuffCounterFrame:IsVisible()) then
			BoldBuffCounterFrame:Hide()
			BC.m("BoldBuffCounter disabled.", BBC.prep)
		else
			BoldBuffCounterFrame:Show()
			BC.m("BoldBuffCounter enabled.", BBC.prep)
		end
	else
		BC.m("Type /bbc help for a command list.", BBC.prep)
	end
end

function BBC.OnEvent(event)
	if BBCConfig.active == 1 then
		if(event == "VARIABLES_LOADED") then
			BoldBuffCounterFrame:SetScale(BBCConfig.scale)
			BoldBuffCounterFrame:Show()
			if BBCConfig.locked == 1 then
				BoldBuffCounterFrameAnchor:Hide()
				BoldBuffCounterFrame:EnableMouse("false")
			else
				BoldBuffCounterFrameAnchor:Show()
				BoldBuffCounterFrame:EnableMouse("true")
			end
		elseif(event == "PLAYER_AURAS_CHANGED" and BoldBuffCounterFrame:IsVisible()) then
			local numBuffs = 0
			local buffIndex, untilCancelled
			local i = 0
			while true do
				buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL")
				if buffIndex < 0 then break end
				i = i + 1
			end

			BoldBuffCounterFrameText:SetText(i)
			
			if i >= BBCConfig.cap then
				if BBCConfig.sound == 1 then
					PlaySoundFile("Interface\\AddOns\\BoldBuffCounter\\beep.mp3")
				end
				BoldBuffCounterFrameText:SetTextColor(1,0,0)
			elseif i > (BBCConfig.cap-3) then
				BoldBuffCounterFrameText:SetTextColor(1,1,0)
			else
				BoldBuffCounterFrameText:SetTextColor(0,1,0)
			end
			
			BoldBuffCounterFrameText:Show()
		end
	end
end