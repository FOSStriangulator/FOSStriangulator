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