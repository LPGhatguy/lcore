local L, this = ...
this.title = "UI Button Superclass"
this.status = "production"
this.version = "1.0"
this.desc = "Provides button functionality and event hooking for any UI element."

local lcore = L.lcore
local oop = lcore.utility.oop
local event = lcore.service.event
local element = lcore.graphics.ui.element
local button

button = oop:class(element) {
	_connect = function(self, manager)
		manager:hook("mousepressed", self)
	end,

	mousepressed = function(self, x, y, button)
		if (self:contains(x, y)) then
			self:click(x, y, button)
		end
	end,

	click = function(self, x, y, button)
	end
}

return button