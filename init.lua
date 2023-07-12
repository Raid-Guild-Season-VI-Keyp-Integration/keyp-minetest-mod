local step = {}

local http_api = minetest.request_http_api()
local player_metadata = {}
local error_message = {}

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
local login_url = "https://keypmine.luxumbra.dev/"
local auth_api_url = "https://minetest-auth.luxumbra.dev/"
local auth_headers = {
    ["Authorization"] = "Bearer ".. auth_key
}

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    player_metadata[player_name] = {}
    minetest.chat_send_player(player_name, "Welcome to the minetest server with Keyp! Type /help for available commands or /login to start the login process if you close it out.")
    show_initial_login_formspec(player_name)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "keyp:login" then
        local player_name = player:get_player_name()
        if fields.refresh_url then
            show_loading_formspec(player_name, "loading...")
            minetest.after(0.25, function()
                show_initial_login_formspec(player_name)
            end)
        elseif fields.next then
            step[player_name] = 2
            show_code_formspec(player_name)
        elseif fields.close then
            minetest.close_formspec(player_name, "keyp:login")
        elseif fields.submit then
            show_loading_formspec(player_name, "logging in...")
            local code = fields.code
            local headers = auth_headers
            -- headers["code"] = code
            -- Make the HTTP request
            http_lib.request_http_get(auth_api_url.. "getInfo/".. code, headers, function(response)
                if response.succeeded then
                    local data = minetest.parse_json(response.data)
                    
                    -- Check if there's an error message in the response data
                    print(data)
                    if data and data.message then
                        -- There's an error message, so handle the error
                        error_message[player_name] = data.message
                        show_code_formspec(player_name, error_message[player_name])
                        return
                    end
            
                    if data and data.accessToken and data.walletAddress then
                        player_metadata[player_name].access_token = data.accessToken
                        player_metadata[player_name].wallet_address = data.walletAddress
                        -- Add the HUD element
                        local player = minetest.get_player_by_name(player_name)
                        if player then
                            add_wallet_address_to_hud(player, data.walletAddress)
                            minetest.after(0.1, function()
                                show_loading_formspec(player_name, "success!")
                            end)
                            minetest.after(0.5, function()
                                minetest.close_formspec(player_name, "keyp:login")
                            end)
                            step[player_name] = nil -- Reset the step
                            error_message[player_name] = nil
                        else
                            print("error", "Player not found!")
                        end
                    else
                        error_message[player_name] = minetest.colorize("#FF0000","                                  Failed to get wallet address.\nPlease sign out in your browser and try again or contact an admin\n \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t error code [0]")
                        show_code_formspec(player_name, error_message[player_name])
                    end
                else
                    error_message[player_name] = minetest.colorize("#FF0000", "         Failed to get wallet address.\nPlease sign out in your browser and try again or contact an admin\n \t\t\t\t\t\t\t\t\t error code [0]")
                    show_code_formspec(player_name, error_message[player_name])
                end
            end)
        end
    end
end)

function show_initial_login_formspec(player_name)
    step[player_name] = 1 
    local formspec = 
        "formspec_version[4]" ..
        "size[9,9]" ..
        "no_prepend[]" ..
        "background[0,0;9,9;login-modal-welcome-75alpha.png;true]" ..
        "bgcolor[;neither;]" ..
        "textarea[1.6,4.5;5,.5;url;;"..login_url.."]" ..
        "image_button[6.8,4.5;.5,.5;refresh-button.png;refresh_url;;false;refresh-button.png]".. -- The refresh button
        "image_button[3.72,7.25;1.44,1.12;next-button.png;next;;false;next-button.png]"..
        "image_button[8,.25;.5,.5;close-button.png;close;;false;close-button.png]"
    local formname = "keyp:login"
    minetest.show_formspec(player_name, formname, formspec)
end

function show_code_formspec(player_name, error_message)
    local formspec = 
        "formspec_version[4]" ..
        "size[9,9]" ..
        "no_prepend[]" ..
        "background[0,0;9,9;login-modal-75alpha.png;true]" ..
        "bgcolor[;neither;]" ..
        "label[2.55,3;Enter the 6-digit code you received:]" ..
        "field[3.5,4;1.5,.75;code;       Code;]" ..
        "button[0,0;0,0;submit;]"..
        "image_button[3.72,7.25;1.44,1.12;next-button.png;submit;;false;next-button.png]"..
        "image_button[8,.25;.5,.5;close-button.png;close;;false;close-button.png]"
    
    -- If there's an error message, add it to the formspec
    if error_message then
        formspec = formspec .. "label[.8,5;".. minetest.formspec_escape(error_message) .."]"
    end

    minetest.show_formspec(player_name, "keyp:login", formspec)
end

function show_loading_formspec(player_name, message)
    local formspec = 
        "formspec_version[4]" ..
        "size[9,9]" ..
        "no_prepend[]" ..
        "background[0,0;9,9;login-modal-75alpha.png;true]" ..
        "bgcolor[;neither;]" ..
        "label[3.75,4;"..message.."]" 
                
    minetest.show_formspec(player_name, "keyp:login", formspec)
end

minetest.register_chatcommand("login", {
    description = "Open the login form",
    func = function(name, param)
        show_initial_login_formspec(name)
    end,
})

minetest.register_chatcommand("logout", {
    description = "Logout of keyp by deleting access token and wallet address, does not expire access token in your browser",
    func = function(name, param)
        logout(name)
    end, 
})

function add_wallet_address_to_hud(player, wallet_address)
    player_metadata[player:get_player_name()].hud_id = player:hud_add({
        hud_elem_type = "text",
        position = {x = 1, y = 0},
        offset = {x = -475, y = 10},
        text = "Wallet: " .. wallet_address,
        alignment = {x = 1, y = 1},
        number = 0xFFFFFF
    })
end

function logout(player_name)
    local player = minetest.get_player_by_name(player_name)
    if player and player_metadata[player_name] and player_metadata[player_name].hud_id then
        player:hud_remove(player_metadata[player_name].hud_id)
    end
    player_metadata[player_name] = {}
    minetest.chat_send_player(player_name, "Successfully logged out.")
end

minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    logout(player_name)
    step[player_name] = nil -- Reset the step when the player leaves
    error_message[player_name] = nil -- Reset the error message when the player leaves
end)