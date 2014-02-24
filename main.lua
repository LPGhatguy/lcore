--~NODOC
--This file is volatile -- it's the testing code for currently developed features.

local L = require("lcore.core")
local event = L:get("service.event")
local oop = L:get("utility.oop")
local color = L:get("graphics.color")
local frame = L:get("graphics.ui.frame")
local image = L:get("graphics.ui.image")
local rectangle = L:get("graphics.ui.rectangle")

local picker

function love.load()
	picker = frame:new(50, 50, 500, 400)
	picker.hue = 0
	picker.pick_x = 0
	picker.pick_y = 0

	local palette = image:new(nil, 20, 20, 300, 200)
	local palette_data
	local slicer = image:new(nil, 340, 20, 40, 200)
	local slicer_data
	local outbox = rectangle:new(20, 240, 300, 40)

	picker:add(palette)
	picker:add(outbox)
	picker:add(slicer)

	local function update_outbox()
			outbox.background_color = {palette_data:getPixel(picker.pick_x, picker.pick_y)}
	end

	local function update_palette()
		palette_data:mapPixel(function(x, y)
			return color:hsv(picker.hue * 255, x * 255 / 300, y * 255 / 200, 255)
		end)

		palette.image:refresh()
		update_outbox()
	end

	palette_data = love.image.newImageData(300, 200)
	palette.image = love.graphics.newImage(palette_data)

	palette.mousepressed = function(self, x, y)
		if (self:contains(x, y)) then
			self.down = true
		end
	end

	palette.update = function(self, delta)
		if (self.down) then
			local mx, my = love.mouse.getPosition()

			if (self:contains(mx, my)) then
				local rx, ry = math.floor(mx - self.ox - self.x), math.floor(my - self.oy - self.y)
				picker.pick_x, picker.pick_y = rx, ry

				outbox.background_color = {palette_data:getPixel(rx, ry)}
			end
		end
	end

	palette.mousereleased = function(self, x, y)
		if (self.down) then
			self.down = false
		end
	end

	palette.draw = function(self)
		image.draw(self)

		love.graphics.setColor(255, 255, 255)
		love.graphics.setLineWidth(1)
		love.graphics.circle("line", self.x + picker.pick_x, self.y + picker.pick_y, 4)
	end

	slicer_data = love.image.newImageData(40, 200)
	slicer_data:mapPixel(function(x, y)
		return color:hsv(y * 255 / 200, 255, 255)
	end)
	slicer.image = love.graphics.newImage(slicer_data)

	slicer.mousepressed = palette.mousepressed
	slicer.mousereleased = palette.mousereleased

	slicer.update = function(self, delta)
		if (self.down) then
			local mx, my = love.mouse.getPosition()

			if (self:contains(mx, my)) then
				local ry = my - self.oy - self.y
				picker.hue = ry / 200
				update_palette()
			end
		end
	end

	slicer.draw = function(self)
		image.draw(self)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", self.x, self.y - 1 + picker.hue * 200, 40, 4)
	end

	event:hook("mousepressed", palette)
	event:hook("mousepressed", slicer)

	event:hook("mousereleased", palette)
	event:hook("mousereleased", slicer)

	event:hook("update", palette)
	event:hook("update", slicer)

	update_palette()
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
	picker:draw()
end