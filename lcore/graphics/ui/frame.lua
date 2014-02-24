--[[
#id graphics.ui.frame
#title UI Frame
#status needs-testing
#version 1.0

#desc Contains other UI elements and controls their draw region
]]

local L = (...)
local oop = L:get("utility.oop")
local rectangle = L:get("graphics.ui.rectangle")
local container = L:get("graphics.ui.container")
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