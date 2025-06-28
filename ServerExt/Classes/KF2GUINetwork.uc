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

Class KF2GUINetwork extends ReplicationInfo
	NotPlaceable;

var PlayerController PlayerOwner;
var transient KF2GUIController GUIController;

var bool bLocalClient;

static function OpenMenuForClient(PlayerController PC, class<KFGUI_Page> Page)
{
	local KF2GUINetwork G;

	foreach PC.ChildActors(class'KF2GUINetwork',G)
		break;
	if (G==None)
		G = PC.Spawn(class'KF2GUINetwork',PC);
	G.ClientOpenMenu(Page);
}

static function CloseMenuForClient(PlayerController PC, class<KFGUI_Page> Page, optional bool bCloseAll)
{
	local KF2GUINetwork G;

	foreach PC.ChildActors(class'KF2GUINetwork',G)
		break;
	if (G==None)
		G = PC.Spawn(class'KF2GUINetwork',PC);
	G.ClientCloseMenu(Page,bCloseAll);
}

simulated reliable client function ClientOpenMenu(class<KFGUI_Page> Page)
{
	if (!bLocalClient)
		return;
	if (GUIController==None)
		GUIController = Class'KF2GUIController'.Static.GetGUIController(PlayerOwner);
	GUIController.OpenMenu(Page);
}

simulated reliable client function ClientCloseMenu(class<KFGUI_Page> Page, bool bCloseAll)
{
	if (!bLocalClient)
		return;
	if (GUIController==None)
		GUIController = Class'KF2GUIController'.Static.GetGUIController(PlayerOwner);
	GUIController.CloseMenu(Page,bCloseAll);
}

simulated function PostBeginPlay()
{
	PlayerOwner = PlayerController(Owner);
	if (WorldInfo.NetMode==NM_Client || (PlayerOwner!=None && LocalPlayer(PlayerOwner.Player)!=None))
	{
		bLocalClient = true;
		if (PlayerOwner==None)
			PlayerOwner = GetALocalPlayerController();
	}
}

defaultproperties
{
	bAlwaysRelevant=false
	bOnlyRelevantToOwner=true
}