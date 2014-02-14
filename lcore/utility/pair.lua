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

--NOMINI START
if (L.debug) then
	local function ish(given, goal, precision)
		goal = goal or 0
		precision = precision or 1e-15
		return (given > goal - precision and given < goal + precision)
	end

	pair.__test = function(self, test)
		local suite = test:suite("Vector Pair Library")
		local a, b, c, d, e, f

		suite:section("pair.length")
		a = self:length(0, 0)
		b = self:length(3, 4)
		suite:test("length-zero", a == 0)
		suite:test("length-nonzero", b == 5)


		suite:section("pair.length2")
		a = self:length2(0, 0)
		b = self:length2(3, 4)
		suite:test("length2-zero", a == 0)
		suite:test("length2-nonzero", b == 25)


		suite:section("pair.normalize")
		a, b = self:normalize(0, 0)
		c, d = self:normalize(3, 4)
		suite:test("normalize-zero", a == 0 and b == 0)
		suite:test("normalize-nonzero", c == 0.6 and d == 0.8)


		suite:section("pair.rotate")
		a, b = self:rotate(0, 0, 31)
		c, d = self:rotate(1, 1, math.pi)
		e, f = self:rotate(1, 1, -math.pi)
		suite:test("rotate-zero", a == 0 and b == 0)
		suite:test("rotate-nonzero", ish(c, -1) and ish(d, -1))
		suite:test("rotate-nonzero-ccw", ish(e, -1) and ish(f, -1))


		suite:section("pair.dot")
		a = self:dot(0, 0, 0, 0)
		b = self:dot(5, 5, 0, 0)
		c = self:dot(5, 5, 5, 5)
		suite:test("dot-zero", a == 0)
		suite:test("dot-halfzero", b == 0)
		suite:test("dot-nonzero", c == 50)


		suite:section("pair.project")
		a, b = self:project(0, 0, 0, 0)
		c, d = self:project(1, 1, 0, 0)
		e, f = self:project(1, 0, 1, 0)
		suite:test("project-zero", a == 0 and b == 0)
		suite:test("project-halfzero", c == 0 and d == 0)
		suite:test("project-self", e == 1 and f == 0)

		return suite
	end
end
--NOMINI END

return pair