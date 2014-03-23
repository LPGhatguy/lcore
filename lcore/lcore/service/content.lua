--[[
#id service.content
#title Content Service
#status prototype
#version 0.1

#desc Provides content loading/unloading for the engine

##todo Auto-alias directories and provide content discovery
##todo Provide reference counting or such to automatically unload content
]]

local L = (...)
local fs = L:get("lcore.utility.filesystem")
local content
local load_assoc_meta

content = {
	forced_loaders = {},
	loaders = {},
	associations = {},
	aliases = {},
	loaded = {},

	find_loader = function(self, path)
		local current = self.associations["current"]
		local default = self.associations["default"]
		local loader

		if (current ~= default) then
			loader = self:find_loader_in(current, path)

			if (loader) then
				return loader
			end
		end

		loader = self:find_loader_in(default, path)

		if (loader) then
			return loader
		end

		local forced = self.forced_loaders

		for index = 1, #forced do
			loader = self:find_loader_in(forced[index], path)

			if (loader) then
				return loader
			end
		end

		return nil, "Couldn't find loader for path!"
	end,

	find_loader_in = function(self, set, path)
		for index = 1, #set do
			local matcher = set[index][1]

			if (type(matcher) == "string") then
				if (path:match(matcher)) then
					return set[index][2]
				end
			elseif (type(matcher) == "function") then
				if (matcher(path)) then
					return set[index][2]
				end
			end
		end
	end,

	alias = function(self, list)
		for key, value in pairs(list) do
			self.aliases[key] = value
		end
	end,

	get = function(self, alias)
		if (self.loaded[alias]) then
			return self.loaded[alias]
		else
			return self:load(alias)
		end
	end,

	load = function(self, alias, loader)
		local path = self.aliases[alias] or alias

		if (fs.exists(path)) then
			local loader = self:find_loader(path)

			if (loader) then
				local content, issue = loader(path)

				if (content) then
					self.loaded[alias] = content

					return content
				else
					return nil, L:warn("Unable to load content '" .. (alias or "nil") .. 
						"' - receieved error: " .. (issue or "nil"))
				end
			else
				return nil, L:warn("Unable to find loader for content '" .. (alias or "nil") .. "'.")
			end
		else
			return nil, L:warn("Content at '" .. (alias or "nil") .. "' does not exist or cannot be found.")
		end
	end,

	unload = function(self, alias)
		self.loaded[alias] = nil
	end
}

load_assoc_meta = {
	__index = function(self, key)
		if (key == "current") then
			return self[L.platform] or self["default"]
		end
	end
}

setmetatable(content.loaders, load_assoc_meta)
setmetatable(content.associations, load_assoc_meta)

--This association is mostly a test
content.loaders["default"] = {
	lua = function(path)
		return loadfile(path)
	end
}

content.associations["default"] = {
	{"%.lua$", content.loaders.default.lua}
}


if (love) then
	content.loaders["love"] = {
		image = love.graphics.newImage,
		image_data = love.image.newImageData
	}

	content.associations["love"] = {
		{"%.png$", content.loaders.love.image},
		{"%.jpg$", content.loaders.love.image},
		{"%.bmp$", content.loaders.love.image_data}
	}
end

return content