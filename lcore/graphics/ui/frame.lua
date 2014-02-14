--[[
#id graphics.ui.frame
#title UI Frame
#status production
#version 1.0

#desc Contains objects within a rectangle-container hybrid.
#desc Essentially a UI container with a drawn bounding box.
]]

local L = (...)
local oop = L:get("utility.oop")
local container = L:get("graphics.ui.container")
local rectangle = L:get("graphics.ui.rectangle")
local frame

frame = oop:class(rectangle, container)({
	draw = function(self)
		rectangle.draw(self)
		container.draw(self)
	end
})

return frame