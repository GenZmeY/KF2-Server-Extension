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

// A component to have multiple "pages" of different components.
Class KFGUI_SwitchComponent extends KFGUI_MultiComponent;

var protected int CurrentComponent;

function PreDraw()
{
	local byte j;

	ComputeCoords();
	if (CurrentComponent<0 || CurrentComponent>=Components.Length)
		return;
	Components[CurrentComponent].Canvas = Canvas;
	for (j=0; j<4; ++j)
		Components[CurrentComponent].InputPos[j] = CompPos[j];
	Components[CurrentComponent].PreDraw();
}

function bool CaptureMouse()
{
	if ((CurrentComponent>=0 || CurrentComponent<Components.Length) && Components[CurrentComponent].CaptureMouse())
	{
		MouseArea = Components[CurrentComponent];
		return true;
	}
	MouseArea = None;
	return Super(KFGUI_Base).CaptureMouse(); // check with frame itself.
}

final function int GetSelectedPage()
{
	return CurrentComponent;
}

final function name GetSelectedPageID()
{
	if (CurrentComponent<Components.Length)
		return Components[CurrentComponent].ID;
	return '';
}

final function bool SelectPageID(name PageID)
{
	local int i;

	if (Components[CurrentComponent].ID==PageID)
		return false;

	for (i=0; i<Components.Length; ++i)
		if (Components[i].ID==PageID)
		{
			Components[CurrentComponent].CloseMenu();
			CurrentComponent = i;
			Components[CurrentComponent].ShowMenu();
			return true;
		}
	return false;
}

final function bool SelectPageIndex(int Num)
{
	if (CurrentComponent==Num)
		return false;

	if (Num>=0 && Num<Components.Length)
	{
		Components[CurrentComponent].CloseMenu();
		CurrentComponent = Num;
		Components[CurrentComponent].ShowMenu();
		return true;
	}
	return false;
}

function ShowMenu()
{
	if (CurrentComponent<Components.Length)
		Components[CurrentComponent].ShowMenu();
}

function CloseMenu()
{
	if (CurrentComponent<Components.Length)
		Components[CurrentComponent].CloseMenu();
}