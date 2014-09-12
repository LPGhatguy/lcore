local L, this = ...
this.title = "UI Rectangle Shape"
this.version = "1.0"
this.status = "production"
this.desc = "Provides facilities identifying a UI element as a rectangle. Does not provide rendering."

local lcore = L.lcore
local oop = lcore.utility.oop
local element = lcore.graphics.ui.element
local rectangle_shape

rectangle_shape = oop:class(element) {
	w = 0,
	h = 0,

	_new = function(self, manager, x, y, w, h)
		element._new(self, manager, x, y)
		
		self.w = w or self.w
		self.h = h or self.h

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
		local absx = self.x + self.ox
		local absy = self.y + self.oy
		return (x >= absx and x <= absx + self.w and y >= absy and y <= absy + self.h)
	end
}

return rectangle_shape