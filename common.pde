float sign(float a){
  if(a>0.) return 1.;
  if(a<0.) return -1.;
  return 0.;
}

PVector PVector_div(PVector a, PVector b){
  return new PVector(a.x/(sign(b.x)*max(0.0001,abs(b.x))), a.y/(sign(b.y)*max(0.0001,abs(b.y))), a.z/(sign(b.z)*max(0.0001,abs(b.z))));
}

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
    this.t = Float.MAX_VALUE;
  }
  
  public HitRecord (float t, PVector normal){
    this.t = t;
    this.normal = normal;
  }
}
