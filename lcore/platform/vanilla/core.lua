local L, this = ...
this.title = "Lua Vanilla Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides useful interfaces for using lcore with vanilla Lua."

local vanilla_core = L:get("lcore.service.nop"):new()

vanilla_core.__platform_name = "vanilla"
vanilla_core.__platform_version = "1.0"

vanilla_core.filesystem = L:get("lcore.platform.vanilla.filesystem")

return vanilla_core