local I = require('openmw.interfaces')
local storage = require('openmw.storage')

require("scripts.FriendlierFire.logic.combat")

I.Combat.addOnHitHandler(AttackHandler)
local sectionPtF = storage.globalSection('SettingsFriendlierFire_playerToFollowers')

local function onUpdate()
    if not sectionPtF:get("disableSpells") then return end
    UpdateSpells()
end

local function targetsChanged(data)
    for _, target in ipairs(data.targets) do
        data.actor:sendEvent("StopAttackingLeader", { target = target })
    end
end

return {
    engineHandlers = {
        onUpdate = onUpdate,
    },
    eventHandlers = {
        OMWMusicCombatTargetsChanged = targetsChanged,
    },
}