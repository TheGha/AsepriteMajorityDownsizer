# AsepriteMajorityDownsizer

A script for Aseprite that replaces all images (all cells with trimming included) in a sprite and downsizes them based on the majority of pixels that make upp the smaller image. so if a 2x2 image with 3 red pixels and 1 blue goes trough this script with the downsize of 2, then the image will be replaced with a red pixel in the top left corner. in the case that two or more colors are the shared majority the top left one is chosen.

the colors have to be identical to be counted as the same. so 255, 0, 0, 255 and a 254, 0, 0, 255 pixel will be counted separate

In the latest version it also changes the canvas size for convinience sake

the InvisibleFactor takes a multiplier that is affects the pixels with alpha 0
a InvisibleFactor of 0 would make a invisible pixel never happen in a chunk (unless there is no other candidate), and a factor of 1 would make em as valuable as normal
you can tweek it to be something like 0.5 if you want small details sticking out to be better preserved
