local L, this = ...
this.title = "Graphics Core"
this.version = "1.0.1"
this.status = "production"
this.desc = "Provides core graphics methods for global interaction between graphics components."

local lcore = L.lcore
local platform = lcore.platform.interface
local graphics = platform.graphics
local core

core = {
	x = 0,
	y = 0,

	translate = function(self, x, y)
		x = x or 0
		y = y or 0

		self.x = self.x + x
		self.y = self.y + y
		graphics.translate(x, y)
	end,

	origin = function(self)
		graphics.origin()
		self.x = 0
		self.y = 0
	end,

	mouse_position = function(self)
		local mx, my = love.mouse.getPosition()
		return mx - self.x, my - self.y
	end
}

return core