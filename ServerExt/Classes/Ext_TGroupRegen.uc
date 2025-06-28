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

class Ext_TGroupRegen extends Ext_TGroupBase;

var localized string GroupDescription;

function string GetUIInfo(Ext_PerkBase Perk)
{
	return Default.GroupInfo@"("$MaxText@GetMaxLimit(Perk)$")";
}

function string GetUIDesc()
{
	return Super.GetUIDesc()$"|"$GroupDescription;
}

static function bool GroupLimited(Ext_PerkBase Perk, class<Ext_TraitBase> Trait)
{
	local int i;
	local byte n;

	n = GetMaxLimit(Perk);
	for (i=0; i<Perk.PerkTraits.Length; ++i)
		if (Perk.PerkTraits[i].CurrentLevel>0 && Perk.PerkTraits[i].TraitType!=Trait && Perk.PerkTraits[i].TraitType.Default.TraitGroup==Default.Class && --n==0)
			return true;
	return false;
}

static final function byte GetMaxLimit(Ext_PerkBase Perk)
{
	if (Perk.CurrentPrestige<1 || Perk.CurrentLevel<100)
		return 1;
	return ((Perk.CurrentPrestige<5 || Perk.CurrentLevel<150) ? 2 : 3);
}

defaultproperties
{

}