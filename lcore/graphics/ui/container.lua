--[[
#id graphics.ui.container
#title UI Container
#status production
#version 1.1

#desc Holds other UI objects so they can work their magic.
]]

local L = (...)
local oop = L:get("utility.oop")
local element = L:get("graphics.ui.element")
local gcore = L:get("graphics.core")
local container

local child_sorter = function(first, second)
	if (first.z == second.z) then
		return first.x < second.x
	else
		return first.z < second.z
	end
end

container = oop:class(element)({
	children = {},

	add = function(self, item)
		table.insert(self.children, item)
	end,

	remove = function(self, item)
		for key, value in pairs(self.children) do
			if (value == item) then
				self.children[key] = nil
				return true
			end
		end

		return false
	end,

	sort = function(self)
		table.sort(self.children, child_sorter)
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