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

Class Ext_TraitGrenadeCap extends Ext_TraitCarryCap;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data);
static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data);

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.PerkManager.SetGrenadeCap(Default.CarryAdds[Level-1]);
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.PerkManager.SetGrenadeCap(0);
}

defaultproperties
{
	DefLevelCosts(0)=40
	DefLevelCosts(1)=55
	DefLevelCosts(2)=70
	DefLevelCosts(3)=90
	DefLevelCosts(4)=150
	CarryAdds(0)=1
	CarryAdds(1)=2
	CarryAdds(2)=3
	CarryAdds(3)=5
	CarryAdds(4)=8
}