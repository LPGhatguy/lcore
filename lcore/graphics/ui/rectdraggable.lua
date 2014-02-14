--[[
#id graphics.ui.rectdraggable
#title Draggable Rectangle
#status needs-testing
#version 1.0

#desc A draggable rectangle.
]]

local L = (...)
local oop = L:get("utility.oop")
local draggable = L:get("graphics.ui.draggable")
local rectangle = L:get("graphics.ui.rectangle")
local rectdraggable

rectdraggable = oop:class(rectangle, draggable)({
	_new = function(self, new, ...)
		new = rectangle._new(self, new, ...)
		new = draggable._new(self, new, ...)

		return new
	end
})

return rectdraggable