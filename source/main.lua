import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/keyboard"
import "CoreLibs/object"
import "CoreLibs/qrcode"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "config"
import "fs"

local gfx <const> = playdate.graphics
local display <const> = playdate.display
local store <const> = playdate.datastore
local timer <const> = playdate.timer

local default_text <const> = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"
local line_height <const> = 18

local intro_played = false
local offset = 0
local text_state = 0
local total_height = 0

function init()
    if (store.read("config") == nil) then
        init_store()
    end
    
    toggle_mode(store.read("config").inverted == false)
    add_menu()

    local categories <const> = get_categories()
    local categories <const> = get_categories()

    fonts = get_fonts(categories)
    total_height = table.length(fonts) * line_height
end

init()

function playdate.update()
    playdate.timer.updateTimers()
    
    local delay = 1000

    if not intro_played then
        play_intro()

        intro_played = true
        delay = 3000
    end

    timer.performAfterDelay(delay, function()
        show_viewer()
    end)
    -- show_viewer()
end

function playdate.downButtonDown()
    lock_screen(display.getHeight())
end

function playdate.upButtonDown()
    lock_screen(-display.getHeight())
end

function playdate.cranked(change)
    lock_screen(math.floor(change))
end

function lock_screen(change)
    if (offset + change >= total_height - display.getHeight() * 3/4) then
        offset = total_height - display.getHeight() * 3/4
    elseif (offset + change <= 0 - display.getHeight() / 4) then
        offset = 0 - display.getHeight() / 4
    else
        offset = offset + change
    end
end

function play_intro()
    gfx.clear()

    local message <const> = "@ i d l e b e r g"
    local messageWidth, messageHeight = gfx.getTextSize(message)

    gfx.drawText(
        message,
        (display.getWidth() / 2) - (messageWidth / 2),
        (display.getHeight() / 2) - (messageHeight / 2)
    )
end

function show_viewer()
    gfx.clear()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        text_state = 0
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        text_state = text_state == 0 and 2 or text_state - 1
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        text_state = text_state == 2 and 0 or text_state + 1
    end

    for index, file in ipairs(fonts) do
        if text_state == 0 then
            message = file.name
        elseif text_state == 1 then 
            message = string.upper(default_text)
        elseif text_state == 2 then
            message = string.lower(default_text)
        end

        local messageWidth, messageHeight = gfx.getTextSize(message)
        local font <const> = gfx.font.new(file.path)
        gfx.setFont(font)

        gfx.drawText(
            message,
            (display.getWidth() / 2) - (messageWidth / 2),
            index * line_height - offset - line_height / 2
        )
    end
end
