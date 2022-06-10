local gfx <const> = playdate.graphics
local store <const> = playdate.datastore

local config = {
    inverted = true
}

function add_menu()
    local menu = playdate.getSystemMenu()

    local menuItem, error = menu:addMenuItem("Invert Color", function()
        toggle_mode(store.read("config").inverted == true)
    end)
end

function init_store()
    store.write(config, "config")
end

function toggle_mode(condition)
    condition = condition or false

    if condition then
        set_dark_mode()
    else
        set_light_mode()
    end
end

function set_dark_mode()
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    config.inverted = false

    store.write(config, "config")
end

function set_light_mode()
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeInverted)
    config.inverted = true

    store.write(config, "config")
end