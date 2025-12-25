local I = require('openmw.interfaces')
local self = require('openmw.self')
local types = require('openmw.types')

function FollowsPlayer(player)
    if self.type == types.Player then
        return false
    end

    local followedActor
    I.AI.forEachPackage(function (pkg)
        if pkg.type == "Follow" then
            followedActor = pkg.target
            return
        end
    end)

    local followsPlayer = followedActor == player
    local isSummon = string.find(self.recordId, "_summon$")
        or string.find(self.recordId, "_summ$")

    local isFollowersSummon = false
    if not followsPlayer and isSummon then
        isFollowersSummon = FollowsPlayer(followedActor)
    end

    return followsPlayer or isFollowersSummon
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