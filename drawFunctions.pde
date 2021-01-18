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

void drawEraserCursor ()
{
   noFill();
   stroke(0);
   strokeWeight(2.0/zoom);
   ellipse(mappedMouseX, mappedMouseY, eraserSize*2.0,eraserSize*2.0);
   //ellipse(mouseX, mouseY, eraserSize*2.0,eraserSize*2.0);
}

void drawBlurMessage()
{
   int img_w = 297;
   int img_h = 40;
   int img_x = (img.width - img_w)/2;
   int img_y = (img.height - img_h)/2;
   fill(0,0,255);
   rect(0,img.height/2 - 30, img.width, 60);
   textAlign(CENTER,CENTER);
   textSize(40);
   fill(255);
   image(processingTextImg,img_x,img_y, img_w, img_h);
   //text("PROCESSING",img.width/2,img.height/2 - 5);
}
