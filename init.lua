local step = {}

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    step[player_name] = 1
    local url = "https://login-url.com"
    local formspec = 
        "formspec_version[4]" ..
        "size[9,9]" ..
        "no_prepend[]" ..
        "background[0,0;9,9;login-modal-60alpha.png;true]" ..
        "bgcolor[;neither;]" ..
        "textarea[2,4.5;5,.5;url;;"..url.."]" ..
        "image_button[8,.25;.5,.5;close-button.png;exit;;false;close-button.png]"..
        "image_button[3.72,7.25;1.44,1.12;next-button.png;next;;false;next-button.png]"
    minetest.show_formspec(player_name, "keyp:login", formspec)
end)


minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "keyp:login" then
        local player_name = player:get_player_name()
        if fields.next then
            step[player_name] = 2
            local formspec = "size[6,4]" ..
                "label[0.5,0.5;Enter the 6-digit code you received:]" ..
                "field[0.5,2;5,1;code;Code;]" ..
                "button_exit[2,3;2,1;submit;Submit]"
            minetest.after(0.1, function()
                minetest.show_formspec(player_name, "keyp:login", formspec)
            end)
        elseif fields.submit then
            local code = fields.code
            print(code)
            -- Do something with the code.
            step[player_name] = nil -- Reset the step
        end
    end
end)

minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    step[player_name] = nil -- Reset the step when the player leaves
end)
