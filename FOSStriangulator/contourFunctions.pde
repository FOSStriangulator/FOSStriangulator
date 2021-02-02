//create a contour image from img , using weight v, and threshold
PImage contourImage (PImage img, int v, int threshold)
{
	int[] AllImgPixels;

	int w = v*(-8);
	int[][] kernel = { { v, v, v },
					   { v, w, v },
					   { v, v, v } };
		
	PImage edgeImg = createImage(img.width, img.height, RGB);

	// Loop through every pixel in the image.
	for (int y = 1; y < img.height-1; y++) 
	{ // Skip top and bottom edges
		for (int x = 1; x < img.width-1; x++) 
		{ // Skip left and right edges
			float sum = 0; // Kernel sum for this pixel
			for (int ky = -1; ky <= 1; ky++) 
			{
				for (int kx = -1; kx <= 1; kx++) 
				{
					// Calculate the adjacent pixel for this kernel point
					int pos = (y + ky)*img.width + (x + kx);
					// Image is grayscale, red/green/blue are identical
					float val = red(img.pixels[pos]);
					// Multiply adjacent pixels based on the kernel values
					sum += kernel[ky+1][kx+1] * val;
				}
			}
			// For this pixel in the new image, set the gray value
			// based on the sum from the kernel
			if (sum >= threshold) {sum = 0;}
			else {sum = 255;}
			//println(sum);
			edgeImg.pixels[y*img.width + x] = color(sum);
		}
	}

  // color all vertical edges white
  for (int y = 0; y < img.height; y++) {
    edgeImg.pixels[y*img.width + 0] = color(255);
    edgeImg.pixels[y*img.width + img.width-1] = color(255);
  }

  // color all horizontal edges white
  for (int x = 0; x < img.width; x++) {
    edgeImg.pixels[0 + x] = color(255);
    edgeImg.pixels[(img.height-1)*img.width + x] = color(255);
  }

	// State that there are changes to edgeImg.pixels[]
	edgeImg.updatePixels();

	return edgeImg;
}

//return an arraylist of intlist (0:contourPoints, 1:non-contourPoints)
ArrayList<IntList> getThresholdPixels (PImage inImg, boolean shuffled)
{
	ArrayList<IntList> result = new ArrayList<IntList>();
	IntList cP = new IntList();
	IntList nCP = new IntList();
	//img = inImg.get();
	for (int y = 0; y < inImg.height; y++) 
	{ // Skip top and bottom edges
		for (int x = 0; x < inImg.width; x++) 
		{
			color argb = inImg.get(x,y);
			int value = (argb >> 16) & 0xFF;
			//println(value);
			if ( value > 254 || x == 0 || y == 0 || x == inImg.width-1 || y == inImg.height-1)
			{
				int i = y*inImg.width + x;
				nCP.append(i);
			}
			else
			{
				int i = y*inImg.width + x;
				cP.append(i);
			}
		
		}
	}
	if (shuffled == true)
	{
		cP.shuffle();
		nCP.shuffle();
	}
	result.add(nCP);
	result.add(cP);
		
	return result;
}

//create a hashset of cartesian coords from intlist of pixel coordinates
LinkedHashSet<PVector> sublistIntList (IntList inList, int start, int end)
{
	LinkedHashSet<PVector> result = new LinkedHashSet<PVector>();
	for(int i = start; i < end; i++)
	{
		result.add((intToCoords(inList.get(i))));
	}
	return result;
}

//converts image pixel coordinate to cartesian coordinate
PVector intToCoords (int tempPoint)
{
	int tempX = tempPoint % img.width;
	int tempY = (int)(tempPoint/img.width);
	PVector result = new PVector(tempX, tempY, 0);
	return result;
}