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

Class Ext_TraitZEDBase extends Ext_TraitBase;

var class<Ext_TraitZEDBase> BaseTrait;
var bool bIsSummoner;

static function bool MeetsRequirements(byte Lvl, Ext_PerkBase Perk)
{
	local int i;

	// First check level.
	if (Perk.CurrentLevel<Default.MinLevel)
		return false;

	// Then check stats.
	if (Lvl==0 && Default.BaseTrait!=None)
	{
		i = Perk.PerkTraits.Find('TraitType',Default.BaseTrait);
		if (i>=0)
			return (Perk.PerkTraits[i].CurrentLevel>0);
	}
	return true;
}

defaultproperties
{
	TraitGroup=class'Ext_TGroupMonster'
	BaseTrait=class'Ext_TraitZED_Summon'
}