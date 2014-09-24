local L, this = ...
this.title = "Header"
this.version = "1.0"
this.status = "prototype"
this.desc = "Provides methods for defining headers"

local lcore = L.lcore
local oop = lcore.utility.oop
local header

header = oop:static() {
}

return header