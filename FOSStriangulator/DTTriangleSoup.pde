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
import java.util.Arrays;
import java.util.List;
import java.util.Iterator;

/**
 * DTTriangle soup class implementation.
 * 
 * @author Johannes Diemke
 */
class DTTriangleSoup {

    private List<DTTriangle> triangleSoup;

    /**
     * Constructor of the triangle soup class used to create a new triangle soup
     * instance.
     */
    public DTTriangleSoup() {
        this.triangleSoup = new ArrayList<DTTriangle>();
    }

    /**
     * Adds a triangle to this triangle soup.
     * 
     * @param triangle
     *            The triangle to be added to this triangle soup
     */
    public void add(DTTriangle triangle) {
        this.triangleSoup.add(triangle);
    }

    /**
     * Removes a triangle from this triangle soup.
     * 
     * @param triangle
     *            The triangle to be removed from this triangle soup
     */
    public void remove(DTTriangle triangle) {
        this.triangleSoup.remove(triangle);
    }

    /**
     * Returns the triangles from this triangle soup.
     * 
     * @return The triangles from this triangle soup
     */
    public List<DTTriangle> getTriangles() {
        return this.triangleSoup;
    }

    /**
     * Returns the triangle from this triangle soup that contains the specified
     * point or null if no triangle from the triangle soup contains the point.
     * 
     * @param point
     *            The point
     * @return Returns the triangle from this triangle soup that contains the
     *         specified point or null
     */
    public DTTriangle findContainingTriangle(PVector point) {
        for (Iterator<DTTriangle> it = triangleSoup.iterator(); it.hasNext();) {
            DTTriangle triangle = it.next();
            if (triangle.contains(point)) {
                return triangle;
            }
        }
        return null;
    }

    /**
     * Returns the neighbor triangle of the specified triangle sharing the same
     * edge as specified. If no neighbor sharing the same edge exists null is
     * returned.
     * 
     * @param triangle
     *            The triangle
     * @param edge
     *            The edge
     * @return The triangles neighbor triangle sharing the same edge or null if
     *         no triangle exists
     */
    public DTTriangle findNeighbour(DTTriangle triangle, DTEdge edge) {
        for (Iterator<DTTriangle> it = triangleSoup.iterator(); it.hasNext();) {
            DTTriangle triangleFromSoup = it.next();
            if (triangleFromSoup.isNeighbour(edge) && triangleFromSoup != triangle) {
                return triangleFromSoup;
            }
        }
        return null;
    }

    /**
     * Returns one of the possible triangles sharing the specified edge. Based
     * on the ordering of the triangles in this triangle soup the returned
     * triangle may differ. To find the other triangle that shares this edge use
     * the {@link findNeighbour(DTTriangle triangle, DTEdge edge)} method.
     * 
     * @param edge
     *            The edge
     * @return Returns one triangle that shares the specified edge
     */
    public DTTriangle findOneTriangleSharing(DTEdge edge) {
        for (Iterator<DTTriangle> it = triangleSoup.iterator(); it.hasNext();) {
            DTTriangle triangle = it.next();
            if (triangle.isNeighbour(edge)) {
                return triangle;
            }
        }
        return null;
    }

    /**
     * Returns the edge from the triangle soup nearest to the specified point.
     * 
     * @param point
     *            The point
     * @return The edge from the triangle soup nearest to the specified point
     */
    public DTEdge findNearestEdge(PVector point) {
        List<DTEdgeDistancePack> edgeList = new ArrayList<DTEdgeDistancePack>();

        for (Iterator<DTTriangle> it = triangleSoup.iterator(); it.hasNext();) {
            DTTriangle triangle = it.next();
            edgeList.add(triangle.findNearestEdge(point));
        }

        DTEdgeDistancePack[] edgeDistancePacks = new DTEdgeDistancePack[edgeList.size()];
        edgeList.toArray(edgeDistancePacks);

        Arrays.sort(edgeDistancePacks);
        return edgeDistancePacks[0].edge;
    }

    /**
     * Removes all triangles from this triangle soup that contain the specified
     * vertex.
     * 
     * @param vertex
     *            The vertex
     */
    public void removeTrianglesUsing(PVector vertex) {
        List<DTTriangle> trianglesToBeRemoved = new ArrayList<DTTriangle>();

        for (Iterator<DTTriangle> it = triangleSoup.iterator(); it.hasNext();) {
            DTTriangle triangle = it.next();
            if (triangle.hasVertex(vertex)) {
                trianglesToBeRemoved.add(triangle);
            }
        }

        triangleSoup.removeAll(trianglesToBeRemoved);
    }

}
