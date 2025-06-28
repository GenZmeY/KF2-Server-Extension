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

class ExtTraderContainer_Filter extends KFGFxTraderContainer_Filter;

function SetPerkFilterData(byte FilterIndex)
{
	local int i;
	local GFxObject DataProvider;
	local GFxObject FilterObject;
	local ExtPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;
	local ExtPerkManager PrM;

	SetBool("filterVisibliity", true);

	KFPC = ExtPlayerController(GetPC());
	if (KFPC != none)
	{
		PrM = KFPC.ActivePerkManager;
		KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
		if (KFPRI != none && PrM!=None)
		{
			i = Max(PrM.UserPerks.Find(PrM.CurrentPerk),0);
			SetInt("selectedIndex", i);

			// Set the title of this filter based on either the perk or the off perk string
			if (FilterIndex < PrM.UserPerks.Length)
			{
				SetString("filterText", PrM.UserPerks[FilterIndex].PerkName);
			}
			else
			{
				SetString("filterText", OffPerkString);
			}

			DataProvider = CreateArray();
			for (i = 0; i < PrM.UserPerks.Length; i++)
			{
				FilterObject = CreateObject("Object");
				FilterObject.SetString("source",  PrM.UserPerks[i].GetPerkIconPath(PrM.UserPerks[i].CurrentLevel));
				DataProvider.SetElementObject(i, FilterObject);
			}

			FilterObject = CreateObject("Object");
			FilterObject.SetString("source",  "img://"$class'KFGFxObject_TraderItems'.default.OffPerkIconPath);
			DataProvider.SetElementObject(i, FilterObject);

			SetObject("filterSource", DataProvider);
		}
	}
}

defaultproperties
{
}