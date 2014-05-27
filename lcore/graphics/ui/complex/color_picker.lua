local L, this = ...
this.title = "UI Color Picker"
this.version = "1.1"
this.status = "production"
this.desc = "A simple HSV color picker"
this.todo = {
	"Reimplement with radio buttons for picking sliders"
}

local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local frame = L:get("lcore.graphics.ui.frame")
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
local shader_source = [[
// convert HSV to RGB
extern float hue;
extern int depth;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec3 c = vec3(hue, texture_coords.x, 1 - texture_coords.y);
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	vec3 v = c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);

	return vec4(floor(v * depth) / depth, 1.0);
}
]]

--used in line_picker sub-component
local function line_draw(self)
	image.draw(self)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", self.x, self.value, self.w, 3)
end

color_picker = oop:class(frame, event) {
	value_x = 1,
	value_y = 1,
	value_h = 0,
	hsv = {0, 0, 0, 255},
	rgb = {0, 0, 0, 255},
	depth = 255,

	box_picker = nil,
	line_picker = nil,
	output_box = nil,
	output_box_backing = nil,
	numerics_box = nil,

	box_shader = nil,

	_new = function(base, self, manager, x, y, w, h)
		self = frame._new(base, self, manager, x, y, w, h)

		self.box_shader = love.graphics.newShader(shader_source)
		self.box_shader:sendInt("depth", self.depth)

		self.box_picker = image:new(self, nil, 0, 0, w - 100, h)
		self.box_picker.image_data = love.image.newImageData(self.box_picker.w, self.box_picker.h)
		self.box_picker.image = love.graphics.newImage(self.box_picker.image_data)
		self.box_picker.border_width = 1
		self.box_picker.down = false
		self.box_picker.mousepressed = picker_mousepressed
		self.box_picker.mousereleased = picker_mousereleased
		self.box_picker.draw = function(this)
			love.graphics.setShader(self.box_shader)
			image.draw(this)
			love.graphics.setShader()

			love.graphics.setLineWidth(1)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.circle("line", self.value_x, self.value_y, 4)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.circle("line", self.value_x, self.value_y, 5)
		end

		self.line_picker = image:new(self, nil, w - 90, 0, 20, h)
		self.line_picker.image_data = love.image.newImageData(self.line_picker.w, self.line_picker.h)
		self.line_picker.image = love.graphics.newImage(self.line_picker.image_data)
		self.line_picker.border_width = 1
		self.line_picker.down = false
		self.line_picker.value = 0
		self.line_picker.mousepressed = picker_mousepressed
		self.line_picker.mousereleased = picker_mousereleased
		self.line_picker.draw = line_draw

		self.output_box = rectangle:new(self, w - 69, 0, 69, 50)
		self.output_box.border_width = 1

		self.output_box_backing = self.output_box:copy()
		self.output_box_backing.background_color = {255, 255, 255}
		self.output_box_backing.z = -1

		self.numerics_box = frame:new(self, w - 69, 50, 69, h - 50)
		self.numerics_box.border_width = 1

		self:add(self.box_picker, self.line_picker,
			self.output_box, self.output_box_backing,
			self.numerics_box)

		self:redraw_line()
		self:recompute_value()

		return self
	end,

	_connect = function(self, manager)
		manager:hook({"draw", "mousepressed", "mousereleased", "update"}, self)
	end,

	_destroy = function(self)
		self:connect()
	end,

	update = function(self, delta)
		local mx, my = love.mouse.getPosition()

		if (self.box_picker.down) then
			local rx = mx - self.box_picker.x - self.box_picker.ox
			local ry = my - self.box_picker.y - self.box_picker.oy

			self.value_x = math.max(1, math.min(self.box_picker.w, rx))
			self.value_y = math.max(0, math.min(self.box_picker.h, ry))
			self:recompute_value()
		elseif (self.line_picker.down) then
			local ry = my - self.line_picker.y - self.line_picker.oy

			self.line_picker.value = math.max(0, math.min(self.line_picker.h, ry))
			self.box_shader:send("hue", 1 - (self.line_picker.value / self.line_picker.h))
			self.box_shader:sendInt("depth", self.depth)
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
			self.value_x * 100 / w,
			(h - self.value_y) * 100 / h,
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
}

return color_picker