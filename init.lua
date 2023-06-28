-- In init.lua

-- Request the HTTP API
local http_api = minetest.request_http_api()

if not http_api then
    print("error", "Failed to get the HTTP API!")
    return
end

-- Load http_lib.lua
local http_lib = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/http_lib.lua")(http_api)

minetest.register_on_joinplayer(function(player)
    -- Example call to the HTTP request function
    http_lib.request_http_get("https://httpbin.org/get")
    local name = player:get_player_name()
    local formspec = {
        "size[10,3]",
        "label[0.5,0.5;Here is the URL you need to visit:]",
        "field[0.5,1.5;9,1;url_field;URL;http://example.com]",
        "button_exit[3,2;2,1;exit;Close]",
    }
    minetest.show_formspec(name, "mod:show_url", table.concat(formspec, ""))
end)

-- minetest.register_on_joinplayer(function(player)
    
-- end)