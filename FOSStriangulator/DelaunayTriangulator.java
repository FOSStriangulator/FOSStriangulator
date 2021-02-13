/** 
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015 Johannes Diemke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// Original source: https://github.com/jdiemke/delaunay-triangulator
// Modifications were made to use Processing's native PVector class

// package io.github.jdiemke.triangulation;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.LinkedHashSet;
import java.util.Iterator;
import processing.core.PVector;

/**
 * A Java implementation of an incremental 2D Delaunay triangulation algorithm.
 * 
 * @author Johannes Diemke
 */
public class DelaunayTriangulator {

    private List<PVector> pointSet;
    private TriangleSoup triangleSoup;

    /**
     * Constructor of the SimpleDelaunayTriangulator class used to create a new
     * triangulator instance.
     * 
     * @param pointSet The point set to be triangulated
     */
    public DelaunayTriangulator(List<PVector> pointSet) {
        this.pointSet = pointSet;
        this.triangleSoup = new TriangleSoup();
    }

    public DelaunayTriangulator(LinkedHashSet<PVector> pPoints) {
        this.pointSet = new ArrayList<PVector>(pPoints.size());
        for (Iterator<PVector> it = pPoints.iterator(); it.hasNext();) {
            PVector pvector = it.next();
            pointSet.add(new PVector(pvector.x, pvector.y));
        }
        this.triangleSoup = new TriangleSoup();
    }

    /**
     * This method generates a Delaunay triangulation from the specified point
     * set.
     */
    public ArrayList<Triangle2D> triangulate() {
        triangleSoup = new TriangleSoup();

        /**
         * In order for the in circumcircle test to not consider the vertices of
         * the super triangle we have to start out with a big triangle
         * containing the whole point set. We have to scale the super triangle
         * to be very large. Otherwise the triangulation is not convex.
         */
        float maxOfAnyCoordinate = 0.0f;

        for (Iterator<PVector> it = getPointSet().iterator(); it.hasNext();) {
            PVector vector = it.next();
            maxOfAnyCoordinate = Math.max(Math.max(vector.x, vector.y), maxOfAnyCoordinate);
        }

        maxOfAnyCoordinate *= 16.0f;

        PVector p1 = new PVector(0.0f, 3.0f * maxOfAnyCoordinate);
        PVector p2 = new PVector(3.0f * maxOfAnyCoordinate, 0.0f);
        PVector p3 = new PVector(-3.0f * maxOfAnyCoordinate, -3.0f * maxOfAnyCoordinate);

        Triangle2D superTriangle = new Triangle2D(p1, p2, p3);

        triangleSoup.add(superTriangle);

        if (pointSet == null || pointSet.size() < 3) {
            return new ArrayList<Triangle2D>(triangleSoup.getTriangles());
        }

        for (int i = 0; i < pointSet.size(); i++) {
            Triangle2D triangle = triangleSoup.findContainingTriangle(pointSet.get(i));

            if (triangle == null) {
                /**
                 * If no containing triangle exists, then the vertex is not
                 * inside a triangle (this can also happen due to numerical
                 * errors) and lies on an edge. In order to find this edge we
                 * search all edges of the triangle soup and select the one
                 * which is nearest to the point we try to add. This edge is
                 * removed and four new edges are added.
                 */
                Edge2D edge = triangleSoup.findNearestEdge(pointSet.get(i));

                Triangle2D first = triangleSoup.findOneTriangleSharing(edge);
                Triangle2D second = triangleSoup.findNeighbour(first, edge);

                PVector firstNoneEdgeVertex = first.getNoneEdgeVertex(edge);
                PVector secondNoneEdgeVertex = second.getNoneEdgeVertex(edge);

                triangleSoup.remove(first);
                triangleSoup.remove(second);

                Triangle2D triangle1 = new Triangle2D(edge.a, firstNoneEdgeVertex, pointSet.get(i));
                Triangle2D triangle2 = new Triangle2D(edge.b, firstNoneEdgeVertex, pointSet.get(i));
                Triangle2D triangle3 = new Triangle2D(edge.a, secondNoneEdgeVertex, pointSet.get(i));
                Triangle2D triangle4 = new Triangle2D(edge.b, secondNoneEdgeVertex, pointSet.get(i));

                triangleSoup.add(triangle1);
                triangleSoup.add(triangle2);
                triangleSoup.add(triangle3);
                triangleSoup.add(triangle4);

                legalizeEdge(triangle1, new Edge2D(edge.a, firstNoneEdgeVertex), pointSet.get(i));
                legalizeEdge(triangle2, new Edge2D(edge.b, firstNoneEdgeVertex), pointSet.get(i));
                legalizeEdge(triangle3, new Edge2D(edge.a, secondNoneEdgeVertex), pointSet.get(i));
                legalizeEdge(triangle4, new Edge2D(edge.b, secondNoneEdgeVertex), pointSet.get(i));
            } else {
                /**
                 * The vertex is inside a triangle.
                 */
                PVector a = triangle.a;
                PVector b = triangle.b;
                PVector c = triangle.c;

                triangleSoup.remove(triangle);

                Triangle2D first = new Triangle2D(a, b, pointSet.get(i));
                Triangle2D second = new Triangle2D(b, c, pointSet.get(i));
                Triangle2D third = new Triangle2D(c, a, pointSet.get(i));

                triangleSoup.add(first);
                triangleSoup.add(second);
                triangleSoup.add(third);

                legalizeEdge(first, new Edge2D(a, b), pointSet.get(i));
                legalizeEdge(second, new Edge2D(b, c), pointSet.get(i));
                legalizeEdge(third, new Edge2D(c, a), pointSet.get(i));
            }
        }

        return new ArrayList<Triangle2D>(triangleSoup.getTriangles());
    }

