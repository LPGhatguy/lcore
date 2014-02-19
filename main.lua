--~NODOC
--This file is volatile -- it's the testing code for currently developed features.

local L = require("lcore.core")
local event = L:get("utility.event")
local oop = L:get("utility.oop")

local rectdraggable = oop:mix("graphics.ui.rectangle", "graphics.ui.draggable")

local draggers = {}

for index = 1, 10 do
	local mine = rectdraggable:new(50 * index - 50, 50, 50, 50)
	local val = 25.5
	mine.border_color = {0, 0, 0, 0}
	mine.background_color = {val * index, 0, 255 - val * index}

	mine.drag_start = function(self)
		self.z = math.huge

		table.sort(draggers, function(first, second)
			if (first.z == second.z) then
				return first.x < second.x
			else
				return first.z < second.z
			end
		end)
	end

	mine.drag_end = function(self)
		self.z = 0
		self.x = math.min(love.window.getWidth(), math.max(0, math.floor(self.x / 50) * 50))
		self.y = math.min(love.window.getHeight(), math.max(0, math.floor(self.y / 50) * 50))
	end

	table.insert(draggers, mine)
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
	for key, value in pairs(draggers) do
		value:draw()
	end
end