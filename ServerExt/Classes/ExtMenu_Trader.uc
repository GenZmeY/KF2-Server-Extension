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

class ExtMenu_Trader extends KFGFxMenu_Trader;

var ExtPlayerController ExtKFPC;
var Ext_PerkBase ExLastPerkClass;

function InitializeMenu(KFGFxMoviePlayer_Manager InManager)
{
	Super.InitializeMenu(InManager);
	ExtKFPC = ExtPlayerController (GetPC());
}

function int GetPerkIndex()
{
	return (ExtKFPC.ActivePerkManager!=None ? Max(ExtKFPC.ActivePerkManager.UserPerks.Find(ExtKFPC.ActivePerkManager.CurrentPerk),0) : 0);
}

function UpdatePlayerInfo()
{
	if (ExtKFPC != none && PlayerInfoContainer != none)
	{
		PlayerInfoContainer.SetPerkInfo();
		PlayerInfoContainer.SetPerkList();
		if (ExtKFPC.ActivePerkManager!=None && ExtKFPC.ActivePerkManager.CurrentPerk!=ExLastPerkClass)
		{
			ExLastPerkClass = ExtKFPC.ActivePerkManager.CurrentPerk;
			OnPerkChanged(GetPerkIndex());
		}

		RefreshItemComponents();
	}
}

function Callback_PerkChanged(int PerkIndex)
{
	ExtKFPC.PendingPerkClass = ExtKFPC.ActivePerkManager.UserPerks[PerkIndex].Class;
	ExtKFPC.SwitchToPerk(ExtKFPC.PendingPerkClass);

	if (PlayerInventoryContainer != none)
	{
		PlayerInventoryContainer.UpdateLock();
	}
	UpdatePlayerInfo();

	// Refresht he UI
	RefreshItemComponents();
}

defaultproperties
{
	SubWidgetBindings.Remove((WidgetName="filterContainer",WidgetClass=class'KFGFxTraderContainer_Filter'))
	SubWidgetBindings.Add((WidgetName="filterContainer",WidgetClass=class'ExtTraderContainer_Filter'))
	SubWidgetBindings.Remove((WidgetName="shopContainer",WidgetClass=class'KFGFxTraderContainer_Store'))
	SubWidgetBindings.Add((WidgetName="shopContainer",WidgetClass=class'ExtTraderContainer_Store'))
	SubWidgetBindings.Remove((WidgetName="playerInfoContainer",WidgetClass=class'KFGFxTraderContainer_PlayerInfo'))
	SubWidgetBindings.Add((WidgetName="playerInfoContainer",WidgetClass=class'ExtTraderContainer_PlayerInfo'))
}