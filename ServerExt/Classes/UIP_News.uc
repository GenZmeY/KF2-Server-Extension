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

Class UIP_News extends KFGUI_MultiComponent;

var KFGUI_TextField NewsField;
var string WebsiteURL;
var KFGUI_Button WebsiteButton;

var localized string WebSiteButtonText;
var localized string WebsiteButtonToolTip;

function InitMenu()
{
	Super.InitMenu();

	// Client settings
	NewsField = KFGUI_TextField(FindComponentID('News'));
	WebsiteButton = KFGUI_Button(FindComponentID('Website'));

	WebsiteButton.ButtonText=WebSiteButtonText;

	Timer();
}

function ShowMenu()
{
	local KFGameReplicationInfo GRI;

	Super.ShowMenu();
	GRI = KFGameReplicationInfo(GetPlayer().WorldInfo.GRI);
	WebsiteButton.SetDisabled(GRI==None || GRI.ServerAdInfo.WebsiteLink=="");
	if (!WebsiteButton.bDisabled)
	{
		WebsiteURL = GRI.ServerAdInfo.WebsiteLink;
		WebsiteButton.ChangeToolTip(WebsiteButtonToolTip$" "$WebsiteURL);
	}
}

function Timer()
{
	if (!ExtPlayerController(GetPlayer()).bMOTDReceived)
		SetTimer(0.2,false);
	else NewsField.SetText(ExtPlayerController(GetPlayer()).ServerMOTD);
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Website':
		class'GameEngine'.static.GetOnlineSubsystem().OpenURL(WebsiteURL);
		break;
	}
}

defaultproperties
{
	Begin Object Class=KFGUI_TextField Name=NewsText
		ID="News"
		XPosition=0.025
		YPosition=0.025
		XSize=0.95
		YSize=0.893
	End Object
	Begin Object Class=KFGUI_Button Name=WebSiteButton
		ID="Website"
		XPosition=0.44
		YPosition=0.92
		XSize=0.12
		YSize=0.06
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object

	Components.Add(NewsText)
	Components.Add(WebSiteButton)
}