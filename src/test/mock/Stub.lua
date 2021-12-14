--- @BlackHarp Stub
--- Stub for Spy.
-- Stub real function to avoid its call
-- See @{Spy} for details.
local pathOfThisFile = (...):match("(.-)[^%.]+$")

local Spy = require(pathOfThisFile..'Spy')


local Stub = {}
Stub.__index = Stub

function Stub:__call( ... )
    return self.spy(...)
end

function Stub:reset()
    self.spy:reset()
    return self
end

function Stub:assertCallCount( count )
    self.spy:assertCallCount(count)
    return self
end

function Stub:assertCallMatches( query )
    self.spy:assertCallMatches(query)
    return self
end

function Stub:assertAnyCallMatches( query )
    self.spy:assertAnyCallMatches(query)
    return self
end

return function(wrappedFn)
    local spy = Spy(wrappedFn, true)
    local self = {
        spy = spy
    }
    return setmetatable(self, Stub)
end
