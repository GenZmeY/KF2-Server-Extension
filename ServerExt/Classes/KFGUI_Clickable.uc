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

Class KFGUI_Clickable extends KFGUI_Base
	abstract;

var() int IntIndex; // More user variables.
var() string ToolTip;

var KFGUI_Tooltip ToolTipItem;

var byte PressedDown[2];
var bool bPressedDown;

function InitMenu()
{
	Super.InitMenu();
	bClickable = !bDisabled;
}

function MouseClick(bool bRight)
{
	if (!bDisabled)
	{
		PressedDown[byte(bRight)] = 1;
		bPressedDown = true;
	}
}

function MouseRelease(bool bRight)
{
	if (!bDisabled && PressedDown[byte(bRight)]==1)
	{
		PressedDown[byte(bRight)] = 0;
		bPressedDown = (PressedDown[0]!=0 || PressedDown[1]!=0);
		HandleMouseClick(bRight);
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	if (!bDisabled)
		PlayMenuSound(MN_LostFocus);
	PressedDown[0] = 0;
	PressedDown[1] = 0;
	bPressedDown = false;
}

function MouseEnter()
{
	Super.MouseEnter();
	if (!bDisabled)
		PlayMenuSound(MN_Focus);
}

function SetDisabled(bool bDisable)
{
	Super.SetDisabled(bDisable);
	bClickable = !bDisable;
	PressedDown[0] = 0;
	PressedDown[1] = 0;
	bPressedDown = false;
}

function NotifyMousePaused()
{
	if (Owner.InputFocus==None && ToolTip!="")
	{
		if (ToolTipItem==None)
		{
			ToolTipItem = New(None)Class'KFGUI_Tooltip';
			ToolTipItem.Owner = Owner;
			ToolTipItem.ParentComponent = Self;
			ToolTipItem.InitMenu();
			ToolTipItem.SetText(ToolTip);
		}
		ToolTipItem.ShowMenu();
		ToolTipItem.CompPos[0] = Owner.MousePosition.X;
		ToolTipItem.CompPos[1] = Owner.MousePosition.Y;
		ToolTipItem.GetInputFocus();
	}
}

final function ChangeToolTip(string S)
{
	if (ToolTipItem!=None)
		ToolTipItem.SetText(S);
	else ToolTip = S;
}

function HandleMouseClick(bool bRight);

defaultproperties
{

}