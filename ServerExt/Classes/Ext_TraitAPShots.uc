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

Class Ext_TraitAPShots extends Ext_TraitBase;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).APShotMul = 1 + (0.25 + (((float(Level) - 1.f) * 5.f) / 100.f));
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).APShotMul = 0.f;
}

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).bUseAPShot = true;
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).bUseAPShot = false;
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkSupport'
	NumLevels=4
	DefLevelCosts(0)=15
	DefLevelCosts(1)=30
	DefLevelCosts(2)=40
	DefLevelCosts(3)=50
	DefMinLevel=15
}