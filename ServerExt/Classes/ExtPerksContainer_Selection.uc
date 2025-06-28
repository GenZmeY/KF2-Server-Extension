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

class ExtPerksContainer_Selection extends KFGFxPerksContainer_Selection;

var localized string PerkChangeWarning;

function UpdatePerkSelection(byte SelectedPerkIndex)
{
	local int i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	local ExtPlayerController KFPC;
	local Ext_PerkBase PerkClass;

	KFPC = ExtPlayerController(GetPC());

	if (KFPC!=none && KFPC.ActivePerkManager!=None)
	{
		DataProvider = CreateArray();

		for (i = 0; i < KFPC.ActivePerkManager.UserPerks.Length; i++)
		{
			PerkClass = KFPC.ActivePerkManager.UserPerks[i];
			TempObj = CreateObject("Object");
			TempObj.SetInt("PerkLevel", PerkClass.CurrentLevel);
			TempObj.SetString("Title",  PerkClass.PerkName);
			TempObj.SetString("iconSource",  PerkClass.GetPerkIconPath(PerkClass.CurrentLevel));
			TempObj.SetBool("bTierUnlocked", true);

			DataProvider.SetElementObject(i, TempObj);
		}
		SetObject("perkData", DataProvider);
		SetInt("SelectedIndex", SelectedPerkIndex);

		UpdatePendingPerkInfo(SelectedPerkIndex);
	}
}

function UpdatePendingPerkInfo(byte SelectedPerkIndex)
{
	local ExtPlayerController KFPC;
	local Ext_PerkBase PerkClass;

	KFPC = ExtPlayerController(GetPC());
	if (KFPC != none)
	{
		PerkClass = KFPC.ActivePerkManager.UserPerks[SelectedPerkIndex];
		SetPendingPerkChanges(PerkClass.PerkName, PerkClass.GetPerkIconPath(PerkClass.CurrentLevel), PerkChangeWarning);
	}
}

function SavePerk(int PerkID);