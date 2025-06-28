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

Class Ext_TraitZedTExt extends Ext_TraitBase;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkCommando(Perk).ZTExtCount = Level;
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkCommando(Perk).ZTExtCount = Level;
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkCommando'
	NumLevels=6
	DefLevelCosts(0)=15
	DefLevelCosts(1)=25
	DefLevelCosts(2)=35
	DefLevelCosts(3)=45
	DefLevelCosts(4)=55
	DefLevelCosts(5)=65
	DefMinLevel=15
}