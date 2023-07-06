final int NB_BUCKETS_BVH = 16;

public class Bucket {
  public int nb;
  public AABB aabb;
  
  public Bucket(){
    this.nb = 0;
    this.aabb = new AABB();
  }
}

public class BVHNode{
  public AABB    aabb;
  public BVHNode left;
  public BVHNode right;
  public int firstTriangleId;
  public int lastTriangleId;
  
  public BVHNode(){
    this.aabb = new AABB();
    this.left = null;
    this.right = null;
    this.firstTriangleId = 0;
    this.lastTriangleId = 0;
  }
  
  public boolean isLeaf() { return (this.left==null && this.right==null ); }
}

public class BVH{
  private BVHNode root;  
  private ArrayList<Triangle> triangles;
  private final static int maxTrianglesPerLeaf = 8;
  private final static int maxDepth            = 32;
  
  public BVH( ArrayList<Triangle> triangles){
    this.triangles = triangles;
    this.root = new BVHNode();
    
    buildRec( root , 0, triangles.size()-1, 0 );
  }

  private int hash(BVHNode node, int axis, int i){
    int x = ((int)(((float)NB_BUCKETS_BVH) * ( triangles.get(i).aabb.centroid().array()[axis] - node.aabb.min.array()[axis] ) / ( node.aabb.max.array()[axis] - node.aabb.min.array()[axis] )));
    if(x>=NB_BUCKETS_BVH) x=NB_BUCKETS_BVH-1;
    else if(x<0) x=0;
    return x;
  }

  private void buildRec( BVHNode node, int firstTriangleId, int lastTriangleId, int depth ){
    for(int i=firstTriangleId; i<=lastTriangleId ;i++)
      node.aabb.extend(triangles.get(i).aabb);
      
    node.firstTriangleId = firstTriangleId;
    node.lastTriangleId  = lastTriangleId;

    if( maxDepth>depth && maxTrianglesPerLeaf<(lastTriangleId-firstTriangleId) ){
      float invSA_P = 1.f/(node.aabb.surface()*(lastTriangleId-firstTriangleId) ), min_cost = Float.MAX_VALUE;
      AABB right = new AABB(); AABB left = new AABB();
      int min_id = 0, min_axis =0;
      
      for(int axis=0; axis<3 ;axis++) {
        Bucket buckets[] = new Bucket[NB_BUCKETS_BVH];
        for(int i=0; i<NB_BUCKETS_BVH ;i++) buckets[i] = new Bucket();
        right.reset(); left.reset();
        
        for(int i=firstTriangleId; i<=lastTriangleId ;i++){
          int x = this.hash(node,axis,i);
          buckets[x].nb++;
          buckets[x].aabb.extend(triangles.get(i).aabb);
        }
  
        for(int i=1; i<NB_BUCKETS_BVH-1 ; i++) {
          left.reset(); int count_left = 0;
          right.reset(); int count_right = 0;
  
          for(int j=0; j<i; j++){
            count_left += buckets[j].nb;
            left.extend( buckets[j].aabb );
          }
  
          for(int j=i; j<NB_BUCKETS_BVH; j++){
            count_right += buckets[j].nb;
            right.extend( buckets[j].aabb );
          }
  
          float SAH = ((count_left*left.surface())+(count_right*right.surface()))*invSA_P;
          if ( min_cost > SAH ) { 
            min_id = i; 
            min_cost = SAH;
            min_axis = axis;
          }
        }
      }
    
      if( min_cost >= 1.f ) return; // stop if it's not worth to split
      
      int stop = lastTriangleId, start;
      boolean swap_val = false;
      for(start=firstTriangleId; start<stop ; ){
        if(swap_val){
          if(hash(node,min_axis,stop)>=min_id) stop--;
          else{ swap_val=false; Collections.swap(triangles,start,stop); stop--; start++; }
        }else{
          if(hash(node,min_axis,start)<=min_id) start++;
          else swap_val = true;
        }
      }
      
      int cutId = max(start,stop);
      
      node.left = new BVHNode();
      buildRec( node.left, firstTriangleId, cutId, depth+1 );
      node.right = new BVHNode();
      buildRec( node.right, cutId+1, lastTriangleId, depth+1 );
    }
  }

  public HitRecord intersect( float tMin, float tMax, PVector o, PVector d){
    return intersectRec( root, tMin, tMax, o, d );
  }

  private HitRecord intersectRec( BVHNode node, float tMin, float tMax, PVector o, PVector d){
    HitRecord hitClosest = new HitRecord();
    
    if(node==null || !node.aabb.intersect( tMin, tMax, o, d )) return hitClosest;   // aabb intersect

    if(node.isLeaf()){
      hitClosest.t = tMax;
      
      for(int i=node.firstTriangleId; i<=node.lastTriangleId ;i++){ 
        HitRecord hit = triangles.get(i).intersect(o,d);
        if( hit.t>tMin && hit.t<hitClosest.t ) hitClosest = hit;
      }
      
      return hitClosest;
    }

    HitRecord tL = intersectRec( node.left, tMin, tMax, o, d);
    HitRecord tR = intersectRec( node.right, tMin, tMax, o, d);
    
    if(tL.t>tMin){
      if(tR.t>tMin) return (tR.t<tL.t ? tR : tL);
      return tL;
    }
    return tR;
  }
}
