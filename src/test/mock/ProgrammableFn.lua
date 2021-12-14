--- @classmod ProgrammableFn
--- Creates an easily programmable function for testing purposes.
-- Multiple behaviours can be defined.
-- A behaviour consists of a set of arguments and a set of return values.
-- If the function is called with these arguments it will return the programmed
-- return values.
local pathOfThisFile = (...):match("(.-)[^%.]+$")

local ValueMatcher = require(pathOfThisFile..'ValueMatcher')


local ProgrammableFn = {}
ProgrammableFn.__index = ProgrammableFn

local function traceback()
    local level = 1
    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        if info.what == "C" then   -- is a C function?
            print(level, "C function")
        else   -- a Lua function
            print(string.format("[%s]:%d", info.short_src, info.currentline))
        end
        level = level + 1
    end
end

local function behaviourReturnValues( behaviour )
    local next = behaviour.nextReturnSet

    local returnSet = behaviour.returnSets[next]

    if next < #behaviour.returnSets then
        next = next + 1
    else
        next = 1
    end
    behaviour.nextReturnSet = next

    return table.unpack(returnSet)
end

function ProgrammableFn:__call( ... )
    local behaviour = self:_findMatchingBehaviour({...})
    if not behaviour then
        -- traceback()
        error('No matching behaviour for call '..self.name, 2)
    end
    return behaviourReturnValues(behaviour)
end

function ProgrammableFn:_findMatchingBehaviour( arguments )
    for _,behaviour in ipairs(self.behaviours) do
        if ValueMatcher.matches(arguments, behaviour.arguments) then
            return behaviour
        end
    end
    return nil
end

--- Creates a new behaviour entry or extends to one.
--
-- @param specification
-- The specification is a table, that contains the arguments that must match to
-- trigger this behaviour and the values that will be returned then.
-- Both are optional and can be passed like this:
-- `whenCalled{with={1,2}, thenReturn={3}}`
function ProgrammableFn:whenCalled( specification )
    local arguments = specification.with or {}
    local returnSet = specification.thenReturn or {}

    local behaviour = self:_findMatchingBehaviour(arguments)
    if behaviour then
        table.insert(behaviour.returnSets, returnSet)
    else
        behaviour = {
            arguments = arguments,
            returnSets = { returnSet },
            nextReturnSet = 1
        }
        table.insert(self.behaviours, behaviour)
    end

    return self
end

function ProgrammableFn:reset()
    self.behaviours = {}
    return self
end


return function(name)
    local self = {
        name = name,
        behaviours = {}
    }
    return setmetatable(self, ProgrammableFn)
end
