--[[
#id graphics.ui.circle
#title UI Circle
#status production
#version 1.0

#desc A circle with a border
]]

local L = (...)
local oop = L:get("utility.oop")
local color = L:get("graphics.color")
local circle_shape = L:get("graphics.ui.circle_shape")
local circle

circle = oop:class(circle_shape)({
	background_color = color:get("darkgray"),
	border_color = color:get("silver"),
	border_width = 2,

	_new = function(self, new, x, y, r)
		new.x = x or 0
		new.y = y or 0
		new.r = r or 0

		return new
	end,

	draw = function(self)
		circle_shape.draw(self)

		local bw = self.border_width
		local hw = bw / 2
		love.graphics.setLineWidth(bw)
		love.graphics.setColor(self.border_color)
		love.graphics.circle("line", self.x, self.y, self.r + bw)

		love.graphics.setColor(self.background_color)
		love.graphics.circle("fill", self.x, self.y, self.r)
	end
})

return circle