--[[
Usage: require("demo.color_picker")

Shows off use of the built-in color picker object
]]

local L = require("lcore.core")
local event = L:get("lcore.service.event")
local color_picker = L:get("lcore.graphics.ui.complex.color_picker")
local platform = L:get("lcore.platform.interface")

color_picker:new(event.global, 50, 50, 600, 480)

platform:init()