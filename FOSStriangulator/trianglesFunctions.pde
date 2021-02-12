boolean notInsideImage (float _x, float _y)
{
  return (_x <=0 || _x >= img.width || _y<=0 || _y >= img.height); 
}

PVector lineIntersection(PVector pa1, PVector pa2, PVector pb1, PVector pb2) 
{
  float aA = pa2.y-pa1.y;
  float aB = pa2.x-pa1.x;
  float bA = pb2.y-pb1.y;
  float bB = pb2.x-pb1.x;
  float det = aA * bB - bA * aB;

  if (det == 0) return null; // parallel

  float aC = aA * pa1.x + aB * pa1.y;
  float bC = bA * pb1.x + bB * pb1.y;

  return new PVector((bB * aC - aB * bC)/det, (aA * bC - bA * aC)/det);
}

//assumes only one and first intersection - that's all we need for this
PVector lineIntersectionBox (PVector p1, PVector p2, PVector boxP1, PVector boxP2)
{
  PVector result = null;
  PVector[] boxVectors = 
  {
   new PVector (boxP1.x,boxP1.y),
   new PVector (boxP1.x,boxP2.y),
   
   new PVector (boxP1.x,boxP2.y),
   new PVector (boxP2.x,boxP2.y),
   
   new PVector (boxP2.x,boxP2.y),
   new PVector (boxP2.x,boxP1.y),
   
   new PVector (boxP2.x,boxP1.y),
   new PVector (boxP1.x,boxP1.y)
  };
  
  for (int i = 0; i < boxVectors.length; i=i+2)
  {
     PVector is = lineIntersection(p1, p2, boxVectors[i], boxVectors[i+1]);
     if (is!=null) { result = is;break;}
  }
  
  return result;
}