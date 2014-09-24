local L, this = ...
this.code = "lcore.platform.reference.graphics"

local lcore = L.lcore
local oop = lcore.utility.oop
local metadata = lcore.meta.metadata

return oop:static(lcore.meta.header) {
	members = {
		immediate = {
			rectangle = metadata:smethod("void rectangle(string mode, float x, float y, float width, float height)",
				"Draws a rectangle using draw mode [mode] with width [width] and height [height] at position [x],[y]"),
			circle = metadata:smethod("void circle(string mode, float x, float y, float radius)",
				"Draws a circle using draw mode [mode] centered at [x],[y] with a radius of [radius]"),
			arc = metadata:smethod("void arc(string mode, float x, float y, float radius, float angle1, float angle2)",
				"Draws an arc using draw mode [mode] centered at [x],[y] with a radius of [radius] starting at [angle1] and ending at [angle2]"),
			polygon = metadata:smethod("void polygon(string mode, ",
				"")
		},

		retained = {
		}
	}
}