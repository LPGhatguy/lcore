local L, this = ...
this.title = "Data Serializer"
this.version = "0.1"
this.status = "prototype"
this.desc = "Provides data serialization and dense packing of objects."
this.todo = {
	"Complete rewrite."
}

local serialize

serialize = {
	primitives = {
		["number"] = {
			is = tonumber,
			read = tonumber,
			write = tostring
		},

		["boolean"] = {
			is = function(source)
				source = source:lower()
				return (source == "false") or (source == "true")
			end,

			read = function(source)
				return (source == "true")
			end,

			write = function(source)
				return source and "true" or "false"
			end
		},

		["string"] = {
			is = function(source)
				return (source:sub(1, 1) == "\"") and (source:sub(source:len()) == "\"")
			end,

			read = function(source)
				return source:sub(2, source:len() - 1)
			end,

			write = function(source)
				return "\"" .. source .. "\""
			end
		},

		["static"] = {
			is = function(source)
				return not not source:match("^%[%w+%]%(.+%)$")
			end,

			read = function(source)
				--TODO
			end,
		}
	},

	serialize = function(self, source, ...)
		--TODO
	end
}

return serialize