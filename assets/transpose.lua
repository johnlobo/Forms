local dlg = Dialog { title = "Transpose image" }

dlg:label {
    label = "Transpose image"
}

dlg:combobox {
    id = "orientation",
    label = "Transpose orientation: ",
    option = "Horizontal -> Vertical",
    options = {
        "Vertical -> Horizontal",
        "Horizontal -> Vertical",
        }
}

dlg:number {
    id = "width",
    label = "Width: ",
    text = string.format("%.1d", 4),
    decimals = 0
}

dlg:number {
    id = "height",
    label = "Height: ",
    text = string.format("%.1d", 9),
    decimals = 0
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
            local items_h = w / args.width


            
            -- Increase height to receive the transposed data
            if args.orientation == "Horizontal -> Vertical" then
                -- Create a new sprite to transpose data                
                local sprite2 = Sprite(w, items_h * args.height)
                app.activeSprite = sprite2
                local cel2 = app.activeCel
                local image2 = cel2.image

                -- Transpose data
                local j = 0
                local x = 0
                local y = 0
                for y = 0, h -1, 1 do
                    j=y
                    for x = 0, w, 1 do
                        local pixelValue = image:getPixel(x, y)
                        image2:drawPixel(math.fmod(x, args.width), j, pixelValue)
                        if ((x>0) and (math.fmod(x, args.width)==3)) then 
                            j = j + args.height
                        end
                    end
                end
                -- Change width to adjust to the data size
                sprite2.width = args.width
            end
            -- Refresh Aseprite
            app.refresh()
            -- Close dialog
            dlg:close()
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