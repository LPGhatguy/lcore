--~NODOC
--This file is volatile -- it's the testing code for currently developed features.

local L = require("lcore.core")
local event = L:get("utility.event")
local rectdraggable = L:get("graphics.ui.rectdraggable")

local druggies = {}

for index = 1, 10 do
	local mine = rectdraggable:new(50 * index - 50, 50, 50, 50)
	mine.drag_start = function(self)
		table.sort(druggies, function(first, second)
			if (second == mine) then
				return true
			else
				return false
			end
		end)
	end
	mine.drag_end = function(self)
		self.x = math.min(love.window.getWidth(), math.max(0, math.floor(self.x / 50) * 50))
		self.y = math.min(love.window.getHeight(), math.max(0, math.floor(self.y / 50) * 50))
	end

	table.insert(druggies, mine)
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
	for key, value in pairs(druggies) do
		value:draw()
	end
end