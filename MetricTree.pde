public class MetricTree{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public Point ref;
  public MetricTree inside;
  public MetricTree outside;
  public float radius;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public MetricTree(){
    reset();
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void reset(){
    ref = null;
    inside = null;
    outside = null;
  }
  
  public void insert(Point new_ref, float r){
    if(this.ref == null){
      ref = new_ref;
      radius = r;  
    }
    
    else if(PVector.dist(new_ref.pos,ref.pos) <= radius){ 
      if(inside == null) inside = new MetricTree();  
      inside.insert(new_ref, r*0.5);
    }
    
    else{
      if(outside == null) outside = new MetricTree();
      outside.insert(new_ref, r*0.5);
    }
  }
  
  public void search(Point p, float rSearch, ArrayList<Point> neightboors){    
    float d = PVector.dist(p.pos,ref.pos);
    
    if(d<(rSearch*rSearch)&&p!=ref) neightboors.add(ref);
    
    if(inside != null && d<radius){
      inside.search(p, rSearch, neightboors);
      
      if(outside != null && d>((radius-rSearch)*(radius-rSearch)))
        outside.search(p, rSearch, neightboors);
    }else{
      if(outside != null && d>radius)    
        outside.search(p, rSearch, neightboors);
      
      if(inside != null && d<((radius+rSearch)*(radius+rSearch)))
        inside.search(p, rSearch, neightboors);
    }    
  }
}
