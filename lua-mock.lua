--- @classmod lua-mock
--- Wraps all modules.
local pathOfThisFile = (...):match("(.-)[^%.]+$")
local Spy = require(pathOfThisFile..'src.test.mock.Spy')
local Mock = require(pathOfThisFile..'src.test.mock.Mock')

local M = {}

M.Spy = Spy
M.Mock = Mock

return M
