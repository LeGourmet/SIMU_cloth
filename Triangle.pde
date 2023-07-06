public class Triangle{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public Point v0, v1, v2;
  public PVector n0, n1, n2;
  public AABB aabb;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Triangle(int i0, int i1, int i2, ArrayList<Point> points){
    this.v0 = points.get(i0);
    this.v1 = points.get(i1);
    this.v2 = points.get(i2);
    
    this.aabb = new AABB();
    this.refreshDataStructure();
  }
  
  public Triangle(int i0, int i1, int i2, int n0, int n1, int n2, ArrayList<Point> points, ArrayList<PVector> normales){
    this.v0 = points.get(i0);
    this.v1 = points.get(i1);
    this.v2 = points.get(i2);
    
    if(normales != null){
      this.n0 = normales.get(n0);
      this.n1 = normales.get(n1);
      this.n2 = normales.get(n2);
    }
    
    this.aabb = new AABB();
    this.refreshDataStructure();
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void refreshDataStructure(){
    aabb.reset();
    aabb.extend(v0.pos);
    aabb.extend(v1.pos);
    aabb.extend(v2.pos);
  }
  
  public void vertices(){
     vertex(v0);
     vertex(v1);
     vertex(v2);
  }
  
  public HitRecord intersect( PVector o, PVector dir ){
    PVector x = PVector.sub(v1.pos, v0.pos);
    PVector y =  PVector.sub(v2.pos, v0.pos);
    PVector a = dir.cross(y);
    float det = PVector.dot(x, a); 
  
    HitRecord hit = new HitRecord();
  
    if(det==0.f) return hit;
  
    float invDet = 1./det;
    PVector b = PVector.sub(o,v0.pos);
    float   u = PVector.dot(b,a)*invDet;
    if(u<0.||u>1.) return hit;
  
    PVector c = b.cross(x);
    float   v = PVector.dot(dir,c)*invDet;
    if(v<0.||u+v>1.) return hit;
  
    hit.t = PVector.dot(y,c)*invDet;
    hit.normal = PVector.mult(n0, ( 1.f - u - v )).add(PVector.mult(n1, u)).add(PVector.mult(n2, v));
    hit.normal.normalize();
    
    return hit;
  }
}
