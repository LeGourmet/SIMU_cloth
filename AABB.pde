public class AABB{
  public PVector max;
  public PVector min;
  
  public AABB(){
    this.max = new PVector();
    this.min = new PVector();
    this.reset();
  }
  
  public void extend(PVector p){
    if(this.min.x > p.x)  this.min.x = p.x;
    if(this.min.y > p.y)  this.min.y = p.y;
    if(this.min.z > p.z)  this.min.z = p.z;
      
    if(this.max.x < p.x)  this.max.x = p.x;
    if(this.max.y < p.y)  this.max.y = p.y;
    if(this.max.z < p.z)  this.max.z = p.z;
  }
  
  public void extend(AABB aabb){
    if(this.min.x > aabb.min.x)  this.min.x = aabb.min.x;
    if(this.min.y > aabb.min.y)  this.min.y = aabb.min.y;
    if(this.min.z > aabb.min.z)  this.min.z = aabb.min.z;
      
    if(this.max.x < aabb.max.x)  this.max.x = aabb.max.x;
    if(this.max.y < aabb.max.y)  this.max.y = aabb.max.y;
    if(this.max.z < aabb.max.z)  this.max.z = aabb.max.z;
  }
  
  public PVector centroid() { return PVector.mult(PVector.add(this.min,this.max),0.5) ; }
  
  public float surface(){
    PVector d = PVector.sub(this.max,this.min);
    return 2.f * ( d.x*d.y + d.x*d.z + d.y*d.z ); 
  }
 
  public void margin(PVector m){
    this.max.add(m);
    this.min.sub(m);
  }
 
  public void reset(){
    this.max.set(Float.MIN_VALUE, Float.MIN_VALUE, Float.MIN_VALUE);
    this.min.set(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
  }
 
  public boolean intersect( float tMin, float tMax, PVector o, PVector d ){ 
      PVector tmin = PVector_div(PVector.sub(this.min,o),d);
      PVector tmax = PVector_div(PVector.sub(this.max,o),d);

      PVector a = new PVector(min(tmin.x,tmax.x), min(tmin.y, tmax.y), min(tmin.z, tmax.z));
      PVector b = new PVector(max(tmin.x,tmax.x), max(tmin.y, tmax.y), max(tmin.z, tmax.z));

      float tnear = max(max(a.x, a.y), a.z);
      float tfar = min(min(b.x, b.y), b.z);

      return tnear<=tfar && tfar>=tMin && tnear<=tMax;
  }
} 
