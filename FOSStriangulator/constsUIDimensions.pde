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

interface UIDimen {
	final int
	INIT_SIDEBAR_X = 0,
	INIT_SIDEBAR_Y = 0,
	SIDEBAR_WIDTH = 360,
	SIDEBAR_HEIGHT = 680,
	MARGIN_UNIT = 8,
	GROUP_SEPARATION = MARGIN_UNIT * 3,
	ELEMENT_SEPARATION = MARGIN_UNIT * 2,
	GROUP_WIDTH = SIDEBAR_WIDTH - 2 * MARGIN_UNIT,
	GROUP_COL_WIDTH_3 = GROUP_WIDTH / 3 - MARGIN_UNIT,
	LABEL_HEIGHT = 12,
	BTN_HEIGHT = 20,
	BTN_LARGE_HEIGHT = 32,
	MESSAGE_BOX_HEIGHT = 64,
	SLIDER_WIDTH = GROUP_WIDTH / 3 * 2 - MARGIN_UNIT; //90 + 90 + 25;
}