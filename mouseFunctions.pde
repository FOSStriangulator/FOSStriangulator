/////////////////////////////////////////
//        MOUSE FUNCTIONS              //
/////////////////////////////////////////


void mouseMoved()
{
  //println(frameRate);
  
  loop();
  mappedMouseX = (mouseX/zoom - (xtrans-xzoom));
  mappedMouseY = (mouseY/zoom - (ytrans-yzoom));
  
  if (deleteMode == false && panMode == false)
  {
    pointsDisplay = (LinkedHashSet)points.clone();   
    pointsDisplay.add(new PVector(mappedMouseX, mappedMouseY, 0));
  }
  else if (deleteMode == true && panMode == false)
  {
    
  }
}
void mouseDragged()
{
  if (mouseButton == CENTER)
  {
    panMode = true;
    //TODO
  }
}

void mouseWheel(MouseEvent event) {
  //TODO
}

void mouseEntered()
{
  //println("mouse entered");
}

void mouseExited()
{
  pointsDisplay = (LinkedHashSet)points.clone(); 
  //println("mouse exited");
}


void mousePressed() 
{ 
  if (mouseButton != CENTER) {panMode = false;}
  
  if (deleteMode == false && mouseEvent.getClickCount()< 2 && mouseButton == LEFT)
  {
    //println("mouse pressed");
    //long timer = System.currentTimeMillis();
    noLoop();  

    points.add(new PVector(mappedMouseX, mappedMouseY, 0));
    //pointsDisplay.add(new PVector(mappedMouseX, mappedMouseY, 0));
    userPointsHash.add(new PVector(mappedMouseX, mappedMouseY, 0));
    
    //redraw();
    //loop();
  }
  else if (deleteMode == true && mouseButton == LEFT)
  {
    //for (PVector temp : points)
    //{
    //  float d = dist(mappedMouseX, mappedMouseY, temp.x, temp.y);
    //  if ( d < eraserSize)
    //  {
    //    userPointsHash.remove(temp);
    //    points.remove(temp);
    //  }
    //}
    
    //LinkedHashSet<PVector> points = new LinkedHashSet<PVector>(); 
    refreshBuffer = true;
    refreshBufferOnce = true;
    Iterator<PVector> it = pointsDisplay.iterator();
    while(it.hasNext())
    {
      PVector p = it.next();
      float d = dist(mappedMouseX, mappedMouseY, p.x, p.y);
      if ( d < eraserSize)
      {
       userPointsHash.remove(p);
       it.remove();
      }
    }
    points = (LinkedHashSet)pointsDisplay.clone(); 
  }
} //end mousepressed

void mouseReleased() 
{
  panMode = false;
  frameRate(60);
}//end released
