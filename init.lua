
local modpath = minetest.get_modpath("ptime").. DIR_DELIM

if minetest.global_exists("unified_inventory") then
	minetest.log("action", "ptime using unified_inventory")
	dofile(modpath .. "ptime_ui/init.lua")
else
	minetest.log("action", "ptime not using unified_inventory")
	dofile(modpath .. "ptime/init.lua")
end
