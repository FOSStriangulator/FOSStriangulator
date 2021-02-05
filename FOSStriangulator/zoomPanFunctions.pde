// TODO prevent from moving past image

final int PAN_CONST = 50;
final float ZOOM_PRECISION = 0.1;
final float MAX_ZOOM = 10.0;
final float MIN_ZOOM = 0.1;

void moveLeft() {
	originX += PAN_CONST;
}

void moveRight() {
	originX -= PAN_CONST;
}

void moveUp() {
	originY += PAN_CONST;
}

void moveDown() {
	originY -= PAN_CONST;
}

void resetView() {
	originX = 0;
	originY = 0;
	zoom = 1.0;
	resetMessageArea();
}

void zoomIn() {
	if (roundToPrecision(zoom, ZOOM_PRECISION) < MAX_ZOOM)
        zoom += 0.1;
	resetMessageArea();
}

void zoomOut() {
	if (roundToPrecision(zoom, ZOOM_PRECISION) > MIN_ZOOM)
        zoom -= 0.1;
	resetMessageArea();
}

float roundToPrecision(float number, float precision) {
	return round(number / precision) * precision;
}
