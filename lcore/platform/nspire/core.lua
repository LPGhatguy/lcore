local L, this = ...
this.name = "TI-Nspire Platform Core"
this.version = "0.1"
this.status = "prototype"
this.desc = "A prototype implementation of a platform interface into the TI-Nspire Lua API."
this.notes = {
	"The capabilities of the Nspire are limited, and, as such, some API calls simply may be ignored."
}

local nspire_core

nspire_core = {
}

return nspire_core