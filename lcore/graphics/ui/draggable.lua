--[[
#id graphics.ui.draggable
#title Draggable Superclass
#status production
#version 1.1

#desc Enables draggable functionality.
]]

local L, this = ...
this.title = "Draggable UI Item"
this.version = "1.1"
this.status = "production"
this.desc = "Enables draggable functionality in other UI elements."

local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local draggable

draggable = oop:class()({
	sx = 0,
	sy = 0,
	smx = 0,
	smy = 0,

	draggable = true,
	dragging = false,
	buttons = {["l"] = true},

	_new = function(self, new, manager)
		new.manager = manager or new.manager

		new.manager:hook("mousepressed", new)
		new.manager:hook("mousereleased", new)
		new.manager:hook("update", new)

		return new
	end,

	_destroy = function(self)
		self.manager:unhook(self)
	end,

	mousepressed = function(self, x, y, button)
		if (self.draggable and self.buttons[button] and self:contains(x, y)) then
			self.dragging = true

			self.sx = self.x
			self.sy = self.y
			self.smx = x
			self.smy = y

			self:drag_start()
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

return draggable