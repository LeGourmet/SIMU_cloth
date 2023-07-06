void vertex(PVector p){
  vertex(p.x,p.y,p.z);
}

void vertex(Point p){   
  fill(p.col);
  vertex(p.pos); 
}

void triangle(Point a, Point b, Point c){
     vertex(a);
     vertex(b);
     vertex(c);
}

public class HitRecord{
  public float t;
  public PVector normal;
  
  public HitRecord(){
    this.t = -1.;
  }
  
  public HitRecord (float t, PVector normal){
    this.t = t;
    this.normal = normal;
  }
}
