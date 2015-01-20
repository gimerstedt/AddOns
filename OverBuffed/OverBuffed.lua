OverBuffedStatus_PlaySound = 1;
OverBuffedStatus_Scale = 2;
OverBuffedStatus_Locked = 0;
OverBuffedStatus_Active = 1;

function OverBuffed_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	SLASH_OverBuffed1 = "/obuff";
	SlashCmdList["OverBuffed"] = OverBuffed_SlashHandler;
end

function OverBuffed_SlashHandler(arg1)
	local _, _, command, args = string.find(arg1, "(%w+)%s?(.*)");
	if(command) then
		command = strlower(command);
	else
		command = "";
	end
	if(command == "sound") then
		if(args == "on") then
			OverBuffedStatus_PlaySound = 1;
			OverBuffed_Print("|cFFFF9955Sound:|r |cFFFFFF00On|r.");
		elseif(args == "off") then
			OverBuffedStatus_PlaySound = 0;
			OverBuffed_Print("|cFFFF9955Sound:|r |cFFFFFF00Off|r.");
		end
	elseif(command == "lock") then
		OverBuffedStatus_Locked = 1;
		OverBuffedFrameAnchor:Hide();
		OverBuffedFrame:EnableMouse("false");
		OverBuffed_Print("|cFFFF9955Position:|r |cFFFFFF00Locked|r.");
	elseif(command == "unlock") then
		OverBuffedStatus_Locked = 0;
		OverBuffedFrameAnchor:Show();
		OverBuffedFrame:EnableMouse("true");
		OverBuffed_Print("|cFFFF9955Position:|r |cFFFFFF00Unlocked|r.");
	elseif(command == "reset") then
		OverBuffedStatus_Locked = 0;
		OverBuffedFrame:SetScale(2);
		OverBuffedStatus_Scale = 2;
		OverBuffedFrame:ClearAllPoints();
		OverBuffedFrame:SetPoint("CENTER", "UIParent");
		OverBuffed_Print("|cFFFF9955Position:|r |cFFFFFF00Reset|r.");
	elseif(command == "scale") then
		if(tonumber(args)) then
			local newscale = tonumber(args);
			OverBuffedStatus_Locked = 0;
			OverBuffedFrame:SetScale(newscale);
			OverBuffedStatus_Scale = newscale;
			OverBuffedFrame:ClearAllPoints();
			OverBuffedFrame:SetPoint("CENTER", "UIParent");
			OverBuffed_Print("|cFFFF9955Scale:|r |cFFFFFF00"..newscale.."|r.");
		end
	elseif(command == "help") then
		OverBuffed_Print("Command List:");
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff on/off", 0.988, 0.819, 0.086);
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff sound on/off", 0.988, 0.819, 0.086);
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff scale 1..3", 0.988, 0.819, 0.086);
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff reset", 0.988, 0.819, 0.086);
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff lock", 0.988, 0.819, 0.086);
		DEFAULT_CHAT_FRAME:AddMessage("     /obuff unlock", 0.988, 0.819, 0.086);
		OverBuffed_Print("Command List.");
	elseif(command == "on") then
		OverBuffedFrame:Show();
		OverBuffedStatus_Active = 1;
		OverBuffedFrame:ClearAllPoints();
		OverBuffed_Print("|cFFFF9955OverBuffed:|r |cFFFFFF00On|r.");
	elseif(command == "off") then
		OverBuffedFrame:Hide();
		OverBuffedStatus_Active = 0;
		OverBuffed_Print("|cFFFF9955OverBuffed:|r |cFFFFFF00Off|r.");
	elseif(command == "") then
		if(OverBuffedFrame:IsVisible()) then
			OverBuffedFrame:Hide();
			OverBuffed_Print("|cFFFF9955OverBuffed:|r |cFFFFFF00Off|r.");
		else
			OverBuffedFrame:Show();
			OverBuffed_Print("|cFFFF9955OverBuffed:|r |cFFFFFF00On|r.");
		end
	else
		OverBuffed_Print("Type /obuff help for a command list.");
	end
end

function OverBuffed_OnEvent(event)
	if OverBuffedStatus_Active == 1 then
		if(event == "VARIABLES_LOADED") then
			OverBuffedFrame:SetScale(OverBuffedStatus_Scale);
			OverBuffedFrame:Show();
			if OverBuffedStatus_Locked == 1 then
				OverBuffedFrameAnchor:Hide();
				OverBuffedFrame:EnableMouse("false");
			else
				OverBuffedFrameAnchor:Show();
				OverBuffedFrame:EnableMouse("true");
			end
		elseif(event == "PLAYER_AURAS_CHANGED" and OverBuffedFrame:IsVisible()) then
			local numBuffs = 0
			local buffIndex, untilCancelled
			local i = 0
			while true do
				buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL")
				if buffIndex < 0 then break end
				i = i + 1
			end

			OverBuffedFrameText:SetText(i);
			
			if i > 31 then
				if OverBuffedStatus_PlaySound == 1 then
					PlaySoundFile("Interface\\AddOns\\OverBuffed\\beep.mp3");
				end
				OverBuffedFrameText:SetTextColor(1,0,0);
			elseif i > 28 then
				OverBuffedFrameText:SetTextColor(1,1,0);
			else
				OverBuffedFrameText:SetTextColor(0,1,0);
			end
			
			if i < 19 then
				OverBuffedFrameText:Hide();
			else
				OverBuffedFrameText:Show();
			end
		end
	end
end

function OverBuffed_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("<OverBuffed> "..msg, 0.988, 0.819, 0.086);
end