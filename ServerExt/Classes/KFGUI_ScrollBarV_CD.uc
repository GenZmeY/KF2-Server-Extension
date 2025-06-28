// This file is part of Server Extension.
// Server Extension - a mutator for Killing Floor 2.
//
// Copyright (C) 2016-2024 The Server Extension authors and contributors
//
// Server Extension is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Server Extension is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Server Extension. If not, see <https://www.gnu.org/licenses/>.

Class KFGUI_ScrollBarV_CD extends KFGUI_ScrollBarV;

function DrawMenu()
{
	local float A;
	local byte i;

	if (bDisabled)
		Canvas.SetDrawColor(5, 5, 5, 0);
	else if (bFocused || bGrabbedScroller)
		Canvas.SetDrawColor(30, 30, 30, 160);
	else Canvas.SetDrawColor(30, 30, 30, 160);

	Owner.CurrentStyle.DrawRectBox (0.f, 0.f, CompPos[2], CompPos[3], 4);

	if (bDisabled)
		return;

	if (bVertical)
		i = 3;
	else i = 2;

	SliderScale = FMax(PageStep * (CompPos[i] - 32.f) / (MaxRange + PageStep),CalcButtonScale);

	if (bGrabbedScroller)
	{
		// Track mouse.
		if (bVertical)
			A = Owner.MousePosition.Y - CompPos[1] - GrabbedOffset;
		else A = Owner.MousePosition.X - CompPos[0] - GrabbedOffset;

		A /= ((CompPos[i]-SliderScale) / float(MaxRange));
		SetValue(A);
	}

	A = float(CurrentScroll) / float(MaxRange);
	ButtonOffset = A*(CompPos[i]-SliderScale);

	if (bGrabbedScroller)
		Canvas.SetDrawColor(90,90,90,255);
	else if (bFocused)
		Canvas.SetDrawColor(65,65,65,255);
	else Canvas.SetDrawColor(40,40,40,255);

	if (bVertical)
		Owner.CurrentStyle.DrawRectBox (0.f, ButtonOffset, CompPos[2], SliderScale, 4);
	else Owner.CurrentStyle.DrawRectBox (ButtonOffset, 0.f, SliderScale, CompPos[3], 4);
}

defaultproperties
{

}