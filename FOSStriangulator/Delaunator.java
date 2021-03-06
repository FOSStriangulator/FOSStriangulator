// TODO publish as a separate project too

// ISC License

// Copyright (c) 2021, Miroslav Mazel, Ricardo Matias, Mapbox et al.

// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.

// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/**
 * A Java port of Mapbox's Delaunator incredibly fast JavaScript library for
 * Delaunay triangulation of 2D points.
 *
 * @description Port of Ricardo Matias's Kotlin library - https://github.com/ricardomatias/delaunator,
 *			  which is itself a port of Mapbox's Delaunator (JavaScript) library -
 *			  https://github.com/mapbox/delaunator
 * @property coords flat positions' array - [x0, y0, x1, y1..]
 *
 */

import java.util.Arrays;

public class Delaunator {
	final float EPSILON = (float) Math.pow(2.0f, -50); // todo double-check this is correct
	final int[] EDGE_STACK = new int[512];

	float[] coords;

	private final int n;

	// arrays that will store the triangulation graph
	final int maxTriangles;
	private int[] _triangles;

	private int[] _halfedges;

	int[] triangles = null;
	int[] halfedges = null;

	// temporary arrays for tracking the edges of the advancing convex hull
	private int hashSize;

	private int[] hullPrev; // edge to prev edge

	private int[] hullNext; // edge to next edge

	private int[] hullTri; // edge to adjacent triangle

	private int[] hullHash; // angular edge hash

	private int hullStart = -1;

	// temporary arrays for sorting points
	private int[] ids;

	private float[] dists;

	private float cx = Float.NaN;
	private float cy = Float.NaN;

	private int trianglesLen = -1;

	int[] hull = null;

	Delaunator(float[] coords) {
		this.coords = coords;
		n = coords.length >> 1;

		// arrays that will store the triangulation graph
		maxTriangles = 2 * n - 5 > 0 ? 2 * n - 5 : 0;
		_triangles = new int[maxTriangles * 3];
		_halfedges = new int[maxTriangles * 3];

		// temporary arrays for tracking the edges of the advancing convex hull
		hashSize = (int) Math.ceil(Math.sqrt(n * 1.0));
		hullPrev = new int[n]; // edge to prev edge
		hullNext = new int[n]; // edge to next edge
		hullTri = new int[n]; // edge to adjacent triangle
		hullHash = new int[hashSize];
		Arrays.fill(hullHash, -1); // todo check if can remove

		// temporary arrays for sorting points
		dists = new float[n];
		ids = new int[n];

		update();
	}

