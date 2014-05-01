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

	_new = function(base, self, manager, x, y, w, h)
		self = element._new(base, self, manager, x, y)
		
		self.w = w or base.w
		self.h = h or base.w

		return self
	end,

	resize = function(self, w, h)
		self.w = w or self.w
		self.h = h or self.h

		if (self._resize) then
			self:_resize()
		end
	end,

	_resize = function(self)
	end,

	contains = function(self, x, y)
		local absx, absy = self.x + self.ox, self.y + self.oy
		return (x >= absx and x <= absx + self.w and y >= absy and y <= absy + self.h)
	end
})

return rectangle_shape