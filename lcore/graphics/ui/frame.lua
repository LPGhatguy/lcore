local L, this = ...
this.title = "UI Frame"
this.version = "1.1"
this.status = "production"
this.desc = "Contains other UI elements and draws a rectangle behind them."

local oop = L:get("lcore.utility.oop")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local container = L:get("lcore.graphics.ui.container")
local platform = L:get("lcore.platform.interface")
local graphics = platform.graphics
local frame

frame = oop:class(rectangle, container) {
	clips_children = true,

	draw = function(self)
		rectangle.draw(self)

		if (self.clips_children) then
			graphics.scissor(self.x + self.ox, self.y + self.oy, self.w, self.h)
		end

		container.draw(self)
		graphics.scissor()
	end
}

return frame