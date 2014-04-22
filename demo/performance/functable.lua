--[[
Usage: require("demo.performance.functable")

Compares performance of a vanilla Lua function chain with an LCORE functable object.
]]

local L = require("lcore.core")
local functable = L:get("lcore.utility.functable")
local stopwatch = L:get("lcore.debug.stopwatch")
local iterations = 1000000

local part_one = function()
	return 7 + 7
end

local part_two = function()
	return 8 + 8
end

local part_three = function()
	return 9 + 9
end

local regular = function()
	part_one()
	part_two()

	return part_three()
end

local revolution = functable:new(part_one, part_two, part_three)

print("Function result: " .. regular())
print("Functable result: " .. revolution())
print("(these results should be the same)\n")

stopwatch:begin("function_create")
for index = 1, iterations do
	local test = function()
		part_one()
		part_two()

		return part_three()
	end
end
stopwatch:finish("function_create")

stopwatch:begin("function_execute")
for index = 1, iterations do
	regular()
end
stopwatch:finish("function_execute")

stopwatch:begin("functable_create")
for index = 1, iterations do
	local test = functable:new(part_one, part_two, part_three)
end
stopwatch:finish("functable_create")

stopwatch:begin("functable_execute")
for index = 1, iterations do
	revolution()
end
stopwatch:finish("functable_execute")

print(([[
For %d iterations:

VANILLA FUNCTION
create: %gms
execute: %gms

LCORE FUNCTABLE
create: %gms
execute %gms

Which means:
create: lcore is %d%% slower
execute: lcore is %d%% slower
]]):format(
	iterations,
	stopwatch:time("function_create") * 1000,
	stopwatch:time("function_execute") * 1000,
	stopwatch:time("functable_create") * 1000,
	stopwatch:time("functable_execute") * 1000,

	-100 + 100 * stopwatch:time("functable_create") / stopwatch:time("function_create"),
	-100 + 100 * stopwatch:time("functable_execute") / stopwatch:time("function_execute")
))