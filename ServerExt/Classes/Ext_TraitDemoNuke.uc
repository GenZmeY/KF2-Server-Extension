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

Class Ext_TraitDemoNuke extends Ext_TraitBase;

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

	if (Perk.CurrentLevel<Default.MinLevel || Perk.CurrentPrestige<3)
		return false;

	if (Lvl==0)
	{
		i = Perk.PerkStats.Find('StatType','Damage');
		if (i>=0)
			return (Perk.PerkStats[i].CurrentValue>=30);
	}

	return true;
}

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local ExtPlayerReplicationInfo MyPRI;

	MyPRI = ExtPlayerReplicationInfo(Perk.PlayerOwner.PlayerReplicationInfo);
	if (MyPRI == None || Ext_PerkDemolition(Perk) == None)
		return;

	MyPRI.bNukeActive = true;
	Ext_PerkDemolition(Perk).NukeDamageMult = 1.0 + (((float(Level) - 1.f) * 5.f) / 100.f);
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local ExtPlayerReplicationInfo MyPRI;

	MyPRI = ExtPlayerReplicationInfo(Perk.PlayerOwner.PlayerReplicationInfo);
	if (MyPRI == None || Ext_PerkDemolition(Perk) == None)
		return;

	MyPRI.bNukeActive = false;
	Ext_PerkDemolition(Perk).NukeDamageMult = 1.0;
}

defaultproperties
{
	SupportedPerk=class'Ext_PerkDemolition'
	TraitGroup=class'Ext_TGroupZEDTime'
	NumLevels=4
	DefLevelCosts(0)=100
	DefLevelCosts(1)=150
	DefLevelCosts(2)=200
	DefLevelCosts(3)=250
	DefMinLevel=100
}