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


void mouseMoved() {
  //println(frameRate);
  
  loop();
  mappedMouseX = (mouseX/zoom - originX);
  mappedMouseY = (mouseY/zoom - originY);
  
  if (deleteMode == false)
  {
    // preview on hover
    pointsDisplay = (LinkedHashSet)points.clone();   
    pointsDisplay.add(new PVector(mappedMouseX, mappedMouseY, 0));
  }
}

void mouseWheel(MouseEvent event) {
  loop();
  float count = event.getCount();

  if (event.isControlDown() || event.isMetaDown()) { // zoom
    if (count < 0) {
      zoomOut(-count);
    }
    else {
      zoomIn(count);
    }
  } else if (event.isShiftDown()) { // horizontal scrolling
    if (count < 0) {
      moveLeft(-count / 10);
    } else {
      moveRight(count / 10);
    }
  } else { // vertical scrolling
    if (count < 0) {
      moveUp(-count / 10);
    } else {
      moveDown(count / 10);
    }
  }
}

void mouseExited()
{
  pointsDisplay = (LinkedHashSet)points.clone(); 
  //println("mouse exited");
}


void mousePressed() { 
  if (deleteMode == false && mouseEvent.getClickCount()< 2 && mouseButton == LEFT) {
    addPoint(mappedMouseX, mappedMouseY);
  } else if (deleteMode == true && mouseButton == LEFT) {
    eraseArea(mappedMouseX, mappedMouseY);
  }
}

void mouseReleased() 
{
  frameRate(60);
}
