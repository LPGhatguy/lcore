local L, this = ...
this.title = "Compound Numeric Range"
this.version = "1.0"
this.status = "production"
this.desc = "Provides facilities for combining ranges with an OR clause"

local lcore = L.lcore
local oop = lcore.utility.oop
local compound_range

compound_range = oop:class() {
	ranges = {},

	_new = function(self, ...)
		self.ranges = {...}
	end,
	
	contains = function(self, number)
		for key, value in ipairs(self.ranges) do
			if (not value:contains(number)) then
				return false
			end
		end

		return true
	end,

	intersection = function(self, other)
		table.insert(self.ranges, range)
	end
}

return compound_range