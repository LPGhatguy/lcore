--[[
#id graphics.ui.rectbutton
#title Rectangular Button
#status needs-testing
#version 1.0

#desc A button in the shape of a rectangle.
]]

local L = (...)
local oop = L:get("utility.oop")
local button = L:get("graphics.ui.button")
local rectangle = L:get("graphics.ui.rectangle")
local rectbutton

rectbutton = oop:class(rectangle, button)({
	_new = function(self, new, ...)
		new = rectangle._new(self, new, ...)
		new = button._new(self, new, ...)

		return new
	end
})

return rectbutton