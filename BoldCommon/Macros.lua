function BC.MakeMacro(name, macro, perCharacter, macroIconTexture, iconIndex, replace, show, noCreate, replaceMacroIndex, replaceMacroName)
	local globalorlocal = "global"
	local macroindex = replaceMacroIndex or GetMacroIndexByName(name) or 0
	local macroiconIndex = iconIndex or 1
	if not iconIndex and macroIconTexture then
		local mi = BC.GiveMacroiconIndex(macroIconTexture)
		if mi then
			macroiconIndex = mi
		end
	end
	if not replaceMacroIndex and not (macroindex > 0) then
		if not noCreate then
			if name then
				local numglobal, numperchar = GetNumMacros()
				local pc = 0
				local num = numglobal
				if perCharacter == 1 then
					pc = 1
					num = numperchar
					globalorlocal = "per character"
				end
				if num < 18 then
					CreateMacro(name, macroiconIndex, macro, 1, pc)
					macroindex = GetMacroIndexByName(name)
					if macroindex > 0 then
						if show then BC.m("Created  '"..name.."'  macro in "..globalorlocal.." index: "..macroindex, BC.prep) end
						return true
					end
				elseif name then
					if show then BC.m("No "..globalorlocal.." macro spaces left to create  '"..name.."'  macro!", BC.prep) end
				else
					if show then BC.m("No "..globalorlocal.." macro spaces left to create macro!", BC.prep) end
				end
			end
		end
	elseif macroindex > 0 then
		if replace or replaceMacroIndex then
			if replaceMacroName then
				EditMacro(macroindex, name, macroiconIndex, macro, 1)
				if name then
					if show then BC.m("Replaced  '"..name.."'  macro in index: "..macroindex, BC.prep) end
				else
					if show then BC.m("Replaced macro in index: "..macroindex, BC.prep) end
				end
			else
				EditMacro(macroindex, nil, macroiconIndex, macro, 1)
				if name then
					if show then BC.m("Replaced  '"..name.."'  macro in index: "..macroindex, BC.prep) end
				else
					if show then BC.m("Replaced macro in index: "..macroindex, BC.prep) end
				end
			end
		elseif name then
			if show then BC.m("Found  '"..name.."'  macro in index: "..macroindex, BC.prep) end
		else
			if show then BC.m("Found macro in index: "..macroindex, BC.prep) end
		end
		return true
	end
	return false
end

function BC.GiveMacroiconIndex(texture)
	for i = 1, GetNumMacroIcons() do
		if (string.find(GetMacroIconInfo(i), texture)) then
			if BC.debug then BC.m("Macro Icon Index#"..i.." for texture:"..texture, BC.prep) end
			return i
		end
	end
	if BC.debug then BC.m("Macro Icon Index# not found for texture:"..texture, BC.prep) end
	return nil
end