	void update() {
		// populate an array of point indices calculate input data bbox
		float minX = Float.POSITIVE_INFINITY;
		float minY = Float.POSITIVE_INFINITY;
		float maxX = Float.NEGATIVE_INFINITY;
		float maxY = Float.NEGATIVE_INFINITY;

		// points -> points
		// minX, minY, maxX, maxY
		for (int i = 0; i < n; i++) {
			float x = coords[2 * i];
			float y = coords[2 * i + 1];
			if (x < minX)
				minX = x;
			if (y < minY)
				minY = y;
			if (x > maxX)
				maxX = x;
			if (y > maxY)
				maxY = y;

			ids[i] = i;
		}

		float cx = (minX + maxX) / 2;
		float cy = (minY + maxY) / 2;

		float minDist = Float.POSITIVE_INFINITY;

		int i0 = -1;
		int i1 = -1;
		int i2 = -1;

		// pick a seed point close to the center
		for (int i = 0; i < n; i++) {
			float d = dist(cx, cy, coords[2 * i], coords[2 * i + 1]);

			if (d < minDist) {
				i0 = i;
				minDist = d;
			}
		}

		float i0x = coords[2 * i0];
		float i0y = coords[2 * i0 + 1];

		minDist = Float.POSITIVE_INFINITY;

		// Find the point closest to the seed
		for (int i = 0; i < n; i++) {
			if (i == i0)
				continue;

			float d = dist(i0x, i0y, coords[2 * i], coords[2 * i + 1]);

			if (d < minDist && d > 0) {
				i1 = i;
				minDist = d;
			}
		}
		float i1x = coords[2 * i1];
		float i1y = coords[2 * i1 + 1];

		float minRadius = Float.POSITIVE_INFINITY;

		// Find the third point which forms the smallest circumcircle with the first two
		for (int i = 0; i < n; i++) {
			if (i == i0 || i == i1)
				continue;

			float r = circumradius(i0x, i0y, i1x, i1y, coords[2 * i], coords[2 * i + 1]);

			if (r < minRadius) {
				i2 = i;
				minRadius = r;
			}
		}

		float i2x = coords[2 * i2];
		float i2y = coords[2 * i2 + 1];

		if (minRadius == Float.POSITIVE_INFINITY) {
			// order collinear points by dx (or dy if all x are identical)
			// and return the list as a hull
			for (int i = 0; i < n; i++) { // todo double-check
				float a = (coords[2 * i] - coords[0]);
				float b = (coords[2 * i + 1] - coords[1]);
				dists[i] = (a == 0.0) ? b : a;
			}

			quicksort(ids, dists, 0, n - 1);

			int[] nhull = new int[n];
			int j = 0;

			float d0 = Float.NEGATIVE_INFINITY;
			for (int i = 0; i < n; i++) {
				int id = ids[i];
				if (dists[id] > d0) {
					hull[j++] = id;
					d0 = dists[id];
				}
			}

			hull = Arrays.copyOf(nhull, j);
			triangles = new int[0];
			halfedges = new int[0];
			return;
		}

		// swap the order of the seed points for counter-clockwise orientation
		if (orient(i0x, i0y, i1x, i1y, i2x, i2y)) {
			int i = i1;
			float x = i1x;
			float y = i1y;
			i1 = i2;
			i1x = i2x;
			i1y = i2y;
			i2 = i;
			i2x = x;
			i2y = y;
		}

		float[] center = circumcenter(i0x, i0y, i1x, i1y, i2x, i2y);
		this.cx = center[0];
		this.cy = center[1];

		for (int i = 0; i < n; i++) {
			dists[i] = dist(coords[2 * i], coords[2 * i + 1], center[0], center[1]);
		}

		// sort the points by distance from the seed triangle circumcenter
		quicksort(ids, dists, 0, n - 1);

		// set up the seed triangle as the starting hull
		hullStart = i0;
		int hullSize = 3;

		hullNext[i0] = hullPrev[i2] = i1; // todo out of bounds exception here
		hullNext[i1] = hullPrev[i0] = i2;
		hullNext[i2] = hullPrev[i1] = i0;

		hullTri[i0] = 0;
		hullTri[i1] = 1;
		hullTri[i2] = 2;

		Arrays.fill(hullHash, -1);
		hullHash[hashKey(i0x, i0y)] = i0;
		hullHash[hashKey(i1x, i1y)] = i1;
		hullHash[hashKey(i2x, i2y)] = i2;

		trianglesLen = 0;
		addTriangle(i0, i1, i2, -1, -1, -1);

		float xp = 0f;
		float yp = 0f;

		for (int k = 0; k < ids.length; k++) {
			int i = ids[k];
			float x = coords[2 * i];
			float y = coords[2 * i + 1];

			// skip near-duplicate points
			// todo could this be the problem? STOPPED HERE
			if (k > 0 && Math.abs(x - xp) <= EPSILON && Math.abs(y - yp) <= EPSILON)
				continue;

			xp = x;
			yp = y;

			// skip seed triangle points
			if (i == i0 || i == i1 || i == i2)
				continue;

			// find a visible edge on the convex hull using edge hash
			int start = 0;
			int key = hashKey(x, y);

			for (int j = 0; j < hashSize; j++) {
				start = hullHash[(key + j) % hashSize];

				if (start != -1 && start != hullNext[start])
					break;
			}

			start = hullPrev[start];

			int e = start;
			int q = hullNext[e];

			while (!orient(x, y, coords[2 * e], coords[2 * e + 1], coords[2 * q], coords[2 * q + 1])) {
				e = q;

				if (e == start) {
					e = -1;
					break;
				}

				q = hullNext[e];
			}

			if (e == -1)
				continue; // likely a near-duplicate point skip it

			// add the first triangle from the point
			int t = addTriangle(e, i, hullNext[e], -1, -1, hullTri[e]);

			// recursively flip triangles from the point until they satisfy the Delaunay
			// condition
			hullTri[i] = legalize(t + 2);
			hullTri[e] = t; // keep track of boundary triangles on the hull
			hullSize++;

			// walk forward through the hull, adding more triangles and flipping recursively
			int next = hullNext[e];
			q = hullNext[next];

			while (orient(x, y, coords[2 * next], coords[2 * next + 1], coords[2 * q], coords[2 * q + 1])) {
				t = addTriangle(next, i, q, hullTri[i], -1, hullTri[next]);
				hullTri[i] = legalize(t + 2);
				hullNext[next] = next; // mark as removed
				hullSize--;

				next = q;
				q = hullNext[next];
			}

			// walk backward from the other side, adding more triangles and flipping
			if (e == start) {
				q = hullPrev[e];

				while (orient(x, y, coords[2 * q], coords[2 * q + 1], coords[2 * e], coords[2 * e + 1])) {
					t = addTriangle(q, i, e, -1, hullTri[e], hullTri[q]);
					legalize(t + 2);
					hullTri[q] = t;
					hullNext[e] = e; // mark as removed
					hullSize--;

					e = q;
					q = hullPrev[e];
				}
			}

			// update the hull indices
			hullStart = e;
			hullPrev[i] = e;

			hullNext[e] = i;
			hullPrev[next] = i;
			hullNext[i] = next;

			// save the two new edges in the hash table
			hullHash[hashKey(x, y)] = i;
			hullHash[hashKey(coords[2 * e], coords[2 * e + 1])] = e;
		}

		hull = new int[hullSize];

		int e = hullStart;

		for (int i = 0; i < hullSize; i++) {
			hull[i] = e;
			e = hullNext[e];
		}

		// trim typed triangle mesh arrays
		triangles = Arrays.copyOf(_triangles, trianglesLen);
		halfedges = Arrays.copyOf(_halfedges, trianglesLen);
	}

