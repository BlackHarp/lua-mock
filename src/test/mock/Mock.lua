--- @classmod Mock
--- Combination of Spy and ProgrammableFn.
-- See @{Spy} and @{ProgrammableFn} for details.
local pathOfThisFile = (...):match("(.-)[^%.]+$")

local ProgrammableFn = require(pathOfThisFile..'ProgrammableFn')
local Spy = require(pathOfThisFile..'Spy')


local Mock = {}
Mock.__index = Mock


function Mock:whenCalled( behaviour )
    self.programmable:whenCalled(behaviour)
    return self
end

function Mock:__call( ... )
    return self.spy(...)
end

function Mock:reset()
    self.spy:reset()
    self.programmable:reset()
    return self.realFunc
end

function Mock:assertCallCount( count )
    self.spy:assertCallCount(count)
    return self
end

function Mock:assertCallMatches( query )
    self.spy:assertCallMatches(query)
    return self
end

function Mock:assertAnyCallMatches( query )
    self.spy:assertAnyCallMatches(query)
    return self
end


return function(wrappedFn, name)
    local programmable = ProgrammableFn(name)
    local spy = Spy(programmable, name)
    local self = {
        realFunc = wrappedFn,
        programmable = programmable,
        spy = spy
    }
    return setmetatable(self, Mock)
end
