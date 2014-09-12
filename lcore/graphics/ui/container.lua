local L, this = ...
this.title = "UI Container"
this.version = "1.1"
this.status = "production"
this.desc = "Holds other UI items and passes draw calls to them."
this.todo = {
}

local lcore = L.lcore
local oop = lcore.utility.oop
local event = lcore.service.event
local element = lcore.graphics.ui.element
local gcore = lcore.graphics.core
local container

local child_sorter = function(first, second)
	if (first.z == second.z) then
		if (first.x == second.x) then
			return first.y < second.y
		else
			return first.x < second.x
		end
	else
		return first.z < second.z
	end
end

container = oop:class(element, event) {
	children = {},

	add = function(self, ...)
		local arg = {...}

		for index, entry in ipairs({...}) do
			table.insert(self.children, entry)

			if (entry.connect) then
				entry:connect(self)
			end
		end

		self:sort()
	end,

	remove = function(self, item)
		for index, child in ipairs(self.children) do
			if (child == item) then
				if (child.connect) then
					child:connect()
				end

				self.children[index] = nil
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
		for index, child in ipairs(self.children) do
			if (child.draw) then
				child:draw()
			end
		end
		gcore:translate(-self.x, -self.y)
	end,

	--Assumes objects to be positioned from their upper-left corner
	--This fails on text_shape objects, sadly, because of their align property
	--It shall be fixed!
	bounding_box = function(self)
		local x1, y1
		local x2, y2
		local sets

		for index, child in ipairs(self.children) do
			local x, y = child.x, child.y
			local w, h = child.w, child.h

			if (x and y) then
				if (sets) then
					x1 = math.min(x1, x)
					y1 = math.min(y1, y)
				else
					sets = true
					x1 = x
					y1 = y
					x2 = x
					y2 = y
				end

				if (w and h) then
					x2 = math.max(x2, x + w)
					y2 = math.max(y2, y + h)
				end
			end
		end

		return x1 or 0, y1 or 0, x2 or 0, y2 or 0
	end
}

return container