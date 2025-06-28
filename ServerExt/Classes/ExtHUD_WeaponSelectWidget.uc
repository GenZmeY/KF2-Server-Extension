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

class ExtHUD_WeaponSelectWidget extends KFGFxHUD_WeaponSelectWidget;

var transient array< class<KFWeaponDefinition> > WeaponGroup;

simulated function UpdateWeaponGroupOnHUD(byte GroupIndex)
{
	local Inventory Inv;
	local KFWeapon KFW;
	local byte i;
	local int Index;
	local array<KFWeapon> WeaponsList;
	local KFGFxObject_TraderItems TraderItems;
	local Pawn P;
	local array< class<KFWeaponDefinition> > WPGroup;

	P = GetPC().Pawn;
	if (P == none || P.InvManager == none)
		return;

	for (Inv = P.InvManager.InventoryChain; Inv != none; Inv = Inv.Inventory)
	{
		KFW = KFWeapon(Inv);
		if (KFW != none && KFW.InventoryGroup == GroupIndex)
			WeaponsList.AddItem(KFW);
	}

	WPGroup.Length = WeaponsList.Length;
	TraderItems = KFGameReplicationInfo(P.WorldInfo.GRI).TraderItems;
	for (i = 0; i < WeaponsList.Length; i++)
	{
		Index = TraderItems.SaleItems.Find('ClassName', WeaponsList[i].Class.Name);
		if (Index != -1)
			WPGroup[i] = TraderItems.SaleItems[Index].WeaponDef;
	}

	WeaponGroup = WPGroup;
	SetWeaponGroupList(WeaponsList, GroupIndex);
}

simulated function SetWeaponGroupList(out array<KFWeapon> WeaponList, byte GroupIndex)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	local bool bUsesAmmo;

	DataProvider = CreateArray();
	if (DataProvider == None)
		return; // gfx has been shut down

	for (i = 0; i < WeaponList.length; i++)
	{
		TempObj = CreateObject("Object");

		if (WeaponGroup[i] != None)
		{
			TempObj.SetString("weaponName", WeaponGroup[i].static.GetItemLocalization("ItemName"));
			TempObj.SetString("texturePath", "img://"$WeaponGroup[i].static.GetImagePath());
		}
		else
		{
			TempObj.SetString("weaponName", WeaponList[i].ItemName);
			TempObj.SetString("texturePath",  "img://"$PathName(WeaponList[i].WeaponSelectTexture));
		}

		TempObj.SetInt("weaponTier", WeaponList[i].CurrentWeaponUpgradeIndex);
		TempObj.SetInt("ammoCount", WeaponList[i].AmmoCount[0]);
		TempObj.SetInt("spareAmmoCount", WeaponList[i].SpareAmmoCount[0]);
		//secondary ammo shenanigans
		TempObj.SetBool("bUsesSecondaryAmmo", WeaponList[i].UsesSecondaryAmmo()&&WeaponList[i].bCanRefillSecondaryAmmo);
		TempObj.SetBool("bEnabled", WeaponList[i].HasAnyAmmo());
		if (WeaponList[i].UsesSecondaryAmmo() && WeaponList[i].bCanRefillSecondaryAmmo)
		{
			TempObj.SetBool("bCanRefillSecondaryAmmo", WeaponList[i].SpareAmmoCapacity[1] > 0);
			TempObj.SetInt("secondaryAmmoCount", WeaponList[i].AmmoCount[1]);
			TempObj.SetInt("secondarySpareAmmoCount", WeaponList[i].SpareAmmoCount[1]);
		}

		TempObj.SetBool("throwable", WeaponList[i].CanThrow());

		bUsesAmmo = (WeaponList[i].static.UsesAmmo());
		TempObj.SetBool("bUsesAmmo", bUsesAmmo);
		DataProvider.SetElementObject(i, TempObj);
	}

	SetWeaponList(DataProvider, GroupIndex);
}

defaultproperties
{

}