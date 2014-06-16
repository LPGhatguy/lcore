local this = {
	title = "LCORE",
	version = "1.0.0",
	status = "development",

	desc = "Provides the basis for lcore and all its modules.",

	todo = {
		"Allow deprecation and tracing of tables and other properties.",
		"Improve method_name's inference.",
		"Look into fixing loop complexify of L:get"
	}
}

if (type(...) ~= "string") then
	error("lcore invoked incorrectly; use require('lcore')")
	return
end

local root = (...):match("(.+)%..-$")

local L
local N

local fs_load = function(path)
	if (L.__internal_platform == "love") then
		return love.filesystem.load(path)
	else
		return loadfile(path)
	end
end

local fs_isfile = function(path)
	if (L.__internal_platform == "love") then
		return love.filesystem.isFile(path)
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

local fs_isdir = function(path)
	if (L.__internal_platform == "love") then
		return love.filesystem.isDirectory(path)
	else
		local handle, err = io.open(path, "r")

		if (handle) then
			handle:close()
			return false
		else
			if (err:lower():match("permission")) then
				--This is _probably_ a directory
				return true
			else
				return false
			end
		end
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
	end,

	compose = function(target, method)
		return function(...)
			return target(method(...))
		end
	end,

	compose_method = function(target, method)
		return function(self, ...)
			return target(self, method(self, ...))
		end
	end
}

L = {
	__internal_platform = love and "love" or "vanilla",

	N = N,
	info = this,

	version = this.version,

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
	autotest = true,

	path = {root},
	loaded = {},
	metadata = {},

	--HIGHER-ORDER METHODS
	configure = function(self, settings)
		for key, value in pairs(settings) do
			self[key] = value
		end

		return self
	end,

	--UTILITY METHODS
	module_to_file_path = function(self, mod)
		return mod:gsub("%.", "/"):gsub("~", "..") .. ".lua"
	end,

	module_to_dir_path = function(self, mod)
		return mod:gsub("%.", "/"):gsub("~", "..")
	end,

	method_name = function(self, method, name)
		local info = debug.getinfo(method)

		return info.name
			or ("@" .. (info.short_src:match("[^/\\]+[\\/][^/\\]+$") or "(unknown file)")
				.. ":" .. info.linedefined)
	end,

	--calls a method and ignores any lcore errors
	safe_call = function(self, method, ...)
		local errors_reported = self.errors_reported
		local warnings_as_errors = self.warnings_as_errors

		self.errors_reported = false
		self.warnings_as_errors = false

		local result = {method(...)}

		self.errors_reported = errors_reported
		self.warnings_as_errors = warnings_as_errors

		return unpack(result)
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
				return self:error("Couldn't find message handler for '" .. id .. "'"
					.. ", received: " .. message)
			end
		end
	end,

	error = function(self, message, level)
		if (self.errors_reported) then
			error("\n" .. (message or "unknown error"), 2 + (level or 0))
		else
			return message
		end
	end,

	warn = function(self, message, level)
		if (self.warnings_reported) then
			if (self.warnings_as_errors) then
				error(message or "unknown error", 2 + (level or 0))
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

		local file_path = self:module_to_file_path(mod)
		local dir_path = self:module_to_dir_path(mod)

		if (fs_isfile(file_path)) then
			self:report("module_found", "Module found in " .. file_path)
			return file_path
		elseif (fs_isdir(dir_path)) then
			self:report("module_found", "Module found in " .. dir_path)
			return dir_path
		else
			table.insert(tried, file_path)
			table.insert(tried, dir_path)
		end

		for index, value in next, self.path do
			local file_path = self:module_to_file_path(value .. "." .. mod)
			local dir_path = self:module_to_dir_path(value .. "." .. mod)

			if (fs_isfile(file_path)) then
				self:report("module_found", "Module found in " .. file_path)
				return file_path, value
			elseif (fs_isdir(dir_path)) then
				self:report("module_found", "Module found in " .. file_path)
				return dir_path, value
			else
				table.insert(tried, file_path)
				table.insert(tried, dir_path)
			end
		end

		return nil, nil, tried
	end,

	add_path = function(self, path)
		table.insert(self.path, path)

		return self
	end,

	get = function(self, mod_name, safe, ...)
		if (self.loaded[mod_name]) then
			return self.loaded[mod_name]
		else
			for index, path in ipairs(self.path) do
				local full_name = path .. mod_name

				if (self.loaded[full_name]) then
					return self.loaded[full_name]
				end
			end

			local path, root, attempts = self:get_path(mod_name)

			if (path) then
				return self:load(mod_name, path, ...)
			elseif (not safe) then
				return nil, self:error("Couldn't find module '" .. mod_name .. "'"
					.. "\n\nPaths tried:\n" .. table.concat(attempts, "\n"))
			end
		end
	end,

	load_file = function(self, mod_name, path, ...)
		local chunk, err = fs_load(path)

		if (not chunk) then
			return nil, self:error(err)
		end

		local info = {
			mod_name = mod_name,
			mod_path = path
		}

		local success, object = pcall(chunk, self, info, ...)

		if (not success) then
			return nil, self:error((mod_name or "unknown module") .. " error: " .. object)
		end

		if (object) then
			if (mod_name) then
				self.loaded[mod_name] = object
				self.metadata[mod_name] = info

				if (self.autotest and info.test_module) then
					self:get(info.test_module)
				end
			end
		end

		return object, info
	end,

	load_directory = function(self, mod_name, path)
		local container = {__lcore_directory = true}

		setmetatable(container, {
			__index = function(container, key)
				container[key] = self:get(mod_name .. "." .. key)
				return container[key]
			end
		})

		self.loaded[mod_name] = container

		return container
	end,

	load = function(self, mod_name, path, ...)
		if (fs_isdir(path)) then
			return self:load_directory(mod_name, path, ...)
		elseif (fs_isfile(path)) then
			return self:load_file(mod_name, path, ...)
		else
			return nil, self:error("Could not load module at '" .. tostring(path) .. "'")
		end
	end
}

return L