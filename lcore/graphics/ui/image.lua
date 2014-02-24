--[[
#id graphics.ui.image
#title UI image
#status production
#version 1.0

#desc An image
]]

local L = (...)
local oop = L:get("utility.oop")
local rectangle_shape = L:get("graphics.ui.rectangle_shape")
local color = L:get("graphics.color")
local image

image = oop:class(rectangle_shape)({
	image = nil,

	_new = function(self, new, image, x, y, w, h)
		new.image = image
		new.x = x or 0
		new.y = y or 0
		new.w = w
		new.h = h

		return new
	end,

	draw = function(self)
		rectangle_shape.draw(self)

		love.graphics.setColor(255, 255, 255)

		if (self.image) then
			if (self.w and self.h) then
				love.graphics.draw(self.image, self.x, self.y, 0, self.w / self.image:getWidth(), self.h / self.image:getHeight())
			else
				love.graphics.draw(self.image, self.x, self.y)
			end
		else
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		end
	end
})

return image