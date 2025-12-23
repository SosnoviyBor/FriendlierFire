local self = require('openmw.self')
local types = require('openmw.types')
local storage = require('openmw.storage')

require("scripts.FriendlierFire.logic.ai")
require("scripts.FriendlierFire.utils.tables")

local activeSpells = {}

local selfToSettings = {
    [types.Player]   = storage.globalSection('SettingsFriendlierFire_followersToPlayer'),
    [types.NPC]      = storage.globalSection('SettingsFriendlierFire_playerToFollowers'),
    [types.Creature] = storage.globalSection('SettingsFriendlierFire_playerToFollowers'),
}

function AttackHandler(attack)
    if not (FollowsPlayer(attack.attacker) or self.type == types.Player) then return end

    local settings = selfToSettings[self.type]

    if attack.successful then
        attack.damage.health = (attack.damage.health or 0) * settings:get("hpDamageMultiplier")
        attack.damage.fatigue = (attack.damage.fatigue or 0) * settings:get("fatDamageMultiplier")
    end
end

function UpdateSpells()
    -- DOESN'T WORK YET
    local currSpells = {}
    ShallowCopy(self.type.activeSpells(self), currSpells)
    print(TablesAreSame(currSpells, activeSpells))
    if TablesAreSame(currSpells, activeSpells) then return end

    local newSpells = ListDifference(currSpells, activeSpells)
    if #newSpells == 0 or not newSpells then
        ShallowCopy(currSpells, activeSpells)
        return
    end

    for _, spell in ipairs(newSpells) do
        -- print("Checking spell:", spell)
        if spell.caster and (self.type == types.Player or FollowsPlayer(spell.caster)) then
            -- print("Removing spell from follower to player:", spell.recordId)
        end
    end
    
    activeSpells = {}
    ShallowCopy(currSpells, activeSpells)
end