    /**
     * This method legalizes edges by recursively flipping all illegal edges.
     * 
     * @param triangle
     *            The triangle
     * @param edge
     *            The edge to be legalized
     * @param newVertex
     *            The new vertex
     */
    private void legalizeEdge(Triangle2D triangle, Edge2D edge, PVector newVertex) {
        Triangle2D neighbourTriangle = triangleSoup.findNeighbour(triangle, edge);

        /**
         * If the triangle has a neighbor, then legalize the edge
         */
        if (neighbourTriangle != null) {
            if (neighbourTriangle.isPointInCircumcircle(newVertex)) {
                triangleSoup.remove(triangle);
                triangleSoup.remove(neighbourTriangle);

                PVector noneEdgeVertex = neighbourTriangle.getNoneEdgeVertex(edge);

                Triangle2D firstTriangle = new Triangle2D(noneEdgeVertex, edge.a, newVertex);
                Triangle2D secondTriangle = new Triangle2D(noneEdgeVertex, edge.b, newVertex);

                triangleSoup.add(firstTriangle);
                triangleSoup.add(secondTriangle);

                legalizeEdge(firstTriangle, new Edge2D(noneEdgeVertex, edge.a), newVertex);
                legalizeEdge(secondTriangle, new Edge2D(noneEdgeVertex, edge.b), newVertex);
            }
        }
    }

    /**
     * Creates a random permutation of the specified point set. Based on the
     * implementation of the Delaunay algorithm this can speed up the
     * computation.
     */
    public void shuffle() {
        Collections.shuffle(pointSet);
    }

    /**
     * Shuffles the point set using a custom permutation sequence.
     * 
     * @param permutation
     *            The permutation used to shuffle the point set
     */
    public void shuffle(int[] permutation) {
        List<PVector> temp = new ArrayList<PVector>();
        for (int i = 0; i < permutation.length; i++) {
            temp.add(pointSet.get(permutation[i]));
        }
        pointSet = temp;
    }

    /**
     * Returns the point set in form of a vector of 2D vectors.
     * 
     * @return Returns the points set.
     */
    public List<PVector> getPointSet() {
        return pointSet;
    }

    /**
     * Returns the trianges of the triangulation in form of a vector of 2D
     * triangles.
     * 
     * @return Returns the triangles of the triangulation.
     */
    public List<Triangle2D> getTriangles() {
        return triangleSoup.getTriangles();
    }

}