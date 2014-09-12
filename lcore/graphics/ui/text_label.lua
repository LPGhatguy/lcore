local L, this = ...
this.title = "UI Text Label"
this.version = "1.0"
this.status = "production"
this.desc = "Provides functionality for handling text in a box."

local lcore = L.lcore
local oop = lcore.utility.oop
local rectangle = lcore.graphics.ui.rectangle
local font = lcore.graphics.font
local label

label = oop:class(rectangle) {
	text_color = {255, 255, 255},
	text = "",
	align = "center", -- {left, center, right}
	valign = "center", -- {top, center, bottom}
	font = nil,

	_new = function(self, manager, text, x, y, w, h, align)
		rectangle._new(self, manager, x, y, w, h)

		--Approximately fit font to height of button
		--One pt is generally about 75% of a pixel
		self.font = font:get((h or self.h) * 0.75)
		self.text = text or self.text
		self.align = align or self.align

		self.w = w or self.font:getWidth(self.text)
		self.h = h or self.font:getHeight()

		return self
	end,

	draw = function(self)
		rectangle.draw(self)

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.text_color)

		local x, y = self.x, self.y
		local w, h = self.w, self.h

		if (self.valign == "bottom") then
			y = self.y + h - self.font:getHeight()
		elseif (self.valign == "center") then
			y = self.y + h / 2 - self.font:getHeight() / 2
		end

		love.graphics.printf(self.text, x, y, w, self.align)
	end
}

return label