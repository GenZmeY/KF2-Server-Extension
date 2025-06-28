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

Class UI_UnloadInfo extends KFGUI_FloatingWindow;

var class<Ext_PerkBase> PerkToReset;
var KFGUI_Button UnloadPerkYesButton, UnloadPerkNoButton;
var KFGUI_TextField InfoLabel;
var byte CurCallCode;

var localized string ResetPerkNotice;
var localized string PleaseWait;
var localized string ResetDisabledWarn;
var localized string ResetMinLevelWarnPart1;
var localized string ResetMinLevelWarnPart2;
var localized string ResetAttentionPart1;
var localized string ResetAttentionPart2;
var localized string ResetAttentionPart3;

var localized string ButtonYesText;
var localized string ButtonNoText;
var localized string ButtonYesToolTip;
var localized string ButtonNoToolTip;

function InitMenu()
{
	UnloadPerkYesButton = KFGUI_Button(FindComponentID('Yes'));
	UnloadPerkNoButton = KFGUI_Button(FindComponentID('No'));

	UnloadPerkYesButton.ButtonText=ButtonYesText;
	UnloadPerkNoButton.ButtonText=ButtonNoText;
	UnloadPerkYesButton.ToolTip=ButtonYesToolTip;
	UnloadPerkNoButton.ToolTip=ButtonNoToolTip;

	InfoLabel = KFGUI_TextField(FindComponentID('Info'));
	Super.InitMenu();
}

final function SetupTo(class<Ext_PerkBase> P)
{
	PerkToReset = P;
	WindowTitle = ResetPerkNotice$" "$P.Default.PerkName;
	UnloadPerkYesButton.SetDisabled(true);
	InfoLabel.SetText(PleaseWait);
	++CurCallCode;
	ExtPlayerController(GetPlayer()).OnClientGetResponse = ReceivedInfo;
	ExtPlayerController(GetPlayer()).ServerGetUnloadInfo(CurCallCode,PerkToReset,false);
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Yes':
		ExtPlayerController(GetPlayer()).ServerGetUnloadInfo(0,PerkToReset,true);
		DoClose();
		break;
	case 'No':
		DoClose();
		break;
	}
}

function CloseMenu()
{
	Super.CloseMenu();
	PerkToReset = None;
	ExtPlayerController(GetPlayer()).OnClientGetResponse = ExtPlayerController(GetPlayer()).DefClientResponse;
}

function ReceivedInfo(byte CallID, byte Code, int DataA, int DataB)
{
	if (CurCallCode!=CallID)
		return;

	switch (Code)
	{
	case 0:
		InfoLabel.SetText(ResetDisabledWarn);
		break;
	case 1:
		InfoLabel.SetText(ResetMinLevelWarnPart1$DataA$ResetMinLevelWarnPart2);
		break;
	case 2:
		InfoLabel.SetText(ResetAttentionPart1$DataA$ResetAttentionPart2$DataB$ResetAttentionPart3);
		UnloadPerkYesButton.SetDisabled(false);
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

	Begin Object Class=KFGUI_Button Name=UnloadPerkYesButton
		ID="Yes"
		XPosition=0.2
		YPosition=0.9
		XSize=0.29
		YSize=0.07
		ExtravDir=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=UnloadPerkNoButton
		ID="No"
		XPosition=0.5
		YPosition=0.9
		XSize=0.29
		YSize=0.07
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object

	Components.Add(WarningLabel)
	Components.Add(UnloadPerkYesButton)
	Components.Add(UnloadPerkNoButton)
}