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

class ExtTraderContainer_Store extends KFGFxTraderContainer_Store;

/** returns true if this item should not be displayed */
function bool IsItemFiltered(STraderItem Item, optional bool bDebug)
{
	if (KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.ClassName))
		return true;
	if ( KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.DualClassName) )
		return true;
	if (!KFPC.GetPurchaseHelper().IsSellable(Item))
		return true;
	if ( Item.WeaponDef.default.PlatformRestriction != PR_All && class'KFUnlockManager'.static.IsPlatformRestricted( Item.WeaponDef.default.PlatformRestriction ) )
		return true;

	return false;
}

function RefreshWeaponListByPerk(byte FilterIndex, const out array<STraderItem> ItemList)
{
	local int i, SlotIndex;
	local GFxObject ItemDataArray; // This array of information is sent to ActionScript to update the Item data
	local array<STraderItem> OnPerkWeapons, SecondaryWeapons, OffPerkWeapons;
	local class<KFPerk> TargetPerkClass;
	local ExtPlayerController EKFPC;

	EKFPC = ExtPlayerController(KFPC);
	if (EKFPC!=none && EKFPC.ActivePerkManager!=None)
	{
		if (FilterIndex<EKFPC.ActivePerkManager.UserPerks.Length)
			TargetPerkClass = EKFPC.ActivePerkManager.UserPerks[FilterIndex].BasePerk;

		SlotIndex = 0;
		ItemDataArray = CreateArray();

		for (i = 0; i < ItemList.Length; i++)
		{
			if (IsItemFiltered(ItemList[i]))
			{
				continue; // Skip this item if it's in our inventory
			}
			else if (ItemList[i].AssociatedPerkClasses.length > 0 && ItemList[i].AssociatedPerkClasses[0] != none && TargetPerkClass != class'KFPerk_Survivalist'
				&& (TargetPerkClass==None || ItemList[i].AssociatedPerkClasses.Find(TargetPerkClass) == INDEX_NONE))
			{
				continue; // filtered by perk
			}
			else
			{
				if (ItemList[i].AssociatedPerkClasses.length > 0)
				{
					switch (ItemList[i].AssociatedPerkClasses.Find(TargetPerkClass))
					{
						case 0: //primary perk
							OnPerkWeapons.AddItem(ItemList[i]);
							break;

						case 1: //secondary perk
							SecondaryWeapons.AddItem(ItemList[i]);
							break;

						default: //off perk
							OffPerkWeapons.AddItem(ItemList[i]);
							break;
					}
				}
			}
		}

		for (i = 0; i < OnPerkWeapons.length; i++)
		{
			SetItemInfo(ItemDataArray, OnPerkWeapons[i], SlotIndex);
			SlotIndex++;
		}

		for (i = 0; i < SecondaryWeapons.length; i++)
		{
			SetItemInfo(ItemDataArray, SecondaryWeapons[i], SlotIndex);
			SlotIndex++;
		}

		for (i = 0; i < OffPerkWeapons.length; i++)
		{
			SetItemInfo(ItemDataArray, OffPerkWeapons[i], SlotIndex);
			SlotIndex++;
		}

		SetObject("shopData", ItemDataArray);
	}
}