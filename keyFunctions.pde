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


void keyPressed() 
{
  if (key == 's' || key == 'S') 
  {
    PGraphics pdf = createGraphics(img.width, img.height, PDF, "output.pdf");
    pdf.beginDraw();
    pdf.noStroke();   
    pdf.image(img, 0, 0);
    
    LinkedHashSet<PVector> pointsDisplay = new LinkedHashSet<PVector>();   
    pointsDisplay = (LinkedHashSet)points.clone(); 
    triangles = new DelaunayTriangulator(pointsDisplay).triangulate();
    
    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle2D t = (Triangle2D)triangles.get(i);

      int ave_x = int((t.a.x + t.b.x + t.c.x)/3);  
      int ave_y = int((t.a.y + t.b.y + t.c.y)/3);

      pdf.fill( img_b.get(ave_x, ave_y));

      pdf.triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
    }
    pdf.dispose();
    pdf.endDraw();
    save("output.png");
  }

  if (key == 'o' || key == 'O') 
  {
    displayType = Pass.IMAGE;
    r.activate(Pass.IMAGE);
  }

  if (key == 'r' || key == 'R') 
  {
    displayType = Pass.RESULT;
    r.activate(Pass.RESULT);
  }

  if (key == 'm' || key == 'M') 
  {
    displayType = Pass.MESH;
    r.activate(Pass.MESH);
  }
 
  if (key == 'c' || key == 'C') 
  {
    displayType = Pass.CONTOUR;
    r.activate(Pass.CONTOUR);
  }

  if (key == 'e' || key == 'E') 
  {
    if (deleteMode == true) 
    {
      e.setState(false);
    }
    else if (deleteMode == false) 
    {  
      e.setState(true);
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
  
  //println(keyCode);
  //println(key);
}
