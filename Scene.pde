public class Scene{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  private Cloth cloth;
  private ArrayList<Obstacle> obstacles;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Scene(Cloth cloth){
    this.cloth = cloth;
    this.obstacles = new ArrayList<Obstacle>();
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void addObstacle(Obstacle o){
    obstacles.add(o);
  }
  
  public void display(){
    beginShape(TRIANGLES);
    cloth.vertices();
    obstacles.forEach(sp -> sp.vertices());
    endShape(CLOSE);
  }
  
  public void refreshDataStructure(){
    cloth.refreshDataStructure();
  }
  
  public void reset(){
    cloth.reset();
    cloth.refreshDataStructure();
  }
  
  public void update(float dt){
    cloth.applyForces(dt);
    cloth.updatePositions(dt); 
    cloth.constrain();
    obstacles.forEach(o -> o.repulseCloth(cloth)); 
    //cloth.interCollision();
  }
}
