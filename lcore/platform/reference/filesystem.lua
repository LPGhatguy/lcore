local L, this = ...
this.title = "PAAPI Reference Filesystem Implementation"
this.version = "0.1"
this.status = "prototype"
this.desc = "A no-op module providing a reference API"

local utable = L:get("lcore.utility.table")
local ref_fs

local fs_nop = function(name, ...)
	local arg = {...}
	local called
	
	return function()
		if (not called) then
			called = true
			print("Method 'filesystem." .. tostring(name) .. "' is not implemented.")
		end

		return unpack(arg)
	end
end

ref_fs = {
	derive = function(self, target)
		return utable:copymerge(self, target)
	end,

	read = fs_nop("read", "[reference implementation]"),
	write = fs_nop("write", true),
	list = fs_nop("list", {}),
	is_file = fs_nop("is_file", false),
	is_directory = fs_nop("is_directory", false)
}

return ref_fs