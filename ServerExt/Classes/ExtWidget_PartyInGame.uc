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

class ExtWidget_PartyInGame extends KFGFxWidget_PartyInGame;

var class<Ext_PerkBase> PPerkSlots[6];
var byte PPerkLevels[6];

struct ExtMemberSlotStruct
{
	var class<Ext_PerkBase> PerkClass;

	structdefaultproperties
	{
		PerkClass=none
	}
};
var ExtMemberSlotStruct ExtMemberSlots[13];

function GFxObject RefreshSlot(int SlotIndex, KFPlayerReplicationInfo KFPRI)
{
	local string PlayerName;
	local UniqueNetId AdminId;
	local bool bIsLeader;
	local bool bIsMyPlayer;
	local ExtPlayerController EPC;
	local GFxObject PlayerInfoObject, PerkIconObject;
	local ExtPlayerReplicationInfo EPRI;

	PlayerInfoObject = CreateObject("Object");
	EPC = ExtPlayerController(GetPC());

	if (KFPRI != none)
	{
		EPRI = ExtPlayerReplicationInfo(KFPRI);
	}
	if (OnlineLobby != none)
	{
		OnlineLobby.GetLobbyAdmin(OnlineLobby.GetCurrentLobbyId(), AdminId);
	}
	bIsLeader = EPRI.UniqueId == AdminId;
	PlayerInfoObject.SetBool("bLeader", bIsLeader);
	bIsMyPlayer = EPC.PlayerReplicationInfo.UniqueId == KFPRI.UniqueId;
	ExtMemberSlots[SlotIndex].PerkClass = EPRI.ECurrentPerk;
	PlayerInfoObject.SetBool("myPlayer", bIsMyPlayer);
	if (ExtMemberSlots[SlotIndex].PerkClass != none)
	{
		PerkIconObject = CreateObject("Object");
		PerkIconObject.SetString("perkIcon", ExtMemberSlots[SlotIndex].PerkClass.static.GetPerkIconPath(EPRI.ECurrentPerkLevel));
		PlayerInfoObject.SetObject("perkImageSource", PerkIconObject);

		PlayerInfoObject.SetString("perkLevel", string(EPRI.ECurrentPerkLevel));
	}
	if (!bIsMyPlayer)
	{
		PlayerInfoObject.SetBool("muted", EPC.IsPlayerMuted(EPRI.UniqueId));
	}
	if (class'WorldInfo'.static.IsE3Build())
	{
		PlayerName = EPRI.PlayerName;
	}
	else
	{
		PlayerName = EPRI.PlayerName;
	}
	PlayerInfoObject.SetString("playerName", PlayerName);
	if (class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Orbis))
	{
		PlayerInfoObject.SetString("profileImageSource", "img://"$KFPC.GetPS4Avatar(PlayerName));
	}
	else
	{
		PlayerInfoObject.SetString("profileImageSource", "img://"$KFPC.GetSteamAvatar(EPRI.UniqueId));
	}
	if (KFGRI != none)
	{
		PlayerInfoObject.SetBool("ready", EPRI.bReadyToPlay && !KFGRI.bMatchHasBegun);
	}

	return PlayerInfoObject;
}

defaultproperties
{
}