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

class ExtWeapDef_MedicPistol extends KFWeapDef_MedicPistol
	abstract;

defaultproperties
{
	// Unsellable weapon
	BuyPrice=0

	// Free ammo
	AmmoPricePerMag=0

	WeaponClassPath="ServerExt.ExtWeap_Pistol_MedicS"

	// Unsellable upgrades
	UpgradeSellPrice[0] = 0
	UpgradeSellPrice[1] = 0
	UpgradeSellPrice[2] = 0
	UpgradeSellPrice[3] = 0
}