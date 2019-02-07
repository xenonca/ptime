
minetest.register_privilege("daylight", {
    description = "Can set Perma Day"
})


local function pday(name)
	local player = minetest.get_player_by_name(name)
	if player:get_attribute("pday") == "true" then
    player:set_attribute("pday", "")
    player:override_day_night_ratio(nil)
    minetest.chat_send_player(name, "-!- Perma Day has been disabled.") else
    player:set_attribute("pday", "true")
    player:override_day_night_ratio(1)
    minetest.chat_send_player(name, "-!- Perma Day has been enabled.")
  end
end

minetest.register_chatcommand("pday", {
  privs = {
        daylight = true,
    },
  description = ("Set day permanently"),
  func = function(name)
    local player = minetest.get_player_by_name(name)
      if player == nil then
        return false, "Player does not exist!"
      end
  pday(name)
end
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if player:get_attribute("pday") == "true" then
		pday(name)
  end
end)
