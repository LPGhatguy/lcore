local L, this = ...
this.title = "PAAPI Reference Graphics Implementation"
this.version = "0.1"
this.status = "prototype"
this.desc = "A no-op module providing a reference API"

local utable = L:get("lcore.utility.table")
local platform = L:get("lcore.platform.interface")
local oop = L:get("lcore.utility.oop")
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

	set_color_rgba = gfx_nop("set_color_rgba"),
	get_color_rgba = gfx_nop("get_color_rgba"),
	set_color = gfx_nop("set_color"),
	get_color = gfx_nop("get_color"),

	set_background_color_rgb = gfx_nop("set_background_color_rgb"),
	get_background_color_rgb = gfx_nop("get_background_color_rgb", 0, 0, 0, 0),
	set_background_color = gfx_nop("set_background_color"),
	get_background_color = gfx_nop("get_background_color", 0, 0, 0, 0),

	retained = {
		rectangle = oop:class() {
			x = 0,
			y = 0,
			w = 0,
			h = 0,
			color = {255, 255, 255, 255},
			fill = true,
			line_width = 2,
			__gfx = nil,

			_new = function(self, x, y, w, h)
				self.__gfx = platform.graphics

				self.x = x or self.x
				self.y = y or self.y
				self.w = w or self.w
				self.h = h or self.h
			end,

			hook = function(self, handler)
				handler:hook("draw", self)
			end,

			draw = function(self)
				self.__gfx.set_color_rgba(self.color)
				self.__gfx.rectangle(self.fill and "fill" or "line", self.x, self.y, self.w, self.h)
			end
		},

		circle = oop:class() {
			x = 0,
			y = 0,
			r = 0,
			color = {255, 255, 255, 255},
			fill = true,
			line_width = 2,
			__gfx = nil,

			_new = function(self, x, y, r)
				self.__gfx = platform.graphics

				self.x = x or self.x
				self.y = y or self.y
				self.r = r or self.r
			end,

			hook = function(self, handler)
				handler:hook("draw", self)
			end,

			draw = function(self)
				self.__gfx.set_color_rgba(self.color)
				self.__gfx.circle(self.fill and "fill" or "line", self.x, self.y, self.r)
			end
		}
	}
}

return ref_gfx