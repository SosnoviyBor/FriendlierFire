---@diagnostic disable: missing-parameter
local storage = require('openmw.storage')
local self = require("openmw.self")
local I = require('openmw.interfaces')

local settings = storage.globalSection('SettingsFriendlierFire_settings')
local isSummon = string.find(self.recordId, "_summon$")
    or self.recordId == "bonewalker_greater_summ"
-- super early return for summons
if isSummon and not settings:get("protectSummons") then
    return
end

-- blacklisted scripts check
local mwscript = self.type.records[self.recordId].mwscript
if mwscript then
    for _, blacklistedScript in ipairs(settings:get("blacklistedScripts")) do
        if mwscript == blacklistedScript then
            return
        end
    end
end

require("scripts.FriendlierFire.logic.combat")
require("scripts.FriendlierFire.logic.spells")
require("scripts.FriendlierFire.logic.ai")

local isFollower = I.FollowerDetectionUtil.getState().followsPlayer
local activeEffects = self.type.activeEffects(self)

I.Combat.addOnHitHandler(
    function(attack)
        if isFollower and attack.successful and attack.attacker then
            if not settings:get("commandDisablesProtection")
                or (activeEffects:getEffect("commandcreature").magnitude == 0
                    and activeEffects:getEffect("commandhumanoid").magnitude == 0)
            then
                return AttackHandler(attack)
            end
        end
    end
)

local function onUpdate()
    if isFollower and settings:get("disableSpells") then
        if not settings:get("commandDisablesProtection")
            or (activeEffects:getEffect("commandcreature").magnitude == 0
                and activeEffects:getEffect("commandhumanoid").magnitude == 0)
        then
            local newSpells = UpdateActiveSpells()
            RemoveFriendlyHarmfulSpells(newSpells)
        end
    end
end

local function startAIPackage(pkg)
    TargetChanged(pkg)
end

local function updateFollowerStatus(data)
    isFollower = data.followers[self.id]
        and data.followers[self.id].followsPlayer
        or false
end

return {
    engineHandlers = {
        onUpdate = onUpdate,
    },
    eventHandlers = {
        StartAIPackage = startAIPackage,
        FriendlyFire_TargetChanged = TargetChanged,
        FDU_UpdateFollowerList = updateFollowerStatus
    }
}
