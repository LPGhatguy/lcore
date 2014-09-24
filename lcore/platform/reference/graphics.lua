local L, this = ...
this.title = "PAAPI Reference Graphics Implementation"
this.version = "0.2"
this.status = "prototype"
this.desc = "A no-op module providing a reference API"

local lcore = L.lcore
local utable = lcore.utility.table
local platform = lcore.platform.interface
local utable = lcore.utility.table
local oop = lcore.utility.oop
local vector2 = lcore.utility.vector2
local color4 = lcore.utility.color4
local ref_gfx

local gfx_nop = function(name, ...)
	local arg = {...}
	local called
	
	return function()
		if (not called) then
			called = true
			print("Method 'graphics." .. tostring(name) .. "' is not implemented.")
		end

		return unpack(arg)
	end
end

ref_gfx = {
	derive = function(self, target)
		return utable:copymerge(self, target)
	end,

	--IMMEDIATE-MODE API
	rectangle = gfx_nop("rectangle"),
	circle = gfx_nop("circle"),
	arc = gfx_nop("arc"),
	polygon = gfx_nop("polygon"),
	line = gfx_nop("line"),
	point = gfx_nop("point"),

	clear = gfx_nop("clear"),
	origin = gfx_nop("origin"),
	pop = gfx_nop("pop"),
	push = gfx_nop("push"),

	translate = gfx_nop("translate"),
	scale = gfx_nop("scale"),
	rotate = gfx_nop("rotate"),
	shear = gfx_nop("shear"),
	scissor = gfx_nop("scissor"),

	project = gfx_nop("project"),
	unproject = gfx_nop("unproject"),

	set_line_width = gfx_nop("set_line_width"),
	get_line_width = gfx_nop("get_line_width", 1),

	set_point_size = gfx_nop("set_point_size"),
	get_point_size = gfx_nop("get_point_size"),

	set_color_rgba = gfx_nop("set_color_rgba"),
	get_color_rgba = gfx_nop("get_color_rgba", 0, 0, 0, 0),
	set_color_c4 = gfx_nop("set_color_c4"),
	get_color_c4 = gfx_nop("get_color_c4", color4:new(255, 255, 255, 255)),

	--void set_background_color_rgba(uchar r, uchar g, uchar b, uchar a)
	set_background_color_rgba = gfx_nop("set_background_color_rgba"),
	--(uchar r, uchar g, uchar b, uchar a) get_background_color_rgba()
	get_background_color_rgba = gfx_nop("get_background_color_rgba", 0, 0, 0, 0),
	--void set_background_color_c4(color4 color)
	set_background_color_c4 = gfx_nop("set_background_color_c4"),
	--(color4 color) get_background_color_c4()
	get_background_color_c4 = gfx_nop("get_background_color_c4", color4:new(0, 0, 0, 0)),

	retained = {
		rectangle = oop:class() {
			position = nil,
			size = nil,
			color = nil,
			fill = true,
			line_width = 2,
			__gfx = nil,

			_new = function(self, x, y, w, h)
				self.__gfx = platform.graphics

				self.position = vector2:new(x or 0, y or 0)
				self.size = vector2:new(w or 0, h or 0)
				self.color = color4:new(255, 255, 255, 255)
			end,

			hook = function(self, handler)
				handler:hook("draw", self)
			end,

			draw = function(self)
				self.__gfx.set_color_c4(self.color)
				self.__gfx.set_line_width(self.line_width)
				self.__gfx.rectangle(self.fill and "fill" or "line", self.position.x, self.position.y, self.size.x, self.size.y)
			end
		},

		circle = oop:class() {
			position = nil,
			r = 0,
			color = nil,
			fill = true,
			line_width = 2,
			__gfx = nil,

			_new = function(self, x, y, r)
				self.__gfx = platform.graphics

				self.position = vector2:new(x or 0, y or 0)
				self.r = r or self.r
				self.color = color4:new(255, 255, 255, 255)
			end,

			hook = function(self, handler)
				handler:hook("draw", self)
			end,

			draw = function(self)
				self.__gfx.set_color_c4(self.color)
				self.__gfx.set_line_width(self.line_width)
				self.__gfx.circle(self.fill and "fill" or "line", self.position.x, self.position.y, self.r)
			end
		},

		polygon = oop:class() {
			points = {},
			color = nil,
			fill = true,
			line_width = 2,
			__gfx = nil,

			_new = function(self, ...)
				self.__gfx = platform.graphics

				local points = {...}

				if (points % 2 ~= 0) then
					return false, "polygon requires an even length list of points!"
				end

				if (points < 3) then
					return false, "polygon requires at least three points!"
				end

				self.points = utable:copy(points)
				self.color = color4:new(255, 255, 255, 255)
			end,

			hook = function(self, handler)
				handler:hook("draw", self)
			end,

			draw = function(self)
				self.__gfx.set_color_c4(self.color)
				self.__gfx.set_line_width(self.line_width)
				self.__gfx.polygon(self.fill and "fill" or "line", self.points)
			end
		}
	}
}

return ref_gfx