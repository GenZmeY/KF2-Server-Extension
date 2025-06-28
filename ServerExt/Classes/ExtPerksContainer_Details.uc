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

class ExtPerksContainer_Details extends KFGFxPerksContainer_Details;

`define AddWeaponsInfo(InClassDef) if (`InClassDef!=None) AddWeaponInfo(WeaponNames, WeaponSources, `InClassDef.static.GetItemName(), `InClassDef.static.GetImagePath())

final function ExUpdateDetails(Ext_PerkBase PerkClass)
{
	local GFxObject DetailsProvider;
	local KFPlayerController KFPC;
	local KFGameReplicationInfo KFGRI;
	local array<string> WeaponNames;
	local array<string> WeaponSources;
	local int i;

	DetailsProvider = CreateObject("Object");

	KFPC = KFPlayerController(GetPC());

	if (KFPC != none)
	{
		KFGRI = KFGameReplicationInfo(KFPC.WorldInfo.GRI);

		DetailsProvider.SetString("ExperienceMessage", ExperienceString @ PerkClass.CurrentEXP);

		if (KFGRI != none)
		{
			`AddWeaponsInfo(PerkClass.PrimaryWeaponDef);
			`AddWeaponsInfo(PerkClass.SecondaryWeaponDef);
			`AddWeaponsInfo(PerkClass.KnifeWeaponDef);
			`AddWeaponsInfo(PerkClass.GrenadeWeaponDef);
		}

		for (i = 0; i < WeaponNames.length; i++)
		{
			DetailsProvider.SetString("WeaponName" $ i, WeaponNames[i]);
			DetailsProvider.SetString("WeaponImage" $ i, "img://"$WeaponSources[i]);
		}

		DetailsProvider.SetString("EXPAction1", "Kill zombies");
		//DetailsProvider.SetString("EXPAction2", PerkClass.default.EXPAction2);

		SetObject("detailsData", DetailsProvider);
	}
}

final function ExUpdatePassives(Ext_PerkBase PerkClass)
{
	local GFxObject PassivesProvider;
	local GFxObject PassiveObject;
	local int i;

	PassivesProvider = CreateArray();
	for (i=0; i<PerkClass.PerkStats.Length; ++i)
	{
		PassiveObject = CreateObject("Object");
		PassiveObject.SetString("PassiveTitle", PerkClass.GetStatUIStr(i));
		PassiveObject.SetString("PerkBonusModifier", "");
		PassiveObject.SetString("PerkBonusAmount", "");
		PassivesProvider.SetElementObject(i, PassiveObject);
	}
	SetObject("passivesData", PassivesProvider);
}