local default_text <const> = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"

local gfx <const> = playdate.graphics
local display <const> = playdate.display

import "config"

function show_viewer()
    gfx.clear()
    gfx.sprite.removeAll()

    local message
    local text_state <const> = get_text_state()

    if text_state == 1 then
        message = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    elseif text_state == 2 then
        message = "abcdefghijklmnopqrstuvwxyz"
    elseif text_state == 3 then
        message = "0123456789"
    end

    local fonts <const> = get_fonts()

    for index, file in ipairs(fonts) do
        if text_state == 0 then
            message = file.name
        end

        local line_height <const> = get_line_height()

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
            index * line_height
        )
        textSprite:add()
    end
end
