local AddOnName, AddonTable = ...;
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", 'AceTimer-3.0', 'AceHook-3.0');
AddOn.callbacks = AddOn.callbacks or LibStub("CallbackHandler-1.0"):New(AddOn)
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G

_G.yaCore = {}

yaCore = _G.yaCore

yaCore[1] = AddOn
yaCore[2] = LSM

yaCore[1].Unit = UnitGUID("player")
yaCore[1].Name = UnitName("player")
yaCore[1].Class = select(2, UnitClass("player"))
yaCore[1].Spec = GetSpecialization()
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