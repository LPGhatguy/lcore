local L, this = ...
this.title = "Color Core"
this.version = "1.0"
this.status = "production"
this.desc = "Lists named colors and provides color manipulation functions."

local color

color = {
	colors = {
		white = {255, 255, 255},
		silver = {192, 192, 192},
		gray = {128, 128, 128},
		darkgray = {64, 64, 64},
		black = {0, 0, 0},

		fuchsia = {255, 0, 255},
		purple = {128, 0, 128},
		indigo = {75, 0, 130},

		blue = {0, 0, 255},
		navy = {0, 0, 128},
		royalblue = {65, 105, 225},
		slate = {50, 80, 80},
		aqua = {0, 255, 255},
		teal = {0, 128, 128},
		turquoise = {65, 225, 110},

		yellow = {255, 255, 0},
		olive = {128, 128, 0},
		gold = {255, 215, 0},

		red = {255, 0, 0},
		maroon = {128, 0, 0},

		orange = {255, 140, 0},
		orangered = {255, 65, 0},
		brown = {140, 70, 20},

		lime = {0, 255, 0},
		green = {0, 128, 0}
	},

	--[[
	@method get
	#title Get Color
	#def (string name)
	#returns table result, boolean success
	#desc Returns the color with the name `name`.
	]]
	get = function(self, name)
		if (self.colors[name]) then
			return self.colors[name], true
		else
			L:warn("Couldn't get color '" .. (name or "nil") .. "'")
			return {0, 0, 0}, false
		end
	end,

	--[[
	@method set
	#title Set Color
	#def (string name)
	#returns boolean success
	#desc Sets the color for use in drawing.
	#desc Equivalent to love.graphics.setColor(color:get(name)), but with protection.
	#desc Addtionally, issues a warning on failure.
	]]
	set = function(self, name)
		if (self.colors[name]) then
			love.graphics.setColor(self.colors[name])
			return true
		else
			L:warn("Couldn't set color '" .. (name or "nil") .. "'")
			return false
		end
	end,

	--[[
	@method add
	#title Add Color
	#returns void
	#def (string name, number r, number g, number b, number a)
	#desc Adds a color of name `name` and components (r, g, b, a)
	]]
	add = function(self, name, r, g, b, a)
		self.colors[name] = self:rgb_static(r, g, b, a)
	end,

	--[[
	@method rgb_static
	#title Make Static Color
	#def ([number r, number g, number b, number a])
	#returns table color
	#desc Creates an immutable, static color object; used in system colors.
	#see make
	]]
	rgb_static = function(self, r, g, b, a)
		return {r or 0, g or 0, b or 0, a or 255, __nocopy = true, __immutable = true}
	end,

	--[[
	@method rgb
	#title Make Color from RGB
	#def ([number r, number g, number b, number a])
	#returns table color
	#desc Creates an RGB color with components (r, g, b, a) and returns it.
	#desc `r`, `g`, and `b` default to 0, while `a` defaults to 255.
	]]
	rgb = function(self, r, g, b, a)
		return r or 0, g or 0, b or 0, a or 255
	end,
	
	--[[
	@method hsv
	#title Make Color from HSV
	#def ([number h, number s, number v, number a])
	#returns table color
	#desc Creates an RGB color with the HSV components (h, s, v, a) and returns it.
	#desc Inputs are between (0, 0, 0, 0) and (360, 100, 100, 255)
	]]
	hsv = function(self, h, s, v, a)
		if (s <= 0) then
			return v, v, v, a
		end

		h, s, v = ((h or 0) * 6) / 360, (s or 0) / 100, (v or 0) / 100
		local c = v * s
		local x = (1 - math.abs((h % 2) - 1)) * c
		local m = (v - c)
		local r, g, b

		if (h < 1) then
			r, g, b = c, x, 0
		elseif (h < 2) then
			r, g, b = x, c, 0
		elseif (h < 3) then
			r, g, b = 0, c, x
		elseif (h < 4) then
			r, g, b = 0, x, c
		elseif (h < 5) then
			r, g, b = x, 0, c
		else
			r, g, b = c, 0, x
		end

		return (r + m) * 255, (g + m) * 255, (b + m) * 255, a or 255
	end,

	--[[
	@method hsl
	#title Make Color from HSL
	#def ([number h, number s, number l, number a])
	#returns table color
	#desc Creates an RGB color with the HSL components (h, s, l, a) and returns it.
	#desc Inputs are between (0, 0, 0, 0) and (360, 100, 100, 255)
	]]
	hsl = function(self, h, s, l, a)
		if (s <= 0) then
	    	return l, l, l, a
	    end

		h, s, l = ((h or 0) * 6) / 360, (s or 0) / 100, (l or 0) / 100
		local c = (1 - math.abs(2 * l - 1)) * s
		local x = (1 - math.abs((h % 2) - 1)) * c
		local m = (l - .5 * c)
		local r, g, b

		if (h < 1) then
			r, g, b = c, x, 0
		elseif (h < 2) then
			r, g, b = x, c, 0
		elseif (h < 3) then
			r, g, b = 0, c, x
		elseif (h < 4) then
			r, g, b = 0, x, c
		elseif (h < 5) then
			r, g, b = x, 0, c
		else
			r, g, b = c, 0, x
		end

		return (r + m) * 255, (g + m) * 255, (b + m) * 255, a or 255
	end,

	--[[
	@method mix
	#title Color Mix
	#def (number ratio, color first, color second, [color target])
	#returns color target
	#desc Mixes colors `first` and `second`, putting the result in `target`.
	#desc By default, `target` is a new color object.
	]]
	mix = function(self, ratio, first, second, target)
		local iratio = 1 - ratio

		target = target or {0, 0, 0}
		target[1] = (ratio * first[1] + iratio * second[1]) / 2
		target[2] = (ratio * first[2] + iratio * second[2]) / 2
		target[3] = (ratio * first[3] + iratio * second[3]) / 2

		return target
	end
}

for index, color in pairs(color.colors) do
	color.__nocopy = true
	color.__immutable = true
end

return color