	private int legalize(int a) {
		int i = 0;
		int na = a;
		int ar;

		// recursion eliminated with a fixed-size stack
		while (true) {
			int b = _halfedges[na];

			/*
			 * if the pair of triangles doesn't satisfy the Delaunay condition (p1 is inside
			 * the circumcircle of [p0, pl, pr]), flip them, then do the same check/flip
			 * recursively for the new pair of triangles
			 *
			 * pl pl /||\ / \ al/ || \bl al/ \a / || \ / \ / a||b \ flip /___ar___\ p0\ ||
			 * /p1 => p0\---bl---/p1 \ || / \ / ar\ || /br b\ /br \||/ \ / pr pr
			 */
			int a0 = na - na % 3;
			ar = a0 + (na + 2) % 3;

			if (b == -1) { // convex hull edge
				if (i == 0)
					break;
				na = EDGE_STACK[--i];
				continue;
			}

			int b0 = b - b % 3;
			int al = a0 + (na + 1) % 3;
			int bl = b0 + (b + 2) % 3;

			int p0 = _triangles[ar];
			int pr = _triangles[na];
			int pl = _triangles[al];
			int p1 = _triangles[bl];

			boolean illegal = inCircle(coords[2 * p0], coords[2 * p0 + 1], coords[2 * pr], coords[2 * pr + 1],
					coords[2 * pl], coords[2 * pl + 1], coords[2 * p1], coords[2 * p1 + 1]);

			if (illegal) {
				_triangles[na] = p1;
				_triangles[b] = p0;

				int hbl = _halfedges[bl];

				// edge swapped on the other side of the hull (rare) fix the halfedge reference
				if (hbl == -1) {
					int e = hullStart;
					do {
						if (hullTri[e] == bl) {
							hullTri[e] = na;
							break;
						}
						e = hullPrev[e];
					} while (e != hullStart);
				}
				link(na, hbl);
				link(b, _halfedges[ar]);
				link(ar, bl);

				int br = b0 + (b + 1) % 3;

				// don't worry about hitting the cap: it can only happen on extremely degenerate
				// input
				if (i < EDGE_STACK.length) {
					EDGE_STACK[i++] = br;
				}
			} else {
				if (i == 0)
					break;
				na = EDGE_STACK[--i];
			}
		}

		return ar;

	}

	private void link(int a, int b) {
		_halfedges[a] = b;
		if (b != -1)
			_halfedges[b] = a;
	}

	// add a new triangle given vertex indices and adjacent half-edge ids
	private int addTriangle(int i0, int i1, int i2, int a, int b, int c) {
		int t = trianglesLen;

		_triangles[t] = i0;
		_triangles[t + 1] = i1;
		_triangles[t + 2] = i2;

		link(t, a);
		link(t + 1, b);
		link(t + 2, c);

		trianglesLen += 3;

		return t;
	}

	private int hashKey(float x, float y) {
		return (int) (Math.floor(pseudoAngle(x - cx, y - cy) * hashSize) % hashSize);
	}

