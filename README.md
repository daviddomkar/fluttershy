# Fluttershy

Low level game-engine-like interface for flutter games. All this does is exposing Fluttershy Widget which you can use to hook into setup, update, event, render and destroy methods to do your own thing with the canvas.

There is also a Renderer class which is a wrapper around the canvas and provides some useful methods to draw things. For example Cameras, Textures, Animated Textures and Sprites with working batching support when using atlas textures.

I am using this as a base for my flutter game project https://riseofpilgrims.cz/