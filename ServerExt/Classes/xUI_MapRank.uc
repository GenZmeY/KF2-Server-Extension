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

Class xUI_MapRank extends KFGUI_Page;

var xVotingReplication RepInfo;

var KFGUI_TextLable InfoLabel;
var KFGUI_Button YesButton;
var KFGUI_Button NoButton;

var localized string InfoText;
var localized string YesButtonText;
var localized string YesButtonToolTip;
var localized string NoButtonText;
var localized string NoButtonToolTip;

function InitMenu()
{
	Super.InitMenu();

	YesButton = KFGUI_Button(FindComponentID('Yes'));
	NoButton = KFGUI_Button(FindComponentID('No'));
	InfoLabel = KFGUI_TextLable(FindComponentID('Info'));

	InfoLabel.SetText(InfoText);
	YesButton.ButtonText=YesButtonText;
	YesButton.ToolTip=YesButtonToolTip;
	NoButton.ButtonText=NoButtonText;
	NoButton.ToolTip=NoButtonToolTip;
}

function CloseMenu()
{
	Super.CloseMenu();
	RepInfo = None;
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Yes':
		RepInfo.ServerRankMap(true);
		DoClose();
		break;
	case 'No':
		RepInfo.ServerRankMap(false);
		DoClose();
		break;
	}
}

defaultproperties
{
	bPersistant=false
	bAlwaysTop=true
	bOnlyThisFocus=true
	XPosition=0.35
	YPosition=0.4
	XSize=0.3
	YSize=0.2

	Begin Object Class=KFGUI_TextLable Name=InfoLabel
		ID="Info"
		XPosition=0.1
		YPosition=0.15
		XSize=0.8
		YSize=0.35
		AlignX=1
		AlignY=1
	End Object
	Begin Object Class=KFGUI_Button Name=YesButton
		XPosition=0.3
		YPosition=0.5
		XSize=0.2
		YSize=0.3
		ID="Yes"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		ExtravDir=1
		TextColor=(R=128,G=255,B=128,A=255)
	End Object
	Begin Object Class=KFGUI_Button Name=NoButton
		XPosition=0.5
		YPosition=0.5
		XSize=0.2
		YSize=0.3
		ID="No"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255,G=128,B=128,A=255)
	End Object

	Components.Add(InfoLabel)
	Components.Add(YesButton)
	Components.Add(NoButton)
}