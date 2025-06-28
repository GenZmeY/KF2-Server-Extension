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

Class Ext_TraitKnockback extends Ext_TraitRagdoll;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	if (ExtHumanPawn(Player)!=None)
		ExtHumanPawn(Player).KnockbackResist = Default.ChanceValues[Level-1];
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	if (ExtHumanPawn(Player)!=None)
		ExtHumanPawn(Player).KnockbackResist = 1.f;
}

defaultproperties
{
	NumLevels=4
	DefLevelCosts(0)=30
	DefLevelCosts(1)=30
	DefLevelCosts(2)=40
	DefLevelCosts(3)=60
	DefMinLevel=70

	ChanceValues(0)=0.8
	ChanceValues(1)=0.5
	ChanceValues(2)=0.3
	ChanceValues(3)=0.1
}