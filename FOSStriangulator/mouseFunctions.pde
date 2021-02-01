// Copyright (C) 2021 Ilya Floussov and FOSStriangulator contributors
//
// This file is part of FOSStriangulator.
//
// FOSStriangulator is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 2 only.
//
// FOSStriangulator is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FOSStriangulator.  If not, see <http://www.gnu.org/licenses/>.


void mouseMoved()
{
  //println(frameRate);
  
  loop();
  mappedMouseX = (mouseX/zoom - (xtrans-xzoom));
  mappedMouseY = (mouseY/zoom - (ytrans-yzoom));
  
  if (deleteMode == false && panMode == false)
  {
    // preview on hover
    pointsDisplay = (LinkedHashSet)points.clone();   
    pointsDisplay.add(new PVector(mappedMouseX, mappedMouseY, 0));
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
}

void mouseReleased() 
{
  panMode = false;
  frameRate(60);
}
