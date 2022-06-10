import "util"

local fs <const> = playdate.file

function get_categories()
    local fonts <const> = fs.listFiles("fonts")
    local subdirs <const> = {}

    for index, file in ipairs(fonts) do
        if ends_with(file, "/") then
            table.insert(subdirs, file)
        end        
    end

    return fonts
end

function get_fonts(categories)
    local fonts <const> = {}

    for index, category in ipairs(categories) do
        local files <const> = fs.listFiles("fonts/" .. category)

        for index, file in ipairs(files) do
            file = basename(file)

            -- only include fixed width fonts
            if not ends_with(file, "(auto-sized)") then
                pretty_name = file:gsub("%(fixed width%)", "")
                pretty_name = pretty_name:gsub("[^%w%s]+", "")
                pretty_name = string.upper(pretty_name)
                pretty_name = trim(pretty_name)

                table.insert(fonts, {
                    path = "fonts/" .. category .. file,
                    name = pretty_name,
                    category = category
                })
            end        
        end    
    end

    table.sort(fonts, function(a, z) return a.name < z.name end)

    return fonts
end