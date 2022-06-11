import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "config"
import "fs"

local gfx <const> = playdate.graphics
local display <const> = playdate.display
local store <const> = playdate.datastore
local timer <const> = playdate.timer

local default_text <const> = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"
local line_height <const> = 20

local intro_played = false
local offset = 0
local text_state = 0
local total_height = 0
local firstPosition = nil
local lastPosition = nil

function init()
    print('app.uuid=cfa01cf3922543ce8c8bf5cb584e66f3')

    if (store.read("config") == nil) then
        init_store()
    end

    toggle_mode(store.read("config").inverted == false)
    add_menu()

    fonts = get_fonts(categories)
    total_height = table.length(fonts) * line_height

    local delay <const> = intro_played and 0 or 1000
    local timer = playdate.timer.new(delay, 0, 1)

    timer.updateCallback = function (t)
      if not intro_played then play_intro() end
    end

    timer.timerEndedCallback = function ()
      intro_played = true
      show_viewer()
    end
end

init()

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        text_state = 0
        show_viewer()
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        text_state = text_state == 0 and 2 or text_state - 1
        show_viewer()
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        text_state = text_state == 2 and 0 or text_state + 1
        show_viewer()
    end
end

function playdate.downButtonDown()
    lock_screen(-display.getHeight())
end

function playdate.upButtonDown()
    lock_screen(display.getHeight())
end

function playdate.cranked(change, acceleratedChange)
    lock_screen(change)
end

function lock_screen(change)
    local allSprites <const> = playdate.graphics.sprite.getAllSprites()

    offset = offset + change

    for index, sprite in ipairs(allSprites) do
        local x, y = sprite:getPosition()
        sprite:moveTo(x, y+change)
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
    gfx.sprite.removeAll()

    if text_state == 1 then
        message = string.upper(default_text)
    elseif text_state == 2 then
        message = string.lower(default_text)
    end

    for index, file in ipairs(fonts) do
        if text_state == 0 then
            message = file.name
        end

        local messageWidth, messageHeight = gfx.getTextSize(message)
        local font <const> = gfx.font.new(file.path)
        gfx.setFont(font)

        local textImage = gfx.image.new(400, line_height)
        gfx.pushContext(textImage)
            gfx.drawText(message, 0, 0)
        gfx.popContext()

        textSprite = gfx.sprite.new(textImage)
        textSprite:moveTo(
            (display.getWidth()) - (messageWidth / 2),
            index * line_height + offset
        )
        textSprite:add()
    end
end

