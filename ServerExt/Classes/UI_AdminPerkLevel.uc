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

Class UI_AdminPerkLevel extends KFGUI_FloatingWindow;

var KFGUI_NumericBox LevelBox;
var int PlayerID,BaseValue;
var KFGUI_Button YesButton;
var KFGUI_Button NoButton;

var localized string WindowTitleSetLevel;
var localized string WindowTitleSetPrestigeLevel;
var localized string WindowTitleSetLevelOf;
var localized string WindowTitleSetPrestigeLevelOf;
var localized string YesButtonText;
var localized string YesButtonToolTip;
var localized string NoButtonText;
var localized string NoButtonToolTip;
var localized string LevelBoxToolTip;

function InitMenu()
{
	Super.InitMenu();

	LevelBox = KFGUI_NumericBox(FindComponentID('Edit'));
	YesButton = KFGUI_Button(FindComponentID('Yes'));
	NoButton = KFGUI_Button(FindComponentID('No'));

	YesButton.ButtonText=YesButtonText;
	YesButton.Tooltip=YesButtonToolTip;
	NoButton.ButtonText=NoButtonText;
	NoButton.Tooltip=NoButtonToolTip;
	LevelBox.Tooltip=LevelBoxToolTip;
}

final function InitPage(int UserID, byte Mode)
{
	local PlayerReplicationInfo PRI;

	PlayerID = UserID;

	// Find matching player by ID
	foreach GetPlayer().WorldInfo.GRI.PRIArray(PRI)
	{
		if (PRI.PlayerID==UserID)
			break;
	}
	if (ExtPlayerReplicationInfo(PRI)==None)
	{
		WindowTitle = Mode==1 ? WindowTitleSetLevel : WindowTitleSetPrestigeLevel;
		return;
	}
	WindowTitle = (Mode==1 ? WindowTitleSetLevelOf : WindowTitleSetPrestigeLevelOf)$" "$PRI.GetHumanReadableName();
	LevelBox.ChangeValue(string(Mode==1 ? ExtPlayerReplicationInfo(PRI).ECurrentPerkLevel : ExtPlayerReplicationInfo(PRI).ECurrentPerkPrestige));
	BaseValue = (Mode==1 ? 100 : 100000);
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Yes':
		ExtPlayerController(GetPlayer()).AdminRPGHandle(PlayerID,BaseValue+LevelBox.GetValueInt());
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
	YPosition=0.4
	XSize=0.4
	YSize=0.15
	bAlwaysTop=true
	bOnlyThisFocus=true

	Begin Object Class=KFGUI_Button Name=YesButten
		ID="Yes"
		XPosition=0.4
		YPosition=0.5
		XSize=0.09
		YSize=0.4
		ExtravDir=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=NoButten
		ID="No"
		XPosition=0.5
		YPosition=0.5
		XSize=0.09
		YSize=0.4
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_NumericBox Name=EditBox
		ID="Edit"
		XPosition=0.05
		YPosition=0.2
		XSize=0.9
		YSize=0.3
		MaxValue=99999
	End Object

	Components.Add(YesButten)
	Components.Add(NoButten)
	Components.Add(EditBox)
}