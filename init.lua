minetest.register_privilege("daylight", {
    description = "Can set Perma Time",
    give_to_singleplayer = false,
})

local function ptime(name)
	local player = minetest.get_player_by_name(name)
    local pmeta = player:get_meta()
	if not pmeta:get("ptime") then
		pmeta:set_string("ptime", "day")
		player:override_day_night_ratio(1)
		minetest.chat_send_player(name, "-!- Perma Day has been enabled")
    elseif pmeta:get("ptime") == "day" then
		pmeta:set_string("ptime", "night")
		player:override_day_night_ratio(.1)
		minetest.chat_send_player(name, "-!- Perma Night has been enabled")
    elseif pmeta:get("ptime") == "night" then
		pmeta:set_string("ptime", nil)
		player:override_day_night_ratio(nil)
		minetest.chat_send_player(name, "-!- Perma Time has been disabled")
    end
end

minetest.register_chatcommand("ptime", {
    privs = {
        daylight = true,
    },
    description = ("Set a permanent day time"),
    func = function(name)
        if not minetest.get_player_by_name(name) then
            return false, "-!- Player does not exist!"
        end
        ptime(name)
    end
})

minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
    local pmeta = player:get_meta()
	if pmeta:get_string("ptime") == "day" then
        player:override_day_night_ratio(1)
	    minetest.chat_send_player(pname, "-!- Perma Day is enabled")
	elseif pmeta:get_string("ptime") == "night" then
	    player:override_day_night_ratio(".1")
	    minetest.chat_send_player(pname, "-!- Perma Night is enabled")
    end
end)

if minetest.global_exists("unified_inventory") then
    unified_inventory.register_button("ptime", {
        type = "image",
        image = "ptime.png",
        tooltip = ("Perma Time"),
        hide_lite=true,
        action = function(player)
            local player_name = player:get_player_name()
            if not minetest.check_player_privs(player_name, {daylight=true}) then
                minetest.chat_send_player(player_name, "-!- You don't have the \"daylight\" privilege!")
                return
            end
            ptime(player_name)
    end})
end