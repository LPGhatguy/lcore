--[[
#id graphics.ui.frame
#title UI Frame
#status needs-testing
#version 1.0

#desc Contains other UI elements and controls their draw region
]]

local L = (...)
local oop = L:get("lcore.utility.oop")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local container = L:get("lcore.graphics.ui.container")
local frame

frame = oop:class(rectangle, container)({
	clips_children = true,

	draw = function(self)
		rectangle.draw(self)

		if (self.clips_children) then
			love.graphics.setScissor(self.x + self.ox, self.y + self.oy, self.w, self.h)
		end

		container.draw(self)
		love.graphics.setScissor()
	end
})

return frame