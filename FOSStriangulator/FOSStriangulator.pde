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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FOSStriangulator. If not, see <http://www.gnu.org/licenses/>.


/*TODO: 
fixed: Look at mouse press action , mapped mouse coordinates are not correct
critical: hashSets based on pixel integer don't properly store float mouse coords or negative and out of range coords, need to find a different way to compare
Transparency slider for triangles alpha
interpolate edge colour
*/

import java.util.LinkedHashSet;
import java.awt.image.BufferedImage;
import java.util.Iterator;
import processing.pdf.*;
import processing.svg.*;
import controlP5.*;

public int displayMode = Mode.MESH;
public boolean eraserOn = false;

boolean pointsEdited = false;

//Graphic UI varialbles
int maxEraserSize = 80;
int minEraserSize = 1;
int eraserSize = 5;
PImage img, img_b, imgContour, icon;

//Control varialbles
private ControlP5 controlP5;
RadioButton modeRadio;
Toggle eraserToggle; 
Textarea messageArea;
Slider edgeWeightSlider, edgeThresholdSlider, edgePtsSlider, randomPtsSlider, eraserSizeSlider;
Button openImageBtn, loadPtsBtn, savePtsBtn;
int controlFrameWidth = 360;
int initWindowLocationX = 100;
int initWindowLocationY = 100;

//Pan Zoom variables
float zoom;
float originX, originY;
float mappedMouseX,mappedMouseY;

//text file writer
PrintWriter output;

//Triangulate points and objects 
ArrayList<PVector> contourPointsList = new ArrayList<PVector>();
ArrayList<IntList> contourImgPoints;
ArrayList triangles = new ArrayList();
ArrayList hoverTriangles = null;

LinkedHashSet<PVector> userPointsHash = new LinkedHashSet<PVector>();
LinkedHashSet<PVector> points = new LinkedHashSet<PVector>();
PVector hoverPoint = null;

IntList contourPoints = new IntList();
IntList nonContourPoints = new IntList();

void setup()
{
  zoom = 1.0;
  img = loadImage(Platform.ASSETS_DIR + "instructions.png");
  icon = loadImage(Platform.ASSETS_DIR + "icon.png");

	img_b = img.get();
	imgContour = contourImage(img_b, 1,80);

  surface.setResizable(true);
	surface.setSize(img.width, img.height);
	surface.setTitle("FOSStriangulator");
  surface.setLocation(initWindowLocationX+controlFrameWidth,initWindowLocationY);
  surface.setIcon(icon);

	//standard corner points
	points.add(new PVector(0, 0, 0));
	points.add(new PVector(img.width-1, 0, 0));
	points.add(new PVector(img.width-1, img.height-1, 0));
	points.add(new PVector(0, img.height-1, 0));
	points.add(new PVector(img.width/2, img.height/2, 0));
	
  userPointsHash.addAll(points);
	
  contourImgPoints = getThresholdPixels (imgContour, true);
	nonContourPoints = contourImgPoints.get(0);
	contourPoints = contourImgPoints.get(1);

	noStroke();
	frameRate(60);
	cursor(CROSS);
	smooth();

	controlP5 = new ControlP5(this);
	ControlFrame cf = new ControlFrame(this, 340, 690, "Tools");
}

void draw()
{
  scale(zoom);
  translate(originX, originY);
  background(Colors.CANVAS);
  
  switch(displayMode)
  {
    case Mode.POINTS:
      image(img, 0, 0);
      drawPoints();
      break;
    
    case Mode.CONTOUR:
      image(imgContour, 0, 0);
      drawPoints();
      break;
    
    case Mode.MESH:
      image(img, 0, 0);
      retriangulate();
      drawTriangleMesh();
      break;

    case Mode.RESULT:
      image(img_b, 0, 0);
      retriangulate();
      drawTriangles();
      break;
  
    default:
      image(img, 0, 0);
      break;
  }

  if (eraserOn) {
    drawEraserCursor();
  } 
}

// key presses within main window
void keyPressed() 
{
  if (key == CODED) {
    codedKeyPressed(keyCode);
  } else {
    if (key == ' ') {
      if (eraserOn) {
        eraseArea(mappedMouseX, mappedMouseY);
      } else {
        addPoint(mappedMouseX, mappedMouseY);
      }
    } else {
      globalKeyPressed(key);
    }
  }
}
