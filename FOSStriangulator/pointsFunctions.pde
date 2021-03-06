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
	retriangulate();
}

void eraseArea(float x, float y) {
	for (Iterator < PVector > it = points.iterator(); it.hasNext();) {
		PVector p = it.next();
		float d = dist(x, y, p.x, p.y);
		if (d < eraserSize) {
			userPointsHash.remove(p);
			it.remove();
		}
	}
	
	retriangulate();
}

void cancelHover() {
	hoverPoint = null;
	hoverDelaunator = null;
}

void retriangulate() {
	delPoints = pVectorsToFloatArrays(points);
	delaunator = new Delaunator(delPoints);
	
	// create hover points
	if (hoverPoint != null) {
		float[] tempPoints = new float[delPoints.length + 2];
		for (int i = 0; i < delPoints.length; i++) {
			tempPoints[i] = delPoints[i];
		}
		tempPoints[delPoints.length] = hoverPoint.x;
		tempPoints[delPoints.length + 1] = hoverPoint.y;
		hoverPoints = tempPoints;
		hoverDelaunator = new Delaunator(hoverPoints);
	}
}

void updateHover(PVector point) {
	hoverPoint = point;
	if (hoverPoint != null) {
		if (hoverDelaunator != null) {
			hoverPoints[delPoints.length] = hoverPoint.x;
			hoverPoints[delPoints.length + 1] = hoverPoint.y;
			hoverDelaunator.update();
		} else {
			retriangulate();
		}
	}
}

float[] pVectorsToFloatArrays(LinkedHashSet<PVector> pointSet) {
	float[] res = new float[pointSet.size() * 2];
	
	int i = 0;
	for (Iterator < PVector > it = pointSet.iterator(); it.hasNext();) {
		PVector pvector = it.next();
		res[i] = pvector.x;
		res[i + 1] = pvector.y;
		i += 2;
	}
	
	return res;
}