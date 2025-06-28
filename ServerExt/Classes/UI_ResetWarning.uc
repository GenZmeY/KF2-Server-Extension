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

Class UI_ResetWarning extends KFGUI_FloatingWindow;

var KFGUI_TextField InfoLabel;
var KFGUI_Button YesButton, NoButton;
var class<Ext_PerkBase> PerkToReset;
var bool bIsPrestige;

var localized string TitleText;
var localized string YesButtonText;
var localized string YesButtonToolTip;
var localized string NoButtonText;
var localized string NobuttonToolTip;
var localized string InfoText;

function InitMenu()
{
	InfoLabel = KFGUI_TextField(FindComponentID('Info'));
	YesButton = KFGUI_Button(FindComponentID('Yes'));
	NoButton = KFGUI_Button(FindComponentID('No'));

	YesButton.ButtonText=YesButtonText;
	YesButton.Tooltip=YesButtonToolTip;
	NoButton.ButtonText=NoButtonText;
	NoButton.Tooltip=NobuttonToolTip;
	InfoLabel.SetText(InfoText);

	Super.InitMenu();
}

function SetupTo(Ext_PerkBase P)
{
	PerkToReset = P.Class;
	WindowTitle = TitleText$" "$P.PerkName;
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Yes':
		ExtPlayerController(GetPlayer()).ServerResetPerk(PerkToReset,bIsPrestige);
		PerkToReset = None;
		DoClose();
		break;
	case 'No':
		DoClose();
		break;
	}
}

defaultproperties
{
	XPosition=0.35
	YPosition=0.2
	XSize=0.3
	YSize=0.45
	bAlwaysTop=true
	bOnlyThisFocus=true

	Begin Object Class=KFGUI_TextField Name=WarningLabel
		ID="Info"
		XPosition=0.01
		YPosition=0.12
		XSize=0.98
		YSize=0.775
	End Object
	Begin Object Class=KFGUI_Button Name=YesButten
		ID="Yes"
		XPosition=0.2
		YPosition=0.9
		XSize=0.29
		YSize=0.07
		ExtravDir=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=NoButten
		ID="No"
		XPosition=0.5
		YPosition=0.9
		XSize=0.29
		YSize=0.07
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object

	Components.Add(WarningLabel)
	Components.Add(YesButten)
	Components.Add(NoButten)
}