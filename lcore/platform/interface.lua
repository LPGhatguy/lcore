local L, this = ...
this.name = "lcore general interface"
this.version = "1.0"
this.status = "prototype"
this.desc = "Provides an interface to platform-specific interfaces."

local interface

interface = {
	platform = nil,
	platforms = {},

	set_platform = function(self, name)
		self.platform = name
	end,

	deduce_platform = function(self)
		if (self.platform) then
			return self.platform
		else
			if (love) then
				return "lcore.platform.love"
			else
				return "lcore.platform.vanilla"
			end
		end
	end,

	get = function(self, name)
		name = name or self:deduce_platform()

		if (self.platforms[name]) then
			return self.platforms[name]
		end

		local loaded, err = L:get(name .. ".core", true)

		if (loaded) then
			self.platforms[name] = platform
		else
			L:error("Could not load platform '" .. (name or "[nil]") .. "', got error: " .. err)
		end

		return loaded
	end
}

return interface