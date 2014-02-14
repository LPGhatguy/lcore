--[[
#id graphics.ui.rectangle
#title UI Rectangle
#status production
#version 1.0

#desc A rectangle with a border
]]

local L = (...)
local oop = L:get("utility.oop")
local box = L:get("graphics.ui.box")
local color = L:get("graphics.color")
local rectangle

rectangle = oop:class(box)({
	background_color = color:get("darkgray"),
	border_color = color:get("silver"),
	border_width = 2,

	draw = function(self)
		box.draw(self)

		local bw = self.border_width
		local hw = bw / 2
		love.graphics.setLineWidth(bw)
		love.graphics.setColor(self.border_color)
		love.graphics.rectangle("line", self.x - hw, self.y - hw, self.w + bw, self.h + bw)

		love.graphics.setColor(self.background_color)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
})

return rectangle