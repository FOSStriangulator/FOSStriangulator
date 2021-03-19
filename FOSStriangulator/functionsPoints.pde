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

void addPoint(float x, float y) {
	points.add(new PVector(x, y, 0));
	userPointsHash.add(new PVector(x, y, 0));
	pointsEdited = true;
}

void eraseArea(float x, float y) {
	for (Iterator<PVector> it = points.iterator(); it.hasNext();) {
		PVector p = it.next();
		float d = dist(x, y, p.x, p.y);
		if ( d < eraserSize ) {
			userPointsHash.remove(p);
			it.remove();
		}
	}
	pointsEdited = true;
}

void cancelHover() {
	hoverPoint = null;
    hoverTriangles = null;
}

void retriangulate() {
	// triangles
	if (pointsEdited) {
		triangles = new DelaunayTriangulator(points).triangulate(); // todo store DelaunayTriangulator, get rid of triangles // todo use points
		pointsEdited = false;
	}

	// hover triangles
	if (hoverPoint != null) { //todo could use a different optimized Delaunay algorithm that allows quick addition without triangulating from the beginning
		ArrayList tempPoints = new ArrayList<PVector>(points.size() + 1);
		for (Iterator<PVector> it = points.iterator(); it.hasNext();) {
			PVector pt = it.next();
			tempPoints.add(new PVector(pt.x, pt.y));
		}
		tempPoints.add(hoverPoint);
		hoverTriangles = new DelaunayTriangulator(tempPoints).triangulate();
	}
}
