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

Class Ext_TraitZED_Health extends Ext_TraitZEDBase;

var array<float> HPList;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local Ext_T_ZEDHelper H;

	foreach Player.ChildActors(class'Ext_T_ZEDHelper',H)
		H.SetHealthScale(Default.HPList[Level-1]);
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local Ext_T_ZEDHelper H;

	foreach Player.ChildActors(class'Ext_T_ZEDHelper',H)
		H.SetHealthScale(1);
}

defaultproperties
{
	NumLevels=5
	bPostApplyEffect=true
	DefLevelCosts(0)=5
	DefLevelCosts(1)=15
	DefLevelCosts(2)=25
	DefLevelCosts(3)=40
	DefLevelCosts(4)=60

	HPList.Add(1.25)
	HPList.Add(1.5)
	HPList.Add(1.75)
	HPList.Add(2)
	HPList.Add(3)
}