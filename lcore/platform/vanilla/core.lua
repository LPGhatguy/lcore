local L, this = ...
this.title = "Lua Vanilla Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides useful interfaces for using lcore with vanilla Lua."

local ref_core = L:get("lcore.platform.reference.core")
local vanilla_core

vanilla_core = ref_core:derive {
	platform_name = "vanilla",
	platform_version = "1.0",

	filesystem = L:get("lcore.platform.vanilla.filesystem"),
	graphics = L:get("lcore.platform.reference.graphics")
}

return vanilla_core