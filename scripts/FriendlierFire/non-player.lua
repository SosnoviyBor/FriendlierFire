local storage = require('openmw.storage')
local I = require('openmw.interfaces')

require("scripts.FriendlierFire.logic.combat")
require("scripts.FriendlierFire.logic.ai")

I.Combat.addOnHitHandler(AttackHandler)
local sectionFtP = storage.globalSection('SettingsFriendlierFire_followersToPlayer')

local function onUpdate()
    if not sectionFtP:get("disableSpells") then return end
    UpdateSpells()
end

return {
    engineHandlers = {
        onUpdate = onUpdate,
    },
    eventHandlers = {
        StopAttackingLeader = StopAttackingLeader,
    },
}