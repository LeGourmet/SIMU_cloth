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
  
  public PVector centroid() { return PVector.mult(PVector.add(min,max),0.5) ; }
  
  public float surface(){
    PVector d = PVector.sub(max,min);
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
    PVector[] MinMax = { min, max };
    int[] s = { int(d.x<0.), int(d.y<0.), int(d.z<0.) };
  
    // *** X axis ***
    float tmpMin, refMin = ((MinMax[s[0]]).x - o.x) / d.x;
    float tmpMax, refMax = ((MinMax[1-s[0]]).x - o.x) / d.x;
  
    // *** Y axis ***
      if( (tmpMin=((MinMax[s[1]]).y - o.y)/d.y)>refMax || refMin>(tmpMax=((MinMax[1-s[1]]).y - o.y)/d.y) ) return false;
      refMin = max( tmpMin, refMin );
      refMax = min( tmpMax, refMax );
  
    // *** Z axis ***
      if( (tmpMin=((MinMax[s[2]]).z - o.z)/d.z)>refMax || refMin>(tmpMax=((MinMax[1-s[2]]).z - o.z)/d.z) ) return false;
      refMin = max( tmpMin, refMin );
      refMax = min( tmpMax, refMax );
  
    return (refMin<tMax) && (refMax>tMin);
  }
} 
