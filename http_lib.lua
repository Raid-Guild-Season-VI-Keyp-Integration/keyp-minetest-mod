-- In http_lib.lua

return function(http)
    -- Create a new table to hold our functions
    local http_lib = {}

    -- Function to make an HTTP GET request
    function http_lib.request_http_get(url, headers)
        -- Use http.fetch to make the HTTP request
        local extra_headers = {}
        for k, v in pairs(headers) do
            table.insert(extra_headers, k .. ": " .. v)
        end
        http.fetch({url = url, extra_headers = extra_headers}, function(res)
            if res.succeeded then
                print("HTTP GET request succeeded with code " .. res.code)
                print("Response body: " .. res.data)
            else
                print("HTTP GET request failed with message: " .. res.error_message)
            end
        end)
    end

    function http_lib.post(url, data, callback)
        if http then
            local post_data = minetest.write_json(data)
            http.fetch({url = url, post_data = post_data}, function(result)
                callback(result.succeeded, result.data, result.error)
            end)
        else
            minetest.log("error", "HTTP API not available. Please add this mod to secure.http_mods in minetest.conf.")
        end
    end

    return http_lib
end
