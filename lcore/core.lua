--[[
#id lcore
#title LCORE
#version 0.2.0
#status production

#desc Provides the basis for everything in the framework.

##todo Allow deprecation/tracing of tables
##todo More useful method_name inference and file determination
]]

if (type(...) ~= "string") then
	return
end

local root = (...):match("(.+)%..-$") or (...)

local N
local L

local fs_exists = function(path)
	if (L.platform == "love") then
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
	if (L.platform == "love") then
		return love.filesystem.load(path)
	else
		return loadfile(path)
	end
end

N = {
	deprecated = function(method, name)
		local output = "Function '"
			.. (name or L:method_name(method, name))
			.. "' is deprecated."

		return function(...)
			L:report("deprecation", output)
			return method(...)
		end
	end,

	traced = function(method, name)
		local output = "Function '"
		.. (name or L:method_name(method, name))
		.. "' was called!"

		return function(...)
			L:report("trace", output)
			return method(...)
		end
	end,

	hooked = function(target, method)
		return function(...)
			method(...)
			return target(...)
		end
	end
}

L = {
	N = N,

	platform = love and "love" or "lua",
	platform_version = "0.9.0",
	framework_version = "0.2.0",

	report_level = {
		default = "warn",
		deprecation = "warn",
		trace = "notice",
		module_found = "none",
	},

	notices_reported = true,
	errors_reported = true,
	warnings_reported = true,
	warnings_as_errors = false,
	debug = true,

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
		return mod:gsub("%.", "/"):gsub("~", "..") .. ".lua"
	end,

	method_name = function(self, method, name)
		local info = debug.getinfo(method)

		return info.name
			or ("@" .. (info.short_src:match("[^/\\]+[\\/][^/\\]+$") or "(unknown file)")
				.. ":" .. info.linedefined)
	end,

	--ERRORS AND WARNINGS
	report = function(self, id, message)
		message = message or "(no message)"
		local level = self.report_level[id]

		if (level == "none") then
			return
		end

		local handler = self[level]

		if (handler) then
			handler(self, message)
		else
			local default = self[self.default_report_level]

			if (default) then
				default(self, message)
			else
				self:error("Couldn't find message handler for '" .. id .. "'"
					.. ", received: " .. message)
			end
		end
	end,

	error = function(self, message)
		if (self.errors_reported) then
			error("\n" .. (message or "unknown error"))
		else
			return message
		end
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

	--MODULE LOADING
	get_path = function(self, mod)
		local tried = {}

		for index, value in next, self.path do
			if (value:len() > 0) then
				value = value .. "."
			end
			
			local path = self:module_to_path(value .. mod)

			if (fs_exists(path)) then
				self:report("module_found", "Module found in " .. path)
				return path
			else
				table.insert(tried, path)
			end
		end

		return nil, tried
	end,

	add_path = function(self, path)
		table.insert(self.path, path)

		return self
	end,

	get = function(self, mod_name, ...)
		if (self.loaded[mod_name]) then
			return self.loaded[mod_name]
		else
			local path, attempts = self:get_path(mod_name)

			if (path) then
				return self:load(mod_name, path, ...)
			else
				self:error("Couldn't find module '" .. mod_name .. "'"
					.. "\n\nPaths tried:\n" .. table.concat(attempts, "\n"))
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
			self:error((mod_name or "unknown module") .. " error: " .. object)
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

return L