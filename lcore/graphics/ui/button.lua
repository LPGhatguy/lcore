--[[
#id graphics.ui.button
#title Button Superclass
#status needs-testing
#version 1.0

#desc Provides the basis for buttons via clever wiring.
]]

local L = (...)
local oop = L:get("utility.oop")
local event = L:get("utility.event")
local button

button = oop:class()({
	_new = function(self, new)
		event:hook("mousepressed", new)

		return new
	end,

	_destroy = function(self)
		event:unhook(self)
	end,

	mousepressed = function(self, x, y, button)
		if (self:contains(x, y)) then
			self:click(x, y, button)
		end
	end,

	click = function(self, x, y, button)
	end
})

return button