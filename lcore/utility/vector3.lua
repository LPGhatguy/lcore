local L, this = ...
this.title = "3D Vector Object"
this.version = "1.0"
this.status = "prototype"
this.desc = "Provides a 3D vector class"

local lcore = L.lcore
local oop = lcore.utility.oop
local vector3

vector3 = oop:class() {
	x = 0,
	y = 0,
	z = 0,

	_new = function(self, x, y, z)
		self.x = x or self.x
		self.y = y or self.y
		self.z = z or self.z
	end,

	length = function(self)
		return math.sqrt(self.x^2 + self.y^2 + self.z^2)
	end,

	length2 = function(self)
		return self.x^2 + self.y^2 + self.z^2
	end,

	normalize = function(self, out)
		out = out or self:copy()

		local length = self:length()
		out.x = self.x / length
		out.y = self.y / length
		out.z = self.z / length

		return out
	end,

	rotate_x = function(self, r, out)
		out = out or self:copy()

		out.y = math.sin(r) * self.y + math.cos(r) * self.y
		out.z = math.cos(r) * self.z - math.sin(r) * self.z

		return out
	end,

	rotate_y = function(self, r, out)
		out = out or self.copy()

		out.x = math.cos(r) * self.x - math.sin(r) * self.x
		out.z = math.sin(r) * self.z + math.cos(r) * self.z
	end,

	rotate_z = function(self, r, out)
		out = out or self:copy()

		out.x = math.sin(r) * self.y + math.cos(r) * self.x
		out.y = math.cos(r) * self.y - math.sin(r) * self.x

		return out
	end,

	dot = function(self, other)
		return self.x * other.x + self.y * other.y + self.z * other.z
	end,

	project = function(self, target, out)
		out = out or self:copy()
		local length = self:length2(target)

		if (length == 0) then
			out.x = 0
			out.y = 0
			out.z = 0

			return out
		else
			local scalar = (self:dot(target) / length)

			out.x = scalar * target.x
			out.y = scalar * target.y
			out.z = scalar * target.z

			return out
		end
	end
}

return vector3