local L, this = ...
this.title = "Grouped Binding"
this.version = "1.0"
this.status = "testing"
this.desc = "Used to create data bindings"

local lcore = L.lcore
local oop = lcore.utility.oop
local grouped_binding

grouped_binding = oop:static() {
	construct = function(self, target, method)
		local internal
		if (type(target) == "userdata") then
			internal = target:get_internal()
		else
			internal = target
			target = oop:wrap(internal)
		end

		local tmeta = getmetatable(target)
		local binding = {
			valid = false,
			update = method
		}

		tmeta.__index = binding
		tmeta.__newindex = internal
		setmetatable(binding, {
			__index = function(self, key)
				if (not binding.valid) then
					(rawget(binding, "update") or internal.update)(internal)
				end

				return internal[key]
			end
		})

		target:update()

		return target
	end
}

return grouped_binding