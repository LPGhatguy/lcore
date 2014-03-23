--[[
#id utility.pair
#title Vector Pair Library

#version 1.0
#status production
#see utility.vector2

#desc Provides vector pair (duple) methods and manipulations
]]

local L = (...)

local pair

pair = {
	--Unary methods
	--[[
	@method length
	#title Length
	#def (number x, number y)
	#returns number result
	#desc Returns the length of the vector (x, y)
	]]
	length = function(self, x, y)
		return math.sqrt(x * x + y * y)
	end,

	--[[
	@method length2
	#title Length Squared
	#def (number x, number y)
	#returns number result
	#desc Returns the squared length of the vector (x, y)
	]]
	length2 = function(self, x, y)
		return x * x + y * y
	end,

	--[[
	@method normalize
	#title Normalize
	#def (number x, number y)
	#returns (number x', number y')
	#desc Returns the unit vector from the given vector (x, y)
	#desc Returns (0, 0) if the vector is invalid or has zero length
	]]
	normalize = function(self, x, y)
		local length = self:length(x, y)

		if (length == 0) then
			return 0, 0
		else
			return x / length, y / length
		end
	end,

	--[[
	@method rotate
	#title Rotate
	#def (number x, number y, number r)
	#returns (number x', number y')
	#desc Rotates the vector (x, y) around the origin and returns the resulting vector
	]]
	rotate = function(self, x, y, r)
		return math.sin(r) * y + math.cos(r) * x, math.cos(r) * y - math.sin(r) * x
	end,
	
	--Binary methods
	--[[
	@method dot
	#title Dot Product
	#def (number x1, number y2, number x2, number y2)
	#returns number result
	#desc Returns the dot product of the vectors (x1, y1) and (x2, y2)
	]]
	dot = function(self, x1, y1, x2, y2)
		return x1 * x2 + y1 * y2
	end,

	--[[
	@method project
	#title Projection
	#def (number x1, number y1, number x2, number y2)
	#returns (number x', number y')
	#desc Returns the vector projection from (x1, y1) onto (x2, y2)
	]]
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