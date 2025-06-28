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

Class KFGUI_FloatingWindow extends KFGUI_Page
	abstract;

var() string WindowTitle; // Title of this window.
var float DragOffset[2];
var KFGUI_FloatingWindowHeader HeaderComp;
var bool bDragWindow;

function InitMenu()
{
	Super.InitMenu();
	HeaderComp = new (Self) class'KFGUI_FloatingWindowHeader';
	AddComponent(HeaderComp);
}

function DrawMenu()
{
	Owner.CurrentStyle.RenderFramedWindow(Self);

	if (HeaderComp!=None)
	{
		HeaderComp.CompPos[3] = Owner.CurrentStyle.DefaultHeight;
		HeaderComp.YSize = HeaderComp.CompPos[3] / CompPos[3]; // Keep header height fit the window height.
	}
}

function SetWindowDrag(bool bDrag)
{
	bDragWindow = bDrag;
	if (bDrag)
	{
		DragOffset[0] = Owner.MousePosition.X-CompPos[0];
		DragOffset[1] = Owner.MousePosition.Y-CompPos[1];
	}
}

function bool CaptureMouse()
{
	if (bDragWindow && HeaderComp!=None) // Always keep focus on window frame now!
	{
		MouseArea = HeaderComp;
		return true;
	}
	return Super.CaptureMouse();
}

function PreDraw()
{
	if (bDragWindow)
	{
		XPosition = FClamp(Owner.MousePosition.X-DragOffset[0],0,InputPos[2]-CompPos[2]) / InputPos[2];
		YPosition = FClamp(Owner.MousePosition.Y-DragOffset[1],0,InputPos[3]-CompPos[3]) / InputPos[3];
	}
	Super.PreDraw();
}

defaultproperties
{

}