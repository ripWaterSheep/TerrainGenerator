# TerrainGenerator

Generate infinite terrain using perlin noise.
Elevation, climate, and clouds are based on separate noisemaps.


## Requirements
* Processing
* PeasyCam library for processing (sketch -> import library -> add library -> peasycam).

## Controls
* WASD to move horizontally (offsets noise in terrainGenerator.pde, moves camera in bigMap because offsetting would require regenerating noise every frame)
* 1 and 2 to morph terrain height noise (not available in bigMap.pde due to extreme lag when updating)
* 3 and 4 to morph climate noise (not in bigMap.pde either)
* r to randomize noise seed and regenerate new terrain
* left click and drag to rotate
* scroll mouse or right click and drag to zoom in
* drag center mouse button to pan
