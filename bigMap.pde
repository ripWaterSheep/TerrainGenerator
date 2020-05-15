import peasy.*;

final int size = 400;
final int yScale = 45;

float[][] terrain = new float[size][size];
final float terrainIncrement = 0.0175; // How much the terrain changes from one tile to the next.
final float yExponent = 1.85; // Increasing this will make valleys lower and bumps higher.


float seaLevel = 0.1;

float[][] climate = new float[size][size];
final float climateIncrement = 0.0015; // How much the biome changes from one to the next. Larger num == smaller biomes.


PeasyCam cam;

int speed = 5;
int xOffset = 0;
int zOffset = 0;
boolean l = false, r = false, f = false, b = false;


color warmWater = color(40, 145, 170);
color normalWater = color(50, 100, 190);
color coldWater = color(35, 70, 150);
color ice = color(150, 170, 230);
color beach = color(210, 180, 100);
color rocks = color(100, 80, 90);

color sand = color(200, 180, 140);
color savannah = color(160, 168, 89);
color plains = color(110, 170, 100);
color tundra = color(170, 115, 50);

color forest = color(63, 125, 59);
color rainForest = color(49, 150, 0);
color taiga = color(80, 173, 150);
color mesa = color(200, 120, 70);

color mountain = color(140, 120, 140);
color snow = color(220, 230, 255);


color biome(float y, float c) {
    
    if (y < seaLevel) {
        if (c < 0.37) return warmWater;
        if (c < 0.75) return normalWater;
        if (c < 0.86) return coldWater;
        return ice;
    }
    if (y < seaLevel + 0.04) {
        return sand;
    };
    
    if (y < 0.33) {
        if (c < 0.37) return sand;
        if (c < 0.5) return savannah;
        if (c < 0.75) return plains;
        if (c < 0.86) return tundra;
        return snow;
    }

    if (y < 0.6) {
        if (c < 0.37) return mesa;
        if (c < 0.5) return rainForest;
        if (c < 0.75) return forest;
        return taiga;
    }

    if (y < 0.875) return mountain;
    return snow;
}

void generate() {
    
    noiseSeed((long) random(0, 1000000000));
    for (int z = 0; z < size; z++) {
        for (int x = 0; x < size; x++) {
            {
                float nz = z * terrainIncrement + terrainIncrement;
                float nx = x * terrainIncrement + terrainIncrement;
                
                float y = noise(nx, nz) +
                    0.5 * noise(2 * nx, 2 * nz, 2) +
                   0.25 * noise(4 * nx, 4 * nz, 4);
                   y = pow(y, 2);
                y = map(y, 0, 1.6, 0, 1); // Normalize the octaves
                
                y = pow(y, yExponent);
                terrain[x][z] = y;
            }
            {
                float nz = z * climateIncrement + climateIncrement;
                float nx = x * climateIncrement + climateIncrement;
                
                float y = noise(nx, nz)
                    + 0.5 * noise(2 * nx, 2 * nz, 2)
                    + 0.25 * noise(4 * nx, 4 * nz, 4);
                    
                y = map(y, 0, 1.35, 0, 1);
                climate[x][z] = y;
            }
        }
    }
}


public void keyPressed() {
    if (key == 'a' || key == 'A') {
        l = true;
    }
    if (key == 'd' || key == 'D') {
        r = true;
    }
    if (key == 'w' || key == 'W') {
        f = true;
    }
    if (key == 's' || key == 'S') {
        b = true;
    }
}


public void keyReleased() {
    if (key == 'a' || key == 'A') {
        l = false;
    }
    if (key == 'd' || key == 'D') {
        r = false;
    }
    if (key == 'w' || key == 'W') {
        f = false;
    }
    if (key == 's' || key == 'S') {
        b = false;
    }
    
    if (key == 'r' || key == 'R') {
        generate();
    }
}


void setup() {
    size(800, 600, P3D);
    cam = new PeasyCam(this, size/2, 100, size/2, 100);
    cam.setMinimumDistance(1);
    cam.setMaximumDistance(1000);
    
    generate();
}



void draw() {
    perspective(PI/2, width/height, 0.0001, 1500);
    translate(0, 150, -size/2);
    scale(1, yScale);

    if (l) {
        xOffset -= speed;
    } else if (r) {
        xOffset += speed;
    }
    if (f) {
        zOffset -= speed;
    } else if (b) {
        zOffset += speed;
    }
    background(110, 150, 250);
    noStroke();
    
    for (int z = 0; z < size-1; z++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < size; x++) {
            
            // Get tile color according to biome, which takes terrain and climate into account.
            fill(biome(terrain[x][z], climate[x][z]));
            
            vertex(x - xOffset, -max(terrain[x][z], seaLevel), z - zOffset);
            vertex(x - xOffset, -max(terrain[x][z+1], seaLevel), z+1 - zOffset);
        }
        endShape();
    }
    
}
