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

void drawEraserCursor () {
	noFill();
	stroke(Colors.ATTENTION);
	strokeWeight(2.0/zoom);
	ellipse(mappedMouseX, mappedMouseY, eraserSize*2.0,eraserSize*2.0);
}

void drawPoints() {
	stroke(Colors.POINT_OUTLINE);
	strokeWeight(1.5/zoom);
	fill(255);

	for (Iterator<PVector> it = points.iterator(); it.hasNext();) {
		PVector pt = it.next();
		ellipse(pt.x, pt.y, 2.5, 2.5);
	}
}

void drawTriangleMesh () {
	noFill();
	beginShape(TRIANGLES);
	strokeJoin(BEVEL);
	strokeWeight(0.7/zoom);
	stroke(Colors.POINT_OUTLINE);

	ArrayList<DTTriangle> drawnTriangles = (hoverTriangles != null) ? hoverTriangles : triangles;

	for (Iterator<DTTriangle> it = drawnTriangles.iterator(); it.hasNext();) {
		DTTriangle t = it.next();
		vertex(t.a.x, t.a.y);
		vertex(t.b.x, t.b.y);
		vertex(t.c.x, t.c.y);
	}
	endShape();
}

void drawTriangles () {
	noStroke();
	beginShape(TRIANGLES);

	ArrayList<DTTriangle> drawnTriangles = (hoverTriangles != null) ? hoverTriangles : triangles;

	for (Iterator<DTTriangle> it = drawnTriangles.iterator(); it.hasNext();) {
		DTTriangle t = it.next();
		int ave_x = int((t.a.x + t.b.x + t.c.x)/3);  
		int ave_y = int((t.a.y + t.b.y + t.c.y)/3);
		
		if (notInsideImage(ave_x,ave_y)) {
			PVector imgEdgeIntersection = lineIntersectionBox(new PVector (ave_x,ave_y), new PVector (img.width/2,img.height/2), new PVector (1.0, 1.0), new PVector (img.width-1,img.height-1));
			fill(img_b.get(floor(imgEdgeIntersection.x), floor(imgEdgeIntersection.y)), 255);
		}
		else {
			fill(img_b.get(ave_x, ave_y), 255);
		}
		vertex(t.a.x, t.a.y);
		vertex(t.b.x, t.b.y);
		vertex(t.c.x, t.c.y);
		
		//testing image intersection
		//if (notInsideImage(ave_x,ave_y))
		//{
		//  fill(255,0,0);
		//  stroke(255,0,0);
		//  ellipse(ave_x,ave_y,5,5);
		//  text( (str(ave_x) +" " + str(ave_y)) ,ave_x,ave_y);
		//  line(ave_x,ave_y,img.width/2,img.height/2);
		//  PVector imgEdgeIntersection = lineIntersectionBox(new PVector (ave_x,ave_y), new PVector (img.width/2,img.height/2), new PVector (0.0, 0.0), new PVector (img.width,img.height));
		//  ellipse(imgEdgeIntersection.x,imgEdgeIntersection.y,5,5);
		//}
	}
	endShape();
}