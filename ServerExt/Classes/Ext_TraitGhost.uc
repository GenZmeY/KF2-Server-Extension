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

Class Ext_TraitGhost extends Ext_TraitBase;

static function bool PreventDeath(KFPawn_Human Player, Controller Instigator, Class<DamageType> DamType, Ext_PerkBase Perk, byte Level, optional Ext_TraitDataStore Data)
{
	local Controller C;

	if ((Instigator==None || Instigator==Player.Controller) && DamType==Class'DmgType_Suicided')
		return false; // Allow normal suicide to go ahead.

	if (Ext_T_GhostHelper(Data).CanResPlayer(Player,Level))
	{
		// Abort current special move
		if (Player.IsDoingSpecialMove())
			Player.SpecialMoveHandler.EndSpecialMove();

		// Notify AI to stop hunting me.
		foreach Player.WorldInfo.AllControllers(class'Controller',C)
			C.NotifyKilled(Instigator,Player.Controller,Player,DamType);
		return true;
	}
	return false;
}

defaultproperties
{
	bHighPriorityDeath=true
	NumLevels=2
	TraitData=class'Ext_T_GhostHelper'
	DefLevelCosts(0)=30
	DefLevelCosts(1)=30
	DefMinLevel=30
}