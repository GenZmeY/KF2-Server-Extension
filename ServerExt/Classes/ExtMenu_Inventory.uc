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

class ExtMenu_Inventory extends KFGFxMenu_Inventory;

function bool IsItemActive(int ItemDefinition)
{
	local class<KFWeaponDefinition> WeaponDef;
	local int ItemIndex;

	ItemIndex = class'ExtWeaponSkinList'.default.Skins.Find('Id', ItemDefinition);

	if (ItemIndex == INDEX_NONE)
	{
		return false;
	}

	WeaponDef = class'ExtWeaponSkinList'.default.Skins[ItemIndex].WeaponDef;

	if (WeaponDef != none)
	{
		return class'ExtWeaponSkinList'.Static.IsSkinEquip(WeaponDef, ItemDefinition, ExtPlayerController(KFPC));
	}

	return false;
}

function Callback_Equip(int ItemDefinition)
{
	local class<KFWeaponDefinition> WeaponDef;
	local int ItemIndex;

	ItemIndex = class'ExtWeaponSkinList'.default.Skins.Find('Id', ItemDefinition);

	if (ItemIndex == INDEX_NONE)
	{
		return;
	}

	WeaponDef = class'ExtWeaponSkinList'.default.Skins[ItemIndex].WeaponDef;

	if (WeaponDef != none)
	{
		if (IsItemActive(ItemDefinition))
		{
			class'ExtWeaponSkinList'.Static.SaveWeaponSkin(WeaponDef, 0, ExtPlayerController(KFPC));

			if (class'WorldInfo'.static.IsConsoleBuild())
			{
				Manager.CachedProfile.ClearWeaponSkin(WeaponDef.default.WeaponClassPath);
			}
		}
		else
		{
			class'ExtWeaponSkinList'.Static.SaveWeaponSkin(WeaponDef, ItemDefinition, ExtPlayerController(KFPC));
			if (class'WorldInfo'.static.IsConsoleBuild())
			{
				Manager.CachedProfile.SaveWeaponSkin(WeaponDef.default.WeaponClassPath, ItemDefinition);
			}
		}
	}

	InitInventory();
}

defaultproperties
{

}