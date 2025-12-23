local I = require('openmw.interfaces')
local self = require('openmw.self')
local types = require('openmw.types')

function FollowsPlayer(player)
    local followedActor
    I.AI.forEachPackage(function (pkg)
        if pkg.type == "Follow" then
            followedActor = pkg.target
            return
        end
    end)

    local isSummon = string.find(self.recordId, "_summon$")
        or string.find(self.recordId, "_summ$")
    if isSummon then
        return StopAttackingLeader({ target = followedActor })
    end

    return followedActor == player
end

local function AttackPlayerFilter(pkg)
    return not (pkg.type == "Combat" and pkg.target.type == types.Player)
end

function StopAttackingLeader(data)
    if AttackPlayerFilter({ type = "Combat", target = data.target }) then
        return false
    end

    if FollowsPlayer(data.target) then
        I.AI.filterPackages(AttackPlayerFilter)
        return true
    else
        return false
    end
end