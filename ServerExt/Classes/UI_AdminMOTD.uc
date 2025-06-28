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

Class UI_AdminMOTD extends KFGUI_FloatingWindow;

var KFGUI_TextField NewsField;
var KFGUI_EditBox EditField;
var KFGUI_Button YesButton;
var KFGUI_Button NoButton;

var localized string WindowTitleText;
var localized string YesButtonText;
var localized string YesButtonToolTip;
var localized string NoButtonText;
var localized string NoButtonToolTip;
var localized string EditBoxToolTip;
var localized string MotdPreviewText;

function InitMenu()
{
	Super.InitMenu();

	// Client settings
	NewsField = KFGUI_TextField(FindComponentID('News'));
	EditField = KFGUI_EditBox(FindComponentID('Edit'));
	YesButton = KFGUI_Button(FindComponentID('Yes'));
	NoButton = KFGUI_Button(FindComponentID('No'));

	WindowTitle = WindowTitleText;
	EditField.ToolTip=EditBoxToolTip;
	YesButton.ButtonText=YesButtonText;
	YesButton.Tooltip=YesButtonToolTip;
	NoButton.ButtonText=NoButtonText;
	NoButton.Tooltip=NoButtonToolTip;

	Timer();
}

function Timer()
{
	if (!ExtPlayerController(GetPlayer()).bMOTDReceived)
		SetTimer(0.2,false);
	else
	{
		EditField.Value = ExtPlayerController(GetPlayer()).ServerMOTD;
		MOTDEdited(EditField);
	}
}

function ButtonClicked(KFGUI_Button Sender)
{
	local string S;

	switch (Sender.ID)
	{
	case 'Yes':
		S = EditField.Value;
		while (Len(S)>510)
		{
			ExtPlayerController(GetPlayer()).ServerSetMOTD(Left(S,500),false);
			S = Mid(S,500);
		}
		ExtPlayerController(GetPlayer()).ServerSetMOTD(S,true);
		DoClose();
		break;
	case 'No':
		DoClose();
		break;
	}
}

function MOTDEdited(KFGUI_EditBox Sender)
{
	NewsField.SetText(MotdPreviewText$"|"$Sender.Value);
}

defaultproperties
{
	XPosition=0.25
	YPosition=0.2
	XSize=0.5
	YSize=0.6
	bAlwaysTop=true
	bOnlyThisFocus=true

	Begin Object Class=KFGUI_TextField Name=WarningLabel
		ID="News"
		XPosition=0.01
		YPosition=0.18
		XSize=0.98
		YSize=0.77
	End Object
	Begin Object Class=KFGUI_Button Name=YesButten
		ID="Yes"
		XPosition=0.4
		YPosition=0.9
		XSize=0.09
		YSize=0.04
		ExtravDir=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=NoButten
		ID="No"
		XPosition=0.5
		YPosition=0.9
		XSize=0.09
		YSize=0.04
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_EditBox Name=EditBox
		ID="Edit"
		XPosition=0.05
		YPosition=0.09
		XSize=0.9
		YSize=0.08
		OnTextChange=MOTDEdited
	End Object

	Components.Add(WarningLabel)
	Components.Add(YesButten)
	Components.Add(NoButten)
	Components.Add(EditBox)
}