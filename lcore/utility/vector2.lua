--[[
#id utility.vector2
#title Vector2 Library

#version 1.0
#status needs-testing
#see utility.pair

#desc Provides vector2 methods and manipulations
]]

local L = (...)

local vector2

vector2 = {
	length = function(self, vector)
		return math.sqrt(vector[1] * vector[1] + vector[2] * vector[2])
	end,

	length2 = function(self, vector)
		return vector[1] * vector[1] + vector[2] * vector[2]
	end,

	normalize = function(self, vector, out)
		out = out or vector

		local length = self:length(vector)
		out[1] = vector[1] / length
		out[2] = vector[2] / length

		return out
	end,

	rotate = function(self, vector, r, out)
		out = out or vector

		out[1] = math.sin(r) * vector[2] + math.cos(r) * vector[1]
		out[2] = math.cos(r) * vector[2] - math.sin(r) * vector[1]

		return out
	end,

	dot = function(self, vector1, vector2)
		return vector1[1] * vector2[1] + vector1[2] * vector2[2]
	end,

	project = function(self, vector, target, out)
		out = out or vector
		local length = self:length2(target)

		if (length == 0) then
			out[1] = 0
			out[2] = 0

			return out
		else
			local scalar = (self:dot(vector, target) / length)

			out[1] = scalar * target[1]
			out[2] = scalar * target[2]

			return out
		end
	end
}

return vector2