local L, this = ...
this.name = "NOP Provider"
this.version = "1.0"
this.status = "production"
this.desc = "Provides NOP instructions to mostly mimick a module without errors."

local nopper
local nopper_meta

local function build_nop(target, notice)
	local new = {}

	setmetatable(new, {
		__index = target,
		__call = function()
			print(notice)
		end
	})

	return new
end

nopper_meta = {
	__index = function(self, index)
		self[index] = build_nop(self, "NOP: " .. index)

		return self[index]
	end
}

nopper = {
	new = function(self)
		return setmetatable({}, nopper_meta)
	end
}


return nopper