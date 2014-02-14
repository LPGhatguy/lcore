--[[
#id graphics.color
#title Color Core
#status production
#version 1.0

#desc Lists named colors and provides color manipulation functions.
]]

local L = (...)
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
		self.colors[name] = self:smake(r, g, b, a)
	end,

	--[[
	@method make
	#title Make Color
	#def ([number r, number g, number b, number a])
	#returns table color
	#desc Creates a color with components (r, g, b, a) and returns it
	#desc `r`, `g`, and `b` default to 0, while `a` defaults to 255.
	]]
	make = function(self, r, g, b, a)
		return {r or 0, g or 0, b or 0, a or 255}
	end,

	--static color make
	--[[
	@method smake
	#title Make Static Color
	#def ([number r, number g, number b, number a])
	#returns table color
	#desc Creates an immutable, static color object; used in system colors.
	#see make
	]]
	smake = function(self, r, g, b, a)
		return {r or 0, g or 0, b or 0, a or 255, __nocopy = true, __immutable = true}
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