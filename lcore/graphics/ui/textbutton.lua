--[[
#id graphics.ui.textbutton
#title Text Button
#status production
#version 1.0

#desc A button that has text
]]

local L = (...)
local oop = L:get("utility.oop")
local button = L:get("graphics.ui.rectbutton")
local textlabel = L:get("graphics.ui.textlabel")
local textbutton

textbutton = oop:class(textlabel, rectbutton)({
})

return textbutton