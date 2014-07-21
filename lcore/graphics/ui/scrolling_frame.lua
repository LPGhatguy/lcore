local L, this = ...
this.title = "Scrolling UI Frame"
this.version = "1.0"
this.status = "production"
this.desc = "Contains other UI elements, draws a background, and scrolls!"

local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local gcore = L:get("lcore.graphics.core")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local container = L:get("lcore.graphics.ui.container")
local frame = L:get("lcore.graphics.ui.frame")
local scrollbar = L:get("lcore.graphics.ui.scrollbar")
local platform = L:get("lcore.platform.interface")
local graphics = platform.graphics
local scrolling_frame

scrolling_frame = oop:class(frame) {
	wheel_lines = 10,
	child_manager = nil,
	scrollbar_horizontal = nil,
	scrollbar_vertical = nil,
	scroll_x = 0,
	scroll_y = 0,
	padding_x = 0,
	padding_y = 0,
	clips_children = true,

	_connect = function(self, manager)
		frame._connect(self, manager)

		manager:hook({"mousepressed", "mousereleased", "update"}, self)
	end,

	_new = function(base, self, manager, x, y, w, h)
		frame._new(base, self, manager, x, y, w, h)

		self.child_manager = event:new()

		self.scrollbar_vertical = scrollbar:new(self.child_manager, w - scrollbar.size, 0, h - scrollbar.size)
		self.scrollbar_horizontal = scrollbar:new(self.child_manager, 0, h - scrollbar.size, w - scrollbar.size, true)

		local x1, y1, x2, y2 = self:bounding_box()

		self.scrollbar_vertical.content_size = y2
		self.scrollbar_horizontal.content_size = x2

		self.scrollbar_vertical.value_changed = function(this)
			self.scroll_y = this.value * this.content_size
		end

		self.scrollbar_horizontal.value_changed = function(this)
			self.scroll_x = this.value * this.content_size
		end

		return self
	end,

	add = function(self, ...)
		frame.add(self, ...)

		local x1, y1, x2, y2 = self:bounding_box()
		self.scrollbar_vertical.content_size = y2
		self.scrollbar_horizontal.content_size = x2

		self.scrollbar_vertical:content_resized()
		self.scrollbar_horizontal:content_resized()
	end,

	fire = function(self, ...)
		frame.fire(self, ...)
		self.child_manager:fire(...)
	end,

	mousepressed = function(self, x, y, button)
		self:fire("mousepressed", x, y, button)

		local sv = self.scrollbar_vertical

		if (button == "wd") then
			sv.handle.y = math.max(sv.handle.y_min, math.min(sv.handle.y_max, sv.handle.y + self.wheel_lines))
			sv.value = (sv.handle.y - sv.handle.y_min) / sv.handle.y_max
			sv:value_changed()
		elseif (button == "wu") then
			sv.handle.y = math.max(sv.handle.y_min, math.min(sv.handle.y_max, sv.handle.y - self.wheel_lines))
			sv.value = (sv.handle.y - sv.handle.y_min) / sv.handle.y_max
			sv:value_changed()
		end
	end,

	draw = function(self)
		rectangle.draw(self)

		gcore:translate(-self.scroll_x, -self.scroll_y)
		if (self.clips_children) then
			graphics.scissor(self.x + self.ox, self.y + self.oy, self.w, self.h)
		end

		container.draw(self)
		graphics.scissor()
		gcore:translate(self.scroll_x, self.scroll_y)

		gcore:translate(self.x, self.y)
		self.child_manager:fire("draw")
		gcore:translate(-self.x, -self.y)
	end
}

return scrolling_frame