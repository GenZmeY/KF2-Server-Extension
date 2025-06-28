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

Class ExtStatList extends Object
	config(ServerExtStats)
	abstract;

struct FTopPlayers
{
	var config string N,Id;
	var config int V;
};
var config array<FTopPlayers> TopPlaytimes,TopKills,TopExp;

static final function SetTopPlayers(ExtPlayerController Other)
{
	local ExtPerkManager PM;
	local bool bDirty;

	PM = Other.ActivePerkManager;

	bDirty = CheckBestTrack(Other.PlayerReplicationInfo,PM.TotalPlayTime,Default.TopPlaytimes);
	bDirty = CheckBestTrack(Other.PlayerReplicationInfo,PM.TotalKills,Default.TopKills) || bDirty;
	bDirty = CheckBestTrack(Other.PlayerReplicationInfo,PM.TotalEXP,Default.TopExp) || bDirty;
	if (bDirty)
		StaticSaveConfig();
}

static final function bool CheckBestTrack(PlayerReplicationInfo PRI, int Value, out array<FTopPlayers> V)
{
	local string S;
	local int i,l;

	S = class'OnlineSubsystem'.Static.UniqueNetIdToString(PRI.UniqueId);

	l = class'ServerExtMut'.Default.MaxTopPlayers;
	if (V.Length>l) // See if list has overflown incase an admin has changed the max stats value.
		V.Length = l;

	i = V.Find('ID',S); // First see if we have an entry from before.
	if (i>=0)
	{
		if (V[i].V==Value) // Stat unchanged.
		{
			if (V[i].N!=PRI.PlayerName) // Name has changed, update that.
			{
				V[i].N = PRI.PlayerName;
				return true;
			}
			return false;
		}

		// Remove entry and insert it back in list only if rank changed.
		if ((i>0 && V[i-1].V<Value) || (i<(V.Length-1) && V[i+1].V>Value))
			V.Remove(i,1);
		else // No change in rank.
		{
			if (V[i].N!=PRI.PlayerName) // Name has changed, update that.
			{
				V[i].N = PRI.PlayerName;
				return true;
			}
			return false;
		}
	}

	for (i=0; i<l; ++i)
	{
		if (i==V.Length || V[i].V<Value) // At final entry, or has higher value then this ranked player.
		{
			V.Insert(i,1);
			V[i].N = PRI.PlayerName;
			V[i].V = Value;
			V[i].ID = S;
			if (V.Length>l) // See if list has overflown.
				V.Length = l;
			return true;
		}
	}
	return false;
}

static final function bool GetStat(ExtPlayerController PC, byte ListNum, int StatIndex)
{
	local UniqueNetId ID;

	switch (ListNum)
	{
	case 0:
		if (StatIndex>=Default.TopPlaytimes.Length)
			return false;
		class'OnlineSubsystem'.Static.StringToUniqueNetId(Default.TopPlaytimes[StatIndex].ID,ID);
		PC.ClientGetStat(ListNum,false,Default.TopPlaytimes[StatIndex].N,ID,Default.TopPlaytimes[StatIndex].V);
		return true;
	case 1:
		if (StatIndex>=Default.TopKills.Length)
			return false;
		class'OnlineSubsystem'.Static.StringToUniqueNetId(Default.TopKills[StatIndex].ID,ID);
		PC.ClientGetStat(ListNum,false,Default.TopKills[StatIndex].N,ID,Default.TopKills[StatIndex].V);
		return true;
	case 2:
		if (StatIndex>=Default.TopExp.Length)
			return false;
		class'OnlineSubsystem'.Static.StringToUniqueNetId(Default.TopExp[StatIndex].ID,ID);
		PC.ClientGetStat(ListNum,false,Default.TopExp[StatIndex].N,ID,Default.TopExp[StatIndex].V);
		return true;
	default:
		return false;
	}
}
