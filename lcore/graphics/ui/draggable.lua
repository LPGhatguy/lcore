local L, this = ...
this.title = "Draggable UI Item"
this.version = "1.1"
this.status = "production"
this.desc = "Enables draggable functionality in other UI elements."

local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local draggable

draggable = oop:class() {
	start_x = 0,
	start_y = 0,
	start_mouse_x = 0,
	start_mouse_y = 0,

	draggable = true,
	dragging = false,
	x_locked = false,
	x_max = math.huge,
	x_min = -math.huge,
	y_locked = false,
	y_max = math.huge,
	y_min = -math.huge,
	buttons = {["l"] = true},

	_connect = function(self, manager)
		manager:hook({"mousepressed", "mousereleased", "update"}, self)
	end,

	destroy = function(self)
		self.manager:unhook(self)
	end,

	mousepressed = function(self, x, y, button)
		if (self.draggable and self.buttons[button] and self:contains(x, y)) then
			self.dragging = true

			self.start_x = self.x
			self.start_y = self.y
			self.start_mouse_x = x
			self.start_mouse_y = y

			self:drag_start()
		end
	end,

	mousereleased = function(self, mx, my, button)
		if (self.dragging) then
			self:update(0)

			self.dragging = false
			self:drag_end()
		end
	end,

	update = function(self, delta)
		if (self.dragging) then
			local lx, ly = self.x, self.y

			local mx, my = love.mouse.getPosition()
			if (not self.x_locked) then
				self.x = math.max(self.x_min, math.min(self.x_max, self.start_x + (mx - self.start_mouse_x)))
			end

			if (not self.y_locked) then
				self.y = math.max(self.y_min, math.min(self.y_max, self.start_y + (my - self.start_mouse_y)))
			end

			if (self.x ~= lx or self.y ~= ly) then
				self:drag_moved()
			end
		end
	end,

	drag_moved = function(self)
	end,

	drag_start = function(self)
	end,

	drag_end = function(self)
	end
}

return draggable