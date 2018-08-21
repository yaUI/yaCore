local AddOnName, AddonTable = ...;
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", 'AceHook-3.0');
AddOn.callbacks = AddOn.callbacks or LibStub("CallbackHandler-1.0"):New(AddOn)
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G

_G.vCore = {}

vCore = _G.vCore

vCore[1] = AddOn
vCore[2] = LSM

vCore[1].Unit = UnitGUID("player")
vCore[1].Name = UnitName("player")
vCore[1].Class = select(2, UnitClass("player"))
vCore[1].Race = select(2, UnitRace("player"))
vCore[1].Level = UnitLevel("player")
vCore[1].Client = GetLocale()
vCore[1].Realm = GetRealmName()
vCore[1].Resolution = GetCVar("gxWindowedResolution")
vCore[1].Color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[vCore[1].Class]
vCore[1].Version = GetAddOnMetadata(AddOnName, "Version")
vCore[1].ScreenHeight = tonumber(string.match(vCore[1].Resolution, "%d+x(%d+)"))
vCore[1].ScreenWidth = tonumber(string.match(vCore[1].Resolution, "(%d+)x+%d"))
vCore[1].VersionNumber = tonumber(vCore[1].Version)
vCore[1].WoWPatch, vCore[1].WoWBuild, vCore[1].WoWPatchReleaseDate, vCore[1].TocVersion = GetBuildInfo()

local function update()
	local spec_id = GetSpecialization()
	if (spec_id and GetSpecializationInfo(spec_id)) then
		vCore[1].Spec = string.lower(select(2, GetSpecializationInfo(spec_id)))
		vCore[1].Role = string.lower(select(6, GetSpecializationInfo(spec_id)))
	end
end

local roleupdate = CreateFrame("frame",nil)
roleupdate:RegisterEvent("LFG_ROLE_UPDATE")
roleupdate:RegisterEvent("PLAYER_ROLES_ASSIGNED")
roleupdate:RegisterEvent("ROLE_CHANGED_INFORM")
roleupdate:RegisterEvent("PVP_ROLE_UPDATE")
roleupdate:SetScript("OnEvent", update)

update()