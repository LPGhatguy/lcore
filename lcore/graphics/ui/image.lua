local L, this = ...
this.title = "UI Image"
this.version = "1.0"
this.status = "production"
this.desc = "Draws an image with an optional background and border."

local oop = L:get("lcore.utility.oop")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local color = L:get("lcore.graphics.color")
local image

image = oop:class(rectangle)({
	image = nil,

	_new = function(base, self, manager, image, x, y, w, h)
		self = rectangle._new(base, self, manager, x, y, w, h)
		self.image = image

		return self
	end,

	draw = function(self)
		rectangle.draw(self)

		love.graphics.setColor(255, 255, 255)

		if (self.image) then
			if (self.w and self.h) then
				love.graphics.draw(self.image, self.x, self.y, 0, self.w / self.image:getWidth(), self.h / self.image:getHeight())
			else
				love.graphics.draw(self.image, self.x, self.y)
			end
		end
	end
})

return image