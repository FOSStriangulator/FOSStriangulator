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

/**
 * Edge distance pack class implementation used to describe the distance to a
 * given edge.
 * 
 * @author Johannes Diemke
 */
public class EdgeDistancePack implements Comparable<EdgeDistancePack> {

    public Edge2D edge;
    public double distance;

    /**
     * Constructor of the edge distance pack class used to create a new edge
     * distance pack instance from a 2D edge and a scalar value describing a
     * distance.
     * 
     * @param edge
     *            The edge
     * @param distance
     *            The distance of the edge to some point
     */
    public EdgeDistancePack(Edge2D edge, double distance) {
        this.edge = edge;
        this.distance = distance;
    }

    @Override
    public int compareTo(EdgeDistancePack o) {
        return Double.compare(this.distance, o.distance);
    }

}