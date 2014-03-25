local L, this = ...
this.title = "UI Rectangle Shape"
this.version = "1.0"
this.status = "production"
this.desc = "Provides facilities identifying a UI element as a rectangle. Does not provide rendering."

local oop = L:get("lcore.utility.oop")
local element = L:get("lcore.graphics.ui.element")
local rectangle_shape

rectangle_shape = oop:class(element)({
	w = 0,
	h = 0,

	_new = function(self, new, manager, x, y, w, h)
		new.manager = manager or new.manager
		new.x = x or 0
		new.y = y or 0
		new.w = w or 0
		new.h = h or 0

		return new
	end,

	contains = function(self, x, y)
		local absx, absy = self.x + self.ox, self.y + self.oy
		return (x > absx and x < absx + self.w and y > absy and y < absy + self.h)
	end
})

return rectangle_shape