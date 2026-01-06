local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")
local core = require("openmw.core")

local function isFriendlyFire(spell, followers)
    if not spell.caster then return false end

    local castByPlayer = spell.caster.type == types.Player
    local castByFollower = followers[spell.caster.id] ~= nil
    local casterIsSelf = spell.caster.id == self.id
    local casterIsFriendly = (castByFollower or castByPlayer) and not casterIsSelf

    local victimIsPlayer = self.type == types.Player
    local victimIsFollower = followers[self.id] ~= nil
    local victimIsFriendly = victimIsFollower or victimIsPlayer

    return casterIsFriendly and victimIsFriendly
end

local function spellIsHarmful(spell)
    for _, effect in pairs(spell.effects) do
        if core.magic.effects.records[effect.id].harmful then
            return true
        end
    end
    return false
end

function UpdateActiveSpells()
    local currActiveSpells = self.type.activeSpells(self)
    local followers = I.FollowerDetectionUtil.getFollowerList()
    local newSpells = {}

    for _, spell in pairs(currActiveSpells) do
        print(self, spell, isFriendlyFire(spell, followers), spellIsHarmful(spell))
        if isFriendlyFire(spell, followers) and spellIsHarmful(spell) then
            table.insert(newSpells, spell)
        end
    end

    return newSpells
end

function RemoveFriendlyHarmfulSpells(newSpells)
    if not next(newSpells) then return end
    
    local activeSpells = self.type.activeSpells(self)
    for _, spell in ipairs(newSpells) do
        activeSpells:remove(spell.activeSpellId)
    end
end