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

Class Ext_TraitWPDemo extends Ext_TraitWeapons;

defaultproperties
{
	LevelEffects(0)=(LoadoutClasses=(class'KFWeap_Thrown_C4'))
	LevelEffects(1)=(LoadoutClasses=(class'KFWeap_GrenadeLauncher_M79'))
	LevelEffects(2)=(LoadoutClasses=(class'KFWeap_RocketLauncher_RPG7'))
	LevelEffects(3)=(LoadoutClasses=(class'KFWeap_Thrown_C4',class'KFWeap_GrenadeLauncher_M79',class'KFWeap_RocketLauncher_RPG7'))
}