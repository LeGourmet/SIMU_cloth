public class Point{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public PVector pos;
  public PVector pos_old;
  public PVector forces;
  public float   mass;
  
  public boolean blocked;
  public color   col;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Point(PVector pos, color col, float mass){
    this.pos = pos;
    this.pos_old = pos.copy();
    this.forces = new PVector(0.,0.,0.);
    this.mass = mass;
    
    this.blocked = false;
    this.col = col;
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public PVector getVelocity(float dt){ return PVector.sub(pos,pos_old).div(dt); }
  public void    setVelocity(PVector vec){ pos_old = pos.copy().sub(vec); }
  
  public void applyForce(PVector force){ if(!blocked) forces.add(force); }
  public void move(PVector vec){ if(!blocked) pos.add(vec); }
  
  public void update(float dt){
    if(blocked) return;
    
    PVector a = new PVector(0.,0.,0.).add(PVector.div(forces,mass));
    PVector vel = getVelocity(dt).add(PVector.mult(a,dt));
    PVector pos_next = new PVector(0.,0.,0.).add(pos).add(PVector.mult(vel,dt));
    
    pos_old.set(pos);
    pos.set(pos_next);
    
    this.forces.set(0.,0.,0.);
  }
  
  public void interCollision(MetricTree mt){
    ArrayList<Point> neightboors = new ArrayList<>();
    mt.search(this, 2., neightboors);
    if(!neightboors.isEmpty()) setVelocity(PVector.mult(getVelocity(DELTA_TIME),-RESTITUION_FORCE_COLLISION));
  }
}
