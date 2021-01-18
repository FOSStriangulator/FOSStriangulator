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

/////////////////////////////////////////
//        BUTTON FUNCTIONS             //
/////////////////////////////////////////

public void eraser(boolean theFlag) 
{
  //println("delete flag set");
  if (theFlag==true) 
  {
    deleteMode = true;
    refreshBufferOnce = true;
    pointsDisplay = (LinkedHashSet)points.clone();  
  } 
  else 
  {
    cursor(CROSS);
    deleteMode = false;
    refreshBuffer = true;
    refreshBufferOnce = false;
  }
}

public void choose() 
{
  refreshBuffer = true;
  selectInput("Select a file to process:", "imageFileSelect");
} //end choose

public void lPoints() 
{
  refreshBuffer = true;
  selectInput("Select a points text file:", "pointsFileSelect");
} //end lPoints

public void sPoints() 
{
  selectOutput("Save points text file:", "pointsFileSave");
} //end sPoints

public void savePDF()
{
  selectOutput("Save as a pdf:", "pdfFileSave");
}

public void saveOBJ()
{
  selectOutput("Save as a obj:", "objFileSave");
}

public void contWeight (int _value) 
{
  if (deleteMode == true){refreshBuffer = true;}
  img_c = countourImage(img_b, _value, (int)cThSlider.getValue());
  contourImgPoints = getThresholdPixels (img_c, true);
  nonContourPoints = contourImgPoints.get(0);
  contourPoints = contourImgPoints.get(1);
  displayType = Pass.CONTOUR;
  r.activate(Pass.CONTOUR);
}

public void contThreshold (int _value) 
{
  if (deleteMode == true){refreshBuffer = true;}
  img_c = countourImage(img_b, (int)cWSlider.getValue(),_value);
  contourImgPoints = getThresholdPixels (img_c, true);
  nonContourPoints = contourImgPoints.get(0);
  contourPoints = contourImgPoints.get(1);
  displayType = Pass.CONTOUR;  
  r.activate(Pass.CONTOUR);
}

public void passChooser(int a) 
{ 
  if (a==Pass.IMAGE)
  {
    displayType = Pass.IMAGE;
    r.activate(Pass.IMAGE);
  }  

  if (a==Pass.MESH)
  {
    refreshBuffer = true;
    displayType = Pass.MESH;
    r.activate(Pass.MESH);
  }

  if (a==Pass.RESULT)
  {
    refreshBuffer = true;
    displayType = Pass.RESULT;
    r.activate(Pass.RESULT);
  }
  if (a==Pass.CONTOUR)
  {
    displayType = Pass.CONTOUR;
    r.activate(Pass.CONTOUR);
  }
}

//need to resolve this - currently uses the old pvector list need to convert everything to hashset
public void randomPointsN(int pointsNumber)
{
  //noLoop();
  if (deleteMode == true){refreshBuffer = true;}
  LinkedHashSet<PVector> contourPointsHash = new LinkedHashSet<PVector>(sublistIntList(contourPoints, 0, (int)cPSlider.getValue()));
  LinkedHashSet<PVector> nonContourPointsHash = new LinkedHashSet<PVector>(sublistIntList(nonContourPoints, 0, pointsNumber));   
  points = new LinkedHashSet<PVector>();
  pointsDisplay = new LinkedHashSet<PVector>();
  points.addAll(userPointsHash);
  points.addAll(contourPointsHash);
  points.addAll(nonContourPointsHash);
  
  pointsDisplay.addAll(points);

  //println(userPointsHash);
  //loop();
}

public void contourPointsN(int pointsNumber)
{
  //noLoop();
  if (deleteMode == true){refreshBuffer = true;}
  LinkedHashSet<PVector> contourPointsHash = new LinkedHashSet<PVector>(sublistIntList(contourPoints, 0, pointsNumber));
  LinkedHashSet<PVector> nonContourPointsHash = new LinkedHashSet<PVector>(sublistIntList(nonContourPoints, 0, (int)nCPSlider.getValue()));   
  points = new LinkedHashSet<PVector>();
  pointsDisplay = new LinkedHashSet<PVector>();
  points.addAll(userPointsHash);
  points.addAll(contourPointsHash);
  points.addAll(nonContourPointsHash);
  
  pointsDisplay.addAll(points);
  //loop();
}
