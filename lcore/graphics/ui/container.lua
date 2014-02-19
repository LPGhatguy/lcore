--[[
#id graphics.ui.container
#title UI Container
#status needs-testing
#version 1.0

#desc Holds other UI objects so they can work their magic.
]]

local L = (...)
local oop = L:get("utility.oop")
local gcore = L:get("graphics.core")
local container

container = oop:class(rectangle)({
	children = {},

	add = function(self, item)
		local id = #self.children + 1

		self.children[id] = item
		return id
	end,

	remove = function(self, id)
		if (self.children[id]) then
			self.children[id] = nil
			return true
		else
			return false
		end
	end,

	draw = function(self)
		gcore:translate(self.x, self.y)
		for index, item in next, self.children do
			item:draw()
		end
		gcore:translate(-self.x, -self.y)
	end
})

return container