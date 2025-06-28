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

Class Ext_TraitAirborne extends Ext_TraitBase;

var array<float> HealRates;

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkFieldMedic(Perk).AirborneAgentHealRate = Default.HealRates[Level-1];
	Ext_PerkFieldMedic(Perk).AirborneAgentLevel = (Level<4 ? 1 : 2);
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkFieldMedic(Perk).AirborneAgentLevel = 0;
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkFieldMedic'
	DefLevelCosts(0)=20
	DefLevelCosts(1)=10
	DefLevelCosts(2)=10
	DefLevelCosts(3)=60
	HealRates(0)=0.05
	HealRates(1)=0.1
	HealRates(2)=0.2
	HealRates(3)=0.15
	NumLevels=4
	DefMinLevel=50
}