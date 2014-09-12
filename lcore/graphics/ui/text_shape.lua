local L, this = ...
this.title = "UI Text Shape"
this.version = "1.0"
this.status = "production"
this.desc = "Provides functionality for handling text."

local lcore = L.lcore
local oop = lcore.utility.oop
local element = lcore.graphics.ui.element
local font = lcore.graphics.font
local label

label = oop:class(element) {
	text = "",
	align = "center", -- {left, center, right}
	valign = "center", -- {top, center, bottom}
	font = nil,
	w = 0,
	h = 0,

	_new = function(self, manager, text, x, y, h, align)
		element._new(self, manager, x, y)

		self.font = font:get(h)
		self.text = text or self.text
		self.align = align or self.align

		self.w = self.font:getWidth(self.text)
		self.h = self.font:getHeight()

		return self
	end,

	_resize = function(self, h)
		self.font = font:get(h)
	end,

	contains = function(self, x, y)
		local w = self.font:getWidth(self.text)
		local h = self.font:getHeight()

		return (x >= self.x and x <= self.x + w and
			y >= self.y and y <= self.y + h)
	end
}

return label