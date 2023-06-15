local spr = app.activeSprite
if not spr then return app.alert "No active sprite" end
if not spr.colorMode == ColorMode.RGB then return app.alert "Color mode must be RGB" end

local dlg = Dialog("Majority downsize weighted")
dlg:entry{ id="downsize", label="Downsize", text="0", focus=true }
   :entry{ id="invisibleFactor", label="InvisibleFactor", text="1"}
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

            -- Loop through each (downsizeI x downsizeI) chunk of pixels
            for y = 0, imgInput.height - 1, downsizeI do
                for x = 0, imgInput.width - 1, downsizeI do
                    -- Create a table to store the pixel counts
                    local counts = {}
                    -- Loop through each pixel in the chunk

                    local chunkYTrue = -1
                    for chunkY = y, y + downsizeI-1 do

                        chunkYTrue = chunkYTrue + 1
                        local chunkXTrue = -1

                        for chunkX = x, x + downsizeI-1 do
                            chunkXTrue = chunkXTrue + 1

                            -- Get the color of the pixel
                            local color = imgInput:getPixel(chunkX, chunkY)

                            --find the number to add to the count
                            local weight = chunkYTrue+1
                            if downsizeI-chunkYTrue < weight then weight = downsizeI-chunkYTrue end
                            if downsizeI-chunkXTrue < weight then weight = downsizeI-chunkXTrue end
                            if chunkXTrue+1 < weight then weight = chunkXTrue+1 end

                            --apply invisible multiplyer
                            if app.pixelColor.rgbaA(color) == 0 then 
                                weight = weight * data.invisibleFactor
                            end
                            if weight ~= 0 then
                                counts[color] = (counts[color] or 0) + weight
                            end
                        end
                    end

                    -- Find the color with the highest count
                    local maxCount = 0
                    local maxColor = app.pixelColor.rgba(0,0,0,0)

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
            imgOutput = Image(imgInput.width / downsizeI, imgInput.height / downsizeI);
            

            local iA = 1;
            for it in imgOutput:pixels() do
                it(colors[iA])          -- set pixel
                iA = iA+1
            end

            cel.image = imgOutput
            cel.position = Point(0, 0)
        end
        spr:crop(imgOutput.bounds)
    end)
end