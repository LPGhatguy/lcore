local L, this = ...
this.title = "UI Image"
this.version = "1.0"
this.status = "production"
this.desc = "Draws an image with an optional background and border."

local oop = L:get("lcore.utility.oop")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local image

image = oop:class(rectangle) {
	image = nil,

	_new = function(self, manager, image, x, y, w, h)
		self = rectangle._new(self, manager, x, y, w, h)
		self.image = image

		return self
	end,

	draw = function(self)
		rectangle.draw(self)

		if (self.image) then
			local iw, ih = self.image:getDimensions()

			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(self.image, self.x, self.y, 0, self.w / iw, self.h / ih)
		end
	end
}

return image