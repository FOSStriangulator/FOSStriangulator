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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FOSStriangulator.	If not, see <http://www.gnu.org/licenses/>.

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded

public class ControlFrame extends PApplet {
	int w, h;
	String name;
	PApplet parent;
	ControlP5 controlP5;
	
	public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
		super();	 
		parent = _parent;
		w=_w;
		h=_h;
		name = _name;
	
		PApplet.runSketch(new String[]{name}, this);
	}
	
	public void settings() {
		size(w, h);
	}
	
	public void setup() {
		surface.setTitle(name);
		surface.setLocation(UIDimen.INIT_SIDEBAR_X, UIDimen.INIT_SIDEBAR_Y);
		frameRate(25); // todo remove all frameRate methods?
		controlP5 = new ControlP5(this);
		
		// COLOR STYLES
		controlP5.setColorForeground(Colors.ACCENT_800);
		controlP5.setColorBackground(Colors.BG_700);
		controlP5.setColorActive(Colors.ACCENT_700);

		// POSITION TRACKING
		int nextY = UIDimen.MARGIN_UNIT;
		int nextHeight = 0;
		int groupY = UIDimen.MARGIN_UNIT;
		int groupHeight = 0;
		
		// COMPONENTS
		nextHeight = UIDimen.BTN_LARGE_HEIGHT;
		openImageBtn = 
			controlP5.addButton("openImageBtn")
			.setPosition(UIDimen.MARGIN_UNIT, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.plugTo(parent,"openImage")
			.setLabel("Choose an image")
			.linebreak();
		
		nextY += nextHeight + UIDimen.MARGIN_UNIT;
		nextHeight = UIDimen.BTN_HEIGHT;
		loadPtsBtn = 
			controlP5.addButton("loadPtsBtn")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.plugTo(parent,"loadPts")
			.setLabel("Load points");

		// Display group
		nextY += nextHeight + UIDimen.GROUP_SEPARATION;
		nextHeight = 2 * UIDimen.BTN_HEIGHT + 3 * UIDimen.MARGIN_UNIT;
		Group displayGroup = 
			controlP5.addGroup("displayGroup")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.setLabel("Display mode")
			.setBackgroundColor(Colors.BG_950)
			.disableCollapse()
			;

		modeRadio = controlP5.addRadioButton("modeRadio")
			.setPosition(UIDimen.MARGIN_UNIT, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.BTN_HEIGHT, UIDimen.BTN_HEIGHT)
			.setItemsPerRow(3)
			.setSpacingColumn(90)
			.setSpacingRow(10)
			.addItem("Points (p)",Mode.POINTS)
			.addItem("Mesh (m)",Mode.MESH)
			.addItem("Contour (c)",Mode.CONTOUR)
			.addItem("Result (r)",Mode.RESULT)
			.activate(Mode.MESH)
			.plugTo(parent,"setMode")
			.setGroup(displayGroup)
			;


		// Display group
		nextY += nextHeight + UIDimen.GROUP_SEPARATION;
		nextHeight = UIDimen.BTN_HEIGHT + 2 * UIDimen.MARGIN_UNIT + UIDimen.LABEL_HEIGHT;
		Group eraserGroup = 
			controlP5.addGroup("eraserGroup")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.setLabel("Eraser")
			.setBackgroundColor(Colors.BG_950)
			.disableCollapse()
			;
	
		eraserToggle =
		controlP5.addToggle("eraserToggle")
			.plugTo(parent,"toggleEraser")
			.setPosition(UIDimen.MARGIN_UNIT, UIDimen.MARGIN_UNIT)
			.setSize(40, UIDimen.BTN_HEIGHT)
			.setLabel("On/off (e)")
			.setGroup(eraserGroup)
			;

		eraserSizeSlider = 
			controlP5.addSlider("eraserSizeSlider")
			.setPosition(eraserToggle.getPosition()[0] + eraserToggle.getWidth() + UIDimen.MARGIN_UNIT, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.SLIDER_WIDTH - eraserToggle.getWidth() - UIDimen.MARGIN_UNIT, UIDimen.BTN_HEIGHT)
			.setRange(minEraserSize,maxEraserSize)
			.setValue(eraserSize)
			.setLabel("Eraser size ([, ])")
			.plugTo(parent,"setEraserSize")
			.setGroup(eraserGroup)
			;
		
		// Point generation group
		nextY += nextHeight + UIDimen.GROUP_SEPARATION;
		nextHeight = 4 * UIDimen.BTN_HEIGHT + 5 * UIDimen.MARGIN_UNIT;
		Group generationGroup = 
			controlP5.addGroup("generationGroup")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.setLabel("Generate points")
			.setBackgroundColor(Colors.BG_950)
			.disableCollapse()
			;
		
		groupY = UIDimen.MARGIN_UNIT;
		groupHeight = UIDimen.BTN_HEIGHT;
		edgeWeightSlider = 
			controlP5.addSlider("edgeWeightSlider")
			.setPosition(UIDimen.MARGIN_UNIT, groupY)
			.setSize(UIDimen.SLIDER_WIDTH, groupHeight)
			.setRange(0,25)
			.setValue(1)
			.setLabel("Edge weight")
			.plugTo(parent,"setEdgeWeight")
			.setGroup(generationGroup)
			;
		
		groupY += groupHeight + UIDimen.MARGIN_UNIT;
		groupHeight = UIDimen.BTN_HEIGHT;
		edgeThresholdSlider = 
			controlP5.addSlider("edgeThresholdSlider")
			.setPosition(UIDimen.MARGIN_UNIT, groupY)
			.setSize(UIDimen.SLIDER_WIDTH, groupHeight)
			.setRange(0,254)
			.setValue(80)
			.setLabel("Edge threshold")
			.plugTo(parent,"setEdgeThreshold")
			.setGroup(generationGroup)
			;
		
		groupY += groupHeight + UIDimen.MARGIN_UNIT;
		groupHeight = UIDimen.BTN_HEIGHT;
		edgePtsSlider = 
			controlP5.addSlider("edgePtsSlider")
			.setPosition(UIDimen.MARGIN_UNIT, groupY)
			.setSize(UIDimen.SLIDER_WIDTH, groupHeight)
			.setRange(0,1000)
			.setValue(0)
			.setLabel("# of edge points")
			.plugTo(parent,"setEdgePts")
			.setGroup(generationGroup)
			;
	
		groupY += groupHeight + UIDimen.MARGIN_UNIT;
		groupHeight = UIDimen.BTN_HEIGHT;
		randomPtsSlider = 
			controlP5.addSlider("randomPtsSlider")
			.setPosition(UIDimen.MARGIN_UNIT, groupY)
			.setSize(UIDimen.SLIDER_WIDTH, groupHeight)
			.setRange(0,1000)
			.setValue(0)
			.setLabel("# of random points")
			.plugTo(parent,"setRandomPts")
			.setGroup(generationGroup)
			;

		// Export group

		// TODO Need to figure out how to make expand and collapse dynamic
		// nextY += generationGroup.isCollapse() ? generationGroup.getBarHeight() : generationGroup.getBackgroundHeight();
		// nextY += UIDimen.GROUP_SEPARATION;
		
		nextY += nextHeight + UIDimen.GROUP_SEPARATION;
		nextHeight = UIDimen.BTN_HEIGHT + 2 * UIDimen.MARGIN_UNIT;
		Group exportGroup = 
			controlP5.addGroup("exportGroup")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.setLabel("Export")
			.setBackgroundColor(Colors.BG_950)
			.disableCollapse()
			;

		Button saveSVGBtn = 
			controlP5.addButton("saveSVGBtn")
			.setPosition(UIDimen.MARGIN_UNIT, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.GROUP_COL_WIDTH_3, UIDimen.BTN_HEIGHT)
			.setLabel("SVG")
			.plugTo(parent,"saveSVG")
			.setGroup(exportGroup)
			;

		Button savePDFBtn = 
			controlP5.addButton("savePDFBtn")
			.setPosition(saveSVGBtn.getPosition()[0] + saveSVGBtn.getWidth() + UIDimen.MARGIN_UNIT/2, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.GROUP_COL_WIDTH_3,UIDimen.BTN_HEIGHT)
			.setLabel("PDF")
			.plugTo(parent,"savePDF")
			.setGroup(exportGroup)
			;
			 
		Button saveOBJBtn = 
			controlP5.addButton("saveOBJBtn")
			.setPosition(savePDFBtn.getPosition()[0] + savePDFBtn.getWidth() + UIDimen.MARGIN_UNIT/2, UIDimen.MARGIN_UNIT)
			.setSize(UIDimen.GROUP_COL_WIDTH_3,UIDimen.BTN_HEIGHT)
			.setLabel("OBJ")
			.plugTo(parent,"saveOBJ")
			.setGroup(exportGroup)
			;

		nextY += nextHeight + UIDimen.ELEMENT_SEPARATION;
		nextHeight = UIDimen.BTN_LARGE_HEIGHT;
		savePtsBtn = 
			controlP5.addButton("savePtsBtn")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.plugTo(parent,"savePts")
			.setLabel("Save points")
			;
		
		nextY += nextHeight + UIDimen.ELEMENT_SEPARATION;
		nextHeight = UIDimen.MESSAGE_BOX_HEIGHT;
		messageArea = 
			controlP5.addTextarea("messageArea")
			.setPosition(UIDimen.MARGIN_UNIT, nextY)
			.setSize(UIDimen.GROUP_WIDTH, nextHeight)
			.setLineHeight(14)
			.setColor(Colors.ON_BG)
			.setColorBackground(Colors.BG_950)
			.setBorderColor(Colors.BG_950)
			.setText("");

		resetMessageArea();
	}

	public void draw() {
		background(Colors.BG_900);
	}
	

	public ControlP5 control() {
		return controlP5;
	}

	// key presses within control panel
	void keyPressed() {
		if (key == CODED) {
			codedKeyPressed(keyCode);
		} else {
			globalKeyPressed(key);
		}
	}
}
