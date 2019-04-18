if minetest.global_exists("unified_inventory") then
	minetest.log("ui exists")

minetest.register_privilege("daylight", {
    description = "Can set Perma Time"
})

unified_inventory.register_button("ptime", {
	type = "image",
	image = "ptime.png"
	tooltip = ("Perma Time"),
	hide_lite=true,
	action = function(player)
		local player_name = player:get_player_name()
		minetest.log("Starting priv check")
		if minetest.check_player_privs(player_name, {daylight=true}) then
			minetest.log("Checked privs, checking if ptime = empty")
			if player:get_attribute("ptime") == nil
			   or player:get_attribute("ptime") == "" then
				player:set_attribute("ptime", "day")
				player:override_day_night_ratio(1)
				minetest.chat_send_player(player_name,
					("-!- Perma Day enabled"))
				minetest.log("Checked if ptime = empty, checking if ptime = day")
					
			elseif	player:get_attribute("ptime") == "day" then
					player:set_attribute("ptime", "night")
					player:override_day_night_ratio(.1)
					minetest.chat_send_player(player_name,
						("-!- Perma Night enabled"))
					minetest.log("Checked if ptime = day, checking if ptime = night")
						
			elseif player:get_attribute("ptime") == "night" then
					player:set_attribute("ptime", "")
					player:override_day_night_ratio(nil)
					minetest.chat_send_player(player_name,
						("-!- Perma Time disabled"))
					minetest.log("Checked if ptime = night, ending")
			end
		else
		minetest.chat_send_player(player_name,
			("You don't have the \"daylight\" privilege!"))
		end
end,
})
end