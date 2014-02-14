--[[
#id graphics.ui.element
#title Element Superclass
#status production
#version 1.1

#desc The mother of all UI elements.
]]

local L = (...)
local oop = L:get("utility.oop")
local gcore = L:get("graphics.core")
local element

element = oop:class()({
	x = 0,
	y = 0,
	ox = 0,
	oy = 0,

	draw = function(self)
		self.ox = gcore.x
		self.oy = gcore.y
	end,

	contains = function(self, x, y)
		return true
	end
})

return element