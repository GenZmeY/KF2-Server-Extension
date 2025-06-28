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

Class Ext_TraitRackEmUp extends Ext_TraitBase;

var array<byte> ComboSize;

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkRhythmPerkBase(Perk).SetMaxRhythm(Default.ComboSize[Level-1]);
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkRhythmPerkBase(Perk).ResetRhythm();
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkRhythmPerkBase'
	DefLevelCosts(0)=10
	DefLevelCosts(1)=15
	DefLevelCosts(2)=20
	DefLevelCosts(3)=30
	DefLevelCosts(4)=50
	ComboSize.Add(4)
	ComboSize.Add(8)
	ComboSize.Add(12)
	ComboSize.Add(16)
	ComboSize.Add(28)
	NumLevels=5
}