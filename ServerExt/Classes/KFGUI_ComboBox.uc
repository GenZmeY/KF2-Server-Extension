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

Class KFGUI_ComboBox extends KFGUI_EditControl;

var KFGUI_ComboSelector Selection;

var float BorderSize;
var() array<string> Values;
var() int SelectedIndex;
var() color SelectedTextColor,TextColor;
var() bool bButtonStretched;

function UpdateSizes()
{
	// Update height.
	if (bScaleByFontSize)
		YSize = (TextHeight + (BorderSize*2)) / InputPos[3];
}

function DrawMenu()
{
	Owner.CurrentStyle.RenderComboBox(Self);
}

function HandleMouseClick(bool bRight)
{
	PlayMenuSound(MN_Dropdown);
	if (Selection==None)
	{
		Selection = New(None)Class'KFGUI_ComboSelector';
		Selection.Owner = Owner;
		Selection.Combo = Self;
		Selection.InitMenu();
	}
	Selection.XPosition = CompPos[0] / Owner.ScreenSize.X;
	Selection.YPosition = (CompPos[1]+CompPos[3]) / Owner.ScreenSize.Y;
	Selection.XSize = CompPos[2] / Owner.ScreenSize.X;
	Selection.YSize = (TextHeight / Owner.ScreenSize.Y) * Values.Length + ((BorderSize*2) / Owner.ScreenSize.Y);
	if ((Selection.YPosition+Selection.YSize)>1.f)
		Selection.YPosition-=((Selection.YPosition+Selection.YSize)-1.f);
	Selection.GetInputFocus();
}

final function string GetCurrent()
{
	if (SelectedIndex<Values.Length)
		return Values[SelectedIndex];
	return "";
}

final function bool SetValue(string S)
{
	local int i;

	i = Values.Find(S);
	if (i==-1)
		return false;
	SelectedIndex = i;
	return true;
}

Delegate OnComboChanged(KFGUI_ComboBox Sender);

defaultproperties
{
	SelectedTextColor=(R=255,G=128,B=128,A=255)
	TextColor=(R=255,G=255,B=255,A=255)
	BorderSize=4
}