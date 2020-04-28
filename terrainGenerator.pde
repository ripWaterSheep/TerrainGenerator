
import peasy.*;

final int size = 200;

float[][] terrain = new float[size][size];
final float terrainIncrement = 0.017; // How much the terrain changes from one tile to the next.
final int yScale = 40; // Multiplier for mountain height.
final float yExponent = 3.25; // Increasing this will make valleys lower and bumps higher.
float terrainMorph = 0; // 3D noise dimension representing time.


float seaLevel = 0.14;

float[][] climate = new float[size][size];
final float climateIncrement = 0.002; // How much the biome changes from one to the next. Larger num == smaller biomes.
float climateMorph = 0; // 3D noise dimension representing time.


float[][] clouds = new float[size][size];
final float cloudIncrement = 0.02; // Speed at which clouds morph
final float cloudThickness = 12; // Multiplier for cloud brightness.
final float cloudSpread = 10; // Exponent for cloud brightness, increases concentration.
float cloudMorph = 0.1; // 3D noise dimension representing time.

float cloudOffset = 0;
final float cloudSpeed = 0.5; // Movement speed of clouds
float cloudMorphSpeed = 0.01; // 3D noise dimension representing time.


PeasyCam cam;

int speed = 5;
float xOffset = 100000; // Offset these to avoid seeing lines of symmetry around origin.
float zOffset = 100000;
boolean l = false, r = false, f = false, b = false, k1 = false, k2 = false, k3 = false, k4 = false;


color warmWater = color(50, 90, 190);
color coldWater = color(35, 60, 150);
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
        if (c < 0.75) return warmWater;
        if (c < 0.86) return coldWater;
        return ice;
    }
    if (y < seaLevel + 0.05) {
        return sand;
    };
    
    if (y < 0.36) {
        if (c < 0.41) return sand;
        if (c < 0.52) return savannah;
        if (c < 0.75) return plains;
        if (c < 0.86) return tundra;
        return snow;
    }

    if (y < 0.55) {
        if (c < 0.41) return mesa;
        if (c < 0.52) return rainForest;
        if (c < 0.75) return forest;
        return taiga;
    }

    if (y < 0.875) return mountain;
    return snow;
}



float ridgeNoise(float nx, float ny) {
    return 2 * (0.5 - abs(0.5 - noise(nx, ny)));
}



void generate() {
    
    for (int z = 0; z < size; z++) {
        for (int x = 0; x < size; x++) {
            {
                float nz = z * cloudIncrement + (zOffset * cloudIncrement) + (cloudOffset * cloudIncrement);
                float nx = x * cloudIncrement + (xOffset * cloudIncrement) + (cloudOffset * cloudIncrement);
        
                float y = noise(nx, nz, cloudMorph) +
                    0.5 * noise(2 * nx, 2 * nz, cloudMorph) +
                    0.25 * noise(4 * nx, 4 * nz, cloudMorph);
                y = map(y, 0, 1.25, 0, 1);
                y = pow(y, cloudSpread);
        
                clouds[x][z] = y;
            }   
            {
                float nz = z * terrainIncrement + (zOffset * terrainIncrement);
                float nx = x * terrainIncrement + (xOffset * terrainIncrement);
                
                float y = noise(nx, nz, terrainMorph) +
                    0.5 * noise(2 * nx, 2 * nz, 2 * terrainMorph) +
                   0.25 * noise(4 * nx, 4 * nz, 4 * terrainMorph);
                y = map(y, 0, 1.3, 0, 1);
                
                y = pow(y, yExponent);
                y = 10 * (y/10);
                terrain[x][z] = y;
            }
            {
                float nz = z * climateIncrement + (zOffset * climateIncrement);
                float nx = x * climateIncrement + (xOffset *climateIncrement);
                
                float y = noise(nx, nz, climateMorph)
                    + 0.5 * noise(2 * nx, 2 * nz, 2* climateMorph)
                    + 0.25 * noise(4 * nx, 4 * nz, 4 * climateMorph);
                y = map(y, 0, 1.32, 0, 1);
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
    if (key == '1') {
        k1 = true;
    }
    if (key == '2') {
        k2 = true;
    }
    if (key == '3') {
        k3 = true;
    }
    if (key == '4') {
        k4 = true;
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
    if (key == '1') {
        k1 = false;
    }
    if (key == '2') {
        k2 = false;
    }
    if (key == '3') {
        k3 = false;
    }
    if (key == '4') {
        k4 = false;
    }
    if (key == 'r' || key == 'R') {
        noiseSeed((long)random(0, 1000000000));
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
    perspective(PI/2, width/height, 0.01, 1500);

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
    if (k1) {
        terrainMorph -= terrainIncrement;
    }
    if (k2) {
        terrainMorph += terrainIncrement;
    }
    if (k3) {
        climateMorph -= climateIncrement;
    }
    if (k4) {
        climateMorph += climateIncrement;
    }
    
    cloudMorph += cloudMorphSpeed;
    cloudOffset += cloudSpeed;
    
    
    generate();

    background(110, 150, 250);
    noStroke();
    

    int y = 125;
    for (int z = 0; z < size-1; z++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < size; x++) {
            color c = biome(terrain[x][z], climate[x][z]);
            // Get tile color according to biome, which takes terrain and climate into account.
            
            float shade = map(clouds[x][z], 0, 1, 1, 0.5); // Shade tiles under clouds.
            shade = min(shade, 1);
            fill(red(c) * shade, green(c) * shade, blue(c) * shade);
            
            
            float e = terrain[x][z];
            e = max(e, seaLevel);
            float next = terrain[x][z+1];
            next = max(next    , seaLevel);

            vertex(x, y - e * yScale, z);
            vertex(x, y - next * yScale, z+1);
        }
        endShape();
    }
    
    y = 0;
    for (int z = 0; z < size-1; z++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < size; x++) {
            float alpha = clouds[x][z];
            alpha *= cloudThickness;
            fill(255, 255, 255, alpha*255);
            
            vertex(x, y - clouds[x][z], z);
            vertex(x, y - clouds[x][z], z+1);
        }
        endShape();
    }
}
