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

Class Ext_TraitToxicDart extends Ext_TraitBase;

var array<int> DartDamages;

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.ToxicDartDamage = Default.DartDamages[Level-1];
	Perk.bToxicDart = true;
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.bToxicDart = false;
}

defaultproperties
{
	DefLevelCosts(0)=25
	DefLevelCosts(1)=25
	DefLevelCosts(2)=30
	DartDamages(0)=15
	DartDamages(1)=35
	DartDamages(2)=70
	NumLevels=3
}