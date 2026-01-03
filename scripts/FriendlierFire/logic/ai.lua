local I = require('openmw.interfaces')
local self = require("openmw.self")
local types = require('openmw.types')
local storage = require('openmw.storage')

local sectioOther = storage.globalSection('SettingsFriendlierFire_other')

local function AttackPlayerFilter(pkg)
    return not (pkg.type == "Combat" and pkg.target.type == types.Player)
end

local function stopAttackingPlayer(data)
    if AttackPlayerFilter({ type = "Combat", target = data.target }) then
        return
    end

    local state = I.FollowerDetectionUtil.getState()
    if state.followsPlayer then
        I.AI.filterPackages(AttackPlayerFilter)
        -- print("Friendlier Fire: Stopped attacking ".. self.recordId .."'s leader.")
    end
end
function StopAttackingOtherFollower(data)
    I.AI.filterPackages(function (pkg)
        return not (pkg.type == "Combat" and pkg.target.id == data.sender.id)
    end)
end

function TargetChanged(data)
    if not sectioOther:get("disableAggro") then return end
    stopAttackingPlayer(data)
    data.target:sendEvent("CheckIfTargetFollowsPlayer", { sender = self })
end
