public class Cloth{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public int x, y;
  public float sizeX, sizeY;
  public float mass;
  
  public ArrayList<Point> points;
  public ArrayList<Spring> springs;
  public ArrayList<Triangle> triangles;
  public PVector center;
  public MetricTree mt;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Cloth(int sizeX, int sizeY, int nb_cut, PVector center, float mass){
    if(x<y){
      this.x =  nb_cut+2;
      this.y = int(float(nb_cut*sizeY)/float(sizeX)+2.);
    }else{
      this.x = int(float(nb_cut*sizeX)/float(sizeY)+2.);
      this.y = nb_cut+2;
    }
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.center = center;
    
    this.mass = mass;
    this.triangles = new ArrayList<>();
    this.points = new ArrayList<>();
    this.springs = new ArrayList<>();
    this.mt = new MetricTree();
    
    reset();
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void reset(){    
    final float massPoints = mass/float(x*y);
    final float sizeCellX = sizeX/float(x-1);
    final float sizeCellY = sizeY/float(y-1);
    
    PImage texture = loadImage(TEXTURE_CLOTH);
    texture.resize(x,y);
    
    points.clear();
    triangles.clear();
    
    // construct grid
    for(int i=0; i<x ;i++)
      for(int j=0; j<y ;j++){
        this.points.add(new Point(new PVector(i*sizeCellX+center.x-sizeX/2., -center.y, j*sizeCellY+center.z-sizeY/2.), texture.pixels[j*x+i], massPoints));
        this.mt.insert(points.get(i), width);
      }
     
    // construt triangles
    for(int i=0; i<x-1 ;i++)
      for(int j=0; j<y-1 ;j++){
       triangles.add(new Triangle(j+y*i, j+y*(i+1), j+1+y*i, points));
       triangles.add(new Triangle(j+1+y*(i+1), j+y*(i+1), j+1+y*i, points));
      }
       
    // construct springs
    for(int i=0; i<x ;i++)
      for(int j=0; j<y;j++){
        if(i<x-1) springs.add(new Spring(points.get(j+y*i),points.get(j+y*(i+1))));
        if(j<y-1) springs.add(new Spring(points.get(j+y*i),points.get(j+1+y*i)));
        if(i<x-1 && j<y-1) springs.add(new Spring(points.get(j+y*i),points.get(j+1+y*(i+1))));
        if(i>0 && j<y-1) springs.add(new Spring(points.get(j+y*i),points.get(j+1+y*(i-1))));
      }
  }
 
  public void applyForces(float dt){
    points.forEach(p -> p.applyForce(PVector.mult(GRAVITY,p.mass)));
    points.forEach(p -> p.applyForce(PVector.mult(p.getVelocity(dt),-0.01)));
  }
  
  public void updatePositions(float dt){
    points.forEach(p -> p.update(dt));
  }
  
  public void constrain(){
    for(int i=0; i<10 ;i++){
      Collections.shuffle(springs);
      for(Spring sp : springs) 
        sp.constrain();   
    }
 }
 
 public void interCollision(){
    points.forEach(p -> p.interCollision(mt));
 }
  
  public void vertices(){
    triangles.forEach(t -> t.vertices());
  }
  
  public void refreshDataStructure(){
    mt.reset();
    for(Point p : points) mt.insert(p, width);
  }
}
