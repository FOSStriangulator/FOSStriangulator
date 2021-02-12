// TODO prevent from moving past image

final int PAN_CONST = 50;
final float ZOOM_PRECISION = 0.1;
final float MAX_ZOOM = 10.0;
final float MIN_ZOOM = 0.1;

void moveLeft(float steps) {
	originX += PAN_CONST * steps;
}

void moveRight(float steps) {
	originX -= PAN_CONST * steps;
}

void moveUp(float steps) {
	originY += PAN_CONST * steps;
}

void moveDown(float steps) {
	originY -= PAN_CONST * steps;
}

void resetView() {
	originX = 0;
	originY = 0;
	zoom = 1.0;
	resetMessageArea();
}

void zoomIn(float steps) {
	float newZoom = roundToPrecision(zoom + 0.1 * steps, ZOOM_PRECISION);
	if (newZoom <= MAX_ZOOM) {
        zoom = newZoom;
		resetMessageArea();
	}
}

void zoomOut(float steps) {
	float newZoom = roundToPrecision(zoom - 0.1 * steps, ZOOM_PRECISION);
	if (newZoom >= MIN_ZOOM) {
        zoom = newZoom;
		resetMessageArea();
	}
}

float roundToPrecision(float number, float precision) {
	return round(number / precision) * precision;
}