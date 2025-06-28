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

class ExtHUD_SpectatorInfo extends KFGFxHUD_SpectatorInfo;

var class<Ext_PerkBase> ExtLastPerkClass;
var bool bUnsetInfo;

function LocalizeText()
{
	local GFxObject TempObject;
	TempObject = CreateObject("Object");

	TempObject.SetString("prevPlayer", "FREE CAMERA");
	TempObject.SetString("nextPlayer", PrevPlayerString);
	TempObject.SetString("changeCamera", ChangeCameraString);

	SetObject("localizedText", TempObject);
}

function UpdatePlayerInfo(optional bool bForceUpdate)
{
	local GFxObject TempObject;
	local ExtPlayerReplicationInfo E;

	if (SpectatedKFPRI == None)
		return;

	E = ExtPlayerReplicationInfo(SpectatedKFPRI);

	if (LastPerkLevel != E.ECurrentPerkLevel || LastPerkLevel != E.ECurrentPerkLevel || bForceUpdate)
	{
		LastPerkLevel = E.ECurrentPerkLevel;
		ExtLastPerkClass = E.ECurrentPerk;
		TempObject = CreateObject("Object");
		TempObject.SetString("playerName", SpectatedKFPRI.GetHumanReadableName());
		if (ExtLastPerkClass!=None && TempObject !=None)
		{
			TempObject.SetString("playerPerk", SpectatedKFPRI.CurrentPerkClass.default.LevelString @LastPerkLevel @ExtLastPerkClass.default.PerkName);
			TempObject.SetString("iconPath", ExtLastPerkClass.Static.GetPerkIconPath(LastPerkLevel));
			SetObject("playerData", TempObject);
		}
		else TempObject.SetString("playerPerk","No perk");
		SetVisible(true);
	}
}

defaultproperties
{

}