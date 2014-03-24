--[[
#id utility.math
#title Math Utilities
#version 0.1
#status incomplete

#desc Provides extended mathematical operations
]]

local L = (...)
local umath

umath = {
	--@method expmod
	--Computes a^b mod c for large, positive, and natural a and b
	expmod = function(a, b, c)
		if (b == 0) then
			return 1
		elseif (b == 1) then
			return a % c
		elseif (b % 2 == 0) then
			return umath.expmod((a^2) % c, b / 2, c)
		else
			return (a * umath.expmod((a^2) % c, (b - 1) / 2, c)) % c
		end
	end
}

return umath