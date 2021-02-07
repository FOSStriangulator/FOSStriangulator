void addPoint(float x, float y) { // todo resolve ConcurrentException with keyboard usage
	noLoop(); // loop restarts once mouse starts moving again, along with pointsDisplay

    points.add(new PVector(x, y, 0));
    userPointsHash.add(new PVector(x, y, 0));
}

void eraseArea(float x, float y) {
    refreshBuffer = true;
    refreshBufferOnce = true;

    Iterator<PVector> it = pointsDisplay.iterator();
    while(it.hasNext())
    {
      PVector p = it.next();
      float d = dist(x, y, p.x, p.y);
      if ( d < eraserSize )
      {
       userPointsHash.remove(p);
       it.remove();
      }
    }
    points = (LinkedHashSet)pointsDisplay.clone(); 
}