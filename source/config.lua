import "scenes/viewer"

local gfx <const> = playdate.graphics
local store <const> = playdate.datastore

local line_height <const> = 20
local text_state = 0

local config = {
    inverted = true
}

function add_menu()
    local menu = playdate.getSystemMenu()

    local menuItem, error = menu:addMenuItem("Invert Color", function()
        toggle_mode(store.read("config").inverted == true, true)
    end)
end

function init_store()
    store.write(config, "config")
end

function toggle_mode(condition, redraw_viewer)
    gfx.sprite.update()
    condition = condition or false
    redraw = redraw or false

    if condition then
        set_light_mode()
    else
        set_dark_mode()
    end

    if redraw_viewer then
        show_viewer()
    end
end

function set_light_mode()
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    config.inverted = false
    store.write(config, "config")
end

function set_dark_mode()
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeInverted)

    config.inverted = true
    store.write(config, "config")
end

function get_line_height()
    return line_height
end

function get_text_state()
    return text_state
end

function set_text_state(value)
    if (value < 0) then
        text_state = 3
    elseif (value > 3) then
        text_state = 0
    else
        text_state = value
    end
end
