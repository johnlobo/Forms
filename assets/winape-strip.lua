local dlg = Dialog { title = "Shrink Image to Half" }

dlg:label {
    label = "Shrink image to half??"
}

dlg:button {
    id = "ok",
    text = "OK",
    focus = false,
    onclick = function()
        local args = dlg.data
        if args.ok then

            local sprite = app.activeSprite
            if sprite == nil then
                sprite = Sprite(64, 64)
                app.activeSprite = sprite
            end

            local cel = app.activeCel
            local image = cel.image

            local w = image.width
            local h = image.height

            for y = 0, h, 1 do
                for x = 2, w, 2 do
                    local pixelValue = image:getPixel(x, y)
                    image:drawPixel(x/2, y, pixelValue)
                end
            end

            sprite.width = w / 2
            sprite.pixelRatio = Size(2,1)

            app.refresh()
        end
    end
}

dlg:button {
    id = "cancel",
    text = "CANCEL",
    onclick = function()
        dlg:close()
    end
}

dlg:show { wait = false }