local L, this = ...
this.title = "Primitive Pointer"
this.version = "1.0"
this.status = "prototype"
this.desc = "Points to some data"

local lcore = L.lcore
local oop = lcore.utility.oop
local primitive_pointer

local function pp_tonumber(n)
	if (type(n) == "userdata") then
		return n.__pp and n.value
	else
		return tonumber(n)
	end
end

primitive_pointer = {
	new = function(self, item)
		local pointer = newproxy(true)
		local pmeta = getmetatable(pointer)

		local body = {
			__pp = true,
			value = item
		}

		pmeta.__index = body
		pmeta.__newindex = body

		pmeta.__tostring = function(self)
			return tostring(body.value)
		end

		pmeta.__concat = function(self, other)
			return tostring(body.value) .. other
		end

		if (type(item) == "number") then
			pmeta.__add = function(self, other)
				return pp_tonumber(self) + pp_tonumber(other)
			end

			pmeta.__sub = function(self, other)
				return pp_tonumber(self) - pp_tonumber(other)
			end

			pmeta.__mul = function(self, other)
				return pp_tonumber(self) * pp_tonumber(other)
			end

			pmeta.__div = function(self, other)
				return pp_tonumber(self) / pp_tonumber(other)
			end

			pmeta.__mod = function(self, other)
				return pp_tonumber(self) % pp_tonumber(other)
			end

			pmeta.__pow = function(self, other)
				return pp_tonumber(self) ^ pp_tonumber(other)
			end
		end

		return pointer
	end
}

return primitive_pointer