local L, this = ...
this.title = "Metadata Utilities"
this.version = "1.0"
this.status = "prototype"
this.desc = "Provides methods for defining metadata about items"

local lcore = L.lcore
local oop = lcore.utility.oop
local utable = lcore.utility.table
local metadata

local function parse_arg_list(list)
	list = list .. " "
	local len = #list

	if (len <= 1) then
		return {}
	end

	local entries, required_entries, optional_entries = {}, {}, {}
	local arg_name_buffer = {}
	local arg_type_buffer = {}
	local arg_default_buffer = {}
	local defaulting = false
	local name = false
	local optional = false

	for index = 1, len do
		local char = list:sub(index, index)

		if (char == "[") then
			optional = true
		elseif (char == "]") then
			optional = false
		elseif (char == "=") then
			defaulting = true
		elseif (char == "," or index == len) then
			local entry = {
				type = table.concat(arg_type_buffer),
				name = table.concat(arg_name_buffer),
				default = table.concat(arg_default_buffer)
			}

			utable:array_data(arg_type_buffer)
			utable:array_data(arg_name_buffer)
			utable:array_data(arg_default_buffer)

			defaulting = false
			name = false

			table.insert(entries, entry)
			table.insert(optional and optional_entries or required_entries, entry)
		elseif (defaulting) then
			table.insert(arg_default_buffer, char)
		elseif (char == " ") then
			if (#arg_type_buffer > 0) then
				name = true
			end
		else
			table.insert(name and arg_name_buffer or arg_type_buffer, char)
		end
	end

	return entries, required_entires, optional_entries
end

metadata = oop:static() {
	method_group = function(self, ...)
		return {
			group = true,
			...
		}
	end,

	smethod = function(self, definition, description)
		local output_list, name, argument_list = definition:match("^(.-)%s?([^%s%(]*)%((.*)%)$")

		local outputs, required_outputs, optional_outputs = parse_arg_list(output_list or "")
		local arguments, required_arguments, optional_arguments = parse_arg_list(argument_list or "")

		return {
			outputs = outputs,
			required_outputs = required_outputs,
			optional_outputs = optional_outputs,

			arguments = arguments,
			required_arguments = required_arguments,
			optional_arguments = optional_arguments,

			description = description
		}
	end
}

return metadata