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

Class Ext_TraitPenetrator extends Ext_TraitBase;

var localized string GroupDescription;

function string GetPerkDescription()
{
	local string S;

	S = Super.GetPerkDescription();
	S $= "|"$GroupDescription;
	return S;
}

static function bool MeetsRequirements(byte Lvl, Ext_PerkBase Perk)
{
	local int i;

	if (Perk.CurrentLevel<Default.MinLevel || Perk.CurrentPrestige<2)
		return false;

	for (i=0; i<Perk.PerkTraits.Length; ++i)
	{
		if (Perk.PerkTraits[i].TraitType==Class'Ext_TraitAPShots')
		{
			if (Perk.PerkTraits[i].CurrentLevel <= 0)
				return false;
			else break;
		}
	}

	return true;
}

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).bUsePerforate = true;
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Ext_PerkSupport(Perk).bUsePerforate = false;
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkSupport'
	TraitGroup=class'Ext_TGroupZEDTime'
	NumLevels=1
	DefLevelCosts(0)=50
	DefMinLevel=65
}