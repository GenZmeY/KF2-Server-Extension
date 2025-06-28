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

class ExtHUD_PlayerBackpack extends KFGFxHUD_PlayerBackpack;

var class<Ext_PerkBase> EPerkClass;

function UpdateGrenades()
{
	local int CurrentGrenades;
	local ExtPerkManager PM;

	if (MyKFInvManager != none)
		CurrentGrenades = MyKFInvManager.GrenadeCount;

	//Update the icon the for grenade type.
	if (ExtPlayerController(MyKFPC)!=None)
	{
		PM = ExtPlayerController(MyKFPC).ActivePerkManager;

		if (PM!=None && PM.CurrentPerk!=None && EPerkClass!=PM.CurrentPerk.Class)
		{
			SetString("backpackGrenadeType", "img://"$PM.CurrentPerk.GrenadeWeaponDef.Static.GetImagePath());
			EPerkClass = PM.CurrentPerk.Class;
		}
	}
	// Update the grenades count value
	if (CurrentGrenades != LastGrenades)
	{
		SetInt("backpackGrenades" , Min(CurrentGrenades,9));
		LastGrenades = CurrentGrenades;
	}
}

defaultproperties
{

}