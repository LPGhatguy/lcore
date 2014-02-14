--[[
#id graphics.ui.draggable
#title Draggable Superclass
#status needs-testing
#version 1.0

#desc Enables draggable functionality.
]]

local L = (...)
local oop = L:get("utility.oop")
local event = L:get("utility.event")
local rectdraggable

rectdraggable = oop:class()({
	sx = 0,
	sy = 0,
	smx = 0,
	smy = 0,

	dragging = false,
	buttons = {["l"] = true},

	_new = function(self, new)
		event:hook("mousepressed", new)
		event:hook("mousereleased", new)
		event:hook("update", new)

		return new
	end,

	_destroy = function(self)
		event:unhook(self)
	end,

	mousepressed = function(self, x, y, button)
		if (self.buttons[button]) then
			if (self:contains(x, y)) then
				self.dragging = true

				self.sx = self.x
				self.sy = self.y
				self.smx = x
				self.smy = y

				self:drag_start()
			end
		end
	end,

	mousereleased = function(self, mx, my, button)
		if (self.dragging) then
			self.x = self.sx + (mx - self.smx)
			self.y = self.sy + (my - self.smy)
			self.dragging = false

			self:drag_end()
		end
	end,

	update = function(self, delta)
		if (self.dragging) then
			local mx, my = love.mouse.getPosition()
			self.x = self.sx + (mx - self.smx)
			self.y = self.sy + (my - self.smy)
		end
	end,

	drag_start = function(self)
	end,

	drag_end = function(self)
	end
})

return rectdraggable