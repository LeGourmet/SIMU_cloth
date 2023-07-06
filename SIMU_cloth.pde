import peasy.*;
import java.util.Collections;

// ------------------------ GLOBAL VAR ------------------------
final float   DELTA_TIME = 0.1;
final PVector GRAVITY = new PVector(0.,9.81,0.);
final float   EPS = 0.01;

// ------------------------ OBSTACLE VAR ------------------------
final String  OBSTACLE_PATH = "./models/Icosphere.obj";
final float   RESTITUION_FORCE_COLLISION = 0.9;

// ------------------------ CLOTH VAR ------------------------
final int     SIZE_CLOTH = 500;
final int     NB_CUT_CLOTH = 75;
final PVector CENTER_CLOTH = new PVector(0,100,0);
final String  TEXTURE_CLOTH = "./textures/FrenchFlag.jpg";

final float   MASS_CLOTH = 1500;
final float   CLOTH_K = 20.;
final float   CLOTH_C = 0.5;
final float   CLOTH_MAX_STRETCHING = 1.35f;
final float   CLOTH_MIN_STRETCHING = 0.1f;

PeasyCam camera;
Scene scene;

void setup(){
  size(900,600,P3D);
  camera = new PeasyCam(this,600);
  
  scene = new Scene(new Cloth(SIZE_CLOTH, SIZE_CLOTH, NB_CUT_CLOTH, CENTER_CLOTH, MASS_CLOTH));
  scene.addObstacle(new Obstacle(new PVector( -100.,0.,0.), color(0,127,127),80.,OBSTACLE_PATH));
  scene.addObstacle(new Obstacle(new PVector( 100.,0.,0.), color(0,127,127),60.,OBSTACLE_PATH));
  
  noStroke();
}

void draw(){  
  background(30);
  lights();
  
  scene.display();
  scene.refreshDataStructure();
  scene.update(DELTA_TIME);
}

void keyPressed(){
  switch(key){
    case 'r' : scene.reset(); break;
    case 'p' : println("frameRate: "+frameRate); 
  }
}
