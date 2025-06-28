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

Class Ext_TraitCarryCap extends Ext_TraitBase;

var array<byte> CarryAdds;

static function ApplyEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local KFInventoryManager M;

	M = KFInventoryManager(Player.InvManager);
	if (M!=None)
		M.MaxCarryBlocks = M.Default.MaxCarryBlocks+Default.CarryAdds[Level-1];
}

static function CancelEffectOn(KFPawn_Human Player, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local KFInventoryManager M;

	M = KFInventoryManager(Player.InvManager);
	if (M!=None)
		M.MaxCarryBlocks = M.Default.MaxCarryBlocks;
}

defaultproperties
{
	NumLevels=5
	DefLevelCosts(0)=10
	DefLevelCosts(1)=15
	DefLevelCosts(2)=20
	DefLevelCosts(3)=25
	DefLevelCosts(4)=50
	CarryAdds.Add(2)
	CarryAdds.Add(4)
	CarryAdds.Add(6)
	CarryAdds.Add(8)
	CarryAdds.Add(15)
}