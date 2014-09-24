local L, this = ...
this.title = "RGBA Color Object"
this.version = "1.0"
this.status = "production"
this.desc = "Provides a standardized color object"

local lcore = L.lcore
local oop = lcore.utility.oop
local color4

color4 = oop:class() {
	r = 0,
	g = 0,
	b = 0,
	a = 255,

	_new = function(self, r, g, b, a)
		self.r = r or self.r
		self.g = g or self.g
		self.b = b or self.b
		self.a = a or self.a
	end
}

return color4