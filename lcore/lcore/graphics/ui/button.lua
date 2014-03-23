--[[
#id graphics.ui.button
#title Button Superclass
#status needs-testing
#version 1.0

#desc Provides the basis for buttons via clever wiring.
]]

local L = (...)
local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local button

button = oop:class()({
	_new = function(self, new, manager)
		new.manager = manager or new.manager

		new.manager:hook("mousepressed", new)

		return new
	end,

	_destroy = function(self)
		self.manager:unhook(self)
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