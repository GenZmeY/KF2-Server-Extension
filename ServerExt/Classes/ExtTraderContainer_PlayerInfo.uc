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

class ExtTraderContainer_PlayerInfo extends KFGFxTraderContainer_PlayerInfo;

function SetPerkInfo()
{
	local Ext_PerkBase CurrentPerk;
	local ExtPlayerController KFPC;
	local float V;

	KFPC = ExtPlayerController(GetPC());
	if (KFPC!=none && KFPC.ActivePerkManager!=None && KFPC.ActivePerkManager.CurrentPerk!=None)
	{
		CurrentPerk = KFPC.ActivePerkManager.CurrentPerk;
		SetString("perkName", CurrentPerk.PerkName);
		SetString("perkIconPath", CurrentPerk.GetPerkIconPath(CurrentPerk.CurrentLevel));
		SetInt("perkLevel", CurrentPerk.CurrentLevel);
		V = CurrentPerk.GetProgressPercent()*100.f;
		SetInt("xpBarValue", int(V));
	}
}

function SetPerkList()
{
	local GFxObject PerkObject;
	local GFxObject DataProvider;
	local ExtPlayerController KFPC;
	local byte i;
	local float PerkPercent;
	local Ext_PerkBase P;

	KFPC = ExtPlayerController(GetPC());
	if (KFPC != none && KFPC.ActivePerkManager!=None)
	{
		DataProvider = CreateArray();

		for (i = 0; i < KFPC.ActivePerkManager.UserPerks.Length; i++)
		{
			P = KFPC.ActivePerkManager.UserPerks[i];
			PerkObject = CreateObject("Object");
			PerkObject.SetString("name", P.PerkName);
			PerkObject.SetString("perkIconSource",  P.GetPerkIconPath(P.CurrentLevel));
			PerkObject.SetInt("level", P.CurrentLevel);

			PerkPercent = P.GetProgressPercent()*100.f;
			PerkObject.SetInt("perkXP", int(PerkPercent));

			DataProvider.SetElementObject(i, PerkObject);
		}

		SetObject("perkList", DataProvider);
	}
}

defaultproperties
{

}