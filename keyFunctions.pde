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
//        KEY FUNCTIONS                //
/////////////////////////////////////////

void globalKeyPressed(char key) {
  if (key == 's' || key == 'S') 
  {
    savePdfToFile("output.pdf");
  }

  if (key == 'p' || key == 'P') 
  {
    displayType = Mode.POINTS;
    modeRadio.activate(Mode.POINTS);
  }

  if (key == 'r' || key == 'R') 
  {
    displayType = Mode.RESULT;
    modeRadio.activate(Mode.RESULT);
  }

  if (key == 'm' || key == 'M') 
  {
    displayType = Mode.MESH;
    modeRadio.activate(Mode.MESH);
  }
 
  if (key == 'c' || key == 'C') 
  {
    displayType = Mode.CONTOUR;
    modeRadio.activate(Mode.CONTOUR);
  }

  if (key == 'e' || key == 'E') 
  {
    if (deleteMode == true) 
    {
      eraserToggle.setState(false);
    }
    else if (deleteMode == false) 
    {  
      eraserToggle.setState(true);
    }
  }
   if ((key == '}' || key == ']') && (eraserSize != maxEraserSize))
  {
    eraserSize = eraserSize+1;  
  }
  
  if ((key == '{' || key == '[') && (eraserSize != minEraserSize))
  {
    eraserSize = eraserSize-1;
  }
}
