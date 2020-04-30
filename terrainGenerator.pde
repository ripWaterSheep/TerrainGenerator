import peasy.*;

final int size = 200;

float[][] terrain = new float[size][size];
final float terrainIncrement = 0.017; // How much the terrain changes from one tile to the next.
final int yScale = 40; // Multiplier for mountain height.
final float yExponent = 1.85; // Increasing this will make valleys lower and bumps higher.
float terrainMorph = 0; // 3D noise dimension representing time.


float seaLevel = 0.1;

float[][] climate = new float[size][size];
final float climateIncrement = 0.0013; // How much the biome changes from one to the next. Larger num == smaller biomes.
float climateMorph = 0; // 3D noise dimension representing time.


float[][] clouds = new float[size][size];
final float cloudIncrement = 0.025; // How much the clouds change from one tile to another
final float cloudThickness = 6; // Multiplier for cloud opacity.
final float cloudSpread = 11; // Exponent for cloud opacity, increases concentration.
float cloudMorph = 0; // 3D noise dimension representing time.

float cloudOffset = 0;
final float cloudSpeed = 0.3;
float cloudMorphSpeed = 0.008;


PeasyCam cam;

int speed = 5;
float xOffset = 100000; // Offset these to avoid seeing lines of symmetry around origin.
float zOffset = 100000;
boolean l = false, r = false, f = false, b = false, t1 = false, t2 = false, c1 = false, c2 = false;


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
    
    if (y < 0.36) {
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
                y = min(1, y);
        
                clouds[x][z] = y;
            }   
            {
                float nz = z * terrainIncrement + (zOffset * terrainIncrement);
                float nx = x * terrainIncrement + (xOffset * terrainIncrement);
                
                float y = noise(nx, nz, terrainMorph) +
                    0.5 * noise(2 * nx, 2 * nz, 2 * terrainMorph) +
                   0.25 * noise(4 * nx, 4 * nz, 4 * terrainMorph);
                   y*=y = noise(nx, nz, terrainMorph) +
                    0.5 * noise(2 * nx, 2 * nz, 2 * terrainMorph) +
                   0.25 * noise(4 * nx, 4 * nz, 4 * terrainMorph);
                   y *= 0.75;
                y = map(y, 0, 1.3, 0, 1);
                
                y = pow(y, yExponent);
                terrain[x][z] = y;
            }
            {
                float nz = z * climateIncrement + (zOffset * climateIncrement);
                float nx = x * climateIncrement + (xOffset *climateIncrement);
                
                float y = noise(nx, nz, climateMorph)
                    + 0.5 * noise(2 * nx, 2 * nz, 2* climateMorph)
                    + 0.25 * noise(4 * nx, 4 * nz, 4 * climateMorph);
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
    if (key == '1') {
        t1 = true;
    }
    if (key == '2') {
        t2 = true;
    }
    if (key == '3') {
        c1 = true;
    }
    if (key == '4') {
        c2 = true;
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
        t1 = false;
    }
    if (key == '2') {
        t2 = false;
    }
    if (key == '3') {
        c1 = false;
    }
    if (key == '4') {
        c2 = false;
    }
    if (key == 'r' || key == 'R') {
        noiseSeed((long)random(0, 1000000000));
    }
}


void setup() {
    size(800, 600, P3D);
    cam = new PeasyCam(this, size/2, 100, size/2, 100);
    cam.setMinimumDistance(1);
    cam.setMaximumDistance(1000);
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
    if (t1) {
        terrainMorph -= terrainIncrement;
    }
    if (t2) {
        terrainMorph += terrainIncrement;
    }
    if (c1) {
        climateMorph -= climateIncrement;
    }
    if (c2) {
        climateMorph += climateIncrement;
    }
    
    cloudMorph += cloudMorphSpeed;
    cloudOffset += cloudSpeed;
    
    generate();

    background(110, 150, 250);
    noStroke();
    
    int h = 125;
    for (int z = 0; z < size-1; z++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < size; x++) {
            
            // Get tile color according to biome, which takes terrain and climate into account.
            color c = biome(terrain[x][z], climate[x][z]);
            
            float shade = map(clouds[x][z], 0, 1, 1, 0.5); // Shade tiles under clouds.
            shade = min(shade, 1);
            fill(red(c) * shade, green(c) * shade, blue(c) * shade);
            
            float e = max(terrain[x][z], seaLevel);
            float next = max(terrain[x][z+1], seaLevel);

            vertex(x, h - e * yScale, z);
            vertex(x, h - next * yScale, z+1);
        }
        endShape();
    }
    
    h = 0;
    for (int z = 0; z < size-1; z++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < size; x++) {
            float alpha = clouds[x][z];
            alpha *= cloudThickness;
            fill(255, 255, 255, alpha*255);
            
            vertex(x, h - clouds[x][z], z);
            vertex(x, h - clouds[x][z], z+1);
        }
        endShape();
    }
}
