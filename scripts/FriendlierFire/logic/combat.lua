local self = require('openmw.self')
local types = require('openmw.types')
local storage = require('openmw.storage')
local I = require('openmw.interfaces')

local selfToSettings = {
    [types.Player]   = storage.globalSection('SettingsFriendlierFire_followersToPlayer'),
    [types.NPC]      = storage.globalSection('SettingsFriendlierFire_playerToFollowers'),
    [types.Creature] = storage.globalSection('SettingsFriendlierFire_playerToFollowers'),
}

function AttackHandler(attack)
    local state = I.FollowerDetectionUtil.getState()
    local followsPlayer = state.followsPlayer
    local isPlayer = self.type == types.Player
    if not (followsPlayer or isPlayer) then return end

    local settings = selfToSettings[self.type]

    if attack.successful then
        attack.damage.health = (attack.damage.health or 0) * settings:get("hpDamageMultiplier")
        attack.damage.fatigue = (attack.damage.fatigue or 0) * settings:get("fatDamageMultiplier")
        attack.damage.magicka = (attack.damage.magicka or 0) * settings:get("magDamageMultiplier")
    end
end
