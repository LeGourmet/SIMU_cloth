public class Obstacle {
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public ArrayList<Point> points;
  public ArrayList<Triangle> triangles;
  public ArrayList<PVector> normales;
  public PVector center;
  public BVH bvh;
  public color col;

  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Obstacle(PVector center, color col, float scale, String path) {
    this.center = center;
    this.col = col;
 
    this.points = new ArrayList<>();
    this.triangles = new ArrayList<>();
    this.normales = new ArrayList<>();
    
    String[] lines = loadStrings(path);
    for(String line : lines){
      String datas[] = line.split(" ");
      switch (datas[0]){
        case "v": points.add(new Point(new PVector(Float.parseFloat(datas[1])*scale+center.x,Float.parseFloat(datas[2])*scale+center.y,Float.parseFloat(datas[3])*scale+center.z),col,20));break;
        case "vn": normales.add(new PVector(Float.parseFloat(datas[1]),Float.parseFloat(datas[2]),Float.parseFloat(datas[3])));break;
        case "f" : triangles.add(new Triangle(Integer.parseInt(datas[1].split("/")[0])-1,Integer.parseInt(datas[2].split("/")[0])-1,Integer.parseInt(datas[3].split("/")[0])-1,
                                              Integer.parseInt(datas[1].split("/")[2])-1,Integer.parseInt(datas[2].split("/")[2])-1,Integer.parseInt(datas[3].split("/")[2])-1,points,normales)); break;
        default : break;
      }
    }
    
    this.bvh = new BVH(triangles);
  }

  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void vertices(){ fill(col); triangles.forEach(t -> t.vertices()); }

  public void repulseCloth(Cloth Cloth) {    
    for (Triangle tri : Cloth.triangles) {
      pointIntersect(tri.v0);
      pointIntersect(tri.v1);
      pointIntersect(tri.v2);
    }
  }
  
  public void pointIntersect(Point p){
    PVector dir = PVector.sub(p.pos, p.pos_old);
    float t_max = dir.mag();
    dir.normalize();
    HitRecord hit = bvh.intersect(0., t_max, p.pos_old, dir);

    if(hit.t>=0. && hit.t<t_max) {
       p.move(PVector.mult(dir, -(t_max-hit.t)));
       p.move(PVector.mult(hit.normal,1.));
       PVector vec = PVector.sub(p.pos, p.pos_old);
       p.setVelocity(PVector.sub(vec,PVector.mult(hit.normal,RESTITUION_FORCE_COLLISION*2.*PVector.dot(hit.normal,vec))));
    }
  }
}
