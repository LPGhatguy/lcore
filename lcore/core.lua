--[[
#id lcore
#title LCORE
#version 0.1.0
#status production

#desc Provides the basis for everything in the framework.
]]

if (type(...) ~= "string") then
	return
end

local root = (...):match("(.+)%..-$") or (...)

local lcore
local test

local fs_exists = function(path)
	if (lcore.platform == "love") then
		return love.filesystem.exists(path)
	else
		local handle, err = io.open(path, "r")

		if (handle) then
			handle:close()
			return true
		else
			return nil, err
		end
	end
end

local fs_load = function(path)
	if (lcore.platform == "love") then
		return love.filesystem.load(path)
	else
		return loadfile(path)
	end
end

lcore = {
	platform = love and "love" or "lua",
	platform_version = "0.9.0",
	framework_version = "0.1.0",
	notices_reported = true,
	errors_reported = true,
	warnings_reported = true,
	warnings_as_errors = false,
	autotest = false,
	debug = true,
	base_directory = "",

	path = {root, ""},
	loaded = {},

	--HIGHER-ORDER METHODS
	configure = function(self, settings)
		for key, value in pairs(settings) do
			self[key] = value
		end

		return self
	end,

	--UTILITY METHODS
	module_to_path = function(self, mod)
		return self.base_directory .. mod:gsub("%.", "/"):gsub("~", "..") .. ".lua"
	end,

	path_to_module = function(self, path)
		return path:gsub(self.base_directory, ""):gsub("/", "%."):match("(.-)%.%w-$")
	end,

	--ERRORS AND WARNINGS
	error = function(self, message)
		if (self.errors_reported) then
			error(message or "unknown error")
		else
			return message
		end
	end,

	xerror = function(err)
		return debug.traceback(err)
	end,

	warn = function(self, message)
		if (self.warnings_reported) then
			if (self.warnings_as_errors) then
				error(message or "unknown error", 4)
			else
				print(message)
			end
		end

		return message
	end,

	notice = function(self, message)
		if (self.notices_reported) then
			print(message)
		end

		return message
	end,

	parse_lua_error = function(self, err)
		return err
	end,

	--MODULE LOADING
	get_path = function(self, mod)
		for index, value in next, self.path do
			local path = self:module_to_path(value .. "." .. mod)
			self:notice("Checking path '" .. path .. "'")

			if (fs_exists(path)) then
				self:notice("Path successful.")
				return path
			else
				self:notice("Path failed.")
			end
		end

		return nil
	end,

	add_path = function(self, path)
		table.insert(self.path, path)
		
		return self
	end,

	get = function(self, mod_name, ...)
		if (self.loaded[mod_name]) then
			return self.loaded[mod_name]
		else
			local path = self:get_path(mod_name)

			if (path) then
				return self:load(mod_name, path, ...)
			else
				self:error("Couldn't load module '" .. mod_name .. "'")
			end
		end
	end,

	load = function(self, mod_name, path, ...)
		local success, chunk = pcall(fs_load, path)

		if (not success or not chunk) then
			self:error(chunk)
		end

		local success, object = pcall(chunk, self, ...)

		if (not success) then
			print("FAILURE FOR", mod_name)
			self:error(object)
		end

		if (object) then
			if (mod_name) then
				self.loaded[mod_name] = object
			end

			if (self.autotest) then
				self.test:run(object)
			end
		end

		return object
	end
}

setmetatable(lcore, {
	__call = function(self, ...)
		return self:configure(...)
	end
})

--[[
@component Test Manager
#id lcore.test
#version 1.0
#status production

#desc Tests pieces of the framework and ensures sanity.
]]
test = {
	instance_meta = {
		__tostring = function(self)
			return self:report()
		end
	},

	instance_test = function(self, name, condition)
		self.tested[name] = condition
		table.insert(self.order, name)

		self.total = self.total + 1

		if (condition) then
			self.success = self.success + 1
		else
			self.failure = self.failure + 1
		end

		return condition
	end,

	instance_section = function(self, name)
		table.insert(self.order, name)
		self.tested[name] = name
	end,

	instance_report = function(self)
		local buffer = {}

		for key, name in next, self.order do
			local result = self.tested[name]

			if (type(result) == "string") then
				table.insert(buffer, "\n" .. result)
			else
				table.insert(buffer, name .. ": " .. (result and "SUCCESS" or "FAILURE"))
			end
		end

		table.insert(buffer, "\nSuccess: " .. self.success)
		table.insert(buffer, "Failure: " .. self.failure)
		table.insert(buffer, "Total: " .. self.total)

		return table.concat(buffer, "\n")
	end,

	suite = function(self, title)
		local instance = {
			title = title,
			success = 0,
			failure = 0,
			total = 0,
			tested = {},
			order = {},

			section = self.instance_section,
			test = self.instance_test,
			report = self.instance_report
		}

		setmetatable(instance, self.instance_meta)

		return instance
	end,

	run = function(self, mod, name)
		if (mod.__test) then
			print(mod:__test(self))
		else
			L:notice("No tests written for " .. (name or "module"))
		end
	end
}

lcore.test = test

return lcore