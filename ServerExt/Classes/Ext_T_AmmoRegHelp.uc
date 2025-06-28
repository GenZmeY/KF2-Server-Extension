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

Class Ext_T_AmmoRegHelp extends Info
	transient;

var Pawn PawnOwner;
var float RegCount;

function PostBeginPlay()
{
	PawnOwner = Pawn(Owner);
	if (PawnOwner==None)
		Destroy();
	else SetTimer(29+FRand(),true);
}

function Timer()
{
	local KFWeapon W;
	local byte i;
	local int ExtraAmmo;

	if (PawnOwner==None || PawnOwner.Health<=0 || PawnOwner.InvManager==None)
		Destroy();
	else
	{
		foreach PawnOwner.InvManager.InventoryActors(class'KFWeapon',W)
		{
			for (i=0; i<2; ++i)
			{
				if (W.SpareAmmoCount[i] < W.SpareAmmoCapacity[i])
				{
					ExtraAmmo = FMax(float(W.SpareAmmoCapacity[i] + W.MagazineCapacity[i])*RegCount,1.f);
					if (i==0)
					{
						W.AddAmmo(ExtraAmmo);
					}
					else
					{
						W.AddSecondaryAmmo(ExtraAmmo);
					}
					W.bNetDirty = true;
				}
			}
		}
	}
}

defaultproperties
{
}