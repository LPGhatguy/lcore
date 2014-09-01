local L, this = ...
this.title = "UI Scrollbar"
this.version = "1.0"
this.status = "development"
this.desc = "Provides a scrolling bar"

local oop = L:get("lcore.utility.oop")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local frame = L:get("lcore.graphics.ui.frame")
local draggable = L:get("lcore.graphics.ui.draggable")
local rect_button = oop:mix(rectangle, "lcore.graphics.ui.button")
local rect_drag = oop:mix(rectangle, "lcore.graphics.ui.draggable")
local platform = L:get("lcore.platform.interface")
local graphics = platform.graphics
local scrollbar

scrollbar = oop:class(frame) {
	horizontal = false,
	size = 30,
	value = 0,
	content_size = 0,
	scroll_x = 0,
	scroll_y = 0,
	padding_x = 0,
	padding_y = 0,
	clips_children = true,

	content_resized = function(self)
		if (self.horizontal) then
			self.handle.w = self.w * (self.w - self.size * 2) / self.content_size
			self.handle.x_max = self.w - self.size - self.handle.w
		else
			self.handle.h = self.h * (self.h - self.size * 2) / self.content_size
			self.handle.y_max = self.h - self.size - self.handle.h
		end
	end,

	_new = function(self, manager, x, y, o, horizontal)
		local w, h
		if (horizontal) then
			w, h = o, self.size
		else
			w, h = self.size, o
		end

		frame._new(self, manager, x, y, w, h)

		self.horizontal = horizontal

		self.button_minus = rect_button:new(nil, 0, 0, self.size, self.size)

		local handle_size = o * (o - self.size * 2) / self.content_size

		if (horizontal) then
			self.button_plus = rect_button:new(nil, w - self.size, 0, self.size, self.size)

			self.handle = rect_drag:new(nil, self.size, 0, handle_size, self.size)
			self.handle.y_locked = true
			self.handle.x_min = self.size
			self.handle.x_max = w - self.size - handle_size

			self.handle.drag_moved = function(this)
				self.value = (this.x - this.x_min) / this.x_max
				self:value_changed()
			end
		else
			self.button_plus = rect_button:new(nil, 0, h - self.size, self.size, self.size)

			self.handle = rect_drag:new(nil, 0, self.size, self.size, handle_size)
			self.handle.x_locked = true
			self.handle.y_min = self.size
			self.handle.y_max = h - self.size - handle_size

			self.handle.drag_moved = function(this)
				self.value = (this.y - this.y_min) / this.y_max
				self:value_changed()
			end
		end

		self.button_minus.background_color = {255, 50, 50}
		self.button_plus.background_color = {50, 255, 50}
		self.handle.background_color = {50, 50, 255}

		self:add(self.button_minus, self.button_plus, self.handle)

		return self
	end,

	_connect = function(self, manager)
		frame._connect(self, manager)

		manager:hook({"mousepressed", "mousereleased", "update"}, self)
	end,

	value_changed = function(self)
	end
}

return scrollbar