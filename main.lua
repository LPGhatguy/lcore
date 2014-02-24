--~NODOC
--This file is volatile -- it's the testing code for currently developed features.

local L = require("lcore.core")
local event = L:get("service.event")
local oop = L:get("utility.oop")
local stopwatch = L:get("debug.stopwatch")

local rectdraggable = oop:mix("graphics.ui.rectangle", "graphics.ui.draggable")
local container = L:get("graphics.ui.container")

local draggers = container:new(0, 0, 50, 50)

for index = 1, 10 do
	local mine = rectdraggable:new(50 * index - 50, 50, 50, 50)

	local val = 25.5
	mine.border_color = {0, 0, 0, 0}
	mine.background_color = {val * index, 0, 255 - val * index}

	mine.drag_start = function(self)
		self.z = math.huge

		draggers:sort()
	end

	mine.drag_end = function(self)
		local target_x = math.min(love.window.getWidth(), math.max(0, math.floor(self.x / 50) * 50))
		local target_y = math.min(love.window.getHeight(), math.max(0, math.floor(self.y / 50) * 50))
		local swap_with = nil

		for key, value in pairs(draggers.children) do
			if (value.x == target_x and value.y == target_y) then
				swap_with = value
				break
			end
		end

		self.z = 0

		self.x = target_x
		self.y = target_y

		if (swap_with) then
			swap_with.x = self.sx
			swap_with.y = self.sy
		end
	end

	draggers:add(mine)
end

function love.mousepressed(...)
	event:fire("mousepressed", ...)
end

function love.mousereleased(...)
	event:fire("mousereleased", ...)
end

function love.update(delta)
	event:fire("update", delta)
end

function love.draw()
	draggers:draw()
end