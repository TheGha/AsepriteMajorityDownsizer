local spr = app.activeSprite
if not spr then return app.alert "No active sprite" end
if not spr.colorMode == ColorMode.RGB then return app.alert "Color mode must be RGB" end

local dlg = Dialog("Majority downsize")
dlg:entry{ id="downsize", label="Downsize", text="0", focus=true }
   :button{ id="ok", text="OK", focus=true }
   :button{ text="Cancel" }
dlg:show()

local data = dlg.data
if data.ok then
  app.transaction(
    function()
        local downsizeI = tonumber(data.downsize)
        for _,cel in ipairs(spr.cels) do
            local imgInput = Image(spr.width, spr.height)
            imgInput:drawImage(cel.image, cel.position)
        
            local colors = {}

            -- Loop through each 3x3 chunk of pixels
            for y = 0, imgInput.height - 1, downsizeI do
                for x = 0, imgInput.width - 1, downsizeI do
                    -- Create a table to store the pixel counts
                    local counts = {}

                    -- Loop through each pixel in the chunk
                    for j = y, y + downsizeI-1 do
                        for i = x, x + downsizeI-1 do
                            -- Get the color of the pixel
                            local c = imgInput:getPixel(i, j)

                            -- Increment the count for this color
                            counts[c] = (counts[c] or 0) + 1
                        end
                    end

                    -- Find the color with the highest count
                    local maxCount = 0
                    local maxColor = nil

                    for c, count in pairs(counts) do
                        if count > maxCount then
                            maxCount = count
                            maxColor = c
                        end
                    end

                    -- Add the color to the table
                    table.insert(colors, maxColor)
                end
            end
            local imgOutput = Image(imgInput.width / downsizeI, imgInput.height / downsizeI);

            local iA = 1;
            for it in imgOutput:pixels() do
                it(colors[iA])          -- set pixel
                iA = iA+1
            end

            cel.image = imgOutput;
        
        end
    end)
end