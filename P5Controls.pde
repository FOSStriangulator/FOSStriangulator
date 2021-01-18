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

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded

public class ControlFrame extends PApplet 
{
  int w, h;
  String name;
  PApplet parent;
  ControlP5 cp5;
  
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) 
  {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    name = _name;
  
    PApplet.runSketch(new String[]{name}, this);
  }
  
  public void settings() 
  {
    size(w, h);
  }
  
  public void setup() 
  {
    surface.setTitle(name);
    surface.setLocation(initWindowLocationX,initWindowLocationY);
    frameRate(25);
    cp5 = new ControlP5(this);
    
    //UI sizes
    int marginX = 10;
    int groupInsetX = 10;
    int groupWidth = controlFrameWidth - (4*marginX);
    int[] largeButtonSize = {(groupWidth - 2*groupInsetX), 20};
    int sliderWidth = 90 + 90 + 25;
    
    //Color styles 
    cp5.setColorForeground(Colors.ACCENT_800);
    cp5.setColorBackground(Colors.BG_800);
    cp5.setColorActive(Colors.ACCENT_700);
    
    //Components
    chooseButton = 
    cp5.addButton("choose")
    .setPosition(marginX,20)
    .setSize(groupWidth,largeButtonSize[1]+10)
    .plugTo(parent,"choose")
    .setLabel("Choose an image...")
    .linebreak()
    ;
  
    Group g2 = 
    cp5.addGroup("g2")
    .setPosition(marginX,chooseButton.getPosition()[1] + chooseButton.getHeight() + 30)
    .setLabel("Point generation")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,130)
    .disableCollapse()
    ;
    
    cWSlider = 
    cp5.addSlider("contWeight")
    .setPosition(groupInsetX,10)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,25)
    .setValue(1)
    .setLabel("Edge weight")
    .plugTo(parent,"contWeight")
    .setGroup(g2)
    ;
    
    cThSlider = 
    cp5.addSlider("contThreshold")
    .setPosition(groupInsetX,40)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,254)
    .setValue(80)
    .setLabel("Edge threshold")
    .plugTo(parent,"contThreshold")
    .setGroup(g2)
    ;
    
    cPSlider = 
    cp5.addSlider("contourPointsN")
    .setPosition(groupInsetX,70)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,500)
    .setValue(0)
    .setLabel("# of edge points")
    .plugTo(parent,"contourPointsN")
    .setGroup(g2)
    ;
  
    nCPSlider = 
    cp5.addSlider("randomPointsN")
    .setPosition(groupInsetX,100)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,500)
    .setValue(0)
    .setLabel("# of random points")
    .plugTo(parent,"randomPointsN")
    .setGroup(g2)
    ;
  
    Group g3 = 
    cp5.addGroup("g3")
    .setPosition(marginX,g2.getPosition()[1] + g2.getBackgroundHeight() + 30)
    .setLabel("Point control")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,60)
    .disableCollapse()
    ;
    
    sPButton = 
    cp5.addButton("sPoints")
    .setPosition(groupInsetX,groupInsetX)
    .setSize(90,largeButtonSize[1])
    .plugTo(parent,"sPoints")
    .setLabel("Save points")
    .setGroup(g3)
    ;
    
    lPButton =  
    cp5.addButton("lPoints")
    .setPosition(sPButton.getPosition()[0] + sPButton.getWidth() + 15,groupInsetX)
    .setSize(90,largeButtonSize[1])
    .plugTo(parent,"lPoints")
    .setLabel("Load points")
    .setGroup(g3)
    ;
  
    e = cp5.addToggle("eraser")
    .plugTo(parent,"eraser")
    .setPosition(lPButton.getPosition()[0] + lPButton.getWidth() + 15,groupInsetX)
    .setSize(90,largeButtonSize[1])
    .setLabel("On/off eraser (e)")
    .setGroup(g3)
    ;
  
    Group g4 = 
    cp5.addGroup("g4")
    .setPosition(marginX,g3.getPosition()[1] + g3.getBackgroundHeight() + 30)
    .setLabel("Display options")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,70)
    .disableCollapse()
    ;
   
    r = cp5.addRadioButton("passChooser")
    .setPosition(groupInsetX,10)
    .setSize(20,largeButtonSize[1])
    .setItemsPerRow(3)
    .setSpacingColumn(90)
    .setSpacingRow(10)
    .addItem("Original (o)",Pass.IMAGE)
    .addItem("Mesh (m)",Pass.MESH)
    .addItem("Contour (c)",Pass.CONTOUR)
    .addItem("Result (r)",Pass.RESULT)
    .activate(Pass.MESH)
    .plugTo(parent,"passChooser")
    .setGroup(g4)
    ;

    //Needs work
    /*TransSlider = 
    cp5.addSlider("randomPointsN")
    .setPosition(groupInsetX,100)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,255)
    .setValue(255)
    .setLabel("Triangle2D Transparency")
    .plugTo(parent,"randomPointsN")
    .setGroup(g4)
    ;*/ 

  
    Button sP = 
    cp5.addButton("savePDF")
    .setPosition(marginX,g4.getPosition()[1] + g4.getBackgroundHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1])
    .setLabel("Export to PDF")
    .plugTo(parent,"savePDF")
    ;
       
    Button sO = 
    cp5.addButton("saveOBJ")
    .setPosition(marginX,sP.getPosition()[1] + sP.getHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1])
    .setLabel("Export to OBJ")
    .plugTo(parent,"saveOBJ")
    ;
       
     // cp5.addSlider("abc").setRange(0, 255).setPosition(10,10);
     // cp5.addSlider("def").plugTo(parent,"def").setRange(0, 255).setPosition(10,30);
     
    ta = 
    cp5.addTextarea("txt")
    .setPosition(marginX,sO.getPosition()[1] + 30)
    .setSize(groupWidth,60)
    .setLineHeight(14)
    .setColor(Colors.ON_BG)
    .setColorBackground(Colors.BG_950)
    .setBorderColor(Colors.BG_950)
    .setText("Messages will appear here")  
    ;
  }

  public void draw() 
  {
      background(Colors.BG_900);
  }
  

  public ControlP5 control() 
  {
    return cp5;
  }

  void keyPressed() 
  {
    if (key == 's' || key == 'S') 
    {
      PGraphics pdf = createGraphics(img.width, img.height, PDF, "output.pdf");
      pdf.beginDraw();
      pdf.noStroke();   
      pdf.image(img, 0, 0);
      LinkedHashSet<PVector> pointsDisplay = new LinkedHashSet<PVector>();  
      pointsDisplay = (LinkedHashSet)points.clone(); 
      triangles = new DelaunayTriangulator(pointsDisplay).triangulate();
      for (int i = 0; i < triangles.size(); i++) 
      {
        Triangle2D t = (Triangle2D)triangles.get(i);
  
        int ave_x = int((t.a.x + t.b.x + t.c.x)/3);  
        int ave_y = int((t.a.y + t.b.y + t.c.y)/3);
  
        pdf.fill( img_b.get(ave_x, ave_y));
  
        pdf.triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
      }
      pdf.dispose();
      pdf.endDraw();
      save("output.png");
    }
  
    if (key == 'o' || key == 'O') 
    {
      displayType = Pass.IMAGE;
      r.activate(Pass.IMAGE);
    }
  
    if (key == 'r' || key == 'R') 
    {
      displayType = Pass.RESULT;
      r.activate(Pass.RESULT);
    }
  
    if (key == 'm' || key == 'M') 
    {
      displayType = Pass.MESH;
      r.activate(Pass.MESH);
    }
   
    if (key == 'c' || key == 'C') 
    {
      displayType = Pass.CONTOUR;
      r.activate(Pass.CONTOUR);
    }
  
    if (key == 'e' || key == 'E') 
    {
      if (deleteMode == true) 
      {
        e.setState(false);
      }
      else if (deleteMode == false) 
      {
        e.setState(true);
      }
    }
     if ((key == '}' || key == ']') && (eraserSize != maxEraserSize))
    {
      eraserSize = eraserSize+1;  
    }
    
    if ((key == '{' || key == '[') && (eraserSize != minEraserSize))
    {
      eraserSize = eraserSize-1;
    }
  }
}
