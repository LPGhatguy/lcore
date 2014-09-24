local L, this = ...
this.title = "Numeric Range"
this.version = "1.0"
this.status = "production"
this.desc = "Provides a numeric range object"

local lcore = L.lcore
local oop = lcore.utility.oop
local range

range = oop:class() {
	float_precision = 5,
	from = -math.huge,
	to = math.huge,

	_new = function(self, from, to)
		local small = math.min(from, to)
		local large = math.max(from, to)

		self.from = small or self.from
		self.to = large or self.to
	end,

	contains = function(self, number)
		return number > self.from and number < self.to
	end,

	intersection = function(self, other, out)
		out = out or self:copy()

		out.from = math.min(self.from, other.from)
		out.to = math.max(self.to, other.to)

		return out
	end,

	randomi = function(self)
		return math.random(self.from, self.to)
	end,

	randomf = function(self, precision)
		local scale = 10 ^ (precision or self.float_precision)
		return math.random(self.from * scale, self.to * scale) / scale
	end,

	loop = function(self, method, ...)
		for index = self.from, self.to do
			method(index, ...)
		end
	end,

	evaluate = function(self)
		local list = {}

		setmetatable(list, {
			__index = function(self, key)
				local v = self.from + key

				return (v <= self.to) and v
			end
		})

		return list
	end,

	evaluate_now = function(self)
		local list = {}

		for index = self.from, self.to do
			table.insert(list, index)
		end

		return list
	end,

	__metatable = {
		__len = function(self)
			return self.to - self.from
		end,

		__tostring = function(self)
			return ("range (%d..%d"):format(self.from, self.to)
		end
	}
}

return range