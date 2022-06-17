local display <const> = playdate.display
local gfx <const> = playdate.graphics

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
