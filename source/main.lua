import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "config"
import "fs"
import "scenes/intro"
import "scenes/viewer"

local gfx <const> = playdate.graphics
local display <const> = playdate.display
local store <const> = playdate.datastore
local timer <const> = playdate.timer

local intro_played = false
local offset = 0
local total_height = 0

function init()
    print('app.uuid=cfa01cf3922543ce8c8bf5cb584e66f3')

    if (store.read("config") == nil) then
        init_store()
    end

    toggle_mode(store.read("config").inverted == false)

    local fonts <const> = get_fonts()
    total_height = table.length(fonts) * get_line_height()

    local delay <const> = intro_played and 0 or 1000
    local timer = playdate.timer.new(delay, 0, 1)

    timer.updateCallback = function (t)
      if not intro_played then play_intro() end
    end

    timer.timerEndedCallback = function ()
      intro_played = true

      add_menu()
      show_viewer()
    end
end

init()

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()

    local text_state <const> = get_text_state()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        set_text_state(0)
        show_viewer()
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        set_text_state( text_state - 1)
        show_viewer()
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        set_text_state(text_state + 1)
        show_viewer()
    end
end

function playdate.downButtonDown()
    move_sprite(-display.getHeight())
end

function playdate.upButtonDown()
    move_sprite(display.getHeight())
end

function playdate.cranked(change, acceleratedChange)
    move_sprite(change)
end

function move_sprite(yDistance)
    local drawOffset <const> = playdate.graphics.getDrawOffset()
    offset = offset + yDistance

    if (offset >= display.getHeight() / 4) then
        offset = display.getHeight() / 4
    elseif (total_height + offset < display.getHeight() * 3/4) then
        offset = -1 * total_height + display.getHeight() * 3/4
    end

    playdate.graphics.setDrawOffset(0, math.floor(offset))
end
