--[[
#id graphics.ui.rectangle_shape
#title UI Rectangle Superclass
#status production
#version 1.0

#desc The mother of all rectangular UI elements.
]]

local L = (...)
local oop = L:get("utility.oop")
local element = L:get("graphics.ui.element")
local rectangle_shape

rectangle_shape = oop:class(element)({
	w = 0,
	h = 0,

	_new = function(self, new, x, y, w, h)
		new.x = x or 0
		new.y = y or 0
		new.w = w or 0
		new.h = h or 0

		return new
	end,

	contains = function(self, x, y)
		local absx, absy = self.x + self.ox, self.y + self.oy
		return (x > absx and x < absx + self.w and y > absy and y < absy + self.h)
	end
})

return rectangle_shape