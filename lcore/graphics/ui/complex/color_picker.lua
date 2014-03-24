--[[
#id graphics.ui.complex.color_picker
#title Color Picker
#status incomplete
#version 1.0

#desc A simple HSV color picker
##todo Display current value numerically
]]

local L = (...)
local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local frame = L:get("lcore.graphics.ui.frame")
local textlabel = L:get("lcore.graphics.ui.textlabel")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local image = L:get("lcore.graphics.ui.image")
local event = L:get("lcore.service.event")
local color_picker

--used in both box_picker and line_picker sub-components
local function picker_mousepressed(self, x, y)
	if (self:contains(x, y)) then
		self.down = true
	end
end

local function picker_mousereleased(self, x, y)
	self.down = false
end

--used in box_picker sub-component
local box_shader = love.graphics.newShader([[
// convert HSV to RGB
extern float hue;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec3 c = vec3(hue, texture_coords.x, 1 - texture_coords.y);
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	vec3 v = c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);

	return vec4(v, 1.0);
}
]])

local function box_draw(self)
	love.graphics.setShader(box_shader)
	image.draw(self)
	love.graphics.setShader()

	love.graphics.setLineWidth(1)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("line", self.value_x, self.value_y, 4)
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.circle("line", self.value_x, self.value_y, 5)
end

--used in line_picker sub-component
local function line_draw(self)
	image.draw(self)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", self.x, self.value, self.w, 3)
end

color_picker = oop:class(frame)({
	child_manager = event:new(),
	hsv = {0, 0, 0, 255},
	rgb = {0, 0, 0, 255},

	box_picker = nil,
	line_picker = nil,
	output_box = nil,
	output_box_backing = nil,
	numerics_box = nil,

	_new = function(self, new, manager, x, y, w, h)
		new = rectangle._new(self, new, manager, x, y, w, h)
		local child_manager = new.child_manager

		new.box_picker = image:new(child_manager, nil, 0, 0, w - 100, h)
		new.box_picker.image_data = love.image.newImageData(new.box_picker.w, new.box_picker.h)
		new.box_picker.image = love.graphics.newImage(new.box_picker.image_data)
		new.box_picker.border_width = 1
		new.box_picker.down = false
		new.box_picker.value_x = 0
		new.box_picker.value_y = 0
		new.box_picker.mousepressed = picker_mousepressed
		new.box_picker.mousereleased = picker_mousereleased
		new.box_picker.draw = box_draw

		new.line_picker = image:new(child_manager, nil, w - 90, 0, 20, h)
		new.line_picker.image_data = love.image.newImageData(new.line_picker.w, new.line_picker.h)
		new.line_picker.image = love.graphics.newImage(new.line_picker.image_data)
		new.line_picker.border_width = 1
		new.line_picker.down = false
		new.line_picker.value = 0
		new.line_picker.mousepressed = picker_mousepressed
		new.line_picker.mousereleased = picker_mousereleased
		new.line_picker.draw = line_draw

		new.output_box = rectangle:new(child_manager, w - 69, 0, 69, 50)
		new.output_box.border_width = 1

		new.output_box_backing = new.output_box:copy()
		new.output_box_backing.background_color = {255, 255, 255}
		new.output_box_backing.z = -1

		new.numerics_box = frame:new(child_manager, w - 69, 50, 69, h - 50)
		new.numerics_box.border_width = 1

		new:add(new.box_picker, new.line_picker,
			new.output_box, new.output_box_backing,
			new.numerics_box)

		new:redraw_line()
		new:recompute_value()

		new.manager:hook({"mousepressed", "mousereleased", "update"}, new)

		return new
	end,

	_destroy = function(self)
		self.manager:unhook_object(self)
	end,

	mousepressed = function(self, ...)
		self:fire("mousepressed", ...)
	end,

	mousereleased = function(self, ...)
		self:fire("mousereleased", ...)
	end,

	update = function(self, delta)
		local mx, my = love.mouse.getPosition()

		if (self.box_picker.down) then
			local rx = mx - self.box_picker.x - self.box_picker.ox
			local ry = my - self.box_picker.y - self.box_picker.oy

			self.box_picker.value_x = math.max(1, math.min(self.box_picker.w, rx))
			self.box_picker.value_y = math.max(0, math.min(self.box_picker.h, ry))
			self:recompute_value()
		elseif (self.line_picker.down) then
			local ry = my - self.line_picker.y - self.line_picker.oy

			self.line_picker.value = math.max(0, math.min(self.line_picker.h, ry))
			box_shader:send("hue", 1 - (self.line_picker.value / self.line_picker.h))
			self:recompute_value()
		end
	end,

	redraw_line = function(self)
		local h = self.box_picker.h

		self.line_picker.image_data:mapPixel(function(x, y)
			return color:hsv((h - y) * 360 / h, 100, 100, 255)
		end)

		self.line_picker.image:refresh()
	end,

	recompute_value = function(self)
		local w, h = self.box_picker.w, self.box_picker.h
		local lh = self.line_picker.h

		self.hsv = {
			(lh - self.line_picker.value) * 360 / lh,
			self.box_picker.value_x * 100 / w,
			(h - self.box_picker.value_y) * 100 / h,
			255
		}
		local r, g, b, a = color:hsv(unpack(self.hsv))
		
		self.rgb[1] = r
		self.rgb[2] = g
		self.rgb[3] = b
		self.rgb[4] = a

		self.output_box.background_color = self.rgb
		self:value_changed()
	end,

	value_changed = function(self)
		--event
	end
})

return color_picker