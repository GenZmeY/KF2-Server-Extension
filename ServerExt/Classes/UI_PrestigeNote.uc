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

Class UI_PrestigeNote extends UI_ResetWarning;

var localized string WindowTitleText;
var localized string PrestigeButtonToolTip;
var localized string InfoLabelTextPart1;
var localized string InfoLabelTextPart2;

function InitMenu()
{
	Super.InitMenu();
	YesButton.ToolTip=PrestigeButtonToolTip;
}

function SetupTo(Ext_PerkBase P)
{
	PerkToReset = P.Class;
	WindowTitle = WindowTitleText$" "$P.PerkName;
	InfoLabel.SetText(InfoLabelTextPart1$P.PrestigeSPIncrease$InfoLabelTextPart2);
}

defaultproperties
{
	bIsPrestige=true

	Begin Object Name=YesButten
	End Object
}