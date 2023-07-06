public class Spring{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public Point A;
  public Point B;
  public float lo;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Spring(Point A, Point B){
    this.A = A;
    this.B = B;
    this.lo = PVector.dist(A.pos,B.pos);
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void constrain(){
    PVector v = PVector.sub(B.pos,A.pos);
    float l = v.mag();
    float l_min = lo*CLOTH_MIN_STRETCHING;
    float l_max = lo*CLOTH_MAX_STRETCHING;
    
    float dif;
    if      (l<l_min) dif = 0.5*(1.-l_min/l);
    else if (l>l_max) dif = 0.5*(1.-l_max/l);     
    else return;
    
    A.move(PVector.mult(v,dif));
    B.move(PVector.mult(v,-dif));
  }
} 
