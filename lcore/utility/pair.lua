local L, this = ...
this.title = "Vector Pair Library"
this.version = "1.0"
this.status = "production"
this.see = {"lcore.utility.vector2"}
this.desc = "Provides vector and duple methods."

local pair

pair = {
	length = function(self, x, y)
		return math.sqrt(x * x + y * y)
	end,

	length2 = function(self, x, y)
		return x * x + y * y
	end,

	normalize = function(self, x, y)
		local length = self:length(x, y)

		if (length == 0) then
			return 0, 0
		else
			return x / length, y / length
		end
	end,

	rotate = function(self, x, y, r)
		return math.sin(r) * y + math.cos(r) * x, math.cos(r) * y - math.sin(r) * x
	end,
	
	dot = function(self, x1, y1, x2, y2)
		return x1 * x2 + y1 * y2
	end,

	project = function(self, x1, y1, x2, y2)
		local length = self:length2(x2, y2)

		if (length == 0) then
			return 0, 0
		else
			local scalar = (self:dot(x1, y1, x2, y2) / length)

			return scalar * x2, scalar * y2
		end
	end
}

return pair