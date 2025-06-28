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

Class ExtMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

function TickHud(float DeltaTime)
{
	local PlayerController PC;

	PC = GetPC();
	if (PC!=none && PC.PlayerInput!=None)
		Super.TickHud(DeltaTime);
}

final function ShowKillMessageX(PlayerReplicationInfo PRI1, PlayerReplicationInfo PRI2, optional string VictimStr, optional bool bDeathMessage = false, optional class<Pawn> PawnOther)
{
	local GFxObject DataObject;
	local bool bHumanDeath;
	local string KilledName, KillerName, KilledIconpath, KillerIconPath;
	local string KillerTextColor, KilledTextColor;

	if (KFPC == none)
		return;

	if (KFGXHUDManager != none)
	{
		if (PawnOther != none)
		{
			if (bDeathMessage)
			{
				KillerTextColor = ZEDTeamTextColor;
				KillerName = class'KFExtendedHUD'.Static.GetNameOf(PawnOther);
			}
			else
			{
				KilledName = class'KFExtendedHUD'.Static.GetNameOf(PawnOther);
				bHumanDeath = false;
			}
		}
		if ((PawnOther==None || !bDeathMessage) && PRI1 != none)
		{
			if (PRI1.GetTeamNum() == 255)
			{
				KillerTextColor = ZEDTeamTextColor;
				KillerIconpath = "img://"$class'KFPerk_Monster'.static.GetPerkIconPath();
			}
			else
			{
				KillerTextColor = HumanTeamTextColor;
				if (ExtPlayerReplicationInfo(PRI1)!=None && ExtPlayerReplicationInfo(PRI1).ECurrentPerk!=None)
					KillerIconpath = ExtPlayerReplicationInfo(PRI1).ECurrentPerk.static.GetPerkIconPath(0);
			}
			KillerName = PRI1.PlayerName;
		}

		if (PRI2 != none)
		{
			if (PRI2.GetTeamNum() == class'KFTeamInfo_Human'.default.TeamIndex)
			{
				bHumanDeath = true;
				KilledTextColor = HumanTeamTextColor;
			}
			else
			{
				KilledTextColor = ZEDTeamTextColor;
				bHumanDeath = false;
			}
			KilledName = PRI2.PlayerName;
			if (ExtPlayerReplicationInfo(PRI2)!=None && ExtPlayerReplicationInfo(PRI2).ECurrentPerk!=None)
				KilledIconpath = ExtPlayerReplicationInfo(PRI2).ECurrentPerk.static.GetPerkIconPath(0);
		}
		else if (VictimStr!="")
		{
			KilledTextColor = HumanTeamTextColor;
			KilledIconpath = "img://"$class'KFPerk_Monster'.static.GetPerkIconPath();
			bHumanDeath = false;
			KilledName = VictimStr;
		}

		DataObject = CreateObject("Object");

		DataObject.SetBool("humanDeath", bHumanDeath);

		DataObject.SetString("killedName", KilledName);
		DataObject.SetString("killedTextColor", KilledTextColor);
		DataObject.SetString("killedIcon", KilledIconpath);

		DataObject.SetString("killerName", KillerName);
		DataObject.SetString("killerTextColor", KillerTextColor);
		DataObject.SetString("killerIcon", KillerIconpath);

		//temp remove when rest of design catches up
		DataObject.SetString("text", KillerName@KilledName);

		KFGXHUDManager.SetObject("newBark", DataObject);
	}
}

function UpdateObjectiveActive()
{
	// Fix:
	// ScriptWarning: Accessed None 'KFGRI'
	// ExtMoviePlayer_HUD Transient.ExtMoviePlayer_HUD_0
	// Function KFGame.KFGFxMoviePlayer_HUD:UpdateObjectiveActive:00B7
	if (GetPC() == None || KFGameReplicationInfo(GetPC().WorldInfo.GRI) == None)
	{
		return;
	}

	Super.UpdateObjectiveActive();
}

defaultproperties
{
	WidgetBindings.Remove((WidgetName="SpectatorInfoWidget",WidgetClass=class'KFGFxHUD_SpectatorInfo'))
	WidgetBindings.Add((WidgetName="SpectatorInfoWidget",WidgetClass=class'ExtHUD_SpectatorInfo'))
	WidgetBindings.Remove((WidgetName="PlayerStatWidgetMC",WidgetClass=class'KFGFxHUD_PlayerStatus'))
	WidgetBindings.Add((WidgetName="PlayerStatWidgetMC",WidgetClass=class'ExtHUD_PlayerStatus'))
	WidgetBindings.Remove((WidgetName="PlayerBackpackWidget",WidgetClass=class'KFGFxHUD_PlayerBackpack'))
	WidgetBindings.Add((WidgetName="PlayerBackpackWidget",WidgetClass=class'ExtHUD_PlayerBackpack'))
	WidgetBindings.Remove((WidgetName="WeaponSelectContainer",WidgetClass=class'KFGFxHUD_WeaponSelectWidget'))
	WidgetBindings.Add((WidgetName="WeaponSelectContainer",WidgetClass=class'ExtHUD_WeaponSelectWidget'))
	WidgetBindings.Remove((WidgetName="ObjectiveContainer",WidgetClass=class'KFGFxHUD_ObjectiveConatiner'))
	WidgetBindings.Add((WidgetName="ObjectiveContainer",WidgetClass=class'ExtHUD_ObjectiveConatiner'))
}