local E, M = unpack(_G.yaCore);
local lastMsg = nil
local waitTable = {};
local waitFrame = nil;

function E:Wait(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false;
	end

	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable;
			local i = 1;
			while(i<=count) do
				local waitRecord = tremove(waitTable,i);
				local d = tremove(waitRecord,1);
				local f = tremove(waitRecord,1);
				local p = tremove(waitRecord,1);
				if(d>elapse) then
					tinsert(waitTable,i,{d-elapse,f,p});
					i = i + 1;
				else
					count = count - 1;
					f(unpack(p));
				end
			end
		end);
	end
	tinsert(waitTable,{delay,func,{...}});
	return true;
end

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
	if lastMsg ~= ... then
		print('|cff5BAAE3ya|rUI:', ...)
		lastMsg = ...
	end
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
	local skin = CreateFrame("Frame", f:GetName().."_yui", UIParent)
	skin:SetAllPoints(f)
	skin:SetWidth(f:GetWidth())
	skin:SetHeight(f:GetHeight())
	skin:SetFrameStrata("BACKGROUND")
	skin:SetFrameLevel(f:GetFrameLevel() - 1)

	local backdrop = CreateFrame("Frame", nil, skin)
	backdrop:SetPoint("TOPLEFT",-5,5)
	backdrop:SetPoint("BOTTOMRIGHT",5,-5)
	backdrop:SetFrameLevel(f:GetFrameLevel() - 1)

	E:SkinBackdrop(backdrop)

	return skin
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