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

Class ExtMoviePlayer_Manager extends KFGFxMoviePlayer_Manager;

var ExtMenu_Gear EGearMenu;
var transient KFGUI_Page PerksPage;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local PlayerController PC;

	switch (WidgetName)
	{
	case 'gearMenu':
		PC = GetPC();
		if (PC.PlayerReplicationInfo.bReadyToPlay && PC.WorldInfo.GRI.bMatchHasBegun)
			return true;
		if (EGearMenu == none)
		{
			EGearMenu = ExtMenu_Gear(Widget);
			EGearMenu.InitializeMenu(self);
		}
		OnMenuOpen(WidgetPath, EGearMenu);
		return true;
	default:
		return Super.WidgetInitialized(WidgetName,WidgetPath,Widget);
	}
}

function LaunchMenus(optional bool bForceSkipLobby)
{
	local GFxWidgetBinding WidgetBinding;
	local bool bSkippedLobby;

	// Add either the in game party or out of game party widget
	WidgetBinding.WidgetName = 'partyWidget';
	bSkippedLobby = bForceSkipLobby || CheckSkipLobby();
	WidgetBinding.WidgetClass = class'ExtWidget_PartyInGame';
	ManagerObject.SetBool("backgroundVisible", false);
	ManagerObject.SetBool("IISMovieVisible", false);
	if (bSkippedLobby)
		CurrentBackgroundMovie.Stop();

	WidgetBindings.AddItem(WidgetBinding);

	// Load the platform-specific graphics options menu
	switch (class'KFGameEngine'.static.GetPlatform())
	{
		case PLATFORM_PC_DX10:
			WidgetBinding.WidgetName = 'optionsGraphicsMenu';
			WidgetBinding.WidgetClass = class'KFGFxOptionsMenu_Graphics_DX10';
			WidgetBindings.AddItem(WidgetBinding);
			break;
		default:
			WidgetBinding.WidgetName = 'optionsGraphicsMenu';
			WidgetBinding.WidgetClass = class'KFGFxOptionsMenu_Graphics';
			WidgetBindings.AddItem(WidgetBinding);
	}

	if (!bSkippedLobby)
	{
		LoadWidgets(WidgetPaths);
		OpenMenu(UI_Start);
		AllowCloseMenu();
	}

	// do this stuff in case CheckSkipLobby failed
	if (bForceSkipLobby)
	{
		bAfterLobby = true;
		CloseMenus(true);
	}
}

function OpenMenu(byte NewMenuIndex, optional bool bShowWidgets = true)
{
	local KF2GUIController GUIController;

	GUIController = class'KF2GUIController'.Static.GetGUIController(GetPC());

	Super.OpenMenu(NewMenuIndex, bShowWidgets);

	if (bAfterLobby)
		return;

	if (NewMenuIndex == UI_Perks)
	{
		PerksPage = GUIController.OpenMenu(class'ExtGUI_PerkSelectionPage');
		SetMovieCanReceiveInput(false);
		PerksMenu.ActionScriptVoid("closeContainer");
	}
	else GUIController.CloseMenu(class'ExtGUI_PerkSelectionPage');
}

function CloseMenus(optional bool bForceClose=false)
{
	local KF2GUIController GUIController;

	if (PerksPage != None)
	{
		GUIController = class'KF2GUIController'.Static.GetGUIController(GetPC());
		GUIController.CloseMenu(class'ExtGUI_PerkSelectionPage');
	}

	Super.CloseMenus(bForceClose);
}

function OnMenuOpen(name WidgetPath, KFGFxObject_Menu Widget)
{
	Super.OnMenuOpen(WidgetPath, Widget);

	if (!bAfterLobby && Widget == PerksMenu)
		PerksMenu.ActionScriptVoid("closeContainer");
}

event OnClose()
{
	// Fix:
	// ScriptWarning: Accessed None 'CurrentBackgroundMovie'
	// ExtMoviePlayer_Manager KF-BIOTICSLAB.TheWorld:PersistentLevel.ExtPlayerController_0.ExtMoviePlayer_Manager_0
	// Function KFGame.KFGFxMoviePlayer_Manager:OnClose:0039
	if (CurrentBackgroundMovie != None)
	{
		Super.OnClose();
	}
	else
	{
		CloseMenus();
	}
}

defaultproperties
{
	InGamePartyWidgetClass=class'ExtWidget_PartyInGame'

	WidgetPaths.Remove("../UI_Widgets/PartyWidget_SWF.swf")
	WidgetPaths.Add("../UI_Widgets/VersusLobbyWidget_SWF.swf")

	WidgetBindings.Remove((WidgetName="PerksMenu",WidgetClass=class'KFGFxMenu_Perks'))
	WidgetBindings.Add((WidgetName="PerksMenu",WidgetClass=class'ExtMenu_Perks'))
	WidgetBindings.Remove((WidgetName="gearMenu",WidgetClass=class'KFGFxMenu_Gear'))
	WidgetBindings.Add((WidgetName="gearMenu",WidgetClass=class'ExtMenu_Gear'))
	WidgetBindings.Remove((WidgetName="traderMenu",WidgetClass=class'KFGFxMenu_Trader'))
	WidgetBindings.Add((WidgetName="traderMenu",WidgetClass=class'ExtMenu_Trader'))
	//WidgetBindings.Remove((WidgetName="inventoryMenu",WidgetClass=class'KFGFxMenu_Inventory'))
	//WidgetBindings.Add((WidgetName="inventoryMenu",WidgetClass=class'ExtMenu_Inventory'))
}