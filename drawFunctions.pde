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
