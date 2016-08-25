local E, M = unpack(_G.yaCore);

function E:Kill(object)
    if object.UnregisterAllEvents then
        object:UnregisterAllEvents()
    end
    object.Show = function() return end
    object:Hide()
end

function E:Strip(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Hide()
			else
				region:SetTexture(nil)
			end
		end
	end		
end

function E:Print(...)
	print('|cff5BAAE3ya|rUI:', ...)
end

function E:TableToLuaString(inTable)
	if type(inTable) ~= "table" then
		E:Print("Invalid argument #1 to E:TableToLuaString (table expected)")
		return
	end

	local ret = "{\n";
	local function recurse(table, level)
		for i,v in pairs(table) do
			ret = ret..strrep("    ", level).."[";
			if(type(i) == "string") then
				ret = ret.."\""..i.."\"";
			else
				ret = ret..i;
			end
			ret = ret.."] = ";

			if(type(v) == "number") then
				ret = ret..v..",\n"
			elseif(type(v) == "string") then
				ret = ret.."\""..v:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\"", "\\\"").."\",\n"
			elseif(type(v) == "boolean") then
				if(v) then
					ret = ret.."true,\n"
				else
					ret = ret.."false,\n"
				end
			elseif(type(v) == "table") then
				ret = ret.."{\n"
				recurse(v, level + 1);
				ret = ret..strrep("    ", level).."},\n"
			else
				ret = ret.."\""..tostring(v).."\",\n"
			end
		end
	end

	if(inTable) then
		recurse(inTable, 1);
	end
	ret = ret.."}";

	return ret;
end

function E:SkinFrame(f)
	local overlay = CreateFrame("Frame", f:GetName().."_overlay", UIParent)
	overlay:SetAllPoints(f)
	overlay:SetWidth(f:GetWidth())
	overlay:SetHeight(f:GetHeight())
	overlay:SetFrameStrata("BACKGROUND")
	overlay:SetFrameLevel(f:GetFrameLevel() - 1)

	local backdrop = CreateFrame("Frame", nil, overlay)
	backdrop:SetPoint("TOPLEFT",-5,5)
	backdrop:SetPoint("BOTTOMRIGHT",5,-5)
	backdrop:SetFrameLevel(f:GetFrameLevel() - 1)

	E:SkinBackdrop(backdrop)
end

function E:SkinBackdrop(f)
	f:SetBackdrop({ 
		bgFile = M:Fetch("yaui", "backdrop"), 
		edgeFile = M:Fetch("yaui", "backdropEdge"),
		tile = false,
		tileSize = 0, 
		edgeSize = 5, 
		insets = { 
			left = 5, 
			right = 5, 
			top = 5, 
			bottom = 5,
			},
	});
	
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,0.6)
end