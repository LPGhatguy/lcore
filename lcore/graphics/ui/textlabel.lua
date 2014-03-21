--[[
#id graphics.ui.textlabel
#title UI Text Label
#status production
#version 1.0

#desc Draws plaintext with a single style to the screen.
]]

local L = (...)
local oop = L:get("utility.oop")
local color = L:get("graphics.color")
local font = L:get("graphics.font")
local rectangle = L:get("graphics.ui.rectangle")
local label

label = oop:class(rectangle)({
	text_color = color:get("white"),
	text = "",
	align = "center",
	font = nil,

	_new = function(self, new, manager, text, x, y, w, h, align)
		new = rectangle._new(self, new, manager, x, y, w, h)

		new.font = font:get(h)
		new.text = text or new.text
		new.align = align or new.align

		return new
	end,

	draw = function(self)
		rectangle.draw(self)

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.text_color)
		love.graphics.printf(self.text, self.x, self.y, self.w, self.align)
	end
})

return label