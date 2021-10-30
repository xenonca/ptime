minetest.register_privilege("daylight", {
    description = "Can set Perma Time",
    give_to_singleplayer = false,
})

local data = {
    day = 1,
    night = 0.1
}

local function ptime(name)
	local player = minetest.get_player_by_name(name)
    local pmeta = player:get_meta()
	if not pmeta:get("ptime") then
		pmeta:set_string("ptime", "day")
		player:override_day_night_ratio(1)
		minetest.chat_send_player(name, "-!- Perma day has been enabled")
    elseif pmeta:get("ptime") == "day" then
		pmeta:set_string("ptime", "night")
		player:override_day_night_ratio(.1)
		minetest.chat_send_player(name, "-!- Perma night has been enabled")
    elseif pmeta:get("ptime") == "night" then
		pmeta:set_string("ptime", nil)
		player:override_day_night_ratio(nil)
		minetest.chat_send_player(name, "-!- Perma time has been disabled")
    end
end

minetest.register_chatcommand("ptime", {
    privs = {daylight = true},
    description = ("Set a permanent day time"),
    func = function(name)
        if not minetest.get_player_by_name(name) then
            return false, "-!- Player does not exist!"
        end
        ptime(name)
    end
})

minetest.register_on_joinplayer(function(player, last_login)
    if not last_login then return end
    local psetting = player:get_meta():get("ptime")

    if psetting then
        player:override_day_night_ratio(data[psetting])
        minetest.chat_send_player(player:get_player_name(), "-!- Perma " .. psetting .. " is enabled")
    end
end)

local defaultnp = minetest.settings:get("ptime.default")
if defaultnp and (defaultnp == "day" or defaultnp == "night") then
    minetest.register_on_newplayer(function(player)
        player:get_meta():set_string("ptime", defaultnp)
        player:override_day_night_ratio(data[defaultnp])
        minetest.chat_send_player(player:get_player_name(), "-!- Perma " .. defaultnp .. " is enabled")
    end)
end

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