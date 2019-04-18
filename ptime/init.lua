
minetest.register_privilege("daylight", {
    description = "Can set Perma Time"
})

local function ptime(name)
	local player = minetest.get_player_by_name(name)
	if player:get_attribute("ptime") == nil
	or player:get_attribute("ptime") == "" then
		player:set_attribute("ptime", "day")
		player:override_day_night_ratio(1)
		minetest.chat_send_player(name, "-!- Perma Day has been enabled.") elseif
		player:get_attribute("ptime") == "day" then
		player:set_attribute("ptime", "night")
		player:override_day_night_ratio(.1)
		minetest.chat_send_player(name, "-!- Perma Night has been enabled.") elseif
		player:get_attribute("ptime") == "night" then
		player:set_attribute("ptime", nil)
		player:override_day_night_ratio(nil)
		minetest.chat_send_player(name, "-!- Perma Time has been disabled.")
  end
end

minetest.register_chatcommand("ptime", {
  privs = {
        daylight = true,
    },
  description = ("Set a permanent day time."),
  func = function(name)
    local player = minetest.get_player_by_name(name)
      if player == nil then
        return false, "Player does not exist!"
      end
  ptime(name)
end
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if player:get_attribute("ptime") == "day"
	or player:get_attribute("ptime") == "night" then
	player:set_attribute("ptime", nil)
	minetest.chat_send_player(name, "-!- Perma Time has been disabled.")
		ptime(name)
  end
end)
