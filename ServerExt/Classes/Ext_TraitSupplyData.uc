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

Class Ext_TraitSupplyData extends Ext_TraitDataStore;

var Ext_T_SupplierInteract SupplyInteraction;

final function SpawnSupplier(KFPawn_Human H, optional bool bGrenades)
{
	if (SupplyInteraction!=None)
		SupplyInteraction.Destroy();

	SupplyInteraction = Spawn(class'Ext_T_SupplierInteract', H,, H.Location, H.Rotation,, true);
	SupplyInteraction.SetBase(H);
	SupplyInteraction.PlayerOwner = H;
	SupplyInteraction.PerkOwner = Perk;
	SupplyInteraction.bGrenades = bGrenades;

	if (PlayerOwner!=None && ExtPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)!=None)
		ExtPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).HasSupplier = class<Ext_TraitSupply>(TraitClass);
}

final function RemoveSupplier()
{
	if (SupplyInteraction!=None)
		SupplyInteraction.Destroy();

	if (PlayerOwner!=None && ExtPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo)!=None)
		ExtPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).HasSupplier = None;
}

function Destroyed()
{
	RemoveSupplier();
}