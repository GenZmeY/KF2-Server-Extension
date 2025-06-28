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

Class Ext_TraitWeapons extends Ext_TraitBase;

var localized string GroupDescription;

struct FLevelFX
{
	var array< class<Inventory> > LoadoutClasses;
};
var array<FLevelFX> LevelEffects;

static function bool MeetsRequirements(byte Lvl, Ext_PerkBase Perk)
{
	if (Lvl>=3 && (Perk.CurrentLevel<50 || !HasMaxCarry(Perk)))
		return false;
	return Super.MeetsRequirements(Lvl,Perk);
}

static final function bool HasMaxCarry(Ext_PerkBase Perk)
{
	local int i;

	i = Perk.PerkTraits.Find('TraitType',Class'Ext_TraitCarryCap');
	return (i==-1 || Perk.PerkTraits[i].CurrentLevel>=3);
}

function string GetPerkDescription()
{
	return Super.GetPerkDescription()$"|"$GroupDescription;
}

static function TraitActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.PrimaryWeapon = None; // Give a new primary weapon.
}

static function TraitDeActivate(Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	Perk.PrimaryWeapon = Perk.Default.PrimaryWeapon;
}

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local class<Inventory> IC;
	local KFInventoryManager M;
	local Inventory Inv;

	Level = Min(Level-1,Default.LevelEffects.Length-1);
	M = KFInventoryManager(Player.InvManager);
	if (M!=None)
		M.bInfiniteWeight = true;
	foreach Default.LevelEffects[Level].LoadoutClasses(IC)
	{
		if (Player.FindInventoryType(IC)==None)
		{
			Inv = Player.CreateInventory(IC,Player.Weapon!=None);
			if (KFWeapon(Inv)!=None)
				KFWeapon(Inv).bGivenAtStart = true;
		}
	}
	if (M!=None)
		M.bInfiniteWeight = false;
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local class<Inventory> IC;
	local Inventory Inv;

	if (Level==0)
		return;
	Level = Min(Level-1,Default.LevelEffects.Length-1);
	foreach Default.LevelEffects[Level].LoadoutClasses(IC)
	{
		Inv = Player.FindInventoryType(IC);
		if (Inv!=None)
			Inv.Destroy();
	}
}

defaultproperties
{
	NumLevels=4
	DefLevelCosts(0)=10
	DefLevelCosts(1)=15
	DefLevelCosts(2)=20
	DefLevelCosts(3)=40
	LoadPriority=1 // Make sure Carry Cap trait gets loaded first.
}