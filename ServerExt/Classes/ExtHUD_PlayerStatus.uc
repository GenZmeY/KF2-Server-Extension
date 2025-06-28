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

class ExtHUD_PlayerStatus extends KFGFxHUD_PlayerStatus;

var ExtPlayerController ExPC;
var class<Ext_PerkBase> ExLastPerkClass;
var string CurPerkPath;

function InitializeHUD()
{
	Super.InitializeHUD();
	ExPC = ExtPlayerController(MyPC);
}

function UpdatePerk()
{
	local int CurrentPerkLevel,CurrentPerkEXP;
	local Ext_PerkBase CurrentPerk;
	local GFxObject PerkIconObject;

	if (ExPC == none || ExPC.ActivePerkManager==None || ExPC.ActivePerkManager.CurrentPerk==None)
		return;

	CurrentPerk = ExPC.ActivePerkManager.CurrentPerk;
	CurrentPerkLevel = CurrentPerk.CurrentLevel;
	CurrentPerkEXP = CurrentPerk.CurrentEXP;

	// Update the perk class.
	if ((ExLastPerkClass != CurrentPerk.Class) || (LastPerkLevel != CurrentPerkLevel))
	{
		CurPerkPath = CurrentPerk.GetPerkIconPath(CurrentPerkLevel);

		PerkIconObject = CreateObject("Object");
		PerkIconObject.SetString("perkIcon", CurPerkPath);
		SetObject("playerPerkIcon", PerkIconObject);

		SetInt("playerPerkXPPercent", CurrentPerk.GetProgressPercent() * 100.f);
		if (LastPerkLevel != CurrentPerkLevel && ExLastPerkClass==CurrentPerk.Class)
		{
			SetBool("bLevelUp", true);
			ShowXPBark(CurrentPerkEXP-LastEXPValue,CurPerkPath,true);
		}
		ExLastPerkClass = CurrentPerk.class;

		SetInt("playerPerkLevel" , CurrentPerkLevel);
		LastPerkLevel = CurrentPerkLevel;
		LastEXPValue = CurrentPerkEXP;
	}
	else if (LastEXPValue!=CurrentPerkEXP)
	{
		SetBool("bLevelUp", false);
		SetInt("playerPerkXPPercent", CurrentPerk.GetProgressPercent() * 100.f);
		ShowXPBark(CurrentPerkEXP-LastEXPValue,CurPerkPath,true);
		LastEXPValue = CurrentPerkEXP;
	}
}

function ShowXPBark(int DeltaXP, string IconPath, bool bIsCurrentPerk)
{
	ActionScriptVoid("showXPBark");
}

function UpdateHealth()
{
	if (MyPC.Pawn == none)
	{
		LastHealth = 0;
		SetInt("playerHealth" , LastHealth);
	}
	else if (LastHealth != MyPC.Pawn.Health)
	{
		LastHealth = MyPC.Pawn.Health;
		SetInt("playerHealth" , LastHealth);
	}
}

defaultproperties
{
}