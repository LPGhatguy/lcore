local L, this = ...
this.title = "Metadata Types"
this.version = "1.0"
this.status = "prototype"
this.desc = "A list of usable base types"

local lcore = L.lcore
local oop = lcore.utility.oop
local types

types = oop:static() {
	float = {
		is = function(object)
			return type(object) == "number"
		end
	},

	int = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0)
		end
	},

	uint = {
		is = function(object)
			return (type(object) == "number") and (object >= 0) and (object % 1 == 0)
		end
	},

	int8 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object >= -2^7) and (object < 2^7)
		end
	},

	uint8 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object < 2^8)
		end
	},

	int16 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object >= -2^15) and (object < 2^15)
		end
	},

	uint16 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object < 2^16)
		end
	},

	int32 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object >= -2^31) and (object < 2^31)
		end
	},

	uint32 = {
		is = function(object)
			return (type(object) == "number") and (object % 1 == 0) and (object < 2^32)
		end
	},

	string = {
		is = function(object)
			return type(object) == "string"
		end
	},

	bool = {
		is = function(object)
			return type(object) == "boolean"
		end
	},

	table = {
		is = function(object)
			return type(object) == "table"
		end
	},

	userdata = {
		is = function(object)
			return type(object) == "userdata"
		end
	},

	void = {
		is = function(object)
			return object == nil
		end
	}
}

return types