	float circumradius(float ax, float ay, float bx, float by, float cx, float cy) {
		float dx = bx - ax;
		float dy = by - ay;
		float ex = cx - ax;
		float ey = cy - ay;

		float bl = dx * dx + dy * dy;
		float cl = ex * ex + ey * ey;
		float d = 0.5f / (dx * ey - dy * ex);

		float x = (ey * bl - dy * cl) * d;
		float y = (dx * cl - ex * bl) * d;

		return x * x + y * y;
	}

	float[] circumcenter(float ax, float ay, float bx, float by, float cx, float cy) {
		float dx = bx - ax;
		float dy = by - ay;
		float ex = cx - ax;
		float ey = cy - ay;

		float bl = dx * dx + dy * dy;
		float cl = ex * ex + ey * ey;
		float d = 0.5f / (dx * ey - dy * ex);

		float x = ax + (ey * bl - dy * cl) * d;
		float y = ay + (dx * cl - ex * bl) * d;

		return new float[] { x, y };
	}

	void quicksort(int[] ids, float[] dists, int left, int right) {
		if (right - left <= 20) {
			for (int i = left + 1; i < right; i++) {
				int temp = ids[i];
				float tempDist = dists[temp];
				int j = i - 1;
				while (j >= left && dists[ids[j]] > tempDist)
					ids[j + 1] = ids[j--];
				ids[j + 1] = temp;
			}
		} else

		{
			int median = (left + right) >> 1;
			int i = left + 1;
			int j = right;

			swap(ids, median, i);

			if (dists[ids[left]] > dists[ids[right]])
				swap(ids, left, right);
			if (dists[ids[i]] > dists[ids[right]])
				swap(ids, i, right);
			if (dists[ids[left]] > dists[ids[i]])
				swap(ids, left, i);

			int temp = ids[i];
			float tempDist = dists[temp];

			while (true) {
				do
					i++;
				while (dists[ids[i]] < tempDist);
				do
					j--;
				while (dists[ids[j]] > tempDist);
				if (j < i)
					break;
				swap(ids, i, j);
			}

			ids[left + 1] = ids[j];
			ids[j] = temp;

			if (right - i + 1 >= j - left) {
				quicksort(ids, dists, i, right);
				quicksort(ids, dists, left, j - 1);
			} else {
				quicksort(ids, dists, left, j - 1);
				quicksort(ids, dists, i, right);
			}
		}
	}

	private void swap(int[] arr, int i, int j) {
		int tmp = arr[i];
		arr[i] = arr[j];
		arr[j] = tmp;
	}

	// monotonically increases with real angle, but doesn't need expensive
	// trigonometry
	private float pseudoAngle(float dx, float dy) {
		float p = dx / (Math.abs(dx) + Math.abs(dy));
		float a = (dy > 0.0) ? 3.0f - p : 1.0f + p;

		return a / 4.0f; // [0..1]
	}

	private float dist(float ax, float ay, float bx, float by) {
		float dx = ax - bx;
		float dy = ay - by;
		return dx * dx + dy * dy;
	}

	// return 2d orientation sign if we're confident in it through J. Shewchuk's
	// error bound check
	private float orientIfSure(float px, float py, float rx, float ry, float qx, float qy) {
		float l = (ry - py) * (qx - px);
		float r = (rx - px) * (qy - py);
		return (Math.abs(l - r) >= (3.3306690738754716e-16 * Math.abs(l + r))) ? l - r : 0.0f;
	}

	// a more robust orientation test that's stable in a given triangle (to fix
	// robustness issues)
	private boolean orient(float rx, float ry, float qx, float qy, float px, float py) {
		float a = orientIfSure(px, py, rx, ry, qx, qy);
		float b = orientIfSure(rx, ry, qx, qy, px, py);
		float c = orientIfSure(qx, qy, px, py, rx, ry);

		if (!isFalsy(a)) {
			return a < 0;
		} else {
			if (!isFalsy(b)) {
				return b < 0;
			} else {
				return c < 0;
			}
		}
	}

	private boolean inCircle(float ax, float ay, float bx, float by, float cx, float cy, float px, float py) {
		float dx = ax - px;
		float dy = ay - py;
		float ex = bx - px;
		float ey = by - py;
		float fx = cx - px;
		float fy = cy - py;

		float ap = dx * dx + dy * dy;
		float bp = ex * ex + ey * ey;
		float cp = fx * fx + fy * fy;

		return dx * (ey * cp - bp * fy) - dy * (ex * cp - bp * fx) + ap * (ex * fy - ey * fx) < 0;
	}

	private boolean isFalsy(float d) {
		return d == -0.0 || d == 0.0 || Float.isNaN(d); // removed d == null, as I'm sticking to primitive types
	}
}
