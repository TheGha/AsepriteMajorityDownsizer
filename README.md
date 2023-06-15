# AsepriteMajorityDownsizer

A script for Aseprite that replaces all images (all cells with trimming included) in a sprite and downsizes them based on the majority of pixels that make upp the smaller image. so if a 2x2 image with 3 red pixels and 1 blue goes trough this script with the downsize of 2, then the image will be replaced with a red pixel in the top left corner. in the case that two or more colors are the shared majority the top left one is chosen.

The colors have to be identical to be counted as the same. so 255, 0, 0, 255 and a 254, 0, 0, 255 pixel will be counted separate

In the latest version it also changes the canvas size for convinience sake

The InvisibleFactor takes a multiplier that is affects the pixels with alpha 0.<br>
A InvisibleFactor of 0 would make a invisible pixel never happen in a chunk (unless there is no other candidate), and a factor of 1 would make em as valuable as normal.<br>
You can tweek it to be something like 0.5 if you want small details sticking out to be better preserved.

The weighted version makes the pixels closer to the center of a chunk worth more, the weight each pixel gets is increased by 1 for each pixel away from the edge of a chunk, for example the weight of each pixel becomes likee this in a 5x5 chunk:<br>
11111<br>
12221<br>
12321<br>
12221<br>
11111
