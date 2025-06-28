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

class ExtWeap_Pistol_MedicS extends KFWeap_Pistol_Medic;

defaultproperties
{
	bCanThrow=false

	SpareAmmoCapacity[0]=-1
	InitialSpareMags[0]=0
	bInfiniteSpareAmmo=True

	// Remove weight bcs of replacing 9mm
	InventorySize=0

	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'ExtDT_Ballistic_Pistol_Medic'

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.7f), (Stat=EWUS_HealFullRecharge, Scale=0.9f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_HealFullRecharge, Scale=0.8f)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=2.55f), (Stat=EWUS_HealFullRecharge, Scale=0.7f)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=3.0f), (Stat=EWUS_HealFullRecharge, Scale=0.6f)))
}

simulated static function bool AllowedForAllPerks()
{
	return true;
}

simulated function ConsumeAmmo(byte FireModeNum)
{
	if (FireModeNum == ALTFIRE_FIREMODE)
		super.ConsumeAmmo(FireModeNum);
}

simulated static event class<KFPerk> GetWeaponPerkClass(class<KFPerk> InstigatorPerkClass)
{
	if (InstigatorPerkClass != None)
		return InstigatorPerkClass;

	return default.AssociatedPerkClasses[0];
}

simulated function KFPerk GetPerk()
{
	if (KFPlayer != None)
		return KFPlayer.GetPerk();
	return super.GetPerk();
}