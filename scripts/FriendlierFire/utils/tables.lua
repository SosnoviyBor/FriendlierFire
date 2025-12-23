--- Returns elements that are in listA but not in listB
--- @param listA table
--- @param listB table
--- @return table
function ListDifference(listA, listB)
    local result = {}

    -- build lookup set for B
    local lookup = {}
    for _, v in pairs(listB) do
        lookup[v] = true
    end

    -- collect values from A not in B
    for _, v in pairs(listA) do
        if not lookup[v] then
            result[#result + 1] = v
        end
    end

    return result
end

function ShallowCopy(from, to)
    for k, v in pairs(from) do
        to[k] = v
    end
end

---Check if both tables have same values
---@param t1 table
---@param t2 table
---@return boolean
function TablesAreSame(t1, t2)
    if #t1 ~= #t2 then return false end
    for k, v in pairs(t1) do
        if t2[k] ~= v then return false end
    end
    for k, v in pairs(t2) do
        if t1[k] ~= v then return false end
    end
    return true
end