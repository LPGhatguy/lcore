local L, this = ...
this.title = "2D Vector Object"
this.version = "1.0"
this.status = "production"
this.desc = "Provides a 2D vector class"

local lcore = L.lcore
local oop = lcore.utility.oop
local vector2

vector2 = oop:class() {
	x = 0,
	y = 0,

	_new = function(self, x, y)
		self.x = x or self.x
		self.y = y or self.y
	end,

	length = function(self)
		return math.sqrt(self.x^2 + self.y^2)
	end,

	length2 = function(self)
		return self.x^2 + self.y^2
	end,

	normalize = function(self, out)
		out = out or self:copy()

		local length = self:length()
		out.x = self.x / length
		out.y = self.y / length

		return out
	end,

	rotate = function(self, r, out)
		out = out or self:copy()

		out.x = math.sin(r) * self.y + math.cos(r) * self.x
		out.y = math.cos(r) * self.y - math.sin(r) * self.x

		return out
	end,

	dot = function(self, other)
		return self.x * other.x + self.y * other.y
	end,

	project = function(self, target, out)
		out = out or self:copy()
		local length = self:length2(target)

		if (length == 0) then
			out.x = 0
			out.y = 0

			return out
		else
			local scalar = (self:dot(target) / length)

			out.x = scalar * target.x
			out.y = scalar * target.y

			return out
		end
	end
}

return vector2