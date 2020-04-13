# Fluttershy

Low level game-engine-like interface for flutter games. All this does is exposing Backend class which you can extend and override setup, update, event, render and destroy methods to do your own thing.

I am planning on making ready made backends in separate packages so you can use what is the best fit for your game or implement your own solution.

Current official backends:

**fluttershy_backend_dartex**: ECS-like backend using my own dartex ECS package [WIP, Experimental]

I am also planning on implementing node based backend similar to how Godot engine functions.

You can also create your own backend and share it as a package. I might even add it to the list if you make a pull request.
