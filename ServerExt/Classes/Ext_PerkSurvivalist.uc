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

Class Ext_PerkSurvivalist extends Ext_PerkBase;

defaultproperties
{
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_PerkIcon_Survivalist'
	DefTraitList.Add(class'Ext_TraitWPSurv')
	//DefTraitList.Add(class'Ext_TraitHeavyArmor')
	BasePerk=class'KFPerk_Survivalist'

	PrimaryMelee=class'KFWeap_Random'
	PrimaryWeapon=class'KFWeap_Knife_Support'
	PerkGrenade=class'KFProj_HEGrenade'

	PrimaryWeaponDef=class'KFWeapDef_Random'
	KnifeWeaponDef=class'KFweapDef_Knife_Support'
	GrenadeWeaponDef=class'KFWeapDef_Grenade_Commando'

	AutoBuyLoadOutPath=(class'KFWeapDef_DragonsBreath', class'KFWeapDef_M16M203', class'KFWeapDef_MedicRifle')
}