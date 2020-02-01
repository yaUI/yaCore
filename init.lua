local AddOnName, AddonTable = ...;
local _G = _G

_G.yaCore = {}

yaCore = _G.yaCore

yaCore[1].Unit = UnitGUID("player")
yaCore[1].Name = UnitName("player")
yaCore[1].Class = select(2, UnitClass("player"))
yaCore[1].Race = select(2, UnitRace("player"))
yaCore[1].Level = UnitLevel("player")
yaCore[1].Client = GetLocale()
yaCore[1].Realm = GetRealmName()
yaCore[1].Resolution = GetCVar("gxWindowedResolution")
yaCore[1].Color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[yaCore[1].Class]
yaCore[1].Version = GetAddOnMetadata(AddOnName, "Version")
yaCore[1].ScreenHeight = tonumber(string.match(yaCore[1].Resolution, "%d+x(%d+)"))
yaCore[1].ScreenWidth = tonumber(string.match(yaCore[1].Resolution, "(%d+)x+%d"))
yaCore[1].VersionNumber = tonumber(yaCore[1].Version)
yaCore[1].WoWPatch, yaCore[1].WoWBuild, yaCore[1].WoWPatchReleaseDate, yaCore[1].TocVersion = GetBuildInfo()

local function update()
	local spec_id = GetSpecialization()
	if (spec_id and GetSpecializationInfo(spec_id)) then
		yaCore[1].Spec = string.lower(select(2, GetSpecializationInfo(spec_id)))
		yaCore[1].Role = string.lower(select(6, GetSpecializationInfo(spec_id)))
	end
end

local roleupdate = CreateFrame("frame",nil)
roleupdate:RegisterEvent("LFG_ROLE_UPDATE")
roleupdate:RegisterEvent("PLAYER_ROLES_ASSIGNED")
roleupdate:RegisterEvent("ROLE_CHANGED_INFORM")
roleupdate:RegisterEvent("PVP_ROLE_UPDATE")
roleupdate:SetScript("OnEvent", update)

update()