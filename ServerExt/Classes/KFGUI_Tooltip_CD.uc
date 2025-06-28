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

Class KFGUI_Tooltip_CD extends KFGUI_Tooltip;

function PreDraw()
{
	local int i;
	local float X,Y,XS,YS,TX,TY,TS;

	if (Owner.CurrentStyle == None)
		return;

	Canvas.Font = Owner.CurrentStyle.PickFont(Owner.CurrentStyle.DefaultFontSize,TS);

	// First compute textbox size.
	TY = Owner.CurrentStyle.DefaultHeight*Lines.Length;
	for (i=0; i<Lines.Length; ++i)
	{
		if (Lines[i]!="")
			Canvas.TextSize(Lines[i],XS,YS);
		TX = FMax(XS,TX);
	}
	TX*=TS;

	// Give some borders.
	TX += KF2Style(Owner.CurrentStyle).TOOLTIP_BORDER*2;
	TY += KF2Style(Owner.CurrentStyle).TOOLTIP_BORDER*2;

	X = CompPos[0];
	Y = CompPos[1]+24.f;

	// Then check if too close to window edge, then move it to another pivot.
	if ((X+TX)>Owner.ScreenSize.X)
		X = Owner.ScreenSize.X-TX;
	if ((Y+TY)>Owner.ScreenSize.Y)
		Y = CompPos[1]-TY;

	if (CurrentAlpha<255)
		CurrentAlpha = Min(CurrentAlpha+25,255);

	// Reset clipping.
	Canvas.SetOrigin(0,0);
	Canvas.SetClip(Owner.ScreenSize.X,Owner.ScreenSize.Y);

	// Draw frame.
	//Canvas.SetDrawColor(200,200,80,CurrentAlpha);
	Canvas.SetDrawColor(45, 45, 45, 160);
	Canvas.SetPos(X-2,Y-2);
	Owner.CurrentStyle.DrawWhiteBox(TX+4,TY+4);
	//Canvas.SetDrawColor(80,10,80,CurrentAlpha);
	Canvas.SetDrawColor(10, 10, 10, 160);
	Canvas.SetPos(X,Y);
	Owner.CurrentStyle.DrawWhiteBox(TX,TY);

	// Draw text.
	Canvas.SetDrawColor(255,255,255,CurrentAlpha);
	X+=KF2Style(Owner.CurrentStyle).TOOLTIP_BORDER;
	Y+=KF2Style(Owner.CurrentStyle).TOOLTIP_BORDER;
	for (i=0; i<Lines.Length; ++i)
	{
		Canvas.SetPos(X,Y);
		Canvas.DrawText(Lines[i],,TS,TS,TextFontInfo);
		Y+=Owner.CurrentStyle.DefaultHeight;
	}
}

defaultproperties
{

}