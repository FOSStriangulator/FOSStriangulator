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


/*TODO: 
fixed: Look at mouse press action , mapped mouse coordinates are not correct
critical: hashSets based on pixel integer don't properly store float mouse coords or negative and out of range coords, need to find a different way to compare
Transparency slider for triangles alpha
interpolate edge colour
*/

import java.util.LinkedHashSet;
import processing.pdf.*;
import processing.svg.*;
import controlP5.*;
import java.awt.image.BufferedImage;
import java.util.Iterator;

public int displayMode = Mode.MESH;
public boolean deleteMode = false;
public boolean panMode = false;
boolean refreshBuffer = true;
boolean refreshBufferOnce = false;

//Graphic UI varialbles
int maxEraserSize = 80;
int minEraserSize = 1;
float eraserSize = 5.0;
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
float xtrans, ytrans;
float xzoom, yzoom;
float mappedMouseX,mappedMouseY;

//text file writer
PrintWriter output;

//Triangulate points and objects 
ArrayList<PVector> contourPointsList = new ArrayList<PVector>();
ArrayList<IntList> contourImgPoints;
ArrayList triangles = new ArrayList();

LinkedHashSet<PVector> userPointsHash = new LinkedHashSet<PVector>();
LinkedHashSet<PVector> points = new LinkedHashSet<PVector>();
LinkedHashSet<PVector> pointsDisplay = new LinkedHashSet<PVector>(); 

IntList contourPoints = new IntList();
IntList nonContourPoints = new IntList();



void setup()
{
  zoom=1.0;
  img = loadImage("Instructions.png");
  icon = loadImage("icon.png");

  /*
  For flatpaks, use:
	img = loadImage("/app/share/Instructions.png");
  icon = loadImage("/app/share/icon.png");
  */

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
  pointsDisplay.addAll(points); 	
	
  contourImgPoints = getThresholdPixels (imgContour, true);
	nonContourPoints = contourImgPoints.get(0);
	contourPoints = contourImgPoints.get(1);

	noStroke();
	frameRate(60);
	cursor(CROSS);
	smooth();

	controlP5 = new ControlP5(this);
	ControlFrame cf = new ControlFrame(this, 340, 690, "Tools");
	//noLoop();
}

void draw()
{
  scale(zoom);
  translate(xtrans-xzoom,ytrans-yzoom);
  background(128);
  
  switch(displayMode)
  {
    case Mode.POINTS:
      image(img, 0, 0);
      drawPoints(0xff0000FF);
      break;
    
    case Mode.CONTOUR:
      image(imgContour, 0, 0);
      drawPoints(0xffFF0000);
      break;
    
    case Mode.MESH:
      image(img, 0, 0);
      if (refreshBuffer == true){triangles = new DelaunayTriangulator(pointsDisplay).triangulate();}
      drawTriangleMesh();
      if (refreshBufferOnce == true){refreshBuffer = false;}
      break;

    case Mode.RESULT:
      image(img_b, 0, 0);
      //LinkedHashSet pointsDisplay = new LinkedHashSet(); 
      //pointsDisplay = (LinkedHashSet)points.clone(); 
      if (refreshBuffer == true){triangles = new DelaunayTriangulator(pointsDisplay).triangulate();}
      drawTriangles();
      if (refreshBufferOnce == true){refreshBuffer = false;}
      break;
  
    default:
      image(img, 0, 0);
      break;
  }

  if (deleteMode == true) 
  {
    drawEraserCursor();
    refreshBuffer = false;
  } 
}

// key presses within main window
void keyPressed() 
{
  globalKeyPressed(key);
}

//create a contour image from img , using weight v, and threshold
PImage contourImage (PImage img, int v, int threshold)
{
	int[] AllImgPixels;

	int w = v*(-8);
	int[][] kernel = { { v, v, v },
					   { v, w, v },
					   { v, v, v } };
		
	PImage edgeImg = createImage(img.width, img.height, RGB);
	//long timer = System.currentTimeMillis();
	// Loop through every pixel in the image.
	for (int y = 1; y < img.height-1; y++) 
	{ // Skip top and bottom edges
		for (int x = 1; x < img.width-1; x++) 
		{ // Skip left and right edges
			float sum = 0; // Kernel sum for this pixel
			for (int ky = -1; ky <= 1; ky++) 
			{
				for (int kx = -1; kx <= 1; kx++) 
				{
					// Calculate the adjacent pixel for this kernel point
					int pos = (y + ky)*img.width + (x + kx);
					// Image is grayscale, red/green/blue are identical
					float val = red(img.pixels[pos]);
					// Multiply adjacent pixels based on the kernel values
					sum += kernel[ky+1][kx+1] * val;
				}
			}
			// For this pixel in the new image, set the gray value
			// based on the sum from the kernel
			if (sum >= threshold) {sum = 255;}
			else {sum = 0;}
			//println(sum);
			edgeImg.pixels[y*img.width + x] = color(sum);

		}
	}
	// State that there are changes to edgeImg.pixels[]
	edgeImg.updatePixels();

	return edgeImg;
}

//return an arraylist of intlist (0:contourPoints, 1:non-contourPoints)
ArrayList<IntList> getThresholdPixels (PImage inImg, boolean shuffled)
{
	ArrayList<IntList> result = new ArrayList<IntList>();
	IntList cP = new IntList();
	IntList nCP = new IntList();
	//img = inImg.get();
	for (int y = 0; y < inImg.height; y++) 
	{ // Skip top and bottom edges
		for (int x = 0; x < inImg.width; x++) 
		{
			color argb = inImg.get(x,y);
			int value = (argb >> 16) & 0xFF;
			//println(value);
			if ( value > 254 || x == 0 || y == 0 || x == inImg.width-1 || y == inImg.height-1)
			{
				int i = y*inImg.width + x;
				cP.append(i);
			}
			else
			{
				int i = y*inImg.width + x;
				nCP.append(i);
			}
		
		}
	}
	if (shuffled == true)
	{
		cP.shuffle();
		nCP.shuffle();
	}
	result.add(nCP);
	result.add(cP);
		
	return result;
}

int[] shuffle (int[] array) 
{
  int m = array.length, t, i;

  // While there remain elements to shuffle
  while (m < 0) {

    // Pick a remaining element
    i = (int)Math.floor(Math.random() * m--);

    // And swap it with the current element.
    t = array[m];
    array[m] = array[i];
    array[i] = t;
  }
  return array;
}
//create a hashset of cartesian coords from intlist of pixel coordinates
LinkedHashSet<PVector> sublistIntList (IntList inList, int start, int end)
{
	LinkedHashSet<PVector> result = new LinkedHashSet<PVector>();
	for(int i = start; i < end; i++)
	{
		result.add((intToCoords(inList.get(i))));
	}
	return result;
}

//converts image pixel coordinate to cartesian coordinate
PVector intToCoords (int tempPoint)
{
	int tempX = tempPoint % img.width;
	int tempY = (int)(tempPoint/img.width);
	PVector result = new PVector(tempX, tempY, 0);
	return result;
}

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
