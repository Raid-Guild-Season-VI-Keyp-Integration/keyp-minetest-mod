local step = {}

local http_api = minetest.request_http_api()
local player_metadata = {}

if not http_api then
    print("error", "Failed to get the HTTP API!")
    return
end

-- Load http_lib.lua
local http_lib = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/http_lib.lua")(http_api)

-- Get the auth key from an environment variable
local auth_key = os.getenv("AUTH_KEY")

-- If the auth key is not found, print an error and return
if not auth_key then
    print("error", "Auth key not found in environment variables!")
    return
end

-- Then, when making the HTTP request, include the auth key in the headers
local auth_api_url = "http://127.0.0.1:5000/"
local auth_headers = {
    ["Authorization"] = "Bearer ".. auth_key
}

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    step[player_name] = 1
    local url = "https://login-url.com"
    local formspec = 
        "formspec_version[4]" ..
        "size[9,9]" ..
        "no_prepend[]" ..
        "background[0,0;9,9;login-modal-welcome-75alpha.png;true]" ..
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
            local formspec = 
                "formspec_version[4]" ..
                "size[9,9]" ..
                "no_prepend[]" ..
                "background[0,0;9,9;login-modal-75alpha.png;true]" ..
                "bgcolor[;neither;]" ..
                "label[0.5,0.5;Enter the 6-digit code you received:]" ..
                "field[0.5,2;5,1;code;Code;]" ..
                "image_button[8,.25;.5,.5;close-button.png;exit;;false;close-button.png]"..
                "image_button[3.72,7.25;1.44,1.12;next-button.png;submit;;false;next-button.png]"
            minetest.after(0.1, function()
                minetest.show_formspec(player_name, "keyp:login", formspec)
            end)
        elseif fields.submit then
            local code = fields.code
            print(code)
            local headers = auth_headers
            headers["code"] = code
            -- Make the HTTP request
            http_lib.request_http_get(auth_api_url.. "auth", headers, function(response)
                if response.succeeded then
                    local data = minetest.parse_json(response.data)
                    if data and data.access_token and data.wallet_address then
                        -- Save access token and wallet address
                        player_metadata[player_name].access_token = data.access_token
                        player_metadata[player_name].wallet_address = data.wallet_address
                        -- Add the HUD element
                        local player = minetest.get_player_by_name(player_name)
                        if player then
                            add_wallet_address_to_hud(player, data.wallet_address)
                        end
                    else
                        minetest.chat_send_player(player_name, "Failed to get wallet address.")
                    end
                else
                    minetest.chat_send_player(player_name, "Failed to get wallet address.")
                end
            end)
        
            step[player_name] = nil -- Reset the step
        end
    
    end
end)

minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    step[player_name] = nil -- Reset the step when the player leaves
end)


function add_wallet_address_to_hud(player, wallet_address)
    player:hud_add({
        hud_elem_type = "text",
        position = {x = 0, y = 0},
        offset = {x = 10, y = 10},
        text = "Wallet: " .. wallet_address,
        alignment = {x = 1, y = 1},
        number = 0xFFFFFF
    })
end