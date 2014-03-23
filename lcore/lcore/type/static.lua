--[[
#id type.static
#title Static Typer

#version 1.0
#status incomplete

##todo Partial specification support in build_spec
##todo Unpack method

#desc Provides static type checks, specifications, and packing.
]]

local L = (...)

local static

local function get_spec(self, spec)
	if (type(spec) ~= "table") then
		spec = self.specs[spec]

		if (not spec) then
			return false
		end
	end

	return spec
end

static = {
	specs = {},

	--Extends typechecking past Lua's type method
	is = {
		["int"] = function(value)
			return (type(value) == "number" and value % 1 == 0)
		end,

		["whole"] = function(value)
			return (type(value) == "number" and value % 1 == 0 and value >= 0)
		end,

		["callable"] = function(value)
			return (not not getmetatable(value).__call)
		end
	},

	register_spec = function(self, name, specification)
		self.specs[name] = specification
	end,

	--TODO: Partial specification support
	build_spec = function(self, object)
		local spec = {}

		for key, value in pairs(object) do
			table.insert(spec, {key, type(key)})
		end

		return spec
	end,

	pack = function(self, object, spec)
		spec = get_spec(self, spec)

		if (not spec) then
			return nil, "Invalid type"
		end

		local out = {}
		for index = 1, #spec do
			out[index] = object[spec[1]]
		end

		return out
	end,

	match = function(self, object, spec)
		spec = get_spec(self, spec)

		if (not spec) then
			return false, "Invalid type"
		end

		for index = 1, #spec do
			local entry = spec[index]

			if (self.is[entry[2]]) then
				if (not self.is[entry[2]](object[entry[1]])) then
					return false
				end
			else
				if (type(object[entry[2]]) ~= entry[1]) then
					return false
				end
			end
		end

		return true
	end
